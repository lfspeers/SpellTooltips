-- SpellTooltips Spell Data
-- Base spell data structure and lookup functions

SpellTooltips = SpellTooltips or {}
SpellTooltips.SpellData = {}

--[[
    Spell data structure:
    [spellID] = {
        name = "Spell Name",
        coefficient = 0.857,        -- Direct damage coefficient
        dotCoefficient = 0.0,       -- DoT coefficient (per tick or total)
        school = "fire",            -- Damage school
        isChanneled = false,
        castTime = 3.0,             -- Base cast time in seconds
        isDot = false,
        dotTicks = 0,
        isHeal = false,
    }
]]

-- Lookup spell data by spell ID
function SpellTooltips.GetSpellDataByID(spellID)
    return SpellTooltips.SpellData[spellID]
end

-- Lookup spell data by spell name (slower, use ID when possible)
function SpellTooltips.GetSpellDataByName(spellName)
    for id, data in pairs(SpellTooltips.SpellData) do
        if data.name == spellName then
            return data, id
        end
    end
    return nil
end

-- Calculate bonus damage from spellpower
function SpellTooltips.CalculateBonusDamage(spellData, spellPower)
    if not spellData or not spellPower then
        return 0, 0
    end

    local directBonus = spellPower * (spellData.coefficient or 0)
    local dotBonus = spellPower * (spellData.dotCoefficient or 0)

    return directBonus, dotBonus
end

-- Get the relevant spellpower for a spell
function SpellTooltips.GetSpellPowerForSpell(spellData)
    if not spellData then
        return 0
    end

    if spellData.isHeal then
        return SpellTooltips.Utils.GetPlayerHealingPower()
    end

    return SpellTooltips.Utils.GetPlayerSpellPowerBySchool(spellData.school)
end

-- Register spell data from a class module
function SpellTooltips.RegisterSpellData(classSpellData, className)
    for spellID, data in pairs(classSpellData) do
        data.class = className
        SpellTooltips.SpellData[spellID] = data
    end
end

-- ===================
-- PHYSICAL DAMAGE SUPPORT (v2.0.0)
-- ===================

SpellTooltips.PhysicalData = {}

-- Register physical ability data from a class module
function SpellTooltips.RegisterPhysicalData(abilityData, className)
    for spellID, data in pairs(abilityData) do
        data.class = className
        data.isPhysical = true
        SpellTooltips.PhysicalData[spellID] = data
    end
end

-- Get physical ability data by spell ID
function SpellTooltips.GetPhysicalAbility(spellID)
    return SpellTooltips.PhysicalData[spellID]
end

-- ===================
-- PLAYER STATS CACHE
-- ===================
-- Cache player combat stats to avoid repeated API calls per tooltip
-- Invalidated by UNIT_STATS, UNIT_ATTACK_POWER, PLAYER_EQUIPMENT_CHANGED events

local statsCache = {
    valid = false,
    ap = 0,
    rap = 0,
    mhMin = 0, mhMax = 0, mhSpeed = 2.0,
    ohMin = 0, ohMax = 0, ohSpeed = 2.0,
    rangedMin = 0, rangedMax = 0, rangedSpeed = 2.0,
}

function SpellTooltips.InvalidateStatsCache()
    statsCache.valid = false
end

local function RefreshStatsCache()
    if statsCache.valid then return end

    -- Attack power
    local base, posBuff, negBuff = UnitAttackPower("player")
    statsCache.ap = (base or 0) + (posBuff or 0) + (negBuff or 0)

    -- Ranged attack power
    base, posBuff, negBuff = UnitRangedAttackPower("player")
    statsCache.rap = (base or 0) + (posBuff or 0) + (negBuff or 0)

    -- Weapon damage (single API call for both hands)
    local minDmg, maxDmg, minOffDmg, maxOffDmg = UnitDamage("player")
    statsCache.mhMin = minDmg or 0
    statsCache.mhMax = maxDmg or 0
    statsCache.ohMin = minOffDmg or 0
    statsCache.ohMax = maxOffDmg or 0

    -- Weapon speed (single API call for both hands)
    local mainSpeed, offSpeed = UnitAttackSpeed("player")
    statsCache.mhSpeed = mainSpeed or 2.0
    statsCache.ohSpeed = offSpeed or 2.0

    -- Ranged weapon
    local speed, rMin, rMax = UnitRangedDamage("player")
    statsCache.rangedMin = rMin or 0
    statsCache.rangedMax = rMax or 0
    statsCache.rangedSpeed = speed or 2.0

    statsCache.valid = true
