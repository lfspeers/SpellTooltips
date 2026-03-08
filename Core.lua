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
frame:RegisterEvent("UNIT_ATTACK_POWER")

-- Track if we've already processed this tooltip
local tooltipProcessed = false
local lastProcessedSpellID = nil

-- Combat stats cache (refreshed on specific events)
local combatCache = {
    -- Weapon stats (invalidated by PLAYER_EQUIPMENT_CHANGED)
    weaponValid = false,
    weaponSpeed = 2.0,
    is2H = false,
    is1H = false,
    isDagger = false,
    -- Attack power (invalidated by UNIT_ATTACK_POWER, UNIT_AURA)
    apValid = false,
    attackPower = 0,
    -- Computed values (use UnitDamage which includes AP)
    totalMinDmg = 0,
    totalMaxDmg = 0,
    -- Base weapon damage (computed: totalDmg - AP contribution)
    baseWeaponMin = 0,
    baseWeaponMax = 0,
}

-- Tooltip-scope multiplier cache (reset per tooltip to avoid recalculating)
-- This avoids calling GetSchoolMultiplier/GetSpellMultiplier multiple times per tooltip
local tooltipCache = {
    school = nil,
    spellName = nil,
    schoolMultiplier = nil,
    spellMultiplier = nil,
    auraMultiplier = nil,
}

-- Reset tooltip cache for new spell
local function ResetTooltipCache()
    tooltipCache.school = nil
    tooltipCache.spellName = nil
    tooltipCache.schoolMultiplier = nil
    tooltipCache.spellMultiplier = nil
    tooltipCache.auraMultiplier = nil
end

-- Get cached school multiplier (calculates once per tooltip)
local function GetCachedSchoolMultiplier(school)
    if tooltipCache.school == school and tooltipCache.schoolMultiplier then
        return tooltipCache.schoolMultiplier
    end
    tooltipCache.school = school
    tooltipCache.schoolMultiplier = Talents and Talents.GetSchoolMultiplier(school) or 1.0
    return tooltipCache.schoolMultiplier
end

-- Get cached aura multiplier (calculates once per tooltip)
local function GetCachedAuraMultiplier(school)
    if tooltipCache.school == school and tooltipCache.auraMultiplier then
        return tooltipCache.auraMultiplier
    end
    tooltipCache.school = school
    if SpellTooltips.Auras and SpellTooltips.Auras.GetSchoolMultiplier then
        tooltipCache.auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(school)
    else
        tooltipCache.auraMultiplier = 1.0
    end
    return tooltipCache.auraMultiplier
end

-- Get cached spell multiplier (calculates once per tooltip)
local function GetCachedSpellMultiplier(spellName)
    if tooltipCache.spellName == spellName and tooltipCache.spellMultiplier then
        return tooltipCache.spellMultiplier
    end
    tooltipCache.spellName = spellName
    tooltipCache.spellMultiplier = Talents and Talents.GetSpellMultiplier(spellName) or 1.0
    return tooltipCache.spellMultiplier
end

-- Debug mode flag (off by default)
local DEBUG_MODE = false

local function DebugPrint(...)
    if DEBUG_MODE then
        print("|cFFFF8000[STT]|r", ...)
    end
end

-- =====================
-- SAFE GLOBAL ACCESS HELPERS
-- =====================

-- Safely get a global frame by name (uses rawget to avoid metamethod issues)
local function SafeGetGlobalFrame(name)
    if type(name) ~= "string" or name == "" then
        return nil
    end
    local frame = rawget(_G, name)
    if type(frame) ~= "table" then
        return nil
    end
    return frame
end

-- Safely get a tooltip line text frame
-- Returns the TextLeft frame or nil if not accessible
local function SafeGetTooltipLine(tooltip, lineIndex)
    -- Validate tooltip
    if not tooltip or type(tooltip) ~= "table" then
        return nil
    end
    if not tooltip.GetName or not tooltip.NumLines then
        return nil
    end

    -- Bounds check lineIndex (reasonable max of 50 lines)
    if type(lineIndex) ~= "number" or lineIndex < 1 or lineIndex > 50 then
        return nil
    end

    -- Check against actual line count
    local success, numLines = pcall(tooltip.NumLines, tooltip)
    if not success or type(numLines) ~= "number" or lineIndex > numLines then
        return nil
    end

    -- Get tooltip name and construct frame name
    local tooltipName = tooltip:GetName()
    if not tooltipName or type(tooltipName) ~= "string" then
        return nil
    end

    local frameName = tooltipName .. "TextLeft" .. lineIndex
    return SafeGetGlobalFrame(frameName)
end

-- =====================
-- ERROR HANDLING HELPERS
-- =====================

-- Log an error without throwing (safe for event handlers)
local function SafeErrorLog(context, err)
    -- Always log errors (not just in debug mode)
    print("|cFFFF0000[STT Error]|r " .. (context or "Unknown") .. ": " .. tostring(err or "nil"))
    if DEBUG_MODE then
        -- In debug mode, also print stack trace if available
        local trace = debugstack and debugstack(2, 5, 0) or ""
        if trace ~= "" then
            print("|cFFFF8000[STT Stack]|r " .. trace)
        end
    end
end

-- Safely call a function, logging errors without crashing
-- Returns: success (boolean), result or error message
local function SafeCall(context, func, ...)
    if type(func) ~= "function" then
        SafeErrorLog(context, "Not a function: " .. type(func))
        return false, "Not a function"
    end

    local args = {...}
    local results = {pcall(function() return func(unpack(args)) end)}
    local success = table.remove(results, 1)

    if not success then
        SafeErrorLog(context, results[1])
        return false, results[1]
    end

    return true, unpack(results)
end

-- =====================
-- ARITHMETIC SAFETY HELPERS
-- =====================

-- Check if a number is valid (not nil, NaN, or Infinity)
local function IsValidNumber(n)
    if type(n) ~= "number" then return false end
    -- NaN check: NaN ~= NaN
    if n ~= n then return false end
    -- Infinity check
    if n == math.huge or n == -math.huge then return false end
    return true
end

-- Return a safe number, using fallback if invalid
local function SafeNumber(n, fallback)
    fallback = fallback or 0
    if IsValidNumber(n) then
        return n
    end
    return fallback
end

-- Safe division that handles zero and invalid values
local function SafeDivide(num, denom, fallback)
    fallback = fallback or 0
    if not IsValidNumber(num) then return fallback end
    if not IsValidNumber(denom) or denom == 0 then return fallback end
    local result = num / denom
    return IsValidNumber(result) and result or fallback
end

-- Clamp a number between min and max
local function ClampNumber(n, minVal, maxVal)
    n = SafeNumber(n, minVal)
    if n < minVal then return minVal end
    if n > maxVal then return maxVal end
    return n
end

-- Safe rounding that handles invalid values
local function SafeRound(x)
    x = SafeNumber(x, 0)
    return math.floor(x + 0.5)
end

-- Round to nearest integer (instead of floor/truncate)
local function Round(x)
    return SafeRound(x)
end

-- Color shortcuts
local C = {
    WHITE = "|cFFFFFFFF",
    GRAY = "|cFFAAAAAA",
    GREEN = "|cFF00FF00",
    YELLOW = "|cFFFFFF00",
    CYAN = "|cFF00FFFF",
    ORANGE = "|cFFFF8000",
    RED = "|cFFFF0000",
    MANA = "|cFF0080FF",
    CRIT = "|cFFFF4444",
    RESET = "|r",
}

