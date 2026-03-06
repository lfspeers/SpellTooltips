-- SpellTooltips Mage Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local MageSpells = {
    -- Arcane Blast (all ranks)
    [30451] = { name = "Arcane Blast", coefficient = 0.714, school = "arcane", castTime = 2.5 },

    -- Arcane Missiles (all ranks)
    [5143] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [5144] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [5145] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [8416] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [8417] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [10211] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [10212] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [25345] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [27075] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [38699] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },
    [38704] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", castTime = 5.0, isChanneled = true, ticks = 5 },

    -- Arcane Power (all ranks)
    [12042] = { name = "Arcane Power", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Blast Wave (all ranks)
    [11113] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [13018] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [13019] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [13020] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [13021] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [27133] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [33933] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0.0 },

    -- Blizzard (all ranks)
    [10] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },
    [6141] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },
    [8427] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },
    [10185] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },
    [10186] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },
    [10187] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },
    [27085] = { name = "Blizzard", coefficient = 0.952, school = "frost", castTime = 8.0, isChanneled = true, ticks = 8 },

    -- Cold Snap (all ranks)
    [11958] = { name = "Cold Snap", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Combustion (all ranks)
    [11129] = { name = "Combustion", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Cone of Cold (all ranks)
    [120] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0.0 },
    [8492] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0.0 },
    [10159] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0.0 },
    [10160] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0.0 },
    [10161] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0.0 },
    [27087] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0.0 },

    -- Dragon's Breath (all ranks)
    [31661] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [33041] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [33042] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0.0 },
    [33043] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0.0 },

    -- Fire Blast (all ranks)
    [2136] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [2137] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [2138] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [8412] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [8413] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [10197] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [10199] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [27078] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [27079] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },
    [33938] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0.0 },

    -- Fireball (all ranks)
    [133] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [143] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [145] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [3140] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [8400] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [8401] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [8402] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [10148] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [10149] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [10150] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [10151] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [25306] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [27070] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },
    [38692] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5 },

    -- Flamestrike (all ranks) - DD + 8 sec DoT, 4 ticks (every 2 sec)
    [2120] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },
    [2121] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },
    [8422] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },
    [8423] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },
    [10215] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },
    [10216] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },
    [27086] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isDot = true, ticks = 4 },

    -- Frostbolt (all ranks)
    [116] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [205] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [837] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [7322] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [8406] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [8407] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [8408] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [10179] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [10180] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [10181] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [25304] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [27071] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [27072] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },
    [38697] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0 },

    -- Ice Barrier (all ranks)
    [11426] = { name = "Ice Barrier", coefficient = 0.1, school = "frost", castTime = 0, isAbsorb = true },
    [13031] = { name = "Ice Barrier", coefficient = 0.1, school = "frost", castTime = 0, isAbsorb = true },
    [13032] = { name = "Ice Barrier", coefficient = 0.1, school = "frost", castTime = 0, isAbsorb = true },
    [13033] = { name = "Ice Barrier", coefficient = 0.1, school = "frost", castTime = 0, isAbsorb = true },
    [27134] = { name = "Ice Barrier", coefficient = 0.1, school = "frost", castTime = 0, isAbsorb = true },
    [33405] = { name = "Ice Barrier", coefficient = 0.1, school = "frost", castTime = 0, isAbsorb = true },

    -- Icy Veins (all ranks)
    [12472] = { name = "Icy Veins", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Molten Armor (all ranks)
    [30482] = { name = "Molten Armor", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Polymorph (all ranks)
    [118] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [12824] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [12825] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [12826] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [28270] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [28271] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [28272] = { name = "Polymorph", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Presence of Mind (all ranks)
    [12043] = { name = "Presence of Mind", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Scorch (all ranks)
    [2948] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [8444] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [8445] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [8446] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [10205] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [10206] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [10207] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [27073] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },
    [27074] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5 },

    -- Summon Water Elemental (all ranks)
    [31687] = { name = "Summon Water Elemental", coefficient = 0.0, school = "unknown", castTime = 0.0 },

}

-- Register Mage spells with the main addon
SpellTooltips.RegisterSpellData(MageSpells, "MAGE")