end

-- Get player's attack power
function SpellTooltips.GetPlayerAttackPower()
    RefreshStatsCache()
    return statsCache.ap
end

-- Get player's main hand weapon damage range
function SpellTooltips.GetMainHandDamage()
    RefreshStatsCache()
    return statsCache.mhMin, statsCache.mhMax
end

-- Get player's off hand weapon damage range
function SpellTooltips.GetOffHandDamage()
    RefreshStatsCache()
    return statsCache.ohMin, statsCache.ohMax
end

-- Get player's main hand weapon speed
function SpellTooltips.GetMainHandSpeed()
    RefreshStatsCache()
    return statsCache.mhSpeed
end

-- Get player's off hand weapon speed
function SpellTooltips.GetOffHandSpeed()
    RefreshStatsCache()
    return statsCache.ohSpeed
end

-- ===================
-- RANGED WEAPON SUPPORT (Hunter)
-- ===================

-- Get player's ranged attack power
function SpellTooltips.GetRangedAttackPower()
    RefreshStatsCache()
    return statsCache.rap
end

-- Get player's ranged weapon damage range
function SpellTooltips.GetRangedWeaponDamage()
    RefreshStatsCache()
    return statsCache.rangedMin, statsCache.rangedMax
end

-- Get player's ranged weapon speed
function SpellTooltips.GetRangedWeaponSpeed()
    local speed = UnitRangedDamage("player")
    return speed or 2.8
end

-- Normalized ranged weapon speed (all ranged weapons use 2.8 in TBC)
function SpellTooltips.GetNormalizedRangedSpeed()
    return 2.8
end

-- Calculate normalized ranged weapon damage
function SpellTooltips.GetNormalizedRangedDamage(minDmg, maxDmg, actualSpeed)
    if not actualSpeed or actualSpeed == 0 then actualSpeed = 2.8 end
    local weaponDPS = (minDmg + maxDmg) / 2 / actualSpeed
    local normalizedDmg = weaponDPS * 2.8  -- All ranged normalize to 2.8
    return normalizedDmg, normalizedDmg
end

-- Calculate normalized weapon damage
-- normalizedSpeed: 1.7 for daggers, 2.4 for other 1H, 3.3 for 2H
function SpellTooltips.GetNormalizedWeaponDamage(minDmg, maxDmg, actualSpeed, normalizedSpeed)
    if not actualSpeed or actualSpeed == 0 then actualSpeed = 2.0 end
    local weaponDPS = (minDmg + maxDmg) / 2 / actualSpeed
    local normalizedDmg = weaponDPS * normalizedSpeed
    return normalizedDmg, normalizedDmg  -- Return same for min/max since it's averaged
end

-- Get off-hand damage multiplier (base 50%, modified by talents)
function SpellTooltips.GetOffHandMultiplier()
    local baseMult = 0.5

    -- Check class-specific Dual Wield Specialization talents
    local dwsBonus = 0
    if SpellTooltips.Talents then
        -- Rogue: +2% per rank (5 ranks)
        local rogueRanks = SpellTooltips.Talents.GetTalentRanksByKey("DUAL_WIELD_SPEC") or 0
        -- Shaman: +3% per rank (3 ranks)
        local shamanRanks = SpellTooltips.Talents.GetTalentRanksByKey("DUAL_WIELD_SPEC_SHAMAN") or 0
        -- Warrior: +5% per rank (5 ranks)
        local warriorRanks = SpellTooltips.Talents.GetTalentRanksByKey("DUAL_WIELD_SPEC_WARRIOR") or 0

        dwsBonus = (rogueRanks * 0.02) + (shamanRanks * 0.03) + (warriorRanks * 0.05)
    end

    return baseMult + dwsBonus
end

-- ===================
-- WARRIOR STANCE SUPPORT
-- ===================

-- Stance buff spell IDs
local WARRIOR_STANCES = {
    [2457] = "Battle Stance",
    [71] = "Defensive Stance",
    [2458] = "Berserker Stance",
}