-- School colors (matching WoW's damage school colors)
local SCHOOL_COLORS = {
    physical = "|cFFC79C6E",  -- Warrior brown/tan
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

-- One-handed weapon subtypes for classification
local ONE_HANDED_SUBTYPES = {
    ["One-Handed Axes"] = true,
    ["One-Handed Maces"] = true,
    ["One-Handed Swords"] = true,
    ["Daggers"] = true,
    ["Fist Weapons"] = true,
}

-- Refresh weapon stats (called on equipment change)
local function RefreshWeaponStats()
    -- Get weapon speed (with validation)
    local speed, _ = UnitAttackSpeed("player")
    if type(speed) == "number" and speed > 0 then
        combatCache.weaponSpeed = speed
    else
        combatCache.weaponSpeed = 2.0  -- Default fallback
    end

    -- Reset weapon type flags
    combatCache.is2H = false
    combatCache.is1H = false
    combatCache.isDagger = false

    -- Check weapon type (with validated GetItemInfo)
    local itemID = GetInventoryItemID("player", 16)
    if itemID and type(itemID) == "number" then
        local success, result = pcall(GetItemInfo, itemID)
        if success and result then
            -- GetItemInfo returns: itemName, itemLink, itemQuality, itemLevel, itemMinLevel,
            --                      itemType, itemSubType, itemStackCount, itemEquipLoc, ...
            local _, _, _, _, _, _, itemSubType, _, itemEquipLoc = GetItemInfo(itemID)
            if type(itemEquipLoc) == "string" then
                combatCache.is2H = (itemEquipLoc == "INVTYPE_2HWEAPON")
            end
            if type(itemSubType) == "string" then
                combatCache.is1H = ONE_HANDED_SUBTYPES[itemSubType] or false
                combatCache.isDagger = (itemSubType == "Daggers")
            end
        end
    end

    -- Get total weapon damage (includes AP contribution)
    local success, minDmg, maxDmg = pcall(UnitDamage, "player")
    if success then
        combatCache.totalMinDmg = (type(minDmg) == "number") and minDmg or 0
        combatCache.totalMaxDmg = (type(maxDmg) == "number") and maxDmg or 0
    else
        combatCache.totalMinDmg = 0
        combatCache.totalMaxDmg = 0
    end

    combatCache.weaponValid = true
    DebugPrint("Weapon stats refreshed - Speed:", combatCache.weaponSpeed, "2H:", combatCache.is2H, "1H:", combatCache.is1H)
end

-- Refresh attack power (called on AP change or aura change)
local function RefreshAttackPower()
    local base, pos, neg = UnitAttackPower("player")
    combatCache.attackPower = (base or 0) + (pos or 0) + (neg or 0)
    combatCache.apValid = true
    DebugPrint("Attack power refreshed:", combatCache.attackPower)
end

-- Compute base weapon damage (without AP contribution)
local function ComputeBaseWeaponDamage()
    if not combatCache.weaponValid then RefreshWeaponStats() end
    if not combatCache.apValid then RefreshAttackPower() end

    -- Refresh total damage (may have changed with AP)
    local success, minDmg, maxDmg = pcall(UnitDamage, "player")
    if success then
        combatCache.totalMinDmg = SafeNumber(minDmg, 0)
        combatCache.totalMaxDmg = SafeNumber(maxDmg, 0)
    end

    -- AP contribution to weapon damage: (AP / 14) * weaponSpeed
    -- Use SafeDivide to prevent division by zero issues
    local ap = SafeNumber(combatCache.attackPower, 0)
    local speed = SafeNumber(combatCache.weaponSpeed, 2.0)
    local apContribution = SafeDivide(ap, 14, 0) * speed
    apContribution = SafeNumber(apContribution, 0)

    -- Base weapon damage = total - AP contribution (floor at 0)
    local baseMin = SafeNumber(combatCache.totalMinDmg, 0) - apContribution
    local baseMax = SafeNumber(combatCache.totalMaxDmg, 0) - apContribution
    combatCache.baseWeaponMin = math.max(0, SafeNumber(baseMin, 0))
    combatCache.baseWeaponMax = math.max(0, SafeNumber(baseMax, 0))

    -- Ensure min <= max
    if combatCache.baseWeaponMin > combatCache.baseWeaponMax then
        combatCache.baseWeaponMin = combatCache.baseWeaponMax
    end

    DebugPrint("Base weapon damage:", Round(combatCache.baseWeaponMin), "-", Round(combatCache.baseWeaponMax),
               "(AP contrib:", Round(apContribution), ")")
end

-- Invalidate weapon cache (called on equipment change)
local function InvalidateWeaponCache()
    combatCache.weaponValid = false
end

-- Invalidate AP cache (called on AP/aura change)
local function InvalidateAPCache()
    combatCache.apValid = false
end

-- Get main hand weapon speed (for seal calculations)
local function GetMainHandSpeed()
    if not combatCache.weaponValid then RefreshWeaponStats() end
    return combatCache.weaponSpeed
end

-- Check if using two-handed weapon (for Seal of Righteousness)
local function IsTwoHandedWeapon()
    if not combatCache.weaponValid then RefreshWeaponStats() end
    return combatCache.is2H
end

-- Check if using one-handed weapon (uses cached value)
local function IsOneHandedWeapon()
    if not combatCache.weaponValid then RefreshWeaponStats() end
    return combatCache.is1H
end

-- Get main hand weapon damage (total, includes AP - for seals that use modified damage)
local function GetMainHandWeaponDamage()
    if not combatCache.weaponValid then RefreshWeaponStats() end
    return combatCache.totalMinDmg, combatCache.totalMaxDmg
end

-- Get base weapon damage (without AP - for physical abilities)
local function GetBaseWeaponDamage()
    ComputeBaseWeaponDamage()
    return combatCache.baseWeaponMin, combatCache.baseWeaponMax
end

-- Get attack power
local function GetAttackPower()
    if not combatCache.apValid then RefreshAttackPower() end
    return combatCache.attackPower
end

-- Get ranged attack power
local function GetRangedAttackPower()
    return Utils.GetPlayerRangedAttackPower()
end

-- Get base ranged weapon damage (without RAP contribution)
local function GetBaseRangedWeaponDamage()
    local speed, minDmg, maxDmg = UnitRangedDamage("player")
    if not speed or speed == 0 then
        return 0, 0, 0
    end

    -- RAP contribution to ranged damage: (RAP / 14) * rangedSpeed
    local rap = GetRangedAttackPower()
    local rapContribution = (rap / 14) * speed

    -- Base ranged damage = total - RAP contribution
    local baseMin = math.max(0, (minDmg or 0) - rapContribution)
    local baseMax = math.max(0, (maxDmg or 0) - rapContribution)

    return baseMin, baseMax, speed
end

-- Normalized weapon speeds for AP calculation
local NORMALIZED_SPEEDS = {
    ["DAGGER"] = 1.7,
    ["ONE_HAND"] = 2.4,
    ["TWO_HAND"] = 3.3,
    ["RANGED"] = 2.8,
    ["FERAL"] = 1.0,  -- Feral forms use 1.0 normalized speed
}

-- Get normalized weapon speed for an ability (uses cached weapon type)
local function GetNormalizedSpeed(spellData)
    if spellData and spellData.normalizedSpeed then
        return spellData.normalizedSpeed
    end

    -- Default normalization based on weapon type
    if spellData and spellData.isRanged then
        return NORMALIZED_SPEEDS.RANGED
    end

    -- Ensure weapon cache is valid
    if not combatCache.weaponValid then
        RefreshWeaponStats()
    end

    -- Use cached weapon type (avoids expensive GetItemInfo call)
    if combatCache.is2H then
        return NORMALIZED_SPEEDS.TWO_HAND
    end

    if combatCache.isDagger then
        return NORMALIZED_SPEEDS.DAGGER
    end

    return NORMALIZED_SPEEDS.ONE_HAND
end

-- Calculate AP bonus damage for a physical ability
-- Formula: (AP / 14) * normalizedSpeed (if normalized) or weaponSpeed (if not)
local function CalculateAPBonus(ap, spellData)
    if not spellData or not ap or ap == 0 then return 0 end

    local speed
    if spellData.isNormalized then
        speed = GetNormalizedSpeed(spellData)
    else
        speed = GetMainHandSpeed()
    end

    return (ap / 14) * speed
end

-- Calculate full physical ability damage
-- Returns: minDmg, maxDmg, apBonus, weaponDmgPortion
local function CalculatePhysicalDamage(spellData)
    if not spellData then return 0, 0, 0, 0 end

    local weaponMin, weaponMax
    local ap

    -- Check if ability has both weapon% AND separate AP scaling
    -- If so, use BASE weapon damage to avoid double-counting AP
    -- Clamp coefficients to reasonable ranges
    local weaponPercent = ClampNumber(spellData.weaponDamagePercent or 0, 0, 10)
    local apCoeff = ClampNumber(spellData.apCoefficient or spellData.rapCoefficient or 0, 0, 5)
    local hasBothScalings = weaponPercent > 0 and apCoeff > 0

    if spellData.isRanged then
        ap = SafeNumber(GetRangedAttackPower(), 0)
        if hasBothScalings then
            -- Use base ranged damage (e.g., Steady Shot: base weapon + RAP*0.20)
            weaponMin, weaponMax = GetBaseRangedWeaponDamage()
        else
            -- Use total ranged damage (e.g., Aimed Shot: 100% ranged damage)
            local success, speed, minDmg, maxDmg = pcall(UnitRangedDamage, "player")
            if success then
                weaponMin = SafeNumber(minDmg, 0)
                weaponMax = SafeNumber(maxDmg, 0)
            else
                weaponMin, weaponMax = 0, 0
            end
        end
    else
        ap = SafeNumber(GetAttackPower(), 0)
        if hasBothScalings then
            -- Use base melee damage (avoids double-counting AP)
            weaponMin, weaponMax = GetBaseWeaponDamage()
        else
            -- Use total melee damage (e.g., Mortal Strike: 100% weapon damage)
            weaponMin, weaponMax = GetMainHandWeaponDamage()
        end
    end

    -- Ensure weapon damage values are valid
    weaponMin = SafeNumber(weaponMin, 0)
    weaponMax = SafeNumber(weaponMax, 0)

    -- Calculate weapon damage portion
    local weaponDmgMin = weaponMin * weaponPercent
    local weaponDmgMax = weaponMax * weaponPercent

    -- Calculate flat AP coefficient bonus (separate from weapon damage)
    local apBonus = SafeNumber(ap * apCoeff, 0)

    -- Add flat damage bonus (clamped to reasonable range)
    local flatDmg = ClampNumber(spellData.flatDamage or 0, 0, 10000)

    -- Total damage (floor at 0)
    local totalMin = math.max(0, SafeNumber(weaponDmgMin + apBonus + flatDmg, 0))
    local totalMax = math.max(0, SafeNumber(weaponDmgMax + apBonus + flatDmg, 0))

    -- Ensure min <= max
    if totalMin > totalMax then
        totalMin = totalMax
    end

    local avgWeaponDmg = SafeDivide(weaponDmgMin + weaponDmgMax, 2, 0)
    return totalMin, totalMax, apBonus, avgWeaponDmg
end

-- Build tooltip for physical abilities (AP/RAP scaling)
local function BuildPhysicalTooltip(tooltip, spellData, spellID)
    local schoolColor = GetSchoolColor(spellData.school, false)

    -- Calculate damage
    local dmgMin, dmgMax, apBonus, weaponPortion = CalculatePhysicalDamage(spellData)

    -- Get multipliers
    local is2H = IsTwoHandedWeapon()
    local physicalMultiplier = Talents.GetPhysicalMultiplier(spellData.name, is2H, spellData.school)
    local auraMultiplier = 1.0
    if SpellTooltips.Auras then
        auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
    end
    local totalMultiplier = physicalMultiplier * auraMultiplier

    -- Apply multipliers
    dmgMin = Round(dmgMin * totalMultiplier)
    dmgMax = Round(dmgMax * totalMultiplier)

    -- Update tooltip text with calculated damage
    for i = 1, tooltip:NumLines() do
        local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
        if textLeft then
            local text = textLeft:GetText()
            if text and text:len() > 10 then
                local newText = text
                -- Replace "X% weapon damage" pattern
                newText = newText:gsub("(%d+)%%%s*weapon%s+damage", function(pct)
                    return schoolColor .. dmgMin .. "-" .. dmgMax .. C.RESET .. " damage"
                end)
                -- Replace "X% of weapon damage" pattern
                newText = newText:gsub("(%d+)%%%s+of%s+weapon%s+damage", function(pct)
                    return schoolColor .. dmgMin .. "-" .. dmgMax .. C.RESET .. " damage"
                end)
                -- Replace "weapon damage plus X" pattern
                newText = newText:gsub("weapon%s+damage%s+plus%s+(%d+)", function(bonus)
                    local bonusNum = tonumber(bonus) or 0
                    local newMin = dmgMin + Round(bonusNum * totalMultiplier)
                    local newMax = dmgMax + Round(bonusNum * totalMultiplier)
                    return schoolColor .. newMin .. "-" .. newMax .. C.RESET .. " damage"
                end)
                -- Replace "an additional X damage" pattern (flat bonus)
                newText = newText:gsub("(additional%s+)(%d+)(%s+damage)", function(pre, dmg, post)
                    local baseDmg = tonumber(dmg) or 0
                    local newDmg = Round(baseDmg * totalMultiplier)
                    return pre .. schoolColor .. newDmg .. C.RESET .. post
                end)
                if newText ~= text then
                    textLeft:SetText(newText)
                end
            end
        end
    end

    -- Add breakdown section
    tooltip:AddLine(" ")

    -- Damage line
    local weaponPercent = (spellData.weaponDamagePercent or 0) * 100
    local apCoeff = (spellData.apCoefficient or spellData.rapCoefficient or 0) * 100
    local apLabel = spellData.isRanged and "RAP" or "AP"

    if weaponPercent > 0 and apCoeff > 0 then
        tooltip:AddLine(string.format("Damage: %s%d-%d%s (%.0f%% wpn + %.0f%% %s)",
            schoolColor, dmgMin, dmgMax, C.RESET, weaponPercent, apCoeff, apLabel), 1, 1, 1)
    elseif weaponPercent > 0 then
        tooltip:AddLine(string.format("Damage: %s%d-%d%s (%.0f%% weapon)",
            schoolColor, dmgMin, dmgMax, C.RESET, weaponPercent), 1, 1, 1)
    elseif apCoeff > 0 then
        tooltip:AddLine(string.format("Damage: %s%d-%d%s (%.0f%% %s)",
            schoolColor, dmgMin, dmgMax, C.RESET, apCoeff, apLabel), 1, 1, 1)
    end

    -- Flat damage bonus
    if spellData.flatDamage and spellData.flatDamage > 0 then
        local flatBonus = Round(spellData.flatDamage * totalMultiplier)
        tooltip:AddLine(string.format("%sFlat bonus: %s+%d",
            C.WHITE, schoolColor, flatBonus), 1, 1, 1)
    end

    -- Talent/aura modifiers (before crit, matching spell format)
    if physicalMultiplier > 1 then
        local bonusPercent = math.floor((physicalMultiplier - 1) * 100 + 0.5)
        tooltip:AddLine(string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
    end
    if auraMultiplier > 1 then
        local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
        tooltip:AddLine(string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
    end

    -- Crit info (after talents/auras, matching spell format)
    local baseCritChance
    if spellData.isRanged then
        baseCritChance = Utils.GetPlayerRangedCritChance()
    else
        baseCritChance = Utils.GetPlayerMeleeCritChance()
    end
    local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
    local totalCritChance = baseCritChance + critBonus
    local critMultiplier = Talents.GetCritDamageMultiplier(spellData.school, true, spellData.name)
    local critMin = Round(dmgMin * critMultiplier)
    local critMax = Round(dmgMax * critMultiplier)
    tooltip:AddLine(string.format("Crit: %s%d-%d%s (%.1f%% @ %.2fx)",
        C.CRIT, critMin, critMax, C.RESET, totalCritChance, critMultiplier), 1, 1, 1)

    -- Special notes
    if spellData.requiresBehind then
        tooltip:AddLine(C.YELLOW .. "Requires: Behind target" .. C.RESET, 1, 1, 1)
    end
    if spellData.requiresStealth then
        tooltip:AddLine(C.YELLOW .. "Requires: Stealth" .. C.RESET, 1, 1, 1)
    end
    if spellData.isBleed then
        tooltip:AddLine(C.YELLOW .. "Bleed: Ignores armor" .. C.RESET, 1, 1, 1)
    end

    tooltip:Show()
    return true
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

-- Module-scope damage replacement patterns (avoids recreation each call)
local DAMAGE_REPLACE_PATTERNS = {
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
    if not spellData then return SafeNumber(baseDamage, 0) end

    baseDamage = SafeNumber(baseDamage, 0)
    -- Clamp spell power to reasonable range (0-50000 for TBC)
    spellPower = ClampNumber(spellPower, 0, 50000)

    local modifiedCoeff = SafeNumber(Talents.GetModifiedCoefficient(spellData), 0)
    -- Clamp coefficient to reasonable range
    modifiedCoeff = ClampNumber(modifiedCoeff, 0, 5)

    -- Use cached multiplier to avoid redundant calculations
    local multiplier = SafeNumber(GetCachedSchoolMultiplier(spellData.school), 1.0)
    -- Clamp multiplier to reasonable range
    multiplier = ClampNumber(multiplier, 0.1, 10)

    local bonusDamage = SafeNumber(spellPower * modifiedCoeff, 0)

    local result = (baseDamage + bonusDamage) * multiplier
    result = SafeNumber(result, 0)
    -- Cap final result at a reasonable maximum
    result = math.min(result, 9999999)

    return Round(result)
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

    -- Calculate final damage for crit display
    local newMin = Round(data.damageMin * multiplier + bonusDamage)
    local newMax = Round(data.damageMax * multiplier + bonusDamage)

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
        local critMult = Talents.GetCritDamageMultiplier(spellData.school, false, spellData.name)

        if totalCritChance > 0 then
            local critMin = Round(newMin * critMult)
            local critMax = Round(newMax * critMult)
            table.insert(lines, string.format("Crit: %s%d-%d%s (%.1f%% @ %.2fx)",
                C.CRIT, critMin, critMax, C.RESET, totalCritChance, critMult))
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
        local critMult = Talents.GetCritDamageMultiplier(spellData.school, false, spellData.name)

        if totalCritChance > 0 then
            -- Calculate per-tick crit damage
            local newPerTick = Round(data.damageMin * multiplier + perTickBonus)
            local critPerTick = Round(newPerTick * critMult)
            table.insert(lines, string.format("Crit: %s%d%s/tick (%.1f%% @ %.2fx)",
                C.CRIT, critPerTick, C.RESET, totalCritChance, critMult))
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

        -- Use module-scope patterns (avoids table recreation each call)
        for _, pattern in ipairs(DAMAGE_REPLACE_PATTERNS) do
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
    -- Validate tooltip has required methods
    if not tooltip or type(tooltip) ~= "table" then
        DebugPrint("BuildTooltip: invalid tooltip")
        return false
    end
    if not tooltip.AddLine or not tooltip.NumLines or not tooltip.GetName then
        DebugPrint("BuildTooltip: tooltip missing required methods")
        return false
    end

    -- Validate spellID is a positive number
    if type(spellID) ~= "number" or spellID < 1 then
        DebugPrint("BuildTooltip: invalid spellID:", spellID)
        return false
    end

    local spellData = addon.GetSpellDataByID(spellID)
    if not spellData then return false end

    -- Validate spell data structure
    local isValid, validationErr = addon.ValidateSpellData and addon.ValidateSpellData(spellData)
    if addon.ValidateSpellData and not isValid then
        DebugPrint("BuildTooltip: invalid spell data -", validationErr)
        return false
    end

    local spellPower = SafeNumber(addon.GetSpellPowerForSpell(spellData), 0)
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

        tooltip:AddLine(" ")
        tooltip:AddLine(string.format("%s bonus: %s+%d%s (%s)", powerLabel, schoolColor, bonusAbsorb, C.RESET, coeffStr), 1, 1, 1)
        tooltip:Show()
        return true
    end

    -- Special handling for physical abilities (weapon damage / AP / RAP based)
    if spellData.isPhysical and not spellData.isSeal then
        -- Get weapon damage and AP/RAP based on ability type
        local wpnMin, wpnMax, ap, apLabel

        -- Check if ability has both weapon% AND separate AP scaling
        -- If so, use BASE weapon damage to avoid double-counting AP
        local weaponPercent = spellData.weaponDamagePercent or 0
        local apCoeff = spellData.apCoefficient or spellData.rapCoefficient or 0
        local hasBothScalings = weaponPercent > 0 and apCoeff > 0

        if spellData.isRanged then
            ap = GetRangedAttackPower()
            apLabel = "RAP"
            if hasBothScalings then
                -- Use base ranged damage (e.g., Steady Shot)
                wpnMin, wpnMax = GetBaseRangedWeaponDamage()
            else
                -- Use total ranged damage
                local speed, minDmg, maxDmg = UnitRangedDamage("player")
                wpnMin = minDmg or 0
                wpnMax = maxDmg or 0
            end
        else
            ap = GetAttackPower()
            apLabel = "AP"
            if hasBothScalings then
                -- Use base melee damage
                wpnMin, wpnMax = GetBaseWeaponDamage()
            else
                -- Use total melee damage
                wpnMin, wpnMax = GetMainHandWeaponDamage()
            end
        end

        -- Calculate weapon damage portion
        local dmgMin = wpnMin * weaponPercent
        local dmgMax = wpnMax * weaponPercent

        -- Add flat AP/RAP coefficient bonus (abilities like Bloodthirst)
        local apBonus = 0
        if apCoeff > 0 then
            apBonus = ap * apCoeff
            dmgMin = dmgMin + apBonus
            dmgMax = dmgMax + apBonus
        end

        -- Add flat damage bonus (abilities like Heroic Strike, Sinister Strike)
        local flatDmg = spellData.flatDamage or 0
        if flatDmg > 0 then
            dmgMin = dmgMin + flatDmg
            dmgMax = dmgMax + flatDmg
        end

        -- Add SP bonus if applicable (some physical abilities scale with SP)
        local spBonus = 0
        if spellData.spCoeff and spellData.spCoeff > 0 then
            spBonus = spellPower * spellData.spCoeff
            dmgMin = dmgMin + spBonus
            dmgMax = dmgMax + spBonus
        end

        -- Get multipliers using physical-specific function
        local is2H = IsTwoHandedWeapon()
        local physicalMultiplier = Talents.GetPhysicalMultiplier(spellData.name, is2H, spellData.school)
        local auraMultiplier = 1.0
        if SpellTooltips.Auras then
            auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
        end
        local multiplier = physicalMultiplier * auraMultiplier

        -- Apply multipliers
        dmgMin = Round(dmgMin * multiplier)
        dmgMax = Round(dmgMax * multiplier)

        -- Update tooltip text with calculated damage
        for i = 1, tooltip:NumLines() do
            local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
            if textLeft then
                local text = textLeft:GetText()
                if text and text:len() > 10 then
                    local newText = text
                    -- Replace "X% weapon damage" pattern (generic - Crusader Strike, etc.)
                    newText = newText:gsub("(%d+)%%%s*weapon%s+damage", function(pct)
                        return schoolColor .. dmgMin .. "-" .. dmgMax .. C.RESET .. " damage"
                    end)
                    -- Replace "X% of weapon damage" pattern
                    newText = newText:gsub("(%d+)%%%s+of%s+weapon%s+damage", function(pct)
                        return schoolColor .. dmgMin .. "-" .. dmgMax .. C.RESET .. " damage"
                    end)
                    -- Replace "weapon damage plus X" pattern
                    newText = newText:gsub("weapon%s+damage%s+plus%s+(%d+)", function(bonus)
                        return schoolColor .. dmgMin .. "-" .. dmgMax .. C.RESET .. " damage"
                    end)
                    -- Replace "an additional X damage" or "plus X damage" patterns
                    newText = newText:gsub("(plus%s+)(%d+)(%s+damage)", function(pre, dmg, post)
                        return pre .. schoolColor .. Round(tonumber(dmg) * multiplier) .. C.RESET .. post
                    end)
                    -- Replace generic "X-Y damage" or "X to Y damage" in description
                    newText = newText:gsub("(%d+)(%s+to%s+)(%d+)(%s+damage)", function(minStr, sep, maxStr, suffix)
                        if weaponPercent > 0 then
                            return schoolColor .. dmgMin .. C.RESET .. sep .. schoolColor .. dmgMax .. C.RESET .. suffix
                        end
                        return minStr .. sep .. maxStr .. suffix
                    end)
                    if newText ~= text then
                        textLeft:SetText(newText)
                    end
                end
            end
        end

        -- Add breakdown
        tooltip:AddLine(" ")

        -- Build damage description string based on what contributes
        local components = {}
        if weaponPercent > 0 then
            table.insert(components, string.format("%.0f%% wpn", weaponPercent * 100))
        end
        if apCoeff > 0 then
            table.insert(components, string.format("%.0f%% %s", apCoeff * 100, apLabel))
        end
        if flatDmg > 0 then
            table.insert(components, string.format("+%d flat", flatDmg))
        end
        if spBonus > 0 then
            table.insert(components, string.format("%.0f%% SP", (spellData.spCoeff or 0) * 100))
        end

        local componentStr = table.concat(components, " + ")
        if componentStr ~= "" then
            tooltip:AddLine(string.format("Damage: %s%d-%d%s (%s)",
                schoolColor, dmgMin, dmgMax, C.RESET, componentStr), 1, 1, 1)
        else
            tooltip:AddLine(string.format("Damage: %s%d-%d%s",
                schoolColor, dmgMin, dmgMax, C.RESET), 1, 1, 1)
        end

        -- Talent/aura modifiers (before crit, matching spell format)
        if physicalMultiplier > 1 then
            local bonusPercent = math.floor((physicalMultiplier - 1) * 100 + 0.5)
            tooltip:AddLine(string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
        end
        if auraMultiplier > 1 then
            local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
            tooltip:AddLine(string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
        end

        -- Crit info for physical abilities (after talents/auras, matching spell format)
        local baseCritChance
        if spellData.isRanged then
            baseCritChance = Utils.GetPlayerRangedCritChance()
        else
            baseCritChance = Utils.GetPlayerMeleeCritChance()
        end
        local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
        local totalCritChance = baseCritChance + critBonus
        local critMultiplier = Talents.GetCritDamageMultiplier(spellData.school, true, spellData.name)
        local critMin = Round(dmgMin * critMultiplier)
        local critMax = Round(dmgMax * critMultiplier)
        tooltip:AddLine(string.format("Crit: %s%d-%d%s (%.1f%% @ %.2fx)",
            C.CRIT, critMin, critMax, C.RESET, totalCritChance, critMultiplier), 1, 1, 1)

        -- Special notes
        if spellData.requiresBehind then
            tooltip:AddLine(C.YELLOW .. "Requires: Behind target" .. C.RESET, 1, 1, 1)
        end
        if spellData.requiresStealth then
            tooltip:AddLine(C.YELLOW .. "Requires: Stealth" .. C.RESET, 1, 1, 1)
        end
        if spellData.isBleed then
            tooltip:AddLine(C.YELLOW .. "Bleed: Ignores armor" .. C.RESET, 1, 1, 1)
        end
        if spellData.isNormalized then
            local normSpeed = GetNormalizedSpeed(spellData)
            tooltip:AddLine(string.format("%sNormalized: %.1fs%s", C.GRAY, normSpeed, C.RESET), 1, 1, 1)
        end

        tooltip:Show()
        return true
    end

    -- Special handling for Seal spells (Paladin)
    if spellData.isSeal then
        -- Utility seals (Seal of Light, Seal of Wisdom) - just show proc chance
        if spellData.isUtilitySeal then
            local weaponSpeed = GetMainHandSpeed()

            tooltip:AddLine(" ")
            tooltip:AddLine(C.YELLOW .. "-- Seal --" .. C.RESET, 1, 1, 1)

            if spellData.ppm then
                local procChance = (spellData.ppm * weaponSpeed / 60) * 100
                tooltip:AddLine(string.format("%sProc: %s%.1f%% (%d PPM @ %.2fs)",
                    C.WHITE, C.GRAY, procChance, spellData.ppm, weaponSpeed), 1, 1, 1)
            end

            tooltip:Show()
            return true
        -- Seal of Command (physical/weapon damage based seal)
        elseif spellData.isPhysical then
            -- Use base weapon damage (SoC scales from weapon damage, not AP-modified damage)
            local wpnMin, wpnMax = GetBaseWeaponDamage()
            local weaponCoeff = spellData.weaponDamagePercent or 0.70
            local spCoeff = spellData.spCoeff or 0

            -- Proc damage: weapon damage * coeff + SP bonus
            local dmgMin = wpnMin * weaponCoeff
            local dmgMax = wpnMax * weaponCoeff
            local spBonus = spellPower * spCoeff

            -- Get multipliers
            local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
            local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
            local auraMultiplier = 1.0
            if SpellTooltips.Auras then
                auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
            end
            local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier

            -- Apply multipliers
            local finalMin = Round((dmgMin + spBonus) * multiplier)
            local finalMax = Round((dmgMax + spBonus) * multiplier)

            -- Judgement calculation (SP scaling only)
            local judgementCoef = spellData.judgementCoef or 0.43
            local judgementSPBonus = spellPower * judgementCoef
            local judgementBaseMin, judgementBaseMax = 0, 0  -- Will be captured from tooltip

            -- Stunned/Incapacitated damage calculation (Seal of Command only)
            -- Stunned damage = 2x base damage (doubles the proc)
            local stunnedFinalMin, stunnedFinalMax
            if spellData.name == "Seal of Command" then
                stunnedFinalMin = finalMin * 2
                stunnedFinalMax = finalMax * 2
            end

            -- Update tooltip text
            for i = 1, tooltip:NumLines() do
                local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
                if textLeft then
                    local text = textLeft:GetText()
                    if text then
                        local newText = text
                        -- Match "Holy damage equal to X% of normal weapon damage" pattern
                        if text:find("Holy damage equal to") then
                            newText = newText:gsub("(Holy damage equal to )(%d+)(%% of normal weapon damage)",
                                function(prefix, pct, suffix)
                                    return schoolColor .. finalMin .. "-" .. finalMax .. C.RESET .. " Holy damage"
                                end)
                        end
                        -- Match judgement damage pattern ("causing 228 to 252 Holy damage")
                        if text:find("causing") and text:find("Holy damage") then
                            newText = newText:gsub("(causing%s+)(%d+)(%s+to%s+)(%d+)(%s+Holy%s+damage)", function(p1, minStr, p2, maxStr, suffix)
                                local baseMin = tonumber(minStr)
                                local baseMax = tonumber(maxStr)
                                -- Capture base damage for crit calculation
                                judgementBaseMin = baseMin
                                judgementBaseMax = baseMax
                                local newMin = Round((baseMin + judgementSPBonus) * multiplier)
                                local newMax = Round((baseMax + judgementSPBonus) * multiplier)
                                return p1 .. schoolColor .. newMin .. C.RESET .. p2 .. schoolColor .. newMax .. C.RESET .. suffix
                            end)
                        end
                        -- Match stunned/incapacitated damage pattern ("X to Y if the target is stunned")
                        if stunnedFinalMin and text:find("stunned") then
                            newText = newText:gsub("(%d+)(%s+to%s+)(%d+)(%s+if%s+the%s+target%s+is%s+stunned)", function(minStr, p2, maxStr, suffix)
                                return schoolColor .. stunnedFinalMin .. C.RESET .. p2 .. schoolColor .. stunnedFinalMax .. C.RESET .. suffix
                            end)
                        end
                        if newText ~= text then
                            textLeft:SetText(newText)
                        end
                    end
                end
            end

            -- Add breakdown - Seal section
            tooltip:AddLine(" ")
            tooltip:AddLine(C.YELLOW .. "-- Seal --" .. C.RESET, 1, 1, 1)
            if spCoeff > 0 then
                tooltip:AddLine(string.format("Damage: %s%d-%d%s (%.0f%% weapon + %.0f%% SP)",
                    schoolColor, finalMin, finalMax, C.RESET, weaponCoeff * 100, spCoeff * 100), 1, 1, 1)
            else
                tooltip:AddLine(string.format("Damage: %s%d-%d%s (%.0f%% weapon)",
                    schoolColor, finalMin, finalMax, C.RESET, weaponCoeff * 100), 1, 1, 1)
            end

            -- Self-damage display for Seal of Blood / Seal of the Martyr
            if spellData.selfDamagePercent then
                local selfDmgMin = Round(finalMin * spellData.selfDamagePercent)
                local selfDmgMax = Round(finalMax * spellData.selfDamagePercent)
                tooltip:AddLine(string.format("Self-damage: %s%d-%d%s (%.0f%%)",
                    C.RED, selfDmgMin, selfDmgMax, C.RESET, spellData.selfDamagePercent * 100), 1, 1, 1)
            end

            -- Proc rate display
            if spellData.procsEverySwing then
                tooltip:AddLine(string.format("%sProc: %sEvery melee swing", C.WHITE, C.GRAY), 1, 1, 1)
            elseif spellData.ppm then
                local weaponSpeed = GetMainHandSpeed()
                local procChance = (spellData.ppm * weaponSpeed / 60) * 100
                tooltip:AddLine(string.format("%sProc: %s%.1f%% (%d PPM @ %.2fs)",
                    C.WHITE, C.GRAY, procChance, spellData.ppm, weaponSpeed), 1, 1, 1)
            end

            -- Crit info for Seal of Command (uses melee crit since it's weapon-based)
            local baseCritChance = Utils.GetPlayerMeleeCritChance()
            local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
            local totalCritChance = baseCritChance + critBonus
            local critMultiplier = Talents.GetCritDamageMultiplier(spellData.school, true, spellData.name)
            local critMin = Round(finalMin * critMultiplier)
            local critMax = Round(finalMax * critMultiplier)
            tooltip:AddLine(string.format("Crit: %s%d-%d%s (%.1f%% @ %.2fx)",
                C.CRIT, critMin, critMax, C.RESET, totalCritChance, critMultiplier), 1, 1, 1)

            -- Judgement section
            tooltip:AddLine(" ")
            tooltip:AddLine(C.YELLOW .. "-- Judgement --" .. C.RESET, 1, 1, 1)
            local judgementBonusDmg = Round(judgementSPBonus * multiplier)
            -- Calculate total judgement damage (base + SP bonus) * multiplier
            local judgementTotalMin = Round((judgementBaseMin + judgementSPBonus) * multiplier)
            local judgementTotalMax = Round((judgementBaseMax + judgementSPBonus) * multiplier)
            tooltip:AddLine(string.format("Damage: %s%d-%d%s (+%d from %.0f%% SP)",
                schoolColor, judgementTotalMin, judgementTotalMax, C.RESET, judgementBonusDmg, judgementCoef * 100), 1, 1, 1)

            -- Judgement self-damage for Seal of Blood / Seal of the Martyr
            if spellData.judgementSelfDamage then
                local judgeSelfMin = Round(judgementTotalMin * spellData.judgementSelfDamage)
                local judgeSelfMax = Round(judgementTotalMax * spellData.judgementSelfDamage)
                tooltip:AddLine(string.format("Self-damage: %s%d-%d%s (%.0f%%)",
                    C.RED, judgeSelfMin, judgeSelfMax, C.RESET, spellData.judgementSelfDamage * 100), 1, 1, 1)
            end

            -- Judgement crit info (uses melee crit with x2 multiplier)
            local judgementCritMin = Round(judgementTotalMin * critMultiplier)
            local judgementCritMax = Round(judgementTotalMax * critMultiplier)
            tooltip:AddLine(string.format("Crit: %s%d-%d%s (%.1f%% @ %.2fx)",
                C.CRIT, judgementCritMin, judgementCritMax, C.RESET, totalCritChance, critMultiplier), 1, 1, 1)

            -- Shared modifiers
            local talentMultiplier = schoolMultiplier * spellMultiplier
            if talentMultiplier > 1 or auraMultiplier > 1 then
                tooltip:AddLine(" ")
                if talentMultiplier > 1 then
                    local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
                    tooltip:AddLine(string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
                end
                if auraMultiplier > 1 then
                    local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
                    tooltip:AddLine(string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
                end
            end

            tooltip:Show()
            return true
        elseif spellData.isStackingDot then
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

            -- Get base weapon damage for seal formula (0.03 * avg weapon dmg)
            -- SoR uses base weapon damage, not AP-modified damage
            local wpnMinDmg, wpnMaxDmg = GetBaseWeaponDamage()
            local avgWeaponDmg = (wpnMinDmg + wpnMaxDmg) / 2
            local weaponDamagePercent = spellData.weaponDamagePercent or 0
            local weaponDmgBonus = weaponDamagePercent * avgWeaponDmg

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
            local judgementBaseMin, judgementBaseMax = 0, 0  -- Will be captured from tooltip

            for i = 1, tooltip:NumLines() do
                local textLeft = _G[tooltip:GetName() .. "TextLeft" .. i]
                if textLeft then
                    local text = textLeft:GetText()
                    if text then
                        local newText = text
                        if text:find("additional") and text:find("Holy damage") then
                            newText = newText:gsub("(additional%s+)(%d+)(%s+Holy%s+damage)", function(prefix, dmgStr, suffix)
                                local baseDmg = tonumber(dmgStr)
                                -- Tooltip shows raw base damage without talent multipliers
                                -- Apply multiplier to (base + SP/weapon bonus)
                                local newDmg = Round((baseDmg + rawBonusDamage) * multiplier)
                                return prefix .. schoolColor .. newDmg .. C.RESET .. suffix
                            end)
                        end
                        if text:find("cause") and text:find("Holy damage") then
                            newText = newText:gsub("(cause%s+)(%d+)(%s+to%s+)(%d+)(%s+Holy%s+damage)", function(p1, minStr, p2, maxStr, suffix)
                                local baseMin = tonumber(minStr)
                                local baseMax = tonumber(maxStr)
                                -- Capture base damage for crit calculation (before multipliers)
                                judgementBaseMin = baseMin
                                judgementBaseMax = baseMax
                                -- Tooltip shows raw base damage without talent multipliers
                                -- Apply multiplier to (base + SP bonus)
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

            -- Seal section
            tooltip:AddLine(" ")
            tooltip:AddLine(C.YELLOW .. "-- Seal --" .. C.RESET, 1, 1, 1)
            tooltip:AddLine(string.format("Bonus: %s+%d%s (%.1f%% SP @ %.2fs)",
                schoolColor, displayBonus, C.RESET, coefficient * 100, weaponSpeed), 1, 1, 1)
            local sorPPM = 60 / weaponSpeed
            tooltip:AddLine(string.format("%sProc: %s100%% (%.1f PPM @ %.2fs)",
                C.WHITE, C.GRAY, sorPPM, weaponSpeed), 1, 1, 1)

            -- Judgement section
            tooltip:AddLine(" ")
            tooltip:AddLine(C.YELLOW .. "-- Judgement --" .. C.RESET, 1, 1, 1)
            -- Calculate total judgement damage: (base + SP bonus) * multiplier
            local judgementTotalMin = Round((judgementBaseMin + rawJudgementBonus) * multiplier)
            local judgementTotalMax = Round((judgementBaseMax + rawJudgementBonus) * multiplier)
            tooltip:AddLine(string.format("Damage: %s%d-%d%s (+%d from %.0f%% SP)",
                schoolColor, judgementTotalMin, judgementTotalMax, C.RESET, displayJudgementBonus, judgementCoef * 100), 1, 1, 1)

            -- Judgement crit info (uses spell crit)
            local baseCritChance = Utils.GetPlayerSpellCritChance(spellData.school)
            local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
            local totalCritChance = baseCritChance + critBonus
            local critMultiplier = Talents.GetCritDamageMultiplier(spellData.school, false, spellData.name)
            local judgementCritMin = Round(judgementTotalMin * critMultiplier)
            local judgementCritMax = Round(judgementTotalMax * critMultiplier)
            tooltip:AddLine(string.format("Crit: %s%d-%d%s (%.1f%% @ %.2fx)",
                C.CRIT, judgementCritMin, judgementCritMax, C.RESET, totalCritChance, critMultiplier), 1, 1, 1)

            -- Shared modifiers
            local talentMultiplier = schoolMultiplier * spellMultiplier
            if talentMultiplier > 1 or auraMultiplier > 1 then
                tooltip:AddLine(" ")
                if talentMultiplier > 1 then
                    local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
                    tooltip:AddLine(string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
                end
                if auraMultiplier > 1 then
                    local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
                    tooltip:AddLine(string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
                end
            end
        end

        tooltip:Show()
        return true
    end

    -- Generic multi-part spell handling (Seed of Corruption, etc.)
    if spellData.parts then
        -- Get shared multipliers
        local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
        local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
        local auraMultiplier = 1.0
        if SpellTooltips.Auras then
            auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
        end
        local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier

        tooltip:AddLine(" ")

        for _, part in ipairs(spellData.parts) do
            -- Section header
            tooltip:AddLine(C.YELLOW .. "-- " .. part.label .. " --" .. C.RESET, 1, 1, 1)

            local partCoeff = part.coefficient or 0
            local partDotCoeff = part.dotCoefficient or 0

            if partDotCoeff > 0 then
                -- DoT part
                local ticks = part.ticks or 1
                local perTickCoeff = partDotCoeff / ticks
                local totalBonus = Round(spellPower * partDotCoeff * multiplier)
                local perTickBonus = Round(spellPower * perTickCoeff * multiplier)
                tooltip:AddLine(string.format("Bonus: %s+%d%s total (%s+%d%s/tick, %.1f%% SP)",
                    schoolColor, totalBonus, C.RESET,
                    schoolColor, perTickBonus, C.RESET,
                    partDotCoeff * 100), 1, 1, 1)
            elseif partCoeff > 0 then
                -- Direct damage part
                local bonus = Round(spellPower * partCoeff * multiplier)
                tooltip:AddLine(string.format("Bonus: %s+%d%s (%.1f%% SP)",
                    schoolColor, bonus, C.RESET, partCoeff * 100), 1, 1, 1)
            end

            tooltip:AddLine(" ")
        end

        -- Shared modifiers
        local talentMultiplier = schoolMultiplier * spellMultiplier
        if talentMultiplier > 1 then
            local bonusPercent = math.floor((talentMultiplier - 1) * 100 + 0.5)
            tooltip:AddLine(string.format("%sTalents: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
        end
        if auraMultiplier > 1 then
            local bonusPercent = math.floor((auraMultiplier - 1) * 100 + 0.5)
            tooltip:AddLine(string.format("%sAuras: %s+%d%%", C.WHITE, C.GRAY, bonusPercent), 1, 1, 1)
        end

        -- Crit info for multi-part spells
        if spellData.canCrit ~= false then
            local baseCritChance = Utils.GetPlayerSpellCritChance(spellData.school)
            local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
            local totalCritChance = baseCritChance + critBonus
            local critMult = Talents.GetCritDamageMultiplier(spellData.school, false, spellData.name)

            if totalCritChance > 0 then
                tooltip:AddLine(string.format("Crit: %s%.2fx%s (%.1f%% chance)",
                    C.CRIT, critMult, C.RESET, totalCritChance), 1, 1, 1)
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

    -- Fallback crit display when breakdown is empty but spell can crit
    if #damageLines == 0 and spellData.canCrit ~= false and not spellData.isHealing then
        local coefficient = spellData.coefficient or spellData.dotCoefficient or 0
        if coefficient > 0 then
            local modifiedCoeff = Talents.GetModifiedCoefficient(spellData)
            local schoolMultiplier = Talents.GetSchoolMultiplier(spellData.school)
            local spellMultiplier = Talents.GetSpellMultiplier(spellData.name)
            local auraMultiplier = 1.0
            if SpellTooltips.Auras then
                auraMultiplier = SpellTooltips.Auras.GetSchoolMultiplier(spellData.school)
            end
            local multiplier = schoolMultiplier * spellMultiplier * auraMultiplier

            local coeffStr = Utils.FormatCoefficient(modifiedCoeff)
            local bonusDamage = Round(spellPower * modifiedCoeff * multiplier)
            tooltip:AddLine(string.format("%sSP bonus: %s+%d (%s)", C.WHITE, C.GRAY, bonusDamage, coeffStr), 1, 1, 1)

            local baseCritChance = Utils.GetPlayerSpellCritChance(spellData.school)
            local critBonus = Talents.GetCritChanceBonus(spellData.name, spellData.school)
            local totalCritChance = baseCritChance + critBonus
            local critMult = Talents.GetCritDamageMultiplier(spellData.school, false, spellData.name)

            if totalCritChance > 0 then
                tooltip:AddLine(string.format("Crit: %s%.2fx%s (%.1f%% chance)",
                    C.CRIT, critMult, C.RESET, totalCritChance), 1, 1, 1)
            end
        end
    end

    tooltip:Show()
    return true
end

-- Process tooltip (internal implementation)
local function ProcessTooltipInternal(tooltip, spellID)
    -- Hold Shift to show original unmodified tooltip
    if IsShiftKeyDown() then
        return
    end

    if tooltipProcessed and lastProcessedSpellID == spellID then
        return
    end

    -- Reset tooltip-scope multiplier cache for new spell
    ResetTooltipCache()

    DebugPrint("Processing spellID:", spellID)

    local spellData = addon.GetSpellDataByID(spellID)
    if not spellData then
        DebugPrint("No spell data found for ID:", spellID)
        return
    end

    -- Skip spells that won't modify the tooltip
    local willModify = (spellData.coefficient or 0) > 0 or
                       (spellData.dotCoefficient or 0) > 0 or
                       (spellData.weaponDamagePercent or 0) > 0 or
                       (spellData.apCoefficient or 0) > 0 or
                       (spellData.rapCoefficient or 0) > 0 or
                       (spellData.flatDamage or 0) > 0 or
                       spellData.isSeal or
                       spellData.isAbsorb or
                       spellData.isPhysical or
                       spellData.isRanged or
                       spellData.parts
    if not willModify then
        DebugPrint("Spell has no modifying data, skipping:", spellData.name)
        return
    end

    DebugPrint("Found spell:", spellData.name)

    local originalData = ParseTooltip(tooltip)

    DebugPrint("Parsed - Name:", originalData.name, "Damage:", originalData.damageMin, "-", originalData.damageMax)

    if not originalData.damageMin and not spellData.isSeal and not spellData.isAbsorb and not spellData.isPhysical and not spellData.parts then
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

-- Process tooltip (protected wrapper)
local function ProcessTooltip(tooltip, spellID)
    local success, err = SafeCall("ProcessTooltip", ProcessTooltipInternal, tooltip, spellID)
    if not success then
        DebugPrint("ProcessTooltip failed for spellID:", spellID)
    end
end

-- Hook for GameTooltip:SetSpellByID
local function OnSetSpellByID(tooltip, spellID)
    tooltipProcessed = false
    C_Timer.After(0, function()
        ProcessTooltip(tooltip, spellID)
    end)
end

-- Hook for OnTooltipSetSpell (internal implementation)
local function OnTooltipSetSpellInternal(tooltip)
    tooltipProcessed = false
    local name, spellID = tooltip:GetSpell()
    if spellID then
        ProcessTooltip(tooltip, spellID)
    end
end

-- Hook for OnTooltipSetSpell (protected wrapper)
local function OnTooltipSetSpell(tooltip)
    local success, err = SafeCall("OnTooltipSetSpell", OnTooltipSetSpellInternal, tooltip)
    if not success then
        DebugPrint("OnTooltipSetSpell failed")
    end
end

-- Reset processed flag when tooltip is cleared
local function OnTooltipCleared(tooltip)
    tooltipProcessed = false
    lastProcessedSpellID = nil
end

-- Announce spell cooldown in /say when Alt-clicking
local function AnnounceSpellCooldown(spellName, spellID)
    if not spellName and not spellID then return end

    -- Get cooldown info
    local start, duration, enabled
    if spellID then
        start, duration, enabled = GetSpellCooldown(spellID)
    else
        start, duration, enabled = GetSpellCooldown(spellName)
    end

    -- Check if spell is on cooldown
    if start and start > 0 and duration and duration > 1.5 then
        local remaining = math.ceil((start + duration) - GetTime())
        if remaining > 0 then
            -- Format the message
            local name = spellName or GetSpellInfo(spellID)
            local message = name .. " CD - " .. remaining .. "s"
            SendChatMessage(message, "SAY")
        end
    end
end

-- Hook for SpellButton clicks (spellbook)
local function OnSpellButtonClick(self, button)
    if IsAltKeyDown() and button == "LeftButton" then
        local slot = SpellBook_GetSpellBookSlot(self)
        if slot then
            local spellName = GetSpellBookItemName(slot, SpellBookFrame.bookType)
            if spellName then
                AnnounceSpellCooldown(spellName, nil)
            end
        end
    end
end

-- Hook for ActionButton clicks (action bars)
local function OnActionButtonClick(self, button)
    if IsAltKeyDown() and button == "LeftButton" then
        local actionType, id, subType = GetActionInfo(self.action)
        if actionType == "spell" then
            local spellName = GetSpellInfo(id)
            AnnounceSpellCooldown(spellName, id)
        elseif actionType == "macro" then
            -- Try to get spell from macro
            local spellID = GetMacroSpell(id)
            if spellID then
                local spellName = GetSpellInfo(spellID)
                AnnounceSpellCooldown(spellName, spellID)
            end
        end
    end
end

-- Initialize hooks (internal implementation)
local hooksInitialized = false
local function InitializeHooksInternal()
    if hooksInitialized then
        DebugPrint("Hooks already initialized, skipping")
        return
    end
    hooksInitialized = true

    if GameTooltip and GameTooltip.SetSpellByID then
        hooksecurefunc(GameTooltip, "SetSpellByID", OnSetSpellByID)
        DebugPrint("Hooked SetSpellByID")
    end
    if GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetSpell", OnTooltipSetSpell)
        DebugPrint("Hooked OnTooltipSetSpell")
        GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
        DebugPrint("Hooked OnTooltipCleared")
    end

    -- Hook spellbook buttons for Alt-click cooldown announce
    if SpellButton_OnClick then
        hooksecurefunc("SpellButton_OnClick", OnSpellButtonClick)
        DebugPrint("Hooked SpellButton_OnClick for CD announce")
    end

    -- Hook action buttons for Alt-click cooldown announce (with safe global access)
    for i = 1, 12 do
        local btn = rawget(_G, "ActionButton" .. i)
        if btn and btn.HookScript then
            local success = pcall(function() btn:HookScript("OnClick", OnActionButtonClick) end)
            if not success then
                DebugPrint("Failed to hook ActionButton" .. i)
            end
        end
        -- Bonus action bars
        btn = rawget(_G, "BonusActionButton" .. i)
        if btn and btn.HookScript then
            pcall(function() btn:HookScript("OnClick", OnActionButtonClick) end)
        end
        -- Multi-bar buttons
        for _, barName in ipairs({"MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarRight", "MultiBarLeft"}) do
            btn = rawget(_G, barName .. "Button" .. i)
            if btn and btn.HookScript then
                pcall(function() btn:HookScript("OnClick", OnActionButtonClick) end)
            end
        end
    end
    DebugPrint("Hooked ActionButtons for CD announce")
end

-- Initialize hooks (protected wrapper)
local function InitializeHooks()
    local success, err = SafeCall("InitializeHooks", InitializeHooksInternal)
    if not success then
        print("|cFFFF0000[STT]|r Failed to initialize hooks - some features may not work")
    end
end

-- Event handler (internal implementation)
local function OnEventInternal(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SpellTooltips" then
        SpellTooltipsDB = SpellTooltipsDB or {}
        if SpellTooltipsDB.showOriginalModifier == nil then
            SpellTooltipsDB.showOriginalModifier = "shift"
        end
        print("|cFF00FF00SpellTooltips|r loaded. Type /stt for commands.")

        local spellCount = 0
        if SpellTooltips.SpellData then
            for _ in pairs(SpellTooltips.SpellData) do spellCount = spellCount + 1 end
        end
        print("|cFF00FF00SpellTooltips|r", spellCount, "spells registered.")

    elseif event == "PLAYER_LOGIN" then
        InitializeHooks()
        RefreshWeaponStats()
        RefreshAttackPower()
        if C_Timer and C_Timer.After then
            C_Timer.After(1, function()
                if Talents and Talents.RefreshCache then
                    Talents.RefreshCache()
                end
            end)
        elseif Talents and Talents.RefreshCache then
            Talents.RefreshCache()
        end

    elseif event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        if Talents and Talents.InvalidateCache then
            Talents.InvalidateCache()
        end
        if C_Timer and C_Timer.After then
            C_Timer.After(0.1, function()
                if Talents and Talents.RefreshCache then
                    Talents.RefreshCache()
                end
            end)
        elseif Talents and Talents.RefreshCache then
            Talents.RefreshCache()
        end

    elseif event == "UNIT_AURA" and arg1 == "player" then
        if SpellTooltips.Auras and SpellTooltips.Auras.InvalidateCache then
            SpellTooltips.Auras.InvalidateCache()
        end
        -- Auras can affect AP (Blessing of Might, etc.)
        InvalidateAPCache()

    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        -- arg1 is the equipment slot that changed (16 = main hand, 17 = off hand)
        InvalidateWeaponCache()
        -- Note: We NO LONGER invalidate talent cache here.
        -- Weapon-conditional bonuses (OHWS, TWHS) are pre-computed separately in
        -- schoolMultipliers1H/2H and physicalMultiplier1H/2H.
        -- GetSchoolMultiplier() checks weapon type at lookup time using cached values.
        -- This saves 100+ API calls on equipment changes.

    elseif event == "UNIT_ATTACK_POWER" and arg1 == "player" then
        InvalidateAPCache()
    end
end

-- Event handler (protected wrapper)
frame:SetScript("OnEvent", function(self, event, arg1)
    local success, err = SafeCall("OnEvent:" .. (event or "nil"), OnEventInternal, self, event, arg1)
    if not success then
        DebugPrint("Event handler failed for:", event)
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
        print("|cFF00FF00SpellTooltips|r Active tracked auras:")
        if SpellTooltips.Auras then
            local activeAuras = SpellTooltips.Auras.GetActiveAuras()
            if #activeAuras == 0 then
                print("  No tracked auras active")
            else
                for _, aura in ipairs(activeAuras) do
                    local bonusStr
                    if aura.isCritBuff and aura.critBonus then
                        bonusStr = string.format("+%.0f%% crit", aura.critBonus * 100)
                    elseif aura.isHasteBuff and aura.hasteBonus then
                        bonusStr = string.format("+%.0f%% haste", aura.hasteBonus * 100)
                    elseif aura.isAPBuff then
                        bonusStr = "+AP buff"
                    elseif aura.bonus and aura.bonus > 0 then
                        bonusStr = string.format("+%.0f%% damage", aura.bonus * 100)
                    else
                        bonusStr = "active"
                    end
                    local schoolStr = aura.school and (" (" .. aura.school .. ")") or ""
                    local spellOnlyStr = aura.isSpellOnly and " [spell only]" or ""
                    print(string.format("  %s: %s%s%s", aura.name, bonusStr, schoolStr, spellOnlyStr))
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
    elseif msg == "physical" then
        print("|cFF00FF00SpellTooltips|r Physical combat stats:")
        local ap = GetAttackPower()
        local speed = GetMainHandSpeed()
        local is2H = IsTwoHandedWeapon()
        local baseMin, baseMax = GetBaseWeaponDamage()
        local totalMin, totalMax = GetMainHandWeaponDamage()
        print(string.format("  Attack Power: %d", ap))
        print(string.format("  Weapon Speed: %.2fs", speed))
        print(string.format("  Weapon Type: %s", is2H and "2H" or "1H"))
        print(string.format("  Base Weapon Damage: %d-%d", Round(baseMin), Round(baseMax)))
        print(string.format("  Total Weapon Damage: %d-%d (with AP)", Round(totalMin), Round(totalMax)))
        local apContrib = (ap / 14) * speed
        print(string.format("  AP Contribution: +%d", Round(apContrib)))
    else
        print("|cFF00FF00SpellTooltips|r v3.0.1")
        print("  /stt debug - Toggle debug mode")
        print("  /stt talents - Show detected talents")
        print("  /stt spells - Show registered spells")
        print("  /stt auras - Show active damage auras")
        print("  Alt+Click spell - Announce cooldown in /say")
    end
end

-- Expose AnnounceSpellCooldown for external use
SpellTooltips.AnnounceSpellCooldown = AnnounceSpellCooldown

-- Expose cached weapon type functions for TalentData.lua (performance optimization)
SpellTooltips.IsOneHandedWeapon = IsOneHandedWeapon
SpellTooltips.IsTwoHandedWeapon = IsTwoHandedWeapon
