-- SpellTooltips Core
-- Caster spell tooltip enhancements with spellpower coefficients

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
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- Track if we've already processed this tooltip
local tooltipProcessed = false
local lastProcessedSpellID = nil

-- Weapon data cache (refreshed on equipment change)
local weaponCache = {
    valid = false,
    speed = 2.0,
    is2H = false,
    minDmg = 0,
    maxDmg = 0,
}

-- Debug mode flag (off by default)
local DEBUG_MODE = false

local function DebugPrint(...)
    if DEBUG_MODE then
        print("|cFFFF8000[STT]|r", ...)
    end
end

-- Round to nearest integer (instead of floor/truncate)
local function Round(x)
    return math.floor(x + 0.5)
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
    CRIT = "|cFFFF4444",
    RESET = "|r",
}

-- School colors (matching WoW's damage school colors)
local SCHOOL_COLORS = {
    holy = "|cFFFFB3E6",
    fire = "|cFFFF8000",
    nature = "|cFF4DFF4D",
    frost = "|cFF80FFFF",
    shadow = "|cFF9482C9",
    arcane = "|cFFFF80FF",
    frostfire = "|cFFFF80C0",
    spellfire = "|cFFFF8000",
    shadowfrost = "|cFF8080FF",
    holyfire = "|cFFFFCC00",
    healing = "|cFF00FF66",
}

-- Get color for a damage school (or healing)
local function GetSchoolColor(school, isHealing)
    if not school then return C.WHITE end
    if isHealing then return SCHOOL_COLORS.healing end
    return SCHOOL_COLORS[string.lower(school)] or C.WHITE
end

-- Refresh weapon cache (called on equipment change)
local function RefreshWeaponCache()
    -- Get weapon speed
    local speed, _ = UnitAttackSpeed("player")
    weaponCache.speed = speed or 2.0

    -- Check if 2H weapon
    local itemID = GetInventoryItemID("player", 16)
    if itemID then
        local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemID)
        weaponCache.is2H = (itemEquipLoc == "INVTYPE_2HWEAPON")
    else
        weaponCache.is2H = false
    end

    -- Get weapon damage (includes AP, used as approximation)
    local minDmg, maxDmg, _, _, _, _ = UnitDamage("player")
    weaponCache.minDmg = minDmg or 0
    weaponCache.maxDmg = maxDmg or 0

    weaponCache.valid = true
    DebugPrint("Weapon cache refreshed - Speed:", weaponCache.speed, "2H:", weaponCache.is2H, "Dmg:", weaponCache.minDmg, "-", weaponCache.maxDmg)
end

-- Ensure weapon cache is valid
local function EnsureWeaponCache()
    if not weaponCache.valid then
        RefreshWeaponCache()
    end
end

-- Invalidate weapon cache (called on equipment change)
local function InvalidateWeaponCache()
    weaponCache.valid = false
end

-- Get main hand weapon speed (for seal calculations)
local function GetMainHandSpeed()
    EnsureWeaponCache()
    return weaponCache.speed
end

-- Check if using two-handed weapon (for Seal of Righteousness)
local function IsTwoHandedWeapon()
    EnsureWeaponCache()
    return weaponCache.is2H
end

-- Get main hand weapon damage (min, max)
local function GetMainHandWeaponDamage()
    EnsureWeaponCache()
    return weaponCache.minDmg, weaponCache.maxDmg
end

