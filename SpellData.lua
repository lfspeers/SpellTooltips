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
function SpellTooltips.RegisterSpellData(classSpellData)
    for spellID, data in pairs(classSpellData) do
        SpellTooltips.SpellData[spellID] = data
    end
end