-- Stance cache (invalidated on UNIT_AURA)
local stanceCache = {
    valid = false,
    name = nil,
    modifier = 1.0,
    critBonus = 0,
}

function SpellTooltips.InvalidateStanceCache()
    stanceCache.valid = false
end

-- Get current warrior stance
-- Returns: stance name, damage modifier, crit bonus
function SpellTooltips.GetWarriorStance()
    local _, playerClass = UnitClass("player")
    if playerClass ~= "WARRIOR" then
        return nil, 1.0, 0
    end

    -- Use cache if valid
    if stanceCache.valid then
        return stanceCache.name, stanceCache.modifier, stanceCache.critBonus
    end

    -- Check for stance buffs
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
        if not name then break end

        if spellId and WARRIOR_STANCES[spellId] then
            local stance = WARRIOR_STANCES[spellId]
            if stance == "Defensive Stance" then
                stanceCache.name, stanceCache.modifier, stanceCache.critBonus = stance, 0.90, 0
            elseif stance == "Berserker Stance" then
                stanceCache.name, stanceCache.modifier, stanceCache.critBonus = stance, 1.0, 0
            else
                stanceCache.name, stanceCache.modifier, stanceCache.critBonus = stance, 1.0, 0
            end
            stanceCache.valid = true
            return stanceCache.name, stanceCache.modifier, stanceCache.critBonus
        end
    end

    -- Default to Battle Stance if no stance detected
    stanceCache.name, stanceCache.modifier, stanceCache.critBonus = "Battle Stance", 1.0, 0
    stanceCache.valid = true
    return stanceCache.name, stanceCache.modifier, stanceCache.critBonus
end

-- Get player's block value (for Shield Slam)
function SpellTooltips.GetPlayerBlockValue()
    local blockValue = GetShieldBlock() or 0

    -- Apply Shield Mastery talent (+10% per rank)
    if SpellTooltips.Talents then
        local smRanks = SpellTooltips.Talents.GetTalentRanksByKey("SHIELD_MASTERY") or 0
        blockValue = blockValue * (1 + smRanks * 0.10)
    end

    return math.floor(blockValue)
end

-- ===================
-- DRUID FERAL FORM SUPPORT
-- ===================

-- Feral form buff spell IDs
local DRUID_FORMS = {
    [768] = "Cat Form",
    [9634] = "Dire Bear Form",
    [5487] = "Bear Form",
}

-- Check if player is in a feral form (cat or bear)
-- Returns: form name or nil, isCat, isBear
function SpellTooltips.GetDruidForm()
    local _, playerClass = UnitClass("player")
    if playerClass ~= "DRUID" then
        return nil, false, false
    end

    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
        if not name then break end

        if spellId and DRUID_FORMS[spellId] then
            local formName = DRUID_FORMS[spellId]
            local isCat = (formName == "Cat Form")
            local isBear = (formName == "Bear Form" or formName == "Dire Bear Form")
            return formName, isCat, isBear
        end
    end

    return nil, false, false
end

-- Detect weapon type for normalization
-- Returns: "dagger", "1h", "2h", "fist", or "feral"
function SpellTooltips.GetWeaponType(slot)
    local slotID = (slot == "offhand") and 17 or 16  -- INVSLOT_OFFHAND or INVSLOT_MAINHAND
    local itemID = GetInventoryItemID("player", slotID)
    if not itemID then return "1h" end

    local _, _, _, _, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemID)

    if itemEquipLoc == "INVTYPE_2HWEAPON" then
        return "2h"
    elseif itemSubType == "Daggers" then
        return "dagger"
    elseif itemSubType == "Fist Weapons" then
        return "fist"
    else
        return "1h"
    end
end

-- Get normalized speed for weapon type
function SpellTooltips.GetNormalizedSpeed(weaponType)
    if weaponType == "dagger" then
        return 1.7
    elseif weaponType == "2h" then
        return 3.3
    else
        return 2.4  -- 1H, fists
    end
end

