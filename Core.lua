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
frame:RegisterEvent("UNIT_AURA")

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

-- Check if main hand is a dagger (for Backstab, Ambush, Mutilate)
local function IsMainHandDagger()
    local itemID = GetInventoryItemID("player", 16) -- INVSLOT_MAINHAND
    if not itemID then return false end
    local _, _, _, _, _, itemType, itemSubType = GetItemInfo(itemID)
    return itemSubType == "Daggers"
end

-- Get player's current combo points
local function GetComboPoints()
    return GetComboPoints("player", "target") or 0
end

-- Note: Rage-scaling abilities (Execute) excluded due to refresh frequency issues

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

    -- Get aura multiplier
    local auraMultiplier, auraList = 1.0, {}
    if SpellTooltips.Auras then
        auraMultiplier, auraList = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end

    local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier

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
    local talentMultiplier = schoolMultiplier * spellMultiplier
    if talentMultiplier > 1.0 and #talentList > 0 then
        local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    -- Aura multiplier line
    if auraMultiplier > 1.0 and #auraList > 0 then
        local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
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

    -- Get aura multiplier
    local auraMultiplier, auraList = 1.0, {}
    if SpellTooltips.Auras then
        auraMultiplier, auraList = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end

    local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier

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
    local talentMultiplier = schoolMultiplier * spellMultiplier
    if talentMultiplier > 1.0 and #talentList > 0 then
        local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    -- Aura multiplier line
    if auraMultiplier > 1.0 and #auraList > 0 then
        local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
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

    -- Get aura multiplier
    local auraMultiplier = 1.0
    if SpellTooltips.Auras then
        auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end

    local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier
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

