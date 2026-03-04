-- SpellTooltips Core
-- Complete tooltip redesign with integrated damage calculations

SpellTooltips = SpellTooltips or {}

local addon = SpellTooltips
local Colors = addon.Colors
local Utils = addon.Utils
local Talents = addon.Talents

-- Addon initialization
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
frame:RegisterEvent("PLAYER_TALENT_UPDATE")
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

-- Track if we've already processed this tooltip
local tooltipProcessed = false
local lastProcessedSpellID = nil

-- Debug mode flag (off by default)
local DEBUG_MODE = false

local function DebugPrint(...)
    if DEBUG_MODE then
        print("|cFFFF8000[STT]|r", ...)
    end
end

-- Color shortcuts
local C = {
    WHITE = "|cFFFFFFFF",
    GRAY = "|cFFAAAAAA",
    GREEN = "|cFF00FF00",
    YELLOW = "|cFFFFFF00",
    CYAN = "|cFF00FFFF",
    ORANGE = "|cFFFF8000",
    MANA = "|cFF0080FF",
    CRIT = "|cFFFF4444",  -- Red for crit info
    RESET = "|r",
}

-- School colors (matching WoW's damage school colors)
local SCHOOL_COLORS = {
    physical = "|cFFFFFF00",  -- Yellow/Tan
    holy = "|cFFFFB3E6",      -- Pink-Gold (distinct from yellow tooltip text)
    fire = "|cFFFF8000",      -- Orange
    nature = "|cFF4DFF4D",    -- Green
    frost = "|cFF80FFFF",     -- Light Cyan
    shadow = "|cFF9482C9",    -- Purple
    arcane = "|cFFFF80FF",    -- Pink/Magenta
    -- Additional/combo schools
    frostfire = "|cFFFF80C0", -- Mix of frost and fire
    spellfire = "|cFFFF8000", -- Treat as fire
    shadowfrost = "|cFF8080FF", -- Mix
    holyfire = "|cFFFFCC00",  -- Mix
    -- Healing uses a distinct green
    healing = "|cFF00FF66",   -- Bright Green (distinct for heals)
}

-- Get color for a damage school (or healing)
local function GetSchoolColor(school, isHealing)
    if not school then return C.WHITE end
    if isHealing then return SCHOOL_COLORS.healing end
    return SCHOOL_COLORS[string.lower(school)] or C.WHITE
end

-- Get main hand weapon speed (for seal calculations)
local function GetMainHandSpeed()
    local speed, _ = UnitAttackSpeed("player")
    return speed or 2.0
end

-- Check if using two-handed weapon
local function IsTwoHandedWeapon()
    local itemID = GetInventoryItemID("player", 16) -- INVSLOT_MAINHAND
    if not itemID then return false end
    local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemID)
    return itemEquipLoc == "INVTYPE_2HWEAPON"
end

-- Patterns for parsing tooltip
local PATTERNS = {
    DAMAGE_RANGE = "(%d+)%s*[%-–to]+%s*(%d+)",
    SINGLE_DAMAGE = "(%d+)%s+%a+%s+damage",
    CHANNELED_DAMAGE = "(%d+)%s+%a+%s+damage%s+over",  -- "X Frost damage over Y sec"
    MANA_COST = "(%d+) Mana",
    CAST_TIME = "(%d+%.?%d*)%s*sec cast",
    CHANNELED = "Channeled",
    INSTANT = "Instant",
    RANGE = "(%d+) yd range",
    COOLDOWN = "(%d+)%s*(%a+) cooldown",
    DOT_DAMAGE = "(%d+)%s+%a+%s+damage over%s+(%d+)",
    SLOW = "([Ss]low%a*.-[%d%.]+%%)",
    NEXT_RANK = "Next rank",
}