-- Calculate physical ability damage
-- Returns: minDmg, maxDmg, attackPower, breakdown
function SpellTooltips.CalculatePhysicalDamage(spellData, comboPoints)
    if not spellData then return 0, 0, 0, {} end

    -- Use ranged stats for ranged abilities (Hunter)
    local ap, minMH, maxMH, speedMH
    local minOH, maxOH, speedOH = 0, 0, 2.0
    local ohMultiplier = 1.0

    if spellData.isRanged then
        ap = SpellTooltips.GetRangedAttackPower()
        minMH, maxMH = SpellTooltips.GetRangedWeaponDamage()
        speedMH = SpellTooltips.GetRangedWeaponSpeed()
    else
        ap = SpellTooltips.GetPlayerAttackPower()
        minMH, maxMH = SpellTooltips.GetMainHandDamage()
        minOH, maxOH = SpellTooltips.GetOffHandDamage()
        speedMH = SpellTooltips.GetMainHandSpeed()
        speedOH = SpellTooltips.GetOffHandSpeed()
        ohMultiplier = SpellTooltips.GetOffHandMultiplier()
    end

    local breakdown = {
        weaponMin = 0,
        weaponMax = 0,
        weaponMinOH = 0,
        weaponMaxOH = 0,
        flatBonus = 0,
        apBonus = 0,
        weaponPct = 0,
        normalized = false,
        hitsBothHands = false,
        usesOffhand = false,
        ohMultiplier = ohMultiplier,
        isRanged = spellData.isRanged or false,
    }

    local resultMin, resultMax = 0, 0

    -- Ranged abilities with RAP coefficient (Arcane Shot, etc.)
    if spellData.isRanged and spellData.rapCoef then
        local rapBonus = math.floor(ap * spellData.rapCoef)
        local baseDmg = spellData.flatBonus or 0

        breakdown.apBonus = rapBonus
        breakdown.flatBonus = baseDmg

        -- Some ranged abilities also add weapon damage (Steady Shot, Aimed Shot)
        if spellData.weaponPct then
            local weaponMin, weaponMax = minMH, maxMH

            -- Apply normalization if specified (ranged normalizes to 2.8)
            if spellData.normalized then
                weaponMin, weaponMax = SpellTooltips.GetNormalizedRangedDamage(minMH, maxMH, speedMH)
                breakdown.normalized = 2.8
            end

            breakdown.weaponMin = weaponMin
            breakdown.weaponMax = weaponMax
            breakdown.weaponPct = spellData.weaponPct

            resultMin = (weaponMin * spellData.weaponPct) + baseDmg + rapBonus
            resultMax = (weaponMax * spellData.weaponPct) + baseDmg + rapBonus
        else
            -- Pure RAP + flat damage (Arcane Shot)
            resultMin = baseDmg + rapBonus
            resultMax = baseDmg + rapBonus
        end

        return math.floor(resultMin), math.floor(resultMax), ap, breakdown
    end

    -- Weapon damage abilities (Sinister Strike, Backstab, etc.)
    if spellData.weaponPct then
        local weaponMin, weaponMax = minMH, maxMH
        local weaponSpeed = speedMH
        local weaponSlot = "mainhand"

        -- Off-hand only abilities (Shiv)
        if spellData.usesOffhand then
            weaponMin, weaponMax = minOH * ohMultiplier, maxOH * ohMultiplier
            weaponSpeed = speedOH
            weaponSlot = "offhand"
            breakdown.usesOffhand = true
        end

        -- Apply normalization if specified (skip for feral abilities - they have fixed 1.0s speed)
        if spellData.normalized and not spellData.isFeral then
            -- Use the ability's specified normalized speed, or auto-detect from weapon
            local normSpeed = spellData.normalized
            if normSpeed == true then
                -- Auto-detect based on weapon type
                local weaponType = SpellTooltips.GetWeaponType(weaponSlot)
                normSpeed = SpellTooltips.GetNormalizedSpeed(weaponType)
            end
            weaponMin, weaponMax = SpellTooltips.GetNormalizedWeaponDamage(weaponMin, weaponMax, weaponSpeed, normSpeed)
            breakdown.normalized = normSpeed
        end

        -- Mark as feral for display purposes
        if spellData.isFeral then
            breakdown.isFeral = true
        end

        breakdown.weaponMin = weaponMin
        breakdown.weaponMax = weaponMax
        breakdown.weaponPct = spellData.weaponPct
        breakdown.flatBonus = spellData.flatBonus or 0

        resultMin = (weaponMin * spellData.weaponPct) + (spellData.flatBonus or 0)
        resultMax = (weaponMax * spellData.weaponPct) + (spellData.flatBonus or 0)

        -- Both hands (Mutilate, Stormstrike)
        if spellData.hitsBothHands then
            local ohMin, ohMax = minOH * ohMultiplier, maxOH * ohMultiplier

            -- Apply normalization to off-hand if needed
            if spellData.normalized then
                local normSpeed = spellData.normalized
                if normSpeed == true then
                    local weaponType = SpellTooltips.GetWeaponType("offhand")
                    normSpeed = SpellTooltips.GetNormalizedSpeed(weaponType)
                end
                ohMin, ohMax = SpellTooltips.GetNormalizedWeaponDamage(ohMin, ohMax, speedOH, normSpeed)
            end

            breakdown.weaponMinOH = ohMin
            breakdown.weaponMaxOH = ohMax
            breakdown.hitsBothHands = true

            -- Add off-hand damage (with same weapon % and flat bonus per hand)
            local ohFlatBonus = spellData.flatBonusOH or spellData.flatBonus or 0
            resultMin = resultMin + (ohMin * spellData.weaponPct) + ohFlatBonus
            resultMax = resultMax + (ohMax * spellData.weaponPct) + ohFlatBonus
        end

    -- Finisher with base damage array (Eviscerate, Deadly Throw)
    elseif spellData.baseDmgMin and spellData.isFinisher then
        local cp = comboPoints or 5
        if cp < 1 then cp = 1 end
        if cp > 5 then cp = 5 end

        resultMin = spellData.baseDmgMin[cp] or spellData.baseDmgMin[5]
        resultMax = spellData.baseDmgMax[cp] or spellData.baseDmgMax[5]

        -- Add AP scaling
        if spellData.apPerCP then
            local apBonus = ap * spellData.apPerCP * cp
            breakdown.apBonus = apBonus
            resultMin = resultMin + apBonus
            resultMax = resultMax + apBonus
        end

    -- DoT with tick damage (Garrote, Rupture)
    elseif spellData.tickDmg then
        local tickDmg = spellData.tickDmg
        local ticks = spellData.ticks or 6
        local apBonus = 0

        -- Array-based tick damage (Rupture - indexed by CP)
        if type(tickDmg) == "table" then
            local cp = comboPoints or 5
            if cp < 1 then cp = 1 end
            if cp > 5 then cp = 5 end
            tickDmg = tickDmg[cp] or tickDmg[5]
            ticks = spellData.ticksByCP and (spellData.ticksByCP[cp] or 8) or ticks

            if spellData.apPerCP then
                apBonus = ap * spellData.apPerCP * cp
                breakdown.apBonus = apBonus
            end
        else
            -- Fixed tick damage (Garrote)
            if spellData.apCoef then
                apBonus = ap * spellData.apCoef
                breakdown.apBonus = apBonus
            end
        end

        local perTick = tickDmg + (apBonus / ticks)
        resultMin = perTick * ticks
        resultMax = resultMin  -- DoTs don't have a range
        breakdown.ticks = ticks
        breakdown.perTick = perTick

    -- Flat damage abilities (Kick, Gouge)
    elseif spellData.flatDmg then
        resultMin = spellData.flatDmg
        resultMax = spellData.flatDmg
        breakdown.flatBonus = spellData.flatDmg

    -- Envenom (damage per poison dose)
    elseif spellData.dmgPerDose and spellData.isFinisher then
        local cp = comboPoints or 5
        if cp < 1 then cp = 1 end
        if cp > 5 then cp = 5 end

        local dmgPerDose = spellData.dmgPerDose[cp] or spellData.dmgPerDose[5]
        -- Assume 5 doses for max damage display
        local doses = 5
        resultMin = dmgPerDose * doses
        resultMax = resultMin

        if spellData.apPerCP then
            local apBonus = ap * spellData.apPerCP * cp
            breakdown.apBonus = apBonus
            resultMin = resultMin + apBonus
            resultMax = resultMax + apBonus
        end
        breakdown.doses = doses
        breakdown.dmgPerDose = dmgPerDose
    end

    return math.floor(resultMin), math.floor(resultMax), ap, breakdown
end
