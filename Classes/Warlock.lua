-- SpellTooltips Warlock Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local WarlockSpells = {
    -- Amplify Curse (all ranks)
    [18288] = { name = "Amplify Curse", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Banish (all ranks)
    [710] = { name = "Banish", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [18647] = { name = "Banish", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Burning Wish (all ranks)
    [18789] = { name = "Burning Wish", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Conflagrate (all ranks)
    [17962] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0.0 },

    -- Corruption (all ranks)
    [172] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [6222] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [6223] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [7648] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [11671] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [11672] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [25311] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },
    [27216] = { name = "Corruption", coefficient = 0.0, dotCoefficient = 0.936, school = "shadow", castTime = 0.0, isDot = true },

    -- Curse of Agony (all ranks)
    [980] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },
    [1014] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },
    [6217] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },
    [11711] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },
    [11712] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },
    [11713] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },
    [27218] = { name = "Curse of Agony", coefficient = 0.0, dotCoefficient = 1.2, school = "shadow", castTime = 0.0, isDot = true },

    -- Curse of Doom (all ranks)
    [603] = { name = "Curse of Doom", coefficient = 0.0, dotCoefficient = 2.0, school = "shadow", castTime = 0.0, isDot = true },
    [30910] = { name = "Curse of Doom", coefficient = 0.0, dotCoefficient = 2.0, school = "shadow", castTime = 0.0, isDot = true },

    -- Death Coil (all ranks)
    [6789] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0.0 },
    [17925] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0.0 },
    [17926] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0.0 },
    [27223] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0.0 },

    -- Demonic Sacrifice (all ranks)
    [18788] = { name = "Demonic Sacrifice", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Drain Life (all ranks) - 5 second channel, 5 ticks
    [689] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [699] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [709] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [7651] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [11699] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [11700] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [27219] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },
    [27220] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true, ticks = 5 },

    -- Drain Soul (all ranks) - 15 second channel, 5 ticks (every 3 sec)
    [1120] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true, ticks = 5 },
    [8288] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true, ticks = 5 },
    [8289] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true, ticks = 5 },
    [11675] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true, ticks = 5 },
    [27217] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true, ticks = 5 },

    -- Hellfire (all ranks) - 15 second channel, 15 ticks (every 1 sec)
    [1949] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, ticks = 15 },
    [11683] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, ticks = 15 },
    [11684] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, ticks = 15 },
    [27213] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, ticks = 15 },

    -- Immolate (all ranks)
    [348] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [707] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [1094] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [2941] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [11665] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [11667] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [11668] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [25309] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },
    [27215] = { name = "Immolate", coefficient = 0.2, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true },

    -- Incinerate (all ranks)
    [29722] = { name = "Incinerate", coefficient = 0.714, school = "fire", castTime = 2.5 },
    [32231] = { name = "Incinerate", coefficient = 0.714, school = "fire", castTime = 2.5 },

    -- Inferno (all ranks)
    [1122] = { name = "Inferno", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Rain of Fire (all ranks) - 8 second channel, 4 waves (every 2 sec)
    [5740] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, ticks = 4 },
    [6219] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, ticks = 4 },
    [11677] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, ticks = 4 },
    [11678] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, ticks = 4 },
    [27212] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, ticks = 4 },

    -- Ritual of Doom (all ranks)
    [18540] = { name = "Ritual of Doom", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Searing Pain (all ranks)
    [5676] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [17919] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [17920] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [17921] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [17922] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [17923] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [27210] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },
    [30459] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5 },

    -- Seed of Corruption (all ranks)
    -- DoT ticks while active, explosion when detonated
    [27243] = {
        name = "Seed of Corruption",
        school = "shadow",
        castTime = 2.0,
        parts = {
            { label = "DoT", dotCoefficient = 0.25, isDot = true, ticks = 6 },
            { label = "Explosion", coefficient = 0.22 },
        },
    },

    -- Shadow Bolt (all ranks)
    [686] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [695] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [705] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [1088] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [1106] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [7641] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [11659] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [11660] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [11661] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [25307] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },
    [27209] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0 },

    -- Shadowburn (all ranks)
    [17877] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [18867] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [18868] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [18869] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [18870] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [18871] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [27263] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [30546] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0.0 },

    -- Siphon Life (all ranks)
    [18265] = { name = "Siphon Life", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 0.0, isDot = true },
    [18879] = { name = "Siphon Life", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 0.0, isDot = true },
    [18880] = { name = "Siphon Life", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 0.0, isDot = true },
    [18881] = { name = "Siphon Life", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 0.0, isDot = true },
    [27264] = { name = "Siphon Life", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 0.0, isDot = true },
    [30911] = { name = "Siphon Life", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 0.0, isDot = true },

    -- Soul Fire (all ranks)
    [6353] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0 },
    [17924] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0 },
    [27211] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0 },
    [30545] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0 },

    -- Subjugate Demon (all ranks)
    [1098] = { name = "Subjugate Demon", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [11725] = { name = "Subjugate Demon", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [11726] = { name = "Subjugate Demon", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Touch of Shadow (all ranks)
    [18791] = { name = "Touch of Shadow", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [35701] = { name = "Touch of Shadow", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Unstable Affliction (all ranks)
    [30108] = { name = "Unstable Affliction", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },
    [30404] = { name = "Unstable Affliction", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },
    [30405] = { name = "Unstable Affliction", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },

}

-- Register Warlock spells with the main addon
SpellTooltips.RegisterSpellData(WarlockSpells, "WARLOCK")