-- Parse original tooltip into structured data
local function ParseTooltip(tooltip)
    local data = {
        lines = {},
        name = nil,
        rank = nil,
        castTime = nil,
        isChanneled = false,
        isInstant = false,
        range = nil,
        manaCost = nil,
        cooldown = nil,
        damageMin = nil,
        damageMax = nil,
        dotDamage = nil,
        dotDuration = nil,
        effects = {},
        descriptionLines = {},
    }

    local numLines = tooltip:NumLines()
    local inNextRank = false

    for i = 1, numLines do
        local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
        local textRight = _G[tooltip:GetName() .. "TextRight" .. i]

        local leftText = textLeft and textLeft:GetText() or ""
        local rightText = textRight and textRight:GetText() or ""

        -- Skip "Next rank" section
        if leftText and leftText:match(PATTERNS.NEXT_RANK) then
            inNextRank = true
        end

        if not inNextRank then
            -- Line 1: Spell name
            if i == 1 then
                data.name = leftText
            -- Line 2: Rank (if present)
            elseif i == 2 and leftText and leftText:match("^Rank %d+") then
                data.rank = leftText:match("Rank (%d+)")
            else
                -- Parse cast info from left side
                if leftText then
                    -- Cast time
                    local castTime = leftText:match(PATTERNS.CAST_TIME)
                    if castTime then
                        data.castTime = tonumber(castTime)
                    end

                    -- Channeled
                    if leftText:match(PATTERNS.CHANNELED) then
                        data.isChanneled = true
                    end

                    -- Instant
                    if leftText:match(PATTERNS.INSTANT) then
                        data.isInstant = true
                    end

                    -- Mana cost
                    local mana = leftText:match(PATTERNS.MANA_COST)
                    if mana then
                        data.manaCost = tonumber(mana)
                    end

                    -- Cooldown
                    local cdAmount, cdUnit = leftText:match(PATTERNS.COOLDOWN)
                    if cdAmount then
                        data.cooldown = { amount = tonumber(cdAmount), unit = cdUnit }
                    end
                end

                -- Parse range from right side
                if rightText then
                    local range = rightText:match(PATTERNS.RANGE)
                    if range then
                        data.range = tonumber(range)
                    end
                end

                -- Parse damage and effects from description lines
                if leftText and leftText:len() > 20 then
                    table.insert(data.descriptionLines, leftText)

                    -- Damage range (e.g., "530-570 Frost damage")
                    local minDmg, maxDmg = leftText:match(PATTERNS.DAMAGE_RANGE)
                    if minDmg and maxDmg and not data.damageMin then
                        data.damageMin = tonumber(minDmg)
                        data.damageMax = tonumber(maxDmg)
                    end

                    -- Single damage value for channeled/AoE (e.g., "1234 Frost damage over 8 sec")
                    if not data.damageMin then
                        local singleDmg = leftText:match(PATTERNS.CHANNELED_DAMAGE)
                        if singleDmg then
                            data.damageMin = tonumber(singleDmg)
                            data.damageMax = tonumber(singleDmg)
                        end
                    end

                    -- Single damage value without "over" (e.g., "97 Fire damage to creatures")
                    -- Handles totems, Lightning Shield, and similar spells
                    if not data.damageMin then
                        local singleDmg = leftText:match(PATTERNS.SINGLE_DAMAGE)
                        if singleDmg then
                            data.damageMin = tonumber(singleDmg)
                            data.damageMax = tonumber(singleDmg)
                        end
                    end

                    -- DoT damage
                    local dotDmg, dotDur = leftText:match(PATTERNS.DOT_DAMAGE)
                    if dotDmg and dotDur then
                        data.dotDamage = tonumber(dotDmg)
                        data.dotDuration = tonumber(dotDur)
                    end

                    -- Effects (slow, etc.)
                    local slow = leftText:match(PATTERNS.SLOW)
                    if slow then
                        table.insert(data.effects, slow)
                    end
                end
            end
        end
    end

    return data
end

-- Calculate damage with spell power and talents
local function CalculateDamage(baseDamage, spellPower, spellData)
    if not spellData or not baseDamage then return baseDamage end

    local modifiedCoeff = Talents.GetModifiedCoefficient(spellData)
    local multiplier = Talents.GetSchoolMultiplier(spellData.school)
    local bonusDamage = spellPower * modifiedCoeff

    return math.floor((baseDamage + bonusDamage) * multiplier)
end

-- Format the cast time line
local function FormatCastLine(data)
    local parts = {}

    -- Cast time
    if data.isInstant then
        table.insert(parts, "Instant")
    elseif data.isChanneled then
        table.insert(parts, string.format("%.1fs channel", data.castTime or 0))
    elseif data.castTime then
        table.insert(parts, string.format("%.1fs cast", data.castTime))
    end

    -- Range
    if data.range then
        table.insert(parts, string.format("%d yd", data.range))
    end

    -- Mana
    if data.manaCost then
        table.insert(parts, string.format("%s%d Mana%s", C.MANA, data.manaCost, C.RESET))
    end

    -- Cooldown
    if data.cooldown then
        table.insert(parts, string.format("%ds CD", data.cooldown.amount))
    end

    return table.concat(parts, " | ")
end