-- Format physical ability damage breakdown
local function FormatPhysicalBreakdown(abilityData, comboPoints)
    local lines = {}
    local minDmg, maxDmg, ap, breakdown = addon.CalculatePhysicalDamage(abilityData, comboPoints)

    if not minDmg or minDmg == 0 then
        return lines
    end

    -- Check if using 2H weapon for talent calculations
    local is2H = IsTwoHandedWeapon()

    -- Get damage multipliers from talents (physical-specific, checks 2H requirement and school)
    local spellMultiplier, spellTalents = Talents.GetPhysicalMultiplier(abilityData.name, is2H, abilityData.school)

    -- Weapon damage abilities (Sinister Strike, Backstab, etc.)
    if abilityData.weaponPct then
        -- Format weapon damage string
        local function formatDmgRange(min, max)
            if math.floor(min) == math.floor(max) then
                return tostring(math.floor(min))
            else
                return string.format("%d-%d", math.floor(min), math.floor(max))
            end
        end

        local normNote = breakdown.normalized and string.format(" (%.1fs norm)", breakdown.normalized) or ""

        -- Both hands (Mutilate, Stormstrike)
        if breakdown.hitsBothHands then
            local mhStr = formatDmgRange(breakdown.weaponMin, breakdown.weaponMax)
            local ohStr = formatDmgRange(breakdown.weaponMinOH, breakdown.weaponMaxOH)
            local ohPct = math.floor(breakdown.ohMultiplier * 100)

            table.insert(lines, string.format("%sMain Hand: %s%s%s", C.WHITE, C.GRAY, mhStr, normNote))
            table.insert(lines, string.format("%sOff Hand: %s%s (%d%%)%s", C.WHITE, C.GRAY, ohStr, ohPct, normNote))

            if abilityData.weaponPct ~= 1.0 then
                table.insert(lines, string.format("%sMultiplier: %s%.0f%% each", C.WHITE, C.GRAY, abilityData.weaponPct * 100))
            end

            if breakdown.flatBonus and breakdown.flatBonus > 0 then
                table.insert(lines, string.format("%sFlat bonus: %s+%d per hand", C.WHITE, C.GRAY, breakdown.flatBonus))
            end

        -- Off-hand only (Shiv)
        elseif breakdown.usesOffhand then
            local ohStr = formatDmgRange(breakdown.weaponMin, breakdown.weaponMax)
            local ohPct = math.floor(breakdown.ohMultiplier * 100)

            table.insert(lines, string.format("%sOff Hand: %s%s (%d%%)%s", C.WHITE, C.GRAY, ohStr, ohPct, normNote))

            if abilityData.weaponPct ~= 1.0 then
                table.insert(lines, string.format("%sMultiplier: %s%.0f%%", C.WHITE, C.GRAY, abilityData.weaponPct * 100))
            end

        -- Main hand only (default)
        else
            local weaponStr = formatDmgRange(breakdown.weaponMin, breakdown.weaponMax)
            table.insert(lines, string.format("%sWeapon: %s%s%s", C.WHITE, C.GRAY, weaponStr, normNote))

            if abilityData.weaponPct ~= 1.0 then
                table.insert(lines, string.format("%sMultiplier: %s%.0f%%", C.WHITE, C.GRAY, abilityData.weaponPct * 100))
            end

            if breakdown.flatBonus and breakdown.flatBonus > 0 then
                table.insert(lines, string.format("%sFlat bonus: %s+%d", C.WHITE, C.GRAY, breakdown.flatBonus))
            end
        end

    -- Finisher abilities with CP scaling (Eviscerate, etc.)
    elseif abilityData.isFinisher and abilityData.baseDmgMin then
        local cp = comboPoints > 0 and comboPoints or 5
        table.insert(lines, string.format("%sBase (%dCP): %s%d-%d",
            C.WHITE, cp, C.GRAY, abilityData.baseDmgMin[cp], abilityData.baseDmgMax[cp]))

        if breakdown.apBonus and breakdown.apBonus > 0 then
            local apCoeffPct = (abilityData.apPerCP or 0) * cp * 100
            table.insert(lines, string.format("%sAP bonus: %s+%d (%.0f%% AP)",
                C.WHITE, C.GRAY, math.floor(breakdown.apBonus), apCoeffPct))
        end

    -- DoT abilities (Rupture, Garrote)
    elseif abilityData.tickDmg then
        local ticks = breakdown.ticks or 6
        table.insert(lines, string.format("%sPer tick: %s%d (x%d ticks)",
            C.WHITE, C.GRAY, math.floor(breakdown.perTick), ticks))

        if breakdown.apBonus and breakdown.apBonus > 0 then
            table.insert(lines, string.format("%sAP bonus: %s+%d total",
                C.WHITE, C.GRAY, math.floor(breakdown.apBonus)))
        end

    -- Envenom (damage per poison dose)
    elseif abilityData.dmgPerDose then
        local cp = comboPoints > 0 and comboPoints or 5
        table.insert(lines, string.format("%sPer dose (%dCP): %s%d",
            C.WHITE, cp, C.GRAY, breakdown.dmgPerDose))
        table.insert(lines, string.format("%sAssuming %d doses: %s%d",
            C.WHITE, breakdown.doses, C.GRAY, math.floor(minDmg)))

    -- Flat damage abilities (Kick, Gouge)
    elseif abilityData.flatDmg then
        table.insert(lines, string.format("%sFlat damage: %s%d", C.WHITE, C.GRAY, abilityData.flatDmg))

    -- AP-based abilities (Bloodthirst, Victory Rush)
    elseif abilityData.apPct then
        local ap = addon.GetPlayerAttackPower()
        local damage = math.floor(ap * abilityData.apPct)
        table.insert(lines, string.format("%sAttack Power: %s%d", C.WHITE, C.GRAY, ap))
        table.insert(lines, string.format("%sDamage: %s%d %s(%.0f%% AP)",
            C.WHITE, SCHOOL_COLORS.physical, damage, C.GRAY, abilityData.apPct * 100))
        minDmg, maxDmg = damage, damage

    -- Shield Slam (block value scaling)
    elseif abilityData.blockValueMod then
        local blockValue = addon.GetPlayerBlockValue()
        local damage = ((abilityData.baseDmgMin + abilityData.baseDmgMax) / 2) + (blockValue * abilityData.blockValueMod)

        table.insert(lines, string.format("%sBase: %s%d-%d", C.WHITE, C.GRAY, abilityData.baseDmgMin, abilityData.baseDmgMax))
        table.insert(lines, string.format("%sBlock value: %s+%d", C.WHITE, C.GRAY, blockValue))
        minDmg = abilityData.baseDmgMin + blockValue
        maxDmg = abilityData.baseDmgMax + blockValue

    -- Devastate (per-sunder stack scaling)
    elseif abilityData.flatPerSunder then
        local sunders = 5  -- Assume max stacks for display
        local weaponMin, weaponMax = addon.GetMainHandDamage()
        local weaponDmg = (weaponMin + weaponMax) / 2 * abilityData.weaponPct
        local sunderBonus = abilityData.flatPerSunder * sunders

        table.insert(lines, string.format("%sWeapon: %s%.0f %s(%.0f%%)", C.WHITE, C.GRAY, weaponDmg, C.GRAY, abilityData.weaponPct * 100))
        table.insert(lines, string.format("%sSunder bonus: %s+%d %s(%d × %d stacks)",
            C.WHITE, C.GRAY, sunderBonus, C.GRAY, abilityData.flatPerSunder, sunders))
        minDmg = math.floor(weaponMin * abilityData.weaponPct + sunderBonus)
        maxDmg = math.floor(weaponMax * abilityData.weaponPct + sunderBonus)

    -- Revenge (flat damage range)
    elseif abilityData.baseDmgMin and abilityData.baseDmgMax and not abilityData.isFinisher then
        table.insert(lines, string.format("%sDamage: %s%d-%d", C.WHITE, C.GRAY, abilityData.baseDmgMin, abilityData.baseDmgMax))
        minDmg, maxDmg = abilityData.baseDmgMin, abilityData.baseDmgMax
    end

    -- Talent multiplier
    if spellMultiplier > 1.0 and #spellTalents > 0 then
        local bonusPercent = math.floor((spellMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    -- Crit info for physical abilities
    local baseCritChance = GetCritChance() or 0
    local critBonus = Talents.GetCritChanceBonus(abilityData.name, "physical")
    local totalCritChance = baseCritChance + critBonus

    -- Physical crit is 200% base, Lethality adds up to 30%
    local baseCritMult = 2.0
    local critDmgBonus = 0
    local lethalityRanks = Talents.GetTalentRanksByKey("LETHALITY")
    if lethalityRanks > 0 then
        critDmgBonus = lethalityRanks * 0.06 * 100  -- Convert to percentage
    end

    if totalCritChance > 0 then
        local critNote = critDmgBonus > 0 and string.format(" (+%.0f%% Lethality)", critDmgBonus) or ""
        table.insert(lines, string.format("%sCrit: %s%.1f%%%s",
            C.WHITE, C.GRAY, totalCritChance, critNote))
    end

    -- Final damage summary
    local schoolColor = SCHOOL_COLORS[abilityData.school] or SCHOOL_COLORS.physical
    local totalLabel = abilityData.isSealProc and "Proc damage" or "Total"

    if minDmg == maxDmg then
        table.insert(lines, string.format("%s%s: %s%d", C.WHITE, totalLabel, schoolColor, math.floor(minDmg)))
    else
        table.insert(lines, string.format("%s%s: %s%d-%d", C.WHITE, totalLabel, schoolColor, math.floor(minDmg), math.floor(maxDmg)))
    end

    -- Self damage for Seal of Blood
    if abilityData.selfDamage then
        local selfMin = math.floor(minDmg * abilityData.selfDamage)
        local selfMax = math.floor(maxDmg * abilityData.selfDamage)
        if selfMin == selfMax then
            table.insert(lines, string.format("%sSelf damage: %s%d", C.WHITE, C.CRIT, selfMin))
        else
            table.insert(lines, string.format("%sSelf damage: %s%d-%d", C.WHITE, C.CRIT, selfMin, selfMax))
        end
    end

    return lines
end

-- Build tooltip for Weapon Imbues (Shaman)
local function BuildImbueTooltip(tooltip, spellID, abilityData)
    local minMH, maxMH = addon.GetMainHandDamage()
    local ap = addon.GetPlayerAttackPower()
    local spellPower = Utils.GetPlayerSpellPowerBySchool(abilityData.school) or 0

    -- Get Elemental Weapons talent multiplier
    local ewMultiplier, _ = Talents.GetSpellMultiplier(abilityData.name)
    local schoolColor = SCHOOL_COLORS[abilityData.school] or SCHOOL_COLORS.physical

    tooltip:AddLine(" ")

    -- Windfury Weapon - bonus AP and extra attack damage
    if abilityData.bonusAP then
        local bonusAP = math.floor(abilityData.bonusAP * ewMultiplier)
        -- Calculate extra attack damage with bonus AP
        -- Extra attacks use weapon damage + (total AP + bonus AP) / 14 * weapon speed
        local weaponSpeed = addon.GetMainHandSpeed()
        local apContribution = (ap + bonusAP) / 14 * weaponSpeed
        local extraMin = math.floor(minMH + apContribution - (ap / 14 * weaponSpeed))
        local extraMax = math.floor(maxMH + apContribution - (ap / 14 * weaponSpeed))

        tooltip:AddLine(string.format("Proc: %s%d extra attacks", C.GRAY, abilityData.extraAttacks), 1, 1, 1)
        tooltip:AddLine(string.format("Bonus AP: %s+%d", schoolColor, bonusAP), 1, 1, 1)
        tooltip:AddLine(string.format("Extra attack: %s+%d-%d %sdamage per hit",
            schoolColor, extraMin - math.floor(minMH), extraMax - math.floor(maxMH), C.GRAY), 1, 1, 1)

    -- Flametongue/Frostbrand - base damage + SP scaling
    elseif abilityData.baseDmg and abilityData.spCoef then
        local baseDmg = abilityData.baseDmg
        local spBonus = math.floor(spellPower * abilityData.spCoef * ewMultiplier)
        local totalDmg = math.floor((baseDmg + spBonus) * ewMultiplier)

        tooltip:AddLine(string.format("Damage per hit: %s+%d", schoolColor, totalDmg), 1, 1, 1)
        tooltip:AddLine(string.format("  Base: %s%d", C.GRAY, baseDmg), 1, 1, 1)
        tooltip:AddLine(string.format("  SP bonus: %s+%d %s(%.0f%% SP)",
            schoolColor, spBonus, C.GRAY, abilityData.spCoef * 100), 1, 1, 1)

    -- Rockbiter - flat damage bonus
    elseif abilityData.flatDmg then
        tooltip:AddLine(string.format("Bonus damage: %s+%d %sper hit",
            schoolColor, abilityData.flatDmg, C.GRAY), 1, 1, 1)
    end

    -- Elemental Weapons talent
    if ewMultiplier > 1.0 then
        local bonusPct = math.floor((ewMultiplier - 1) * 100 + 0.5)
        tooltip:AddLine(string.format("Elemental Weapons: %s+%d%%", C.GRAY, bonusPct), 1, 1, 1)
    end

    tooltip:Show()
    return true
end

-- Build tooltip for Seal abilities (Paladin)
local function BuildSealTooltip(tooltip, spellID, abilityData)
    local minMH, maxMH = addon.GetMainHandDamage()
    local is2H = IsTwoHandedWeapon()
    local spellMultiplier = Talents.GetPhysicalMultiplier(abilityData.name, is2H, abilityData.school)
    local schoolColor = SCHOOL_COLORS.holy

    -- Calculate melee proc damage
    local procMin = math.floor(minMH * abilityData.weaponPct * spellMultiplier)
    local procMax = math.floor(maxMH * abilityData.weaponPct * spellMultiplier)

    -- Calculate judgement damage (weapon + spell power)
    local judgementMin, judgementMax = 0, 0
    local spellPower = Utils.GetPlayerSpellPowerBySchool("holy") or 0

    if abilityData.judgement then
        local jData = abilityData.judgement
        local weaponMin = minMH * (jData.weaponPct or 0)
        local weaponMax = maxMH * (jData.weaponPct or 0)
        local spBonus = spellPower * (jData.spCoef or 0)

        judgementMin = math.floor((weaponMin + spBonus) * spellMultiplier)
        judgementMax = math.floor((weaponMax + spBonus) * spellMultiplier)
    end

    -- Update tooltip lines
    for i = 1, tooltip:NumLines() do
        local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
        if textLeft then
            local text = textLeft:GetText()
            if text then
                local newText = text

                -- Update melee proc damage: "deal X Holy damage" or "deals X Holy damage"
                newText = newText:gsub("(deal[s]?%s+)(%d+)(%s+Holy%s+damage)", function(prefix, dmgStr, suffix)
                    -- This is the melee proc line
                    return prefix .. schoolColor .. procMin .. "-" .. procMax .. C.RESET .. suffix
                end)

                -- Update judgement damage: "cause X to Y Holy damage"
                newText = newText:gsub("(cause%s+)(%d+)(%s+to%s+)(%d+)(%s+Holy%s+damage)", function(p1, minStr, p2, maxStr, suffix)
                    return p1 .. schoolColor .. judgementMin .. C.RESET .. p2 .. schoolColor .. judgementMax .. C.RESET .. suffix
                end)

                if newText ~= text then
                    textLeft:SetText(newText)
                end
            end
        end
    end

    -- Add breakdown
    tooltip:AddLine(" ")
    tooltip:AddLine(string.format("%sMelee proc: %s%d-%d %s(%.0f%% weapon)",
        C.WHITE, schoolColor, procMin, procMax, C.GRAY, abilityData.weaponPct * 100), 1, 1, 1)

    if abilityData.selfDamage then
        local selfMin = math.floor(procMin * abilityData.selfDamage)
        local selfMax = math.floor(procMax * abilityData.selfDamage)
        tooltip:AddLine(string.format("%s  Self damage: %s%d-%d", C.WHITE, C.CRIT, selfMin, selfMax), 1, 1, 1)
    end

    if abilityData.judgement then
        local jData = abilityData.judgement
        tooltip:AddLine(string.format("%sJudgement: %s%d-%d %s(%.0f%% wpn + %.0f%% SP)",
            C.WHITE, schoolColor, judgementMin, judgementMax, C.GRAY,
            (jData.weaponPct or 0) * 100, (jData.spCoef or 0) * 100), 1, 1, 1)

        if jData.bonusIfStunned then
            tooltip:AddLine(string.format("%s  +%.0f%% if target is stunned", C.GREEN, jData.bonusIfStunned * 100), 1, 1, 1)
        end

        if jData.selfDamage then
            local jSelfMin = math.floor(judgementMin * jData.selfDamage)
            local jSelfMax = math.floor(judgementMax * jData.selfDamage)
            tooltip:AddLine(string.format("%s  Self damage: %s%d-%d", C.WHITE, C.CRIT, jSelfMin, jSelfMax), 1, 1, 1)
        end
    end

    -- Talent breakdown
    if spellMultiplier > 1.0 then
        local bonusPct = math.floor((spellMultiplier - 1) * 100 + 0.5)
        tooltip:AddLine(string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPct), 1, 1, 1)
    end

    tooltip:Show()
    return true
end

-- Build tooltip for physical abilities
local function BuildPhysicalTooltip(tooltip, spellID, originalData)
    local abilityData = addon.GetPhysicalAbility(spellID)
    if not abilityData then return false end

    -- Handle Seals specially
    if abilityData.isSeal then
        return BuildSealTooltip(tooltip, spellID, abilityData)
    end

    -- Handle Weapon Imbues specially
    if abilityData.isImbue then
        return BuildImbueTooltip(tooltip, spellID, abilityData)
    end

    local comboPoints = GetComboPoints()
    local minDmg, maxDmg, ap, breakdown = addon.CalculatePhysicalDamage(abilityData, comboPoints)

    -- Check if using 2H weapon for talent calculations
    local is2H = IsTwoHandedWeapon()

    -- Get talent multipliers (physical-specific, checks 2H requirement and school)
    local spellMultiplier = Talents.GetPhysicalMultiplier(abilityData.name, is2H, abilityData.school)

    -- Check for warrior stance modifier
    local stanceName, stanceModifier, _ = addon.GetWarriorStance()
    local totalMultiplier = spellMultiplier * (stanceModifier or 1.0)

    -- Apply multipliers to damage
    minDmg = math.floor(minDmg * totalMultiplier)
    maxDmg = math.floor(maxDmg * totalMultiplier)

    local schoolColor = SCHOOL_COLORS[abilityData.school] or SCHOOL_COLORS.physical

    -- Update damage values in existing tooltip text
    for i = 1, tooltip:NumLines() do
        local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
        if textLeft then
            local text = textLeft:GetText()
            if text and text:len() > 20 then
                local newText = text

                -- Replace damage ranges with calculated values
                newText = newText:gsub("(%d+)(%s*[%-–to]+%s*)(%d+)(%s+damage)", function(minStr, sep, maxStr, suffix)
                    return schoolColor .. minDmg .. C.RESET .. sep .. schoolColor .. maxDmg .. C.RESET .. suffix
                end)

                -- Replace single damage values
                newText = newText:gsub("(causing%s+)(%d+)(%s+damage)", function(prefix, dmgStr, suffix)
                    return prefix .. schoolColor .. minDmg .. C.RESET .. suffix
                end)
                newText = newText:gsub("(deals%s+)(%d+)(%s+damage)", function(prefix, dmgStr, suffix)
                    return prefix .. schoolColor .. minDmg .. C.RESET .. suffix
                end)
                newText = newText:gsub("(for%s+)(%d+)(%s+damage)", function(prefix, dmgStr, suffix)
                    return prefix .. schoolColor .. minDmg .. C.RESET .. suffix
                end)

                if newText ~= text then
                    textLeft:SetText(newText)
                end
            end
        end
    end

    -- Add breakdown section
    tooltip:AddLine(" ")

    local breakdownLines = FormatPhysicalBreakdown(abilityData, comboPoints)
    for _, line in ipairs(breakdownLines) do
        tooltip:AddLine(line, 1, 1, 1)
    end

    -- Show stance modifier for warriors
    if stanceName and stanceModifier and stanceModifier ~= 1.0 then
        tooltip:AddLine(string.format("%s%s: %s%.0f%% damage",
            C.WHITE, stanceName, C.GRAY, stanceModifier * 100), 1, 1, 1)
    end

    -- Add special notes for abilities with requirements
    if abilityData.requiresDagger and not IsMainHandDagger() then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cFFFF0000Requires dagger in main hand|r", 1, 1, 1)
    end

    if abilityData.requiresBehind then
        tooltip:AddLine("|cFFFFFF00Must be behind target|r", 1, 1, 1)
    end

    if abilityData.requiresStealth then
        tooltip:AddLine("|cFFFFFF00Requires Stealth|r", 1, 1, 1)
    end

    -- On-next-swing indicator
    if abilityData.isOnNextSwing then
        tooltip:AddLine("|cFFAAAAAReplaces next auto-attack|r", 1, 1, 1)
    end

    -- AoE target indicator
    if abilityData.targets then
        tooltip:AddLine(string.format("|cFFAAAAHits %d targets|r", abilityData.targets), 1, 1, 1)
    elseif abilityData.isAoE then
        tooltip:AddLine("|cFFAAAAArea of Effect|r", 1, 1, 1)
    end

    -- Show ability-specific conditional bonuses and debuffs
    local hasConditionals = false

    if abilityData.bonusIfPoisoned then
        if not hasConditionals then
            tooltip:AddLine(" ")
            hasConditionals = true
        end
        local bonusPct = math.floor(abilityData.bonusIfPoisoned * 100)
        tooltip:AddLine(string.format("|cFF00FF00+%d%% if target is poisoned|r", bonusPct), 1, 1, 1)
    end

    if abilityData.appliesDebuff and abilityData.debuffNote then
        if not hasConditionals then
            tooltip:AddLine(" ")
            hasConditionals = true
        end
        tooltip:AddLine(string.format("|cFF00FF00Applies: %s|r", abilityData.debuffNote), 1, 1, 1)
    end

    -- Show conditional talent bonuses
    local conditionals = Talents.GetConditionalTalents("physical", abilityData.name)
    if #conditionals > 0 then
        if not hasConditionals then
            tooltip:AddLine(" ")
        end
        for _, cond in ipairs(conditionals) do
            local bonusPct = math.floor(cond.bonus * 100 + 0.5)
            tooltip:AddLine(string.format("|cFFAAAAAA+%d%% %s (%s)|r", bonusPct, cond.name, cond.condition), 1, 1, 1)
        end
    end

    tooltip:Show()
    return true
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

            -- Judgement bonus (flat SP coefficient)
            local judgementCoef = spellData.judgementCoef or 0.25
            local judgementBonus = math.floor(spellPower * judgementCoef)

            -- Get spell-specific multiplier (Improved Seal of Righteousness)
            local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)

            -- Update existing tooltip lines
            for i = 1, tooltip:NumLines() do
                local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
                if textLeft then
                    local text = textLeft:GetText()
                    if text then
                        local newText = text

                        -- Match "additional X Holy damage" (melee proc)
                        if text:find("additional") and text:find("Holy damage") then
                            newText = newText:gsub("(additional%s+)(%d+)(%s+Holy%s+damage)", function(prefix, dmgStr, suffix)
                                local baseDmg = tonumber(dmgStr)
                                local newDmg = math.floor((baseDmg + bonusDamage) * spellMultiplier)
                                return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
                            end)
                        end

                        -- Match "cause X to Y Holy damage" (judgement)
                        if text:find("cause") and text:find("Holy damage") then
                            newText = newText:gsub("(cause%s+)(%d+)(%s+to%s+)(%d+)(%s+Holy%s+damage)", function(p1, minStr, p2, maxStr, suffix)
                                local baseMin = tonumber(minStr)
                                local baseMax = tonumber(maxStr)
                                local newMin = math.floor((baseMin + judgementBonus) * spellMultiplier)
                                local newMax = math.floor((baseMax + judgementBonus) * spellMultiplier)
                                return p1 .. schoolColor .. newMin .. C.RESET .. p2 .. schoolColor .. newMax .. C.RESET .. suffix
                            end)
                        end

                        if newText ~= text then
                            textLeft:SetText(newText)
                        end
                    end
                end
            end

            tooltip:AddLine(" ")
            tooltip:AddLine(string.format("Melee: %s+%d%s (%.1f%% SP @ %.2fs)",
                schoolColor, bonusDamage, C.RESET, baseCoeff * 100, weaponSpeed), 1, 1, 1)
            tooltip:AddLine(string.format("Judgement: %s+%d%s (%.0f%% SP)",
                schoolColor, judgementBonus, C.RESET, judgementCoef * 100), 1, 1, 1)
            if spellMultiplier > 1 then
                tooltip:AddLine(string.format("Talents: %s+%.0f%%", C.GRAY, (spellMultiplier - 1) * 100), 1, 1, 1)
            end
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
-- Check if modifier key is held to show original tooltip
local function ShouldShowOriginalTooltip()
    local modifier = SpellTooltipsDB and SpellTooltipsDB.showOriginalModifier or "shift"
    if modifier == "shift" and IsShiftKeyDown() then
        return true
    elseif modifier == "ctrl" and IsControlKeyDown() then
        return true
    elseif modifier == "alt" and IsAltKeyDown() then
        return true
    elseif modifier == "none" then
        return false
    end
    return false