-- Patterns for parsing tooltip
local PATTERNS = {
    DAMAGE_RANGE = "(%d+)%s*[%-–]%s*(%d+)",
    DAMAGE_RANGE_TO = "(%d+)%s+to%s+(%d+)",
    SINGLE_DAMAGE = "(%d+)%s+%a+%s+damage",
    CHANNELED_DAMAGE = "(%d+)%s+%a+%s+damage%s+over",
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

        if leftText and leftText:match(PATTERNS.NEXT_RANK) then
            inNextRank = true
        end

        if not inNextRank then
            if i == 1 then
                data.name = leftText
            elseif i == 2 and leftText and leftText:match("^Rank %d+") then
                data.rank = leftText:match("Rank (%d+)")
            else
                if leftText then
                    local castTime = leftText:match(PATTERNS.CAST_TIME)
                    if castTime then data.castTime = tonumber(castTime) end
                    if leftText:match(PATTERNS.CHANNELED) then data.isChanneled = true end
                    if leftText:match(PATTERNS.INSTANT) then data.isInstant = true end
                    local mana = leftText:match(PATTERNS.MANA_COST)
                    if mana then data.manaCost = tonumber(mana) end
                    local cdAmount, cdUnit = leftText:match(PATTERNS.COOLDOWN)
                    if cdAmount then data.cooldown = { amount = tonumber(cdAmount), unit = cdUnit } end
                end

                if rightText then
                    local range = rightText:match(PATTERNS.RANGE)
                    if range then data.range = tonumber(range) end
                end

                if leftText and leftText:len() > 20 then
                    table.insert(data.descriptionLines, leftText)
                    -- Try hyphen/dash pattern first
                    local minDmg, maxDmg = leftText:match(PATTERNS.DAMAGE_RANGE)
                    -- Then try "X to Y" pattern
                    if not minDmg then
                        minDmg, maxDmg = leftText:match(PATTERNS.DAMAGE_RANGE_TO)
                    end
                    if minDmg and maxDmg and not data.damageMin then
                        data.damageMin = tonumber(minDmg)
                        data.damageMax = tonumber(maxDmg)
                    end
                    if not data.damageMin then
                        local singleDmg = leftText:match(PATTERNS.CHANNELED_DAMAGE)
                        if singleDmg then
                            data.damageMin = tonumber(singleDmg)
                            data.damageMax = tonumber(singleDmg)
                        end
                    end
                    if not data.damageMin then
                        local singleDmg = leftText:match(PATTERNS.SINGLE_DAMAGE)
                        if singleDmg then
                            data.damageMin = tonumber(singleDmg)
                            data.damageMax = tonumber(singleDmg)
                        end
                    end
                    local dotDmg, dotDur = leftText:match(PATTERNS.DOT_DAMAGE)
                    if dotDmg and dotDur then
                        data.dotDamage = tonumber(dotDmg)
                        data.dotDuration = tonumber(dotDur)
                    end
                    local slow = leftText:match(PATTERNS.SLOW)
                    if slow then table.insert(data.effects, slow) end
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

    return Round((baseDamage + bonusDamage) * multiplier)
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
    local includedMultiplier = Talents.GetSpellMultiplierIncluded(spellData.name)

    local auraMultiplier, auraList = 1.0, {}
    if SpellTooltips.Auras then
        auraMultiplier, auraList = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end

    local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier
    -- SP bonus gets both regular multipliers AND included multipliers
    local spBonusMultiplier = multiplier * includedMultiplier
    local bonusDamage = Round(spellPower * modifiedCoeff * spBonusMultiplier)
    local coeffStr = Utils.FormatCoefficient(modifiedCoeff)
    local powerLabel = spellData.isHealing and "HP" or "SP"

    if spellData.isSecondary then
        table.insert(lines, string.format("%s%s bonus: %s+%d (%s)", C.WHITE, powerLabel, C.GRAY, bonusDamage, coeffStr))
        return lines
    end

    local talentList = {}
    for _, t in ipairs(schoolTalents) do table.insert(talentList, t) end
    for _, t in ipairs(spellTalents) do table.insert(talentList, t) end

    local baseStr
    if data.damageMin == data.damageMax then
        baseStr = tostring(data.damageMin)
    else
        baseStr = string.format("%d-%d", data.damageMin, data.damageMax)
    end

    table.insert(lines, string.format("%sBase: %s%s", C.WHITE, C.GRAY, baseStr))
    table.insert(lines, string.format("%sBonus: %s+%d (%s %s)", C.WHITE, C.GRAY, bonusDamage, coeffStr, powerLabel))

    local talentMultiplier = schoolMultiplier * spellMultiplier
    if talentMultiplier > 1.0 then
        local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    if auraMultiplier > 1.0 and #auraList > 0 then
        local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

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

-- Format channeled spell damage as formula
local function FormatChanneledDamage(data, spellData, spellPower)
    local lines = {}

    if not data.damageMin or not spellData then
        return lines
    end

    local modifiedCoeff, coeffBonus = Talents.GetModifiedCoefficient(spellData)
    local schoolMultiplier, schoolTalents = Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier, spellTalents = Talents.GetSpellMultiplier(spellData.name)
    local includedMultiplier = Talents.GetSpellMultiplierIncluded(spellData.name)

    local auraMultiplier, auraList = 1.0, {}
    if SpellTooltips.Auras then
        auraMultiplier, auraList = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end

    local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier
    local spBonusMultiplier = multiplier * includedMultiplier

    local talentList = {}
    for _, t in ipairs(schoolTalents) do table.insert(talentList, t) end
    for _, t in ipairs(spellTalents) do table.insert(talentList, t) end

    local ticks = spellData.ticks or 1
    local perTickCoeff = modifiedCoeff / ticks
    local perTickBonus = Round(spellPower * perTickCoeff * spBonusMultiplier)
    local totalBonus = Round(spellPower * modifiedCoeff * spBonusMultiplier)
    local powerLabel = spellData.isHealing and "HP" or "SP"

    table.insert(lines, string.format("%sBase: %s%d per tick", C.WHITE, C.GRAY, data.damageMin))

    if ticks > 1 then
        local perTickCoeffStr = Utils.FormatCoefficient(perTickCoeff)
        local totalCoeffStr = Utils.FormatCoefficient(modifiedCoeff)
        table.insert(lines, string.format("%sBonus: %s+%d/tick (%s), +%d total (%s)",
            C.WHITE, C.GRAY, perTickBonus, perTickCoeffStr, totalBonus, totalCoeffStr))
    else
        local coeffStr = Utils.FormatCoefficient(modifiedCoeff)
        table.insert(lines, string.format("%sBonus: %s+%d (%s %s)", C.WHITE, C.GRAY, totalBonus, coeffStr, powerLabel))
    end

    local talentMultiplier = schoolMultiplier * spellMultiplier
    if talentMultiplier > 1.0 then
        local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

    if auraMultiplier > 1.0 and #auraList > 0 then
        local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
        table.insert(lines, string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent))
    end

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

    if coefficient == 0 and dotCoefficient == 0 then return text end

    local modifiedCoeff = Talents.GetModifiedCoefficient(spellData)
    local ticks = spellData.ticks or 1
    local perTickCoeff = modifiedCoeff / ticks

    local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
    -- Multipliers already in tooltip base (apply to SP bonus only)
    local includedMultiplier = Talents.GetSpellMultiplierIncluded(spellData.name)

    local auraMultiplier = 1.0
    if SpellTooltips.Auras then
        auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end

    local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier
    -- Total multiplier for SP bonus includes both external and included multipliers
    local spBonusMultiplier = multiplier * includedMultiplier
    local schoolColor = GetSchoolColor(spellData.school, spellData.isHealing)

    local newText = text

    -- Replace damage range (hyphen/dash format: "100-200" or "100 - 200")
    -- Formula: base * multiplier + spBonus * spBonusMultiplier
    -- (base already has includedMultiplier, SP bonus needs it applied)
    if coefficient > 0 then
        newText = newText:gsub("(%d+)(%s*[%-–]%s*)(%d+)", function(minStr, sep, maxStr)
            local minDmg = tonumber(minStr)
            local maxDmg = tonumber(maxStr)
            local bonusDamage = spellPower * perTickCoeff
            local newMin = Round(minDmg * multiplier + bonusDamage * spBonusMultiplier)
            local newMax = Round(maxDmg * multiplier + bonusDamage * spBonusMultiplier)
            return schoolColor .. newMin .. C.RESET .. sep .. schoolColor .. newMax .. C.RESET
        end)
        -- Replace damage range ("X to Y" format)
        newText = newText:gsub("(%d+)(%s+to%s+)(%d+)", function(minStr, sep, maxStr)
            local minDmg = tonumber(minStr)
            local maxDmg = tonumber(maxStr)
            local bonusDamage = spellPower * perTickCoeff
            local newMin = Round(minDmg * multiplier + bonusDamage * spBonusMultiplier)
            local newMax = Round(maxDmg * multiplier + bonusDamage * spBonusMultiplier)
            return schoolColor .. newMin .. C.RESET .. sep .. schoolColor .. newMax .. C.RESET
        end)
    end

    -- Replace DoT damage
    if dotCoefficient > 0 then
        newText = newText:gsub("(additional%s+)(%d+)(%s+%a+%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * dotCoefficient
            local newDmg = Round(dmg * multiplier + bonusDamage * spBonusMultiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
    end

    -- Handle "X damage over Y sec" patterns (total damage, not per-tick)
    if spellData.isDot or spellData.isChanneled then
        -- This pattern shows TOTAL damage, so use full coefficient
        local totalDmgCoeff = (coefficient > 0) and modifiedCoeff or dotCoefficient
        if totalDmgCoeff > 0 then
            newText = newText:gsub("(%s)(%d+)(%s+%a+%s+damage%s+over)", function(prefix, dmgStr, suffix)
                local dmg = tonumber(dmgStr)
                local bonusDamage = spellPower * totalDmgCoeff
                local newDmg = Round(dmg * multiplier + bonusDamage * spBonusMultiplier)
                return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
            end)
        end
    end

    if coefficient > 0 then
        -- Use per-tick coefficient for channeled/DoT spells, full coefficient otherwise
        local effectiveCoeff = (spellData.isChanneled or spellData.isDot) and perTickCoeff or modifiedCoeff

        -- Various damage patterns
        local patterns = {
            "(%s)(%d+)(%s+%a+%s+damage%s+to%s)",
            "(causing%s+)(%d+)(%s+%a+%s+damage)",
            "(%s)(%d+)(%s+%a+%s+damage%s+every)",
            "(%s)(%d+)(%s+%a+%s+damage%s+when)",
            "(%s)(%d+)(%s+%a+%s+damage%s+for)",
            "(inflicts%s+)(%d+)(%s+%a+%s+damage)",
            "(causes%s+)(%d+)(%s+%a+%s+damage)",
            "(deals%s+)(%d+)(%s+%a+%s+damage%.?)",
            "(for%s+)(%d+)(%s+%a+%s+damage)",
        }

        for _, pattern in ipairs(patterns) do
            newText = newText:gsub(pattern, function(prefix, dmgStr, suffix)
                local dmg = tonumber(dmgStr)
                local bonusDamage = spellPower * effectiveCoeff
                local newDmg = Round(dmg * multiplier + bonusDamage * spBonusMultiplier)
                return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
            end)
        end
    end

    -- Handle absorption spells
    if spellData.isAbsorb and coefficient > 0 then
        newText = newText:gsub("([Aa]bsorbs?%s+)(%d+)(%s+damage)", function(prefix, dmgStr, suffix)
            local dmg = tonumber(dmgStr)
            local bonusDamage = spellPower * modifiedCoeff
            local newDmg = Round(dmg * multiplier + bonusDamage * spBonusMultiplier)
            return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
        end)
    end

    return newText
end

-- Build tooltip for caster spells
local function BuildTooltip(tooltip, spellID, originalData)
    local spellData = addon.GetSpellDataByID(spellID)
    if not spellData then return false end

    local spellPower = addon.GetSpellPowerForSpell(spellData)
    local schoolColor = GetSchoolColor(spellData.school, spellData.isHealing)

    -- Special handling for Absorption spells
    if spellData.isAbsorb then
        local modifiedCoeff = Talents.GetModifiedCoefficient(spellData)
        local bonusAbsorb = Round(spellPower * modifiedCoeff)
        local coeffStr = Utils.FormatCoefficient(modifiedCoeff)
        local powerLabel = spellData.isHealing and "HP" or "SP"

        for i = 1, tooltip:NumLines() do
            local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
            if textLeft then
                local text = textLeft:GetText()
                if text and text:find("damage") then
                    local newText = text
                    newText = newText:gsub("(%s)(%d+)(%s+damage)", function(prefix, absorbStr, suffix)
                        local baseAbsorb = tonumber(absorbStr)
                        local newAbsorb = math.floor(baseAbsorb + bonusAbsorb)
                        return prefix .. schoolColor .. newAbsorb .. C.RESET .. suffix
                    end)
                    newText = newText:gsub("(absorbing%s+)(%s+)(%d+)(%s+damage)", function(prefix, absorbStr, suffix)
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

        tooltip:AddLine(" ")
        tooltip:AddLine(string.format("%s bonus: %s+%d%s (%s)", powerLabel, schoolColor, bonusAbsorb, C.RESET, coeffStr), 1, 1, 1)
        tooltip:Show()
        return true
    end

    -- Special handling for Seal spells (Paladin)
    if spellData.isSeal then
        if spellData.isStackingDot then
            -- Get all multipliers
            local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
            local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
            local includedMultiplier = Talents.GetSpellMultiplierIncluded(spellData.name)
            local auraMultiplier = 1.0
            if SpellTooltips.Auras then
                auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
            end
            local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier
            local spBonusMultiplier = multiplier * includedMultiplier

            local perStackBonus = Round(spellPower * spellData.coefficientPerStack * spBonusMultiplier)
            local maxBonus = Round(spellPower * spellData.coefficientPerStack * spellData.maxStacks * spBonusMultiplier)

            tooltip:AddLine(" ")
            tooltip:AddLine(string.format("Per stack: %s+%d%s (%.0f%% SP)",
                schoolColor, perStackBonus, C.RESET, spellData.coefficientPerStack * 100), 1, 1, 1)
            tooltip:AddLine(string.format("At %d stacks: %s+%d%s (%.0f%% SP)",
                spellData.maxStacks, schoolColor, maxBonus, C.RESET,
                spellData.coefficientPerStack * spellData.maxStacks * 100), 1, 1, 1)
        else
            local weaponSpeed = GetMainHandSpeed()
            local is2H = IsTwoHandedWeapon()
            local baseCoeff = is2H and spellData.baseCoeff2H or spellData.baseCoeff1H
            local coefficient = baseCoeff * weaponSpeed

            -- Get weapon damage for seal formula (0.03 * avg weapon dmg)
            local wpnMinDmg, wpnMaxDmg = GetMainHandWeaponDamage()
            local avgWeaponDmg = (wpnMinDmg + wpnMaxDmg) / 2
            local weaponDmgCoeff = spellData.weaponDmgCoeff or 0
            local weaponDmgBonus = weaponDmgCoeff * avgWeaponDmg

            -- Get all multipliers
            local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
            local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
            local includedMultiplier = Talents.GetSpellMultiplierIncluded(spellData.name)
            local auraMultiplier = 1.0
            if SpellTooltips.Auras then
                auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
            end
            local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier
            local spBonusMultiplier = multiplier * includedMultiplier

            -- Seal damage = (baseDmg + SP * coeff + weaponDmgBonus) * multiplier
            -- Calculate raw bonuses (before multiplier - multiplier applied to total)
            local spBonus = spellPower * coefficient
            local wpnBonus = weaponDmgBonus
            local rawBonusDamage = spBonus + wpnBonus

            local judgementCoef = spellData.judgementCoef or 0.25
            local rawJudgementBonus = spellPower * judgementCoef

            for i = 1, tooltip:NumLines() do
                local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
                if textLeft then
                    local text = textLeft:GetText()
                    if text then
                        local newText = text
                        if text:find("additional") and text:find("Holy damage") then
                            newText = newText:gsub("(additional%s+)(%d+)(%s+Holy%s+damage)", function(prefix, dmgStr, suffix)
                                local baseDmg = tonumber(dmgStr)
                                -- Formula: (base + SP_bonus + wpn_bonus) * multiplier
                                local newDmg = Round((baseDmg + rawBonusDamage) * multiplier)
                                return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
                            end)
                        end
                        if text:find("cause") and text:find("Holy damage") then
                            newText = newText:gsub("(cause%s+)(%d+)(%s+to%s+)(%d+)(%s+Holy%s+damage)", function(p1, minStr, p2, maxStr, suffix)
                                local baseMin = tonumber(minStr)
                                local baseMax = tonumber(maxStr)
                                -- Formula: (base + judgement_bonus) * multiplier
                                local newMin = Round((baseMin + rawJudgementBonus) * multiplier)
                                local newMax = Round((baseMax + rawJudgementBonus) * multiplier)
                                return p1 .. schoolColor .. newMin .. C.RESET .. p2 .. schoolColor .. newMax .. C.RESET .. suffix
                            end)
                        end
                        if newText ~= text then
                            textLeft:SetText(newText)
                        end
                    end
                end
            end

            -- Display the bonus from SP/weapon (after multiplier for display)
            local displayBonus = Round(rawBonusDamage * multiplier)
            local displayJudgementBonus = Round(rawJudgementBonus * multiplier)

            tooltip:AddLine(" ")
            tooltip:AddLine(string.format("Melee: %s+%d%s (%.1f%% SP @ %.2fs + %.0f%% WpnDmg)",
                schoolColor, displayBonus, C.RESET, coefficient * 100, weaponSpeed, weaponDmgCoeff * 100), 1, 1, 1)
            tooltip:AddLine(string.format("Judgement: %s+%d%s (%.0f%% SP)",
                schoolColor, displayJudgementBonus, C.RESET, judgementCoef * 100), 1, 1, 1)
            local talentMultiplier = schoolMultiplier * spellMultiplier
            if talentMultiplier > 1 then
                tooltip:AddLine(string.format("Talents: %s+%.0f%%", C.GRAY, (talentMultiplier - 1) * 100), 1, 1, 1)
            end
            if auraMultiplier > 1 then
                tooltip:AddLine(string.format("Auras: %s+%.0f%%", C.GRAY, (auraMultiplier - 1) * 100), 1, 1, 1)
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

    local damageLines
    if spellData.isChanneled and originalData.damageMin then
        damageLines = FormatChanneledDamage(originalData, spellData, spellPower)
    else
        damageLines = FormatDamageBreakdown(originalData, spellData, spellPower)
    end

    for _, line in ipairs(damageLines) do
        tooltip:AddLine(line, 1, 1, 1)
    end

    tooltip:Show()
    return true
end

-- Process tooltip
local function ProcessTooltip(tooltip, spellID)
    -- Hold Shift to show original unmodified tooltip
    if IsShiftKeyDown() then
        return
    end

    if tooltipProcessed and lastProcessedSpellID == spellID then
        return
    end

    DebugPrint("Processing spellID:", spellID)

    local spellData = addon.GetSpellDataByID(spellID)
    if not spellData then
        DebugPrint("No spell data found for ID:", spellID)
        return
    end

    -- Skip spells that won't modify the tooltip
    local willModify = (spellData.coefficient or 0) > 0 or
                       (spellData.dotCoefficient or 0) > 0 or
                       spellData.isSeal or
                       spellData.isAbsorb
    if not willModify then
        DebugPrint("Spell has no modifying data, skipping:", spellData.name)
        return
    end

    DebugPrint("Found spell:", spellData.name)

    local originalData = ParseTooltip(tooltip)

    DebugPrint("Parsed - Name:", originalData.name, "Damage:", originalData.damageMin, "-", originalData.damageMax)

    if not originalData.damageMin and not spellData.isSeal and not spellData.isAbsorb then
        DebugPrint("No damage values found in tooltip")
        return
    end

    local success = BuildTooltip(tooltip, spellID, originalData)
    if success then
        DebugPrint("Tooltip rebuilt successfully")
        tooltipProcessed = true
        lastProcessedSpellID = spellID
    end
end

-- Hook for GameTooltip:SetSpellByID
local function OnSetSpellByID(tooltip, spellID)
    tooltipProcessed = false
    C_Timer.After(0, function()
        ProcessTooltip(tooltip, spellID)
    end)
end

-- Hook for OnTooltipSetSpell
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
    if GameTooltip.SetSpellByID then
        hooksecurefunc(GameTooltip, "SetSpellByID", OnSetSpellByID)
        DebugPrint("Hooked SetSpellByID")
    end
    GameTooltip:HookScript("OnTooltipSetSpell", OnTooltipSetSpell)
    DebugPrint("Hooked OnTooltipSetSpell")
    GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
    DebugPrint("Hooked OnTooltipCleared")
end

-- Event handler
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SpellTooltips" then
        SpellTooltipsDB = SpellTooltipsDB or {}
        if SpellTooltipsDB.showOriginalModifier == nil then
            SpellTooltipsDB.showOriginalModifier = "shift"
        end
        print("|cFF00FF00SpellTooltips|r loaded. Type /stt for commands.")

        local spellCount = 0
        for _ in pairs(SpellTooltips.SpellData) do spellCount = spellCount + 1 end
        print("|cFF00FF00SpellTooltips|r", spellCount, "spells registered.")

    elseif event == "PLAYER_LOGIN" then
        InitializeHooks()
        RefreshWeaponCache()
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
        if SpellTooltips.Auras then
            SpellTooltips.Auras.InvalidateCache()
        end

    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        -- arg1 is the equipment slot that changed (16 = main hand, 17 = off hand)
        InvalidateWeaponCache()
        -- Also invalidate talent cache since OHWS depends on weapon type
        Talents.InvalidateCache()
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
        local _, playerClass = UnitClass("player")
        print("|cFF00FF00SpellTooltips|r Talents for " .. playerClass .. ":")
        for key, info in pairs(SpellTooltips.TalentInfo) do
            if not info.class or info.class == playerClass then
                local ranks = Talents.GetTalentRanksByKey(key)
                print(string.format("  %s: %d/%d", info.name, ranks, info.maxRanks))
            end
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
    elseif msg == "auras" then
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
    elseif msg == "seal" then
        print("|cFF00FF00SpellTooltips|r Seal calculation debug:")
        local is1H = Talents.IsOneHandedWeaponEquipped and Talents.IsOneHandedWeaponEquipped() or false
        local is2H = Talents.IsTwoHandedWeaponEquipped and Talents.IsTwoHandedWeaponEquipped() or false
        print(string.format("  Weapon: 1H=%s, 2H=%s", tostring(is1H), tostring(is2H)))
        local schoolMult = Talents.GetSchoolMultiplier("holy")
        local spellMult = Talents.GetSpellMultiplier("Seal of Righteousness")
        local auraMult = 1.0
        if SpellTooltips.Auras then
            auraMult = SpellTooltips.Auras.GetSchoolMultiplier("holy")
        end
        print(string.format("  School mult (OHWS): %.2f", schoolMult))
        print(string.format("  Spell mult (ImpSoR): %.2f", spellMult))
        print(string.format("  Aura mult: %.2f", auraMult))
        print(string.format("  Total mult: %.2f", schoolMult * spellMult * auraMult))
    else
        print("|cFF00FF00SpellTooltips|r v2.5.0 (Caster Spells Only)")
        print("  /stt debug - Toggle debug mode")
        print("  /stt talents - Show detected talents")
        print("  /stt spells - Show registered spells")
        print("  /stt auras - Show active damage auras")
    end
end
