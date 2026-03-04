-- SpellTooltips Utils
-- Helper functions for spellpower retrieval and tooltip formatting

SpellTooltips = SpellTooltips or {}
SpellTooltips.Utils = {}

-- Color constants for tooltip text
SpellTooltips.Colors = {
    SPELL_DAMAGE = "|cFF00FF00",    -- Green for spell damage bonus
    COEFFICIENT = "|cFFFFFF00",      -- Yellow for coefficient info
    TOTAL = "|cFF00FFFF",            -- Cyan for total damage
    LABEL = "|cFFAAAAAA",            -- Gray for labels
    RESET = "|r",
}

-- School indices used by GetSpellBonusDamage
SpellTooltips.Schools = {
    physical = 1,
    holy = 2,
    fire = 3,
    nature = 4,
    frost = 5,
    shadow = 6,
    arcane = 7,
}

-- Get player's highest spell damage (checks all schools)
function SpellTooltips.Utils.GetPlayerSpellPower()
    local maxSpellPower = 0
    for i = 2, 7 do  -- Skip physical (1)
        local power = GetSpellBonusDamage(i) or 0
        if power > maxSpellPower then
            maxSpellPower = power
        end
    end
    return maxSpellPower
end

-- Get spell damage for a specific school
function SpellTooltips.Utils.GetPlayerSpellPowerBySchool(school)
    if not school then
        return SpellTooltips.Utils.GetPlayerSpellPower()
    end

    local schoolIndex = SpellTooltips.Schools[string.lower(school)]
    if schoolIndex then
        return GetSpellBonusDamage(schoolIndex) or 0
    end

    return SpellTooltips.Utils.GetPlayerSpellPower()
end

-- Get player's healing power
function SpellTooltips.Utils.GetPlayerHealingPower()
    return GetSpellBonusHealing() or 0
end

-- Format a tooltip line with label and value
function SpellTooltips.Utils.FormatTooltipLine(label, value, color)
    color = color or SpellTooltips.Colors.SPELL_DAMAGE
    return string.format("%s%s:%s %s%s",
        SpellTooltips.Colors.LABEL,
        label,
        SpellTooltips.Colors.RESET,
        color,
        tostring(value) .. SpellTooltips.Colors.RESET
    )
end

-- Format damage range
function SpellTooltips.Utils.FormatDamageRange(minDmg, maxDmg)
    if minDmg == maxDmg then
        return tostring(math.floor(minDmg))
    end
    return string.format("%d - %d", math.floor(minDmg), math.floor(maxDmg))
end

-- Round a number to specified decimal places
function SpellTooltips.Utils.Round(num, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(num * mult + 0.5) / mult
end

-- Format coefficient as percentage
function SpellTooltips.Utils.FormatCoefficient(coeff)
    return string.format("%.1f%%", coeff * 100)
end

-- Get player's spell crit chance for a specific school
function SpellTooltips.Utils.GetPlayerSpellCritChance(school)
    local schoolIndex = SpellTooltips.Schools[string.lower(school or "")]
    if schoolIndex then
        return GetSpellCritChance(schoolIndex) or 0
    end
    -- Return highest crit if no school specified
    local maxCrit = 0
    for i = 2, 7 do
        local crit = GetSpellCritChance(i) or 0
        if crit > maxCrit then maxCrit = crit end
    end
    return maxCrit
end
