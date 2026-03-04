-- SpellTooltips Warlock Spell Data
-- TBC Classic Warlock spell coefficients (Wowhead datamined)

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local WarlockSpells = {
    -- ===================
    -- DIRECT DAMAGE SPELLS
    -- ===================

    -- Shadow Bolt (all ranks) - 85.7% coefficient
    [686] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [695] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [705] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [1088] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [1106] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [7641] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [11659] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [11660] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [11661] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25307] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [27209] = { name = "Shadow Bolt", coefficient = 0.857, school = "shadow", castTime = 3.0,
              tags = { T.Shadow, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Incinerate (all ranks) - 71.4% coefficient
    [29722] = { name = "Incinerate", coefficient = 0.714, school = "fire", castTime = 2.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [32231] = { name = "Incinerate", coefficient = 0.714, school = "fire", castTime = 2.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Searing Pain (all ranks) - 42.9% coefficient
    [5676] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [17919] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [17920] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [17921] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [17922] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [17923] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [27210] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [30459] = { name = "Searing Pain", coefficient = 0.429, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Soul Fire (all ranks) - 115% coefficient
    [6353] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [17924] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [27211] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [30545] = { name = "Soul Fire", coefficient = 1.15, school = "fire", castTime = 6.0,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Shadowburn (all ranks) - 42.9% coefficient (instant, talent)
    [17877] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [18867] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [18868] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [18869] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [18870] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [18871] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27263] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [30546] = { name = "Shadowburn", coefficient = 0.429, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Conflagrate (all ranks) - 42.9% coefficient (instant, consumes Immolate)
    [17962] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Consumes, T.SpellPower, T.CanCrit } },
    [18930] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Consumes, T.SpellPower, T.CanCrit } },
    [18931] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Consumes, T.SpellPower, T.CanCrit } },
    [18932] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Consumes, T.SpellPower, T.CanCrit } },
    [27266] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Consumes, T.SpellPower, T.CanCrit } },
    [30912] = { name = "Conflagrate", coefficient = 0.429, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Consumes, T.SpellPower, T.CanCrit } },

    -- Shadowfury (all ranks) - 19.5% coefficient (instant AoE stun)
    [30283] = { name = "Shadowfury", coefficient = 0.195, school = "shadow", castTime = 0, isAoE = true,
              tags = { T.Shadow, T.Direct, T.AoE, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },
    [30413] = { name = "Shadowfury", coefficient = 0.195, school = "shadow", castTime = 0, isAoE = true,
              tags = { T.Shadow, T.Direct, T.AoE, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },
    [30414] = { name = "Shadowfury", coefficient = 0.195, school = "shadow", castTime = 0, isAoE = true,
              tags = { T.Shadow, T.Direct, T.AoE, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },

    -- Death Coil (all ranks) - 21.4% coefficient (instant)
    [6789] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [17925] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [17926] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [27223] = { name = "Death Coil", coefficient = 0.214, school = "shadow", castTime = 0,
              tags = { T.Shadow, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },

    -- ===================
    -- DOT SPELLS
    -- ===================

    -- Immolate (all ranks) - 20% direct, 65% DoT over 15s
    [348] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [707] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [1094] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [2941] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [11665] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [11667] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [11668] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [25309] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [27215] = { name = "Immolate", coefficient = 0.20, dotCoefficient = 0.65, school = "fire", castTime = 2.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },

    -- Corruption (all ranks) - 93.6% DoT over 18s (instant cast)
    [172] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [6222] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [6223] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [7648] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [11671] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [11672] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [25311] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [27216] = { name = "Corruption", coefficient = 0, dotCoefficient = 0.936, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Curse of Agony (all ranks) - 120% DoT over 24s (backloaded damage)
    [980] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [1014] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [6217] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [11711] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [11712] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [11713] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [27218] = { name = "Curse of Agony", coefficient = 0, dotCoefficient = 1.20, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Curse of Doom (all ranks) - 200% DoT over 60s
    [603] = { name = "Curse of Doom", coefficient = 0, dotCoefficient = 2.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [30910] = { name = "Curse of Doom", coefficient = 0, dotCoefficient = 2.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Siphon Life (all ranks) - 100% DoT over 30s (talent)
    [18265] = { name = "Siphon Life", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [18879] = { name = "Siphon Life", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [18880] = { name = "Siphon Life", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [18881] = { name = "Siphon Life", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [27264] = { name = "Siphon Life", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },
    [30911] = { name = "Siphon Life", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 0, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.Debuff, T.SpellPower, T.NoCrit } },

    -- Unstable Affliction (all ranks) - 100% DoT over 18s + dispel damage (talent)
    [30108] = { name = "Unstable Affliction", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 1.5, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [30404] = { name = "Unstable Affliction", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 1.5, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },
    [30405] = { name = "Unstable Affliction", coefficient = 0, dotCoefficient = 1.00, school = "shadow", castTime = 1.5, isDot = true, canCrit = false,
              tags = { T.Shadow, T.DoT, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.NoCrit } },

    -- ===================
    -- CHANNELED SPELLS
    -- ===================

    -- Drain Life (all ranks) - 71.4% over 5s channel
    [689] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [699] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [709] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [7651] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [11699] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [11700] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [27219] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },
    [27220] = { name = "Drain Life", coefficient = 0.714, school = "shadow", castTime = 5.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.Healing, T.SpellPower, T.NoCrit } },

    -- Drain Soul (all ranks) - 42.9% over 15s channel
    [1120] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.NoCrit } },
    [8288] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.NoCrit } },
    [8289] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.NoCrit } },
    [11675] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.NoCrit } },
    [27217] = { name = "Drain Soul", coefficient = 0.429, school = "shadow", castTime = 15.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.NoCrit } },

    -- Health Funnel (all ranks) - 42.9% over channel
    [755] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [3698] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [3699] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [3700] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [11693] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [11694] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [11695] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },
    [27259] = { name = "Health Funnel", coefficient = 0.429, school = "shadow", castTime = 10.0, isChanneled = true,
              tags = { T.Shadow, T.Channeled, T.Friendly, T.Healing, T.SpellPower, T.NoCrit } },

    -- ===================
    -- AOE SPELLS
    -- ===================

    -- Hellfire (all ranks) - 28.6% per tick (channeled AoE, damages self)
    [1949] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.AoE, T.Self, T.Damage, T.SpellPower, T.CanCrit } },
    [11683] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.AoE, T.Self, T.Damage, T.SpellPower, T.CanCrit } },
    [11684] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.AoE, T.Self, T.Damage, T.SpellPower, T.CanCrit } },
    [27213] = { name = "Hellfire", coefficient = 0.286, school = "fire", castTime = 15.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.AoE, T.Self, T.Damage, T.SpellPower, T.CanCrit } },

    -- Rain of Fire (all ranks) - 33% total over channel (AoE)
    [5740] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.Ground, T.AoE, T.Damage, T.SpellPower, T.CanCrit } },
    [6219] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.Ground, T.AoE, T.Damage, T.SpellPower, T.CanCrit } },
    [11677] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.Ground, T.AoE, T.Damage, T.SpellPower, T.CanCrit } },
    [11678] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.Ground, T.AoE, T.Damage, T.SpellPower, T.CanCrit } },
    [27212] = { name = "Rain of Fire", coefficient = 0.33, school = "fire", castTime = 8.0, isChanneled = true, isAoE = true,
              tags = { T.Fire, T.Channeled, T.Ground, T.AoE, T.Damage, T.SpellPower, T.CanCrit } },

    -- Seed of Corruption (all ranks) - 22% coefficient on explosion
    [27243] = { name = "Seed of Corruption", coefficient = 0.22, school = "shadow", castTime = 2.0, isAoE = true,
              tags = { T.Shadow, T.Direct, T.DoT, T.AoE, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [47835] = { name = "Seed of Corruption", coefficient = 0.22, school = "shadow", castTime = 2.0, isAoE = true,
              tags = { T.Shadow, T.Direct, T.DoT, T.AoE, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [47836] = { name = "Seed of Corruption", coefficient = 0.22, school = "shadow", castTime = 2.0, isAoE = true,
              tags = { T.Shadow, T.Direct, T.DoT, T.AoE, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
}

-- Register Warlock spells with the main addon
SpellTooltips.RegisterSpellData(WarlockSpells)