-- Format the damage breakdown as a formula
local function FormatDamageBreakdown(data, spellData, spellPower)
    local lines = {}

    if not data.damageMin or not spellData then
        return lines
    end

    local modifiedCoeff, coeffBonus = Talents.GetModifiedCoefficient(spellData)
    local schoolMultiplier, schoolTalents = Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier, spellTalents = Talents.GetSpellMultiplier(spellData.name)
    local multiplier = schoolMultiplier * spellMultiplier

    local bonusDamage = math.floor(spellPower * modifiedCoeff)
    local coeffStr = Utils.FormatCoefficient(modifiedCoeff)

    -- Secondary effects (like Holy Shield procs) - just show SP bonus
    if spellData.isSecondary then
        table.insert(lines, string.format("%sSP bonus: %s+%d (%s)", C.WHITE, C.GRAY, bonusDamage, coeffStr))
        return lines
    end

    -- Combine talent lists
    local talentList = {}
    for _, t in ipairs(schoolTalents) do table.insert(talentList, t) end
    for _, t in ipairs(spellTalents) do table.insert(talentList, t) end

    -- Base damage string
    local baseStr
    if data.damageMin == data.damageMax then
        baseStr = tostring(data.damageMin)
    else
        baseStr = string.format("%d-%d", data.damageMin, data.damageMax)
    end

    -- Base Damage line
    table.insert(lines, string.format("%sBase: %s%s", C.WHITE, C.GRAY, baseStr))

    -- Bonus Damage line
    table.insert(lines, string.format("%sBonus: %s+%d (%s SP)", C.WHITE, C.GRAY, bonusDamage, coeffStr))

    -- Talent multiplier line
    if multiplier > 1.0 and #talentList > 0 then
        local bonusPercent = math.floor((multiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    -- Crit Chance line (only if spell can crit)
    if spellData.canCrit ~= false then
        local baseCritChance = Utils.GetPlayerSpellCritChance(spellData.school)
        local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
        local totalCritChance = baseCritChance + critBonus
        local critMultiplier = Talents.GetCritDamageMultiplier(spellData.school)

        if totalCritChance > 0 then
            local critDmgBonus = (critMultiplier - 1) * 100
            table.insert(lines, string.format("%sCrit: %s%.1f%% %s(+%.0f%% dmg)",
                C.WHITE, C.GRAY, totalCritChance, C.GRAY, critDmgBonus))
        end
    end

    return lines
end

-- Format DoT information
local function FormatDotLine(data, spellData, spellPower)
    if not data.dotDamage or not spellData or not spellData.dotCoefficient then
        return nil
    end

    local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
    local multiplier = schoolMultiplier * spellMultiplier
    local dotBonus = math.floor(spellPower * spellData.dotCoefficient)
    local totalDot = math.floor((data.dotDamage + dotBonus) * multiplier)

    local coeffStr = Utils.FormatCoefficient(spellData.dotCoefficient)

    return string.format("%sDoT: %s+%d over %ds (%s SP)",
        C.WHITE, C.GRAY, totalDot, data.dotDuration, coeffStr)
end

-- Format channeled spell damage as formula
local function FormatChanneledDamage(data, spellData, spellPower)
    local lines = {}

    if not data.damageMin or not spellData then
        return lines
    end

    local modifiedCoeff, coeffBonus = Talents.GetModifiedCoefficient(spellData)
    local schoolMultiplier, schoolTalents = Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier, spellTalents = Talents.GetSpellMultiplier(spellData.name)
    local multiplier = schoolMultiplier * spellMultiplier

    -- Combine talent lists
    local talentList = {}
    for _, t in ipairs(schoolTalents) do table.insert(talentList, t) end
    for _, t in ipairs(spellTalents) do table.insert(talentList, t) end

    local ticks = spellData.ticks or 1
    local perTickCoeff = modifiedCoeff / ticks
    local perTickBonus = math.floor(spellPower * perTickCoeff)
    local totalBonus = math.floor(spellPower * modifiedCoeff)

    -- Base Damage line (per tick)
    table.insert(lines, string.format("%sBase: %s%d per tick", C.WHITE, C.GRAY, data.damageMin))

    -- Bonus Damage line - show per tick and total for multi-tick spells
    if ticks > 1 then
        local perTickCoeffStr = Utils.FormatCoefficient(perTickCoeff)
        local totalCoeffStr = Utils.FormatCoefficient(modifiedCoeff)
        table.insert(lines, string.format("%sBonus: %s+%d/tick (%s), +%d total (%s)",
            C.WHITE, C.GRAY, perTickBonus, perTickCoeffStr, totalBonus, totalCoeffStr))
    else
        local coeffStr = Utils.FormatCoefficient(modifiedCoeff)
        table.insert(lines, string.format("%sBonus: %s+%d (%s SP)", C.WHITE, C.GRAY, totalBonus, coeffStr))
    end

    -- Talent multiplier line
    if multiplier > 1.0 and #talentList > 0 then
        local bonusPercent = math.floor((multiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    -- Crit Chance line (only if spell can crit)
    if spellData.canCrit ~= false then
        local baseCritChance = Utils.GetPlayerSpellCritChance(spellData.school)
        local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
        local totalCritChance = baseCritChance + critBonus
        local critMultiplier = Talents.GetCritDamageMultiplier(spellData.school)

        if totalCritChance > 0 then
            local critDmgBonus = (critMultiplier - 1) * 100
            table.insert(lines, string.format("%sCrit: %s%.1f%% %s(+%.0f%% dmg)",
                C.WHITE, C.GRAY, totalCritChance, C.GRAY, critDmgBonus))
        end
    end

    return lines
end

-- Update damage values in a line of text with school color
local function UpdateDamageInText(text, spellPower, spellData)
    if not text or not spellData then return text end

    local coefficient = spellData.coefficient or 0
    local dotCoefficient = spellData.dotCoefficient or 0

    -- Return early only if both coefficients are zero
    if coefficient == 0 and dotCoefficient == 0 then return text end

    local modifiedCoeff = Talents.GetModifiedCoefficient(spellData)

    -- For channeled spells with ticks (like Arcane Missiles), use per-tick coefficient
    local ticks = spellData.ticks or 1
    local perTickCoeff = modifiedCoeff / ticks

    local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
    local multiplier = schoolMultiplier * spellMultiplier
    local schoolColor = GetSchoolColor(spellData.school, spellData.isHealing)

    local newText = text

    -- 1. Replace damage range with colored values (e.g., "530-570 Fire damage")
    -- Uses per-tick coefficient for channeled spells, full coefficient otherwise
    if coefficient > 0 then
        newText = newText:gsub("(%d+)(%s*[%-–to]+%s*)(%d+)", function(minStr, sep, maxStr)
            local minDmg = tonumber(minStr)
            local maxDmg = tonumber(maxStr)
            local bonusDamage = spellPower * perTickCoeff
            local newMin = math.floor((minDmg + bonusDamage) * multiplier)
            local newMax = math.floor((maxDmg + bonusDamage) * multiplier)
            return schoolColor .. newMin .. C.RESET .. sep .. schoolColor .. newMax .. C.RESET
        end)
    end

    -- 2. Replace "additional X SCHOOL damage over" for hybrid spells (e.g., Immolate, Moonfire, Holy Fire)
    -- Uses dotCoefficient for the DoT portion
    if dotCoefficient > 0 then
        newText = newText:gsub("(additional%s+)(%d+)(%s+%a+%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * dotCoefficient
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
    end

    -- 3. Replace single damage values for DoT/channeled spells (e.g., "512 Holy damage over 8 sec")
    -- This handles: Consecration, Blizzard, Corruption, Curse of Agony, Mind Flay, etc.
    -- Only apply to spells marked as isDot or isChanneled (where the "over X sec" damage scales)
    -- This prevents incorrectly modifying non-scaling DoT portions (e.g., Seed of Corruption's DoT)
    if spellData.isDot or spellData.isChanneled then
        -- For spells with coefficient > 0 (like Consecration), use that
        -- For pure DoTs with coefficient = 0 (like Corruption), use dotCoefficient
        local singleDmgCoeff = (coefficient > 0) and modifiedCoeff or dotCoefficient
        if singleDmgCoeff > 0 then
            -- Match "X SCHOOL damage over" but avoid matching numbers already colorized
            -- After step 2, "additional" patterns have color codes, so they won't match this simpler pattern
            newText = newText:gsub("(%s)(%d+)(%s+%a+%s+damage%s+over)", function(prefix, dmgStr, suffix)
                local dmg = tonumber(dmgStr)
                local bonusDamage = spellPower * singleDmgCoeff
                local newDmg = math.floor((dmg + bonusDamage) * multiplier)
                return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
            end)
        end
    end

    -- 4. Replace single damage values without range or "over" (e.g., "causes X Fire damage to creatures")
    -- This handles: Magma Totem, Lightning Shield, and similar per-hit/per-tick damage
    -- Pattern: "X SCHOOL damage" followed by " to" or " every" or end of damage phrase
    if coefficient > 0 then
        -- Match "X SCHOOL damage to" (like Magma Totem: "causes 97 Fire damage to creatures")
        newText = newText:gsub("(%s)(%d+)(%s+%a+%s+damage%s+to%s)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "causing X SCHOOL damage" (like Arcane Missiles: "causing 264 Arcane damage every")
        -- Use per-tick coefficient for channeled spells with ticks
        newText = newText:gsub("(causing%s+)(%d+)(%s+%a+%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * perTickCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "X SCHOOL damage every" (like "97 Fire damage every 2 seconds")
        -- Use per-tick coefficient for channeled spells with ticks
        newText = newText:gsub("(%s)(%d+)(%s+%a+%s+damage%s+every)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * perTickCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "X SCHOOL damage when" (like Lightning Shield: "X Nature damage when you are hit")
        newText = newText:gsub("(%s)(%d+)(%s+%a+%s+damage%s+when)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "X SCHOOL damage for" (like Holy Shield: "deals 155 Holy damage for each attack")
        newText = newText:gsub("(%s)(%d+)(%s+%a+%s+damage%s+for)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "inflicts X SCHOOL damage" (like Judgement of Righteousness)
        newText = newText:gsub("(inflicts%s+)(%d+)(%s+%a+%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "causes X SCHOOL damage" (generic pattern)
        newText = newText:gsub("(causes%s+)(%d+)(%s+%a+%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "deals X SCHOOL damage" followed by period or end (generic)
        newText = newText:gsub("(deals%s+)(%d+)(%s+%a+%s+damage%.?)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "for X SCHOOL damage" (like Judgement: "judge an enemy for X Holy damage")
        newText = newText:gsub("(for%s+)(%d+)(%s+%a+%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
    end

    -- 5. Handle absorption spells (Power Word: Shield, Ice Barrier, etc.)
    if spellData.isAbsorb and coefficient > 0 then
        -- Match "Absorbs X damage" pattern
        newText = newText:gsub("([Aa]bsorbs%s+)(%d+)(%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
        -- Match "absorb X damage" (without 's')
        newText = newText:gsub("([Aa]bsorb%s+)(%d+)(%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = math.floor((dmg + bonusDamage) * multiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
    end

    return newText
end

-- Modify tooltip in place and append breakdown
local function BuildTooltip(tooltip, spellID, originalData)
    local spellData = addon.GetSpellDataByID(spellID)
    if not spellData then return false end

    local spellPower = addon.GetSpellPowerForSpell(spellData)
    local schoolColor = GetSchoolColor(spellData.school, spellData.isHealing)

    -- Special handling for Absorption spells (Ice Barrier, Power Word: Shield)
    if spellData.isAbsorb then
        local modifiedCoeff = Talents.GetModifiedCoefficient(spellData)
        local bonusAbsorb = math.floor(spellPower * modifiedCoeff)
        local coeffStr = Utils.FormatCoefficient(modifiedCoeff)

        -- Update existing tooltip lines - match absorption patterns
        for i = 1, tooltip:NumLines() do
            local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
            if textLeft then
                local text = textLeft:GetText()
                if text and text:find("damage") then
                    local newText = text
                    -- Match "X damage" where X is the absorption value
                    -- Pattern: number followed by space and "damage"
                    newText = newText:gsub("(%s)(%d+)(%s+damage)", function(prefix, absorbStr, suffix)
                        local baseAbsorb = tonumber(absorbStr)
                        local newAbsorb = math.floor(baseAbsorb + bonusAbsorb)
                        return prefix .. schoolColor .. newAbsorb .. C.RESET .. suffix
                    end)
                    -- Also try matching at start of relevant phrase (absorbing X damage)
                    newText = newText:gsub("(absorbing%s+)(%d+)(%s+damage)", function(prefix, absorbStr, suffix)
                        local baseAbsorb = tonumber(absorbStr)
                        local newAbsorb = math.floor(baseAbsorb + bonusAbsorb)
                        return prefix .. schoolColor .. newAbsorb .. C.RESET .. suffix
                    end)
                    if newText ~= text then
                        textLeft:SetText(newText)
                    end
                end
            end
        end

        -- Add breakdown
        tooltip:AddLine(" ")
        tooltip:AddLine(string.format("SP bonus: %s+%d%s (%s)", schoolColor, bonusAbsorb, C.RESET, coeffStr), 1, 1, 1)

        tooltip:Show()
        return true
    end

    -- Special handling for Seal spells
    if spellData.isSeal then
        if spellData.isStackingDot then
            -- Seal of Vengeance/Corruption - show per-stack and max-stack damage
            local perStackBonus = math.floor(spellPower * spellData.coefficientPerStack)
            local maxBonus = math.floor(spellPower * spellData.coefficientPerStack * spellData.maxStacks)

            tooltip:AddLine(" ")
            tooltip:AddLine(string.format("Per stack: %s+%d%s (%.0f%% SP)",
                schoolColor, perStackBonus, C.RESET, spellData.coefficientPerStack * 100), 1, 1, 1)
            tooltip:AddLine(string.format("At %d stacks: %s+%d%s (%.0f%% SP)",
                spellData.maxStacks, schoolColor, maxBonus, C.RESET,
                spellData.coefficientPerStack * spellData.maxStacks * 100), 1, 1, 1)
        else
            -- Seal of Righteousness - update damage number and show breakdown
            local weaponSpeed = GetMainHandSpeed()
            local is2H = IsTwoHandedWeapon()
            local baseCoeff = is2H and spellData.baseCoeff2H or spellData.baseCoeff1H
            local coefficient = baseCoeff * weaponSpeed
            local bonusDamage = math.floor(spellPower * coefficient)

            -- Get spell-specific multiplier (Improved Seal of Righteousness)
            local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)

            -- Update existing tooltip lines - match "additional X Holy damage"
            for i = 1, tooltip:NumLines() do
                local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
                if textLeft then
                    local text = textLeft:GetText()
                    if text and text:find("additional") and text:find("Holy damage") then
                        -- Match "additional X Holy damage" pattern
                        local newText = text:gsub("(additional%s+)(%d+)(%s+Holy%s+damage)", function(prefix, dmgStr, suffix)
                            local baseDmg = tonumber(dmgStr)
                            local newDmg = math.floor((baseDmg + bonusDamage) * spellMultiplier)
                            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
                        end)
                        if newText ~= text then
                            textLeft:SetText(newText)
                        end
                    end
                end
            end

            tooltip:AddLine(" ")
            local talentNote = spellMultiplier > 1 and string.format(" (×%.0f%% talent)", spellMultiplier * 100) or ""
            tooltip:AddLine(string.format("SP bonus: %s+%d%s (%.1f%% × %.2fs)%s",
                schoolColor, bonusDamage, C.RESET, baseCoeff * 100, weaponSpeed, talentNote), 1, 1, 1)
            tooltip:AddLine(string.format("  Using %s weapon", is2H and "2H" or "1H"), 0.7, 0.7, 0.7)
        end

        tooltip:Show()
        return true
    end

    -- Update existing tooltip lines with new damage values
    for i = 1, tooltip:NumLines() do
        local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
        if textLeft then
            local text = textLeft:GetText()
            if text and text:len() > 20 then
                local updatedText = UpdateDamageInText(text, spellPower, spellData)
                if updatedText ~= text then
                    textLeft:SetText(updatedText)
                end
            end
        end
    end

    -- Add breakdown at the bottom
    tooltip:AddLine(" ")

    -- Damage breakdown
    local damageLines
    if spellData.isChanneled and originalData.damageMin then
        damageLines = FormatChanneledDamage(originalData, spellData, spellPower)
    else
        damageLines = FormatDamageBreakdown(originalData, spellData, spellPower)
    end

    for _, line in ipairs(damageLines) do
        tooltip:AddLine(line, 1, 1, 1)
    end

    -- DoT line
    local dotLine = FormatDotLine(originalData, spellData, spellPower)
    if dotLine then
        tooltip:AddLine(" ")
        tooltip:AddLine(dotLine, 1, 1, 1)
    end

    tooltip:Show()
    return true
end

-- Process tooltip
local function ProcessTooltip(tooltip, spellID)
    -- Prevent reprocessing
    if tooltipProcessed and lastProcessedSpellID == spellID then
        return
    end

    DebugPrint("Processing spellID:", spellID)

    local spellData = addon.GetSpellDataByID(spellID)
    if not spellData then
        DebugPrint("No spell data found for ID:", spellID)
        return
    end

    DebugPrint("Found spell:", spellData.name)

    -- Parse original tooltip
    local originalData = ParseTooltip(tooltip)

    DebugPrint("Parsed - Name:", originalData.name, "Damage:", originalData.damageMin, "-", originalData.damageMax)

    -- Only process if we found damage values OR it's a seal/absorb (these don't show damage numbers)
    if not originalData.damageMin and not spellData.isSeal and not spellData.isAbsorb then
        DebugPrint("No damage values found in tooltip")
        return
    end

    -- Build new tooltip
    local success = BuildTooltip(tooltip, spellID, originalData)
    if success then
        DebugPrint("Tooltip rebuilt successfully")
        tooltipProcessed = true
        lastProcessedSpellID = spellID
    end
end

-- Hook for GameTooltip:SetSpellByID (action bars)
local function OnSetSpellByID(tooltip, spellID)
    tooltipProcessed = false
    C_Timer.After(0, function()
        ProcessTooltip(tooltip, spellID)
    end)
end

-- Hook for OnTooltipSetSpell (spellbook and other sources)
local function OnTooltipSetSpell(tooltip)
    tooltipProcessed = false

    local name, spellID = tooltip:GetSpell()
    if spellID then
        ProcessTooltip(tooltip, spellID)
    end
end

-- Reset processed flag when tooltip is cleared
local function OnTooltipCleared(tooltip)
    tooltipProcessed = false
    lastProcessedSpellID = nil
end

-- Initialize hooks
local function InitializeHooks()
    -- Hook SetSpellByID if it exists
    if GameTooltip.SetSpellByID then
        hooksecurefunc(GameTooltip, "SetSpellByID", OnSetSpellByID)
        DebugPrint("Hooked SetSpellByID")
    end

    -- Hook OnTooltipSetSpell
    GameTooltip:HookScript("OnTooltipSetSpell", OnTooltipSetSpell)
    DebugPrint("Hooked OnTooltipSetSpell")

    -- Hook OnTooltipCleared
    GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
    DebugPrint("Hooked OnTooltipCleared")
end

-- Event handler
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SpellTooltips" then
        SpellTooltipsDB = SpellTooltipsDB or {}
        print("|cFF00FF00SpellTooltips|r loaded. Type /stt for commands.")

        -- Count registered spells
        local count = 0
        for _ in pairs(SpellTooltips.SpellData) do count = count + 1 end
        print("|cFF00FF00SpellTooltips|r", count, "spells registered.")

    elseif event == "PLAYER_LOGIN" then
        InitializeHooks()

        -- Use C_Timer if available, otherwise use OnUpdate
        if C_Timer and C_Timer.After then
            C_Timer.After(1, function()
                Talents.RefreshCache()
            end)
        else
            Talents.RefreshCache()
        end

    elseif event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        Talents.InvalidateCache()
        if C_Timer and C_Timer.After then
            C_Timer.After(0.1, function()
                Talents.RefreshCache()
            end)
        else
            Talents.RefreshCache()
        end
    end
end)

-- Slash commands
SLASH_SPELLTOOLTIPS1 = "/stt"
SLASH_SPELLTOOLTIPS2 = "/spelltooltips"
SlashCmdList["SPELLTOOLTIPS"] = function(msg)
    if msg == "debug" then
        DEBUG_MODE = not DEBUG_MODE
        print("|cFF00FF00SpellTooltips|r Debug mode:", DEBUG_MODE and "ON" or "OFF")
    elseif msg == "talents" then
        print("|cFF00FF00SpellTooltips|r Configured talents:")
        for key, info in pairs(SpellTooltips.TalentInfo) do
            local ranks = Talents.GetTalentRanksByKey(key)
            print(string.format("  %s (tab %d, idx %d): %d/%d",
                info.name, info.tab, info.index, ranks, info.maxRanks))
        end
    elseif msg == "spells" then
        print("|cFF00FF00SpellTooltips|r Registered spells:")
        local count = 0
        for id, data in pairs(SpellTooltips.SpellData) do
            count = count + 1
            if count <= 10 then
                print(string.format("  [%d] %s", id, data.name))
            end
        end
        print(string.format("  ... %d total spells", count))
    elseif msg:match("^scan (%d+)$") then
        -- Scan a talent tree: /stt scan 3 (for frost)
        local tabNum = tonumber(msg:match("^scan (%d+)$"))
        print("|cFF00FF00SpellTooltips|r Scanning talent tree", tabNum)
        for i = 1, 30 do
            local name, iconTexture, tier, column, rank, maxRank = GetTalentInfo(tabNum, i)
            if name then
                print(string.format("  [%d] %s: %d/%d (tier %d)", i, name, rank or 0, maxRank or 0, tier or 0))
            end
        end
    elseif msg:match("^scan (%d+) save$") then
        -- Scan and save to SavedVariables: /stt scan 2 save
        local tabNum = tonumber(msg:match("^scan (%d+) save$"))
        SpellTooltipsDB = SpellTooltipsDB or {}
        SpellTooltipsDB.TalentScan = SpellTooltipsDB.TalentScan or {}
        SpellTooltipsDB.TalentScan[tabNum] = {}

        local _, className = UnitClass("player")
        SpellTooltipsDB.TalentScan.class = className
        SpellTooltipsDB.TalentScan.timestamp = date("%Y-%m-%d %H:%M:%S")

        print("|cFF00FF00SpellTooltips|r Scanning and saving talent tree", tabNum)
        for i = 1, 30 do
            local name, iconTexture, tier, column, rank, maxRank = GetTalentInfo(tabNum, i)
            if name then
                SpellTooltipsDB.TalentScan[tabNum][i] = {
                    name = name,
                    rank = rank or 0,
                    maxRank = maxRank or 0,
                    tier = tier or 0
                }
                print(string.format("  [%d] %s: %d/%d (tier %d)", i, name, rank or 0, maxRank or 0, tier or 0))
            end
        end
        print("|cFF00FF00SpellTooltips|r Saved! /reload then check:")
        print("  WTF/Account/<name>/SavedVariables/SpellTooltips.lua")
    elseif msg == "dumpall" then
        -- Dump all talent trees to SavedVariables for reference export
        SpellTooltipsDB = SpellTooltipsDB or {}
        SpellTooltipsDB.TalentDump = {}

        local _, className = UnitClass("player")
        local localizedClass, _ = UnitClass("player")

        -- Get talent tree names
        local treeNames = {}
        for tab = 1, 3 do
            local name, _, _, _ = GetTalentTabInfo(tab)
            treeNames[tab] = name or ("Tree " .. tab)
        end

        SpellTooltipsDB.TalentDump = {
            class = className,
            localizedClass = localizedClass,
            exportedAt = date("%Y-%m-%d %H:%M:%S"),
            trees = {}
        }

        print("|cFF00FF00SpellTooltips|r Dumping all talents for", localizedClass)

        for tab = 1, 3 do
            SpellTooltipsDB.TalentDump.trees[tab] = {
                name = treeNames[tab],
                talents = {}
            }

            print(string.format("  Tree %d: %s", tab, treeNames[tab]))

            for i = 1, 30 do
                local name, iconTexture, tier, column, rank, maxRank = GetTalentInfo(tab, i)
                if name then
                    SpellTooltipsDB.TalentDump.trees[tab].talents[i] = {
                        name = name,
                        tier = tier or 0,
                        column = column or 0,
                        currentRanks = rank or 0,
                        maxRanks = maxRank or 0,
                        icon = iconTexture
                    }
                    print(string.format("    [%d] %s (%d/%d)", i, name, rank or 0, maxRank or 0))
                end
            end
        end

        print("|cFF00FF00SpellTooltips|r Dump complete! /reload then copy from:")
        print("  WTF/Account/<name>/SavedVariables/SpellTooltips.lua")
        print("  Look for TalentDump section")
    elseif msg == "dumpspells" then
        -- Dump all spell tooltips to SavedVariables
        SpellTooltipsDB = SpellTooltipsDB or {}
        SpellTooltipsDB.SpellDump = {}

        local _, className = UnitClass("player")
        SpellTooltipsDB.SpellDump.class = className
        SpellTooltipsDB.SpellDump.exportedAt = date("%Y-%m-%d %H:%M:%S")
        SpellTooltipsDB.SpellDump.spells = {}

        -- Create a hidden tooltip for scanning
        local scanTip = CreateFrame("GameTooltip", "STTScanTooltip", nil, "GameTooltipTemplate")
        scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")

        print("|cFF00FF00SpellTooltips|r Dumping spell tooltips...")

        local count = 0
        for spellID, spellData in pairs(SpellTooltips.SpellData) do
            scanTip:ClearLines()
            scanTip:SetSpellByID(spellID)

            local tooltipLines = {}
            for i = 1, scanTip:NumLines() do
                local textLeft = _G["STTScanTooltipTextLeft" .. i]
                local textRight = _G["STTScanTooltipTextRight" .. i]
                local leftText = textLeft and textLeft:GetText() or ""
                local rightText = textRight and textRight:GetText() or ""

                if leftText and leftText ~= "" then
                    table.insert(tooltipLines, {
                        left = leftText,
                        right = rightText ~= "" and rightText or nil
                    })
                end
            end

            SpellTooltipsDB.SpellDump.spells[spellID] = {
                name = spellData.name,
                school = spellData.school,
                coefficient = spellData.coefficient,
                ticks = spellData.ticks,
                tooltip = tooltipLines
            }
            count = count + 1
        end

        print(string.format("|cFF00FF00SpellTooltips|r Dumped %d spells! /reload then copy from:", count))
        print("  WTF/Account/<name>/SavedVariables/SpellTooltips.lua")
        print("  Look for SpellDump section")
    else
        print("|cFF00FF00SpellTooltips|r v1.0.0")
        print("  /stt debug - Toggle debug mode")
        print("  /stt talents - Show detected talents")
        print("  /stt spells - Show registered spells")
        print("  /stt scan 1|2|3 - Scan talent tree")
        print("  /stt scan 1|2|3 save - Scan and save to file")
        print("  /stt dumpall - Export all talents to SavedVariables")
        print("  /stt dumpspells - Export all spell tooltips to SavedVariables")
    end
end