end

local function ProcessTooltip(tooltip, spellID)
    -- Check for modifier key to show original tooltip
    if ShouldShowOriginalTooltip() then
        return
    end

    -- Prevent reprocessing
    if tooltipProcessed and lastProcessedSpellID == spellID then
        return
    end

    DebugPrint("Processing spellID:", spellID)

    -- Check for physical ability first (v2.0.0+)
    local physicalData = addon.GetPhysicalAbility(spellID)
    if physicalData then
        DebugPrint("Found physical ability:", physicalData.name)
        local originalData = ParseTooltip(tooltip)
        local success = BuildPhysicalTooltip(tooltip, spellID, originalData)
        if success then
            DebugPrint("Physical tooltip rebuilt successfully")
            tooltipProcessed = true
            lastProcessedSpellID = spellID
        end
        return
    end

    -- Check for spell data (caster spells)
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

-- Track modifier key state for live updates
local lastModifierState = false
local currentTooltipSpellID = nil
local modifierCheckThrottle = 0

-- Reset processed flag when tooltip is cleared
local function OnTooltipCleared(tooltip)
    tooltipProcessed = false
    lastProcessedSpellID = nil
    currentTooltipSpellID = nil
    lastModifierState = false
end

-- Store the current spell ID when processing
local origProcessTooltip = ProcessTooltip
ProcessTooltip = function(tooltip, spellID)
    currentTooltipSpellID = spellID
    lastModifierState = ShouldShowOriginalTooltip()
    origProcessTooltip(tooltip, spellID)
