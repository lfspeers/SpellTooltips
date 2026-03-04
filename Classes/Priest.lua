-- SpellTooltips Priest Spell Data
-- TBC Classic Priest spell coefficients (Wowhead datamined)

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local PriestSpells = {
    -- ===================
    -- SHADOW DAMAGE SPELLS
    -- ===================

    -- Mind Blast (all ranks) - 42.9% coefficient (1.5s cast)
    [8092] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8102] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8103] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8104] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8105] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8106] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10945] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10946] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10947] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25372] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25375] = { name = "Mind Blast", coefficient = 0.429, school = "shadow", castTime = 1.5,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Shadow Word: Pain (all ranks) - 110% DoT over 18s (instant)
    [589] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [594] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [970] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [992] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [2767] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [10892] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [10893] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [10894] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [25367] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [25368] = { name = "Shadow Word: Pain", coefficient = 0, dotCoefficient = 1.10, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Shadow Word: Death (all ranks) - 42.9% coefficient (instant)
    [32379] = { name = "Shadow Word: Death", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [32996] = { name = "Shadow Word: Death", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Mind Flay (all ranks) - 57% over 3s channel
    [15407] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [17311] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [17312] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [17313] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [17314] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [18807] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [25387] = { name = "Mind Flay", coefficient = 0.57, school = "shadow", castTime = 3.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },

    -- Vampiric Touch (all ranks) - 100% DoT over 15s (1.5s cast, talent)
    [34914] = { name = "Vampiric Touch", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 1.5, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [34916] = { name = "Vampiric Touch", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 1.5, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [34917] = { name = "Vampiric Touch", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 1.5, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Devouring Plague (all ranks) - 80% DoT over 24s (instant, Undead only)
    [2944] = { name = "Devouring Plague", coefficient = 0, dotCoefficient = 0.80, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [19276] = { name = "Devouring Plague", coefficient = 0, dotCoefficient = 0.80, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [19277] = { name = "Devouring Plague", coefficient = 0, dotCoefficient = 0.80, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [19278] = { name = "Devouring Plague", coefficient = 0, dotCoefficient = 0.80, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [19279] = { name = "Devouring Plague", coefficient = 0, dotCoefficient = 0.80, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [25467] = { name = "Devouring Plague", coefficient = 0, dotCoefficient = 0.80, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },

    -- ===================
    -- HOLY DAMAGE SPELLS
    -- ===================

    -- Smite (all ranks) - 71.4% coefficient (2.5s cast)
    [585] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [591] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [598] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [984] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [1004] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [6060] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10933] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10934] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25363] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25364] = { name = "Smite", coefficient = 0.714, school = "holy", castTime = 2.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Holy Fire (all ranks) - 85.7% direct + 16.5% DoT (3.5s cast)
    [14914] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15262] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15263] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15264] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15265] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15266] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15267] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15261] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25384] = { name = "Holy Fire", coefficient = 0.857, dotCoefficient = 0.165, school = "holy", castTime = 3.5, isDot = true,
              tags = { T.Holy, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Holy Nova (all ranks) - 10.7% damage coefficient (instant AoE)
    [15237] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [15430] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [15431] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [27799] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [27800] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [27801] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [25331] = { name = "Holy Nova", coefficient = 0.107, school = "holy", castTime = 0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },

    -- ===================
    -- HEALING SPELLS
    -- ===================

    -- Greater Heal (all ranks) - 85.7% coefficient (3.0s cast)
    [2060] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10963] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10964] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10965] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25314] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25210] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25213] = { name = "Greater Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Heal (all ranks) - 85.7% coefficient (3.0s cast)
    [2054] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [2055] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [6063] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [6064] = { name = "Heal", coefficient = 0.857, school = "holy", castTime = 3.0, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Flash Heal (all ranks) - 42.9% coefficient (1.5s cast)
    [2061] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [9472] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [9473] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [9474] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10915] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10916] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10917] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25233] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25235] = { name = "Flash Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Renew (all ranks) - 100% HoT over 15s (instant)
    [139] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [6074] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [6075] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [6076] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [6077] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [6078] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [10927] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [10928] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [10929] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [25315] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [25221] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [25222] = { name = "Renew", coefficient = 0, dotCoefficient = 1.00, school = "holy", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Holy, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },

    -- Prayer of Healing (all ranks) - 28.6% coefficient (3.0s cast, AoE heal)
    [596] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [996] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10960] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10961] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25316] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25308] = { name = "Prayer of Healing", coefficient = 0.286, school = "holy", castTime = 3.0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Circle of Healing (all ranks) - 28.6% coefficient (instant AoE heal, talent)
    [34861] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Instant, T.Healing, T.SpellPower, T.CanCrit } },
    [34863] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Instant, T.Healing, T.SpellPower, T.CanCrit } },
    [34864] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Instant, T.Healing, T.SpellPower, T.CanCrit } },
    [34865] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Instant, T.Healing, T.SpellPower, T.CanCrit } },
    [34866] = { name = "Circle of Healing", coefficient = 0.286, school = "holy", castTime = 0, isHealing = true, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Friendly, T.Instant, T.Healing, T.SpellPower, T.CanCrit } },

    -- Binding Heal (all ranks) - 42.9% coefficient (1.5s cast, heals self and target)
    [32546] = { name = "Binding Heal", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.Multitarget, T.Friendly, T.Self, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Prayer of Mending (all ranks) - 42.9% coefficient (instant, bounces on damage)
    [33076] = { name = "Prayer of Mending", coefficient = 0.429, school = "holy", castTime = 0, isHealing = true,
              tags = { T.Holy, T.Proc, T.Chain, T.Friendly, T.Instant, T.Healing, T.Buff, T.OnHit, T.SpellPower, T.CanCrit, T.Bounce } },

    -- ===================
    -- ABSORPTION SPELLS
    -- ===================

    -- Power Word: Shield (all ranks) - 10% coefficient (instant)
    [17] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [592] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [600] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [3747] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [6065] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [6066] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [10898] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [10899] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [10900] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [10901] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [25217] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
    [25218] = { name = "Power Word: Shield", coefficient = 0.10, school = "holy", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Holy, T.Absorb, T.SingleTarget, T.Friendly, T.Instant, T.Buff, T.SpellPower } },
}

-- Register Priest spells with the main addon
SpellTooltips.RegisterSpellData(PriestSpells)
