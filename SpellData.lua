-- SpellTooltips Spell Data
-- Base spell data structure and lookup functions

SpellTooltips = SpellTooltips or {}
SpellTooltips.SpellData = {}

--[[
    Spell data structure:
    [spellID] = {
        name = "Spell Name",
        coefficient = 0.857,        -- Direct damage SP coefficient
        dotCoefficient = 0.0,       -- DoT SP coefficient (per tick or total)
        school = "fire",            -- Damage school (physical, holy, fire, nature, frost, shadow, arcane)
        isChanneled = false,
        castTime = 3.0,             -- Base cast time in seconds
        isDot = false,
        ticks = 0,                  -- Number of DoT/HoT ticks
        isHealing = false,

        -- Physical ability fields (melee/ranged)
        isPhysical = false,         -- True for melee/ranged abilities
        isRanged = false,           -- True for ranged abilities (uses RAP instead of AP)
        weaponDamagePercent = 1.0,  -- Weapon damage multiplier (1.0 = 100%)
        apCoefficient = 0.0,        -- Attack Power coefficient (flat AP scaling)
        rapCoefficient = 0.0,       -- Ranged Attack Power coefficient
        flatDamage = 0,             -- Flat damage added to ability
        isNormalized = false,       -- Uses normalized weapon speed for AP
        normalizedSpeed = 2.4,      -- Normalized speed (2.4 for 1H, 3.3 for 2H, 2.8 for ranged)

        -- Special ability fields
        isSeal = false,             -- Paladin seal
        isAbsorb = false,           -- Absorption shield
        isBleed = false,            -- Bleed effect (ignores armor)
        requiresBehind = false,     -- Must be behind target (Backstab, Shred)
        requiresStealth = false,    -- Must be in stealth (Ambush, Garrote)
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

    if spellData.isHealing then
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