end

-- OnUpdate to detect modifier key changes while tooltip is shown
local function OnTooltipUpdate(tooltip, elapsed)
    if not currentTooltipSpellID then return end

    -- Throttle checks to ~10 times per second
    modifierCheckThrottle = modifierCheckThrottle + elapsed
    if modifierCheckThrottle < 0.1 then return end
    modifierCheckThrottle = 0

    local currentModifierState = ShouldShowOriginalTooltip()

    if currentModifierState ~= lastModifierState then
        lastModifierState = currentModifierState
        -- Force tooltip refresh by clearing and re-setting
        local spellID = currentTooltipSpellID
        tooltipProcessed = false

        -- Clear and rebuild tooltip
        if tooltip.SetSpellByID then
            tooltip:ClearLines()
            tooltip:SetSpellByID(spellID)
        end
    end
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

    -- Hook OnUpdate for modifier key detection
    GameTooltip:HookScript("OnUpdate", OnTooltipUpdate)
    DebugPrint("Hooked OnUpdate for modifier key detection")
end

-- Event handler
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SpellTooltips" then
        SpellTooltipsDB = SpellTooltipsDB or {}
        -- Default settings
        if SpellTooltipsDB.showOriginalModifier == nil then
            SpellTooltipsDB.showOriginalModifier = "shift"  -- Options: "shift", "ctrl", "alt", "none"
        end
        local modKey = SpellTooltipsDB.showOriginalModifier
        if modKey and modKey ~= "none" then
            print("|cFF00FF00SpellTooltips|r loaded. Hold " .. modKey:upper() .. " for original tooltip. /stt for help.")
        else
            print("|cFF00FF00SpellTooltips|r loaded. Type /stt for commands.")
        end

        -- Count registered spells
        local spellCount = 0
        for _ in pairs(SpellTooltips.SpellData) do spellCount = spellCount + 1 end

        -- Count registered physical abilities
        local physicalCount = 0
        if SpellTooltips.PhysicalData then
            for _ in pairs(SpellTooltips.PhysicalData) do physicalCount = physicalCount + 1 end
        end

        if physicalCount > 0 then
            print("|cFF00FF00SpellTooltips|r", spellCount, "spells +", physicalCount, "physical abilities registered.")
        else
            print("|cFF00FF00SpellTooltips|r", spellCount, "spells registered.")
        end

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

    elseif event == "UNIT_AURA" and arg1 == "player" then
        -- Invalidate aura cache when player buffs change
        if SpellTooltips.Auras then
            SpellTooltips.Auras.InvalidateCache()
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
    elseif msg == "physical" then
        print("|cFF00FF00SpellTooltips|r Registered physical abilities:")
        local count = 0
        if SpellTooltips.PhysicalData then
            for id, data in pairs(SpellTooltips.PhysicalData) do
                count = count + 1
                if count <= 15 then
                    local typeStr = ""
                    if data.isFinisher then typeStr = " (finisher)"
                    elseif data.isDot then typeStr = " (DoT)"
                    elseif data.weaponPct then typeStr = string.format(" (%.0f%% wpn)", data.weaponPct * 100)
                    end
                    print(string.format("  [%d] %s%s", id, data.name, typeStr))
                end
            end
        end
        print(string.format("  ... %d total physical abilities", count))
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
    elseif msg == "classinfo" then
        -- Dump all class spells, tooltips, and talents to SavedVariables
        SpellTooltipsDB = SpellTooltipsDB or {}

        -- Clear old export sections to avoid confusion
        SpellTooltipsDB.TalentDump = nil
        SpellTooltipsDB.TalentScan = nil

        local _, className = UnitClass("player")
        local localizedClass, _ = UnitClass("player")

        -- Create a hidden tooltip for scanning
        local scanTip = CreateFrame("GameTooltip", "STTClassInfoTooltip", nil, "GameTooltipTemplate")
        scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")

        print("|cFF00FF00SpellTooltips|r Generating class info for", localizedClass)

        -- Initialize ClassInfo structure
        SpellTooltipsDB.ClassInfo = {
            class = className,
            localizedClass = localizedClass,
            exportedAt = date("%Y-%m-%d %H:%M:%S"),
            spells = {},
            talents = {
                trees = {},
                configured = {}
            }
        }

        -- Get talent tree names and talents
        print("  Scanning talents...")
        for tab = 1, 3 do
            local treeName, _, _, _ = GetTalentTabInfo(tab)
            SpellTooltipsDB.ClassInfo.talents.trees[tab] = {
                name = treeName or ("Tree " .. tab),
                talents = {}
            }

            for i = 1, 30 do
                local name, iconTexture, tier, column, rank, maxRank = GetTalentInfo(tab, i)
                if name then
                    SpellTooltipsDB.ClassInfo.talents.trees[tab].talents[i] = {
                        name = name,
                        tier = tier or 0,
                        column = column or 0,
                        currentRanks = rank or 0,
                        maxRanks = maxRank or 0
                    }
                end
            end
        end

        -- Get configured talents from TalentData
        for key, info in pairs(SpellTooltips.TalentInfo or {}) do
            if info.class == className then
                local ranks = Talents.GetTalentRanksByKey(key)
                SpellTooltipsDB.ClassInfo.talents.configured[key] = {
                    name = info.name,
                    tab = info.tab,
                    index = info.index,
                    maxRanks = info.maxRanks,
                    currentRanks = ranks,
                    type = info.type,
                    perRank = info.perRank,
                    school = info.school,
                    affects = info.affects
                }
            end
        end

        -- Get ALL spells from the player's spellbook
        print("  Scanning spellbook...")
        local spellCount = 0
        local seenSpells = {}

        -- Iterate through all spellbook tabs
        for tab = 1, GetNumSpellTabs() do
            local tabName, tabTexture, offset, numSpells = GetSpellTabInfo(tab)
            for i = offset + 1, offset + numSpells do
                local spellType, spellID = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)
                if spellType == "SPELL" and spellID and not seenSpells[spellID] then
                    seenSpells[spellID] = true

                    local spellName, spellRank = GetSpellInfo(spellID)
                    if spellName then
                        -- Scan tooltip
                        scanTip:ClearLines()
                        scanTip:SetSpellByID(spellID)

                        local tooltipLines = {}
                        for j = 1, scanTip:NumLines() do
                            local textLeft = _G["STTClassInfoTooltipTextLeft" .. j]
                            if textLeft then
                                local text = textLeft:GetText()
                                if text and text ~= "" then
                                    table.insert(tooltipLines, text)
                                end
                            end
                        end

                        -- Check if we have coefficient data for this spell
                        local spellData = SpellTooltips.SpellData[spellID]

                        SpellTooltipsDB.ClassInfo.spells[spellID] = {
                            name = spellName,
                            rank = spellRank,
                            tab = tabName,
                            school = spellData and spellData.school or nil,
                            coefficient = spellData and spellData.coefficient or nil,
                            dotCoefficient = spellData and spellData.dotCoefficient or nil,
                            castTime = spellData and spellData.castTime or nil,
                            isHealing = spellData and spellData.isHealing or nil,
                            isDot = spellData and spellData.isDot or nil,
                            isChanneled = spellData and spellData.isChanneled or nil,
                            isAbsorb = spellData and spellData.isAbsorb or nil,
                            isSeal = spellData and spellData.isSeal or nil,
                            ticks = spellData and spellData.ticks or nil,
                            hasCoefficient = spellData ~= nil,
                            tooltip = tooltipLines
                        }
                        spellCount = spellCount + 1
                    end
                end
            end
        end

        print(string.format("|cFF00FF00SpellTooltips|r Export complete!"))
        print(string.format("  Class: %s", localizedClass))
        print(string.format("  Spells: %d", spellCount))
        print(string.format("  Talents: %d configured", Utils.TableCount(SpellTooltipsDB.ClassInfo.talents.configured)))
        print("  /reload then copy from:")
        print("  WTF/Account/<name>/SavedVariables/SpellTooltips.lua")
        print("  Look for ClassInfo section")

    elseif msg == "auras" then
        -- List active auras affecting damage
        print("|cFF00FF00SpellTooltips|r Active damage auras:")
        if SpellTooltips.Auras then
            local activeAuras = SpellTooltips.Auras.GetActiveAuras()
            if #activeAuras == 0 then
                print("  No tracked auras active")
            else
                for _, aura in ipairs(activeAuras) do
                    local bonusStr = string.format("+%.0f%% damage", aura.bonus * 100)
                    local schoolStr = aura.school and (" (" .. aura.school .. ")") or ""
                    print(string.format("  %s: %s%s", aura.name, bonusStr, schoolStr))
                end
            end
        else
            print("  Aura tracking not loaded")
        end

    elseif msg:match("^modifier%s+(%w+)$") then
        -- Set modifier key: /stt modifier shift|ctrl|alt|none
        local modifier = msg:match("^modifier%s+(%w+)$"):lower()
        if modifier == "shift" or modifier == "ctrl" or modifier == "alt" or modifier == "none" then
            SpellTooltipsDB.showOriginalModifier = modifier
            if modifier == "none" then
                print("|cFF00FF00SpellTooltips|r Original tooltip disabled (always show enhanced)")
            else
                print("|cFF00FF00SpellTooltips|r Hold " .. modifier:upper() .. " to show original tooltip")
            end
        else
            print("|cFF00FF00SpellTooltips|r Invalid modifier. Use: shift, ctrl, alt, or none")
        end
    elseif msg == "modifier" then
        -- Show current modifier setting
        local current = SpellTooltipsDB.showOriginalModifier or "shift"
        if current == "none" then
            print("|cFF00FF00SpellTooltips|r Original tooltip: disabled")
        else
            print("|cFF00FF00SpellTooltips|r Hold " .. current:upper() .. " to show original tooltip")
        end
        print("  Change with: /stt modifier shift|ctrl|alt|none")
    else
        print("|cFF00FF00SpellTooltips|r v2.3.0")
        print("  /stt debug - Toggle debug mode")
        print("  /stt talents - Show detected talents")
        print("  /stt spells - Show registered spells")
        print("  /stt physical - Show registered physical abilities")
        print("  /stt auras - Show active damage auras")
        print("  /stt modifier - Show/set key to view original tooltip")
        print("  /stt scan 1|2|3 - Scan talent tree")
        print("  /stt scan 1|2|3 save - Scan and save to file")
        print("  /stt dumpall - Export all talents to SavedVariables")
        print("  /stt dumpspells - Export all spell tooltips to SavedVariables")
        print("  /stt classinfo - Export full class info (spells + talents)")
    end
end
