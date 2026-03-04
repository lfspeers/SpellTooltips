-- SpellTooltips Druid Spell Data
-- TBC Classic Druid spell coefficients (Wowhead datamined)

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local DruidSpells = {
    -- ===================
    -- BALANCE DAMAGE SPELLS
    -- ===================

    -- Wrath (all ranks) - 57.1% coefficient (2.0s cast)
    [5176] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [5177] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [5178] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [5179] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [5180] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [6780] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8905] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [9912] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [26984] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [26985] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Starfire (all ranks) - 100% coefficient (3.5s cast)
    [2912] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8949] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8950] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8951] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [9875] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [9876] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25298] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [26986] = { name = "Starfire", coefficient = 1.00, school = "arcane", castTime = 3.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Moonfire (all ranks) - 15% direct + 52% DoT over 12s (instant)
    [8921] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8924] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8925] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8926] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8927] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8928] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8929] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [9833] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [9834] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [9835] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [26987] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [26988] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0, isDot = true,
              tags = { T.Arcane, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },

    -- Insect Swarm (all ranks) - 76% DoT over 12s (instant, talent)
    [5570] = { name = "Insect Swarm", coefficient = 0, dotCoefficient = 0.76, school = "nature", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Nature, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [24974] = { name = "Insect Swarm", coefficient = 0, dotCoefficient = 0.76, school = "nature", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Nature, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [24975] = { name = "Insect Swarm", coefficient = 0, dotCoefficient = 0.76, school = "nature", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Nature, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [24976] = { name = "Insect Swarm", coefficient = 0, dotCoefficient = 0.76, school = "nature", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Nature, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [24977] = { name = "Insect Swarm", coefficient = 0, dotCoefficient = 0.76, school = "nature", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Nature, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [27013] = { name = "Insect Swarm", coefficient = 0, dotCoefficient = 0.76, school = "nature", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Nature, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Hurricane (all ranks) - 10.7% per tick (channeled AoE)
    [16914] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, isAoE = true, canCrit = false,
              tags = { T.Nature, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [17401] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, isAoE = true, canCrit = false,
              tags = { T.Nature, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [17402] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, isAoE = true, canCrit = false,
              tags = { T.Nature, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [27012] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, isAoE = true, canCrit = false,
              tags = { T.Nature, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },

    -- ===================
    -- RESTORATION HEALING SPELLS
    -- ===================

    -- Healing Touch (all ranks) - 100% coefficient (3.5s cast)
    [5185] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [5186] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [5187] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [5188] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [5189] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [6778] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [8903] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [9758] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [9888] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [9889] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25297] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [26978] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [26979] = { name = "Healing Touch", coefficient = 1.00, school = "nature", castTime = 3.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Regrowth (all ranks) - 28.6% direct + 70% HoT over 21s (2.0s cast)
    [8936] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [8938] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [8939] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [8940] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [8941] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [9750] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [9856] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [9857] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [9858] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [26980] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },
    [27637] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.70, school = "nature", castTime = 2.0, isHealing = true, isDot = true,
              tags = { T.Nature, T.Direct, T.HoT, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.Buff, T.SpellPower, T.CanCrit } },

    -- Rejuvenation (all ranks) - 80% HoT over 12s (instant)
    [774] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [1058] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [1430] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [2090] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [2091] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [3627] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [8910] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [9839] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [9840] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [9841] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [25299] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [26981] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },
    [26982] = { name = "Rejuvenation", coefficient = 0, dotCoefficient = 0.80, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.SpellPower, T.NoCrit } },

    -- Lifebloom (all ranks) - 52% HoT + 34.3% bloom (instant)
    [33763] = { name = "Lifebloom", coefficient = 0.343, dotCoefficient = 0.52, school = "nature", castTime = 0, isHealing = true, isDot = true,
              tags = { T.Nature, T.HoT, T.Direct, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.Stacks, T.SpellPower, T.CanCrit } },

    -- Tranquility (all ranks) - 114% total over channel (channeled AoE heal)
    [740] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isChanneled = true, isHealing = true, isAoE = true,
              tags = { T.Nature, T.Channeled, T.AoE, T.Friendly, T.Healing, T.SpellPower, T.CanCrit } },
    [8918] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isChanneled = true, isHealing = true, isAoE = true,
              tags = { T.Nature, T.Channeled, T.AoE, T.Friendly, T.Healing, T.SpellPower, T.CanCrit } },
    [9862] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isChanneled = true, isHealing = true, isAoE = true,
              tags = { T.Nature, T.Channeled, T.AoE, T.Friendly, T.Healing, T.SpellPower, T.CanCrit } },
    [9863] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isChanneled = true, isHealing = true, isAoE = true,
              tags = { T.Nature, T.Channeled, T.AoE, T.Friendly, T.Healing, T.SpellPower, T.CanCrit } },
    [26983] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isChanneled = true, isHealing = true, isAoE = true,
              tags = { T.Nature, T.Channeled, T.AoE, T.Friendly, T.Healing, T.SpellPower, T.CanCrit } },

    -- Swiftmend (consumes HoT, heals for 12s of that HoT)
    [18562] = { name = "Swiftmend", coefficient = 0, school = "nature", castTime = 0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Consumes, T.SpellPower, T.CanCrit } },
}

-- Register Druid spells with the main addon
SpellTooltips.RegisterSpellData(DruidSpells)
