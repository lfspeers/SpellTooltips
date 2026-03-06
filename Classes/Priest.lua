-- SpellTooltips Priest Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local PriestSpells = {
    -- Abolish Disease (all ranks)
    [552] = { name = "Abolish Disease", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Binding Heal (all ranks)
    [32546] = { name = "Binding Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },

    -- Circle of Healing (all ranks)
    [34861] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0.0, isHealing = true },
    [34863] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0.0, isHealing = true },
    [34864] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0.0, isHealing = true },
    [34865] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0.0, isHealing = true },
    [34866] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0.0, isHealing = true },

    -- Cure Disease (all ranks)
    [528] = { name = "Cure Disease", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Desperate Prayer (all ranks) - Instant self-heal (Dwarf/Human racial)
    [13908] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [19236] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [19238] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [19240] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [19241] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [19242] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [19243] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },
    [25437] = { name = "Desperate Prayer", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },

    -- Devouring Plague (all ranks)
    [2944] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },
    [19276] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },
    [19277] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },
    [19278] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },
    [19279] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },
    [19280] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },
    [25467] = { name = "Devouring Plague", coefficient = 0.0, dotCoefficient = 0.8, school = "shadow", castTime = 0.0, isDot = true },

    -- Dispel Magic (all ranks)
    [527] = { name = "Dispel Magic", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [988] = { name = "Dispel Magic", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Flash Heal (all ranks)
    [2061] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [9472] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [9473] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [9474] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [10915] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [10916] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [10917] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [25233] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [25235] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },

    -- Greater Heal (all ranks)
    [2060] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [10963] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [10964] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [10965] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [25210] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [25213] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [25314] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },

    -- Heal (all ranks)
    [2054] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [2055] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [6063] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },
    [6064] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true },

    -- Hex of Weakness (all ranks)
    [9035] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [19281] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [19282] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [19283] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [19284] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [19285] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [25470] = { name = "Hex of Weakness", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Holy Fire (all ranks)
    [14914] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15261] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15262] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15263] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15264] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15265] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15266] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [15267] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },
    [25384] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true },

    -- Holy Nova (all ranks)
    [15237] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0.0 },
    [15430] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0.0 },
    [15431] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0.0 },
    [27799] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0.0 },
    [27800] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0.0 },
    [27801] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0.0 },

    -- Inner Focus (all ranks)
    [14751] = { name = "Inner Focus", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Lesser Heal (all ranks) - Cast times: 1.5s/2.0s/2.5s
    [2050] = { name = "Lesser Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [2052] = { name = "Lesser Heal", coefficient = 0.571, school = "holy", castTime = 2.0, isHealing = true },
    [2053] = { name = "Lesser Heal", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },

    -- Lightwell (all ranks)
    [724] = { name = "Lightwell", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [27870] = { name = "Lightwell", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [27871] = { name = "Lightwell", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [28276] = { name = "Lightwell", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Mana Burn (all ranks)
    [8129] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [8131] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10874] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10875] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10876] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [25379] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [25380] = { name = "Mana Burn", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Mind Blast (all ranks)
    [8092] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [8102] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [8103] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [8104] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [8105] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [8106] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [10945] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [10946] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [10947] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [25372] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },
    [25375] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5 },

    -- Mind Control (all ranks)
    [605] = { name = "Mind Control", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10911] = { name = "Mind Control", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10912] = { name = "Mind Control", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27620] = { name = "Mind Control", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Mind Flay (all ranks) - 3 second channel, 3 ticks
    [15407] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },
    [17311] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },
    [17312] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },
    [17313] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },
    [17314] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },
    [18807] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },
    [25387] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true, ticks = 3 },

    -- Power Infusion (all ranks)
    [10060] = { name = "Power Infusion", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Power Word: Shield (all ranks)
    [17] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [592] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [600] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [3747] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [6065] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [6066] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [10898] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [10899] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [10900] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [10901] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [25217] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },
    [25218] = { name = "Power Word: Shield", coefficient = 0.1, school = "holy", castTime = 0.0, isAbsorb = true },

    -- Prayer of Healing (all ranks)
    [596] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true },
    [996] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true },
    [10960] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true },
    [10961] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true },
    [25308] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true },
    [25316] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true },

    -- Prayer of Mending (all ranks)
    [33076] = { name = "Prayer of Mending", coefficient = 0.429, school = "holy", castTime = 0.0, isHealing = true },

    -- Renew (all ranks)
    [139] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [6074] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [6075] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [6076] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [6077] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [6078] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [10927] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [10928] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [10929] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [25221] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [25222] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },
    [25315] = { name = "Renew", coefficient = 0.0, dotCoefficient = 1.0, school = "holy", castTime = 0.0, isHealing = true, isDot = true },

    -- Shackle Undead (all ranks)
    [9484] = { name = "Shackle Undead", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [9485] = { name = "Shackle Undead", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10955] = { name = "Shackle Undead", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27655] = { name = "Shackle Undead", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Shadow Word: Death (all ranks)
    [32379] = { name = "Shadow Word: Death", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [32380] = { name = "Shadow Word: Death", coefficient = 0.429, school = "shadow", castTime = 0.0 },
    [32996] = { name = "Shadow Word: Death", coefficient = 0.429, school = "shadow", castTime = 0.0 },

    -- Shadow Word: Pain (all ranks)
    [589] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [594] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [970] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [992] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [2767] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [10892] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [10893] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [10894] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [25367] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },
    [25368] = { name = "Shadow Word: Pain", coefficient = 0.0, dotCoefficient = 1.1, school = "shadow", castTime = 0.0, isDot = true },

    -- Shadowfiend (all ranks)
    [34433] = { name = "Shadowfiend", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Shadowform (all ranks)
    [15473] = { name = "Shadowform", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Shadowguard (all ranks) - Troll racial, procs on hit, 3 charges
    -- SP coefficient: 0.267 per proc (source: Wowhead TBC)
    [18137] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },
    [19308] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },
    [19309] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },
    [19310] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },
    [19311] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },
    [19312] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },
    [25477] = { name = "Shadowguard", coefficient = 0.267, school = "shadow", castTime = 0.0, isProc = true },

    -- Smite (all ranks)
    [585] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [591] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [598] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [984] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [1004] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [6060] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [10933] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [10934] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [25363] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },
    [25364] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5 },

    -- Starshards (all ranks) - 6 second channeled DoT, 6 ticks (Night Elf racial)
    [10797] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [19296] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [19299] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [19302] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [19303] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [19304] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [19305] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },
    [25446] = { name = "Starshards", coefficient = 0.0, dotCoefficient = 1.0, school = "arcane", castTime = 6.0, isChanneled = true, ticks = 6 },

    -- Vampiric Embrace (all ranks)
    [15286] = { name = "Vampiric Embrace", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Vampiric Touch (all ranks)
    [34914] = { name = "Vampiric Touch", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },
    [34916] = { name = "Vampiric Touch", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },
    [34917] = { name = "Vampiric Touch", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },
    [34918] = { name = "Vampiric Touch", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },
    [34919] = { name = "Vampiric Touch", coefficient = 0.0, dotCoefficient = 1.0, school = "shadow", castTime = 1.5, isDot = true },

}

-- Register Priest spells with the main addon
SpellTooltips.RegisterSpellData(PriestSpells, "PRIEST")
