-- SpellTooltips Shaman Spell Data
-- TBC Classic Shaman spell coefficients

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local ShamanSpells = {
    -- ===================
    -- ELEMENTAL DAMAGE SPELLS
    -- ===================

    -- Lightning Bolt (all ranks) - 79.4% coefficient (2.5s cast)
    [403] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [529] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [548] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [915] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [943] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [6041] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10391] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10392] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15207] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [15208] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25448] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25449] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Chain Lightning (all ranks) - 57.1% coefficient (2.5s cast, jumps to 2 additional targets)
    [421] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Chain, T.Multitarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit, T.Bounce } },
    [930] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Chain, T.Multitarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit, T.Bounce } },
    [2860] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Chain, T.Multitarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit, T.Bounce } },
    [10605] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Chain, T.Multitarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit, T.Bounce } },
    [25439] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Chain, T.Multitarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit, T.Bounce } },
    [25442] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.5,
              tags = { T.Nature, T.Direct, T.Chain, T.Multitarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit, T.Bounce } },

    -- Earth Shock (all ranks) - 38.6% coefficient (instant)
    [8042] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [8044] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [8045] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [8046] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [10412] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [10413] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [10414] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },
    [25454] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit } },

    -- Flame Shock (all ranks) - 15% direct + 52% DoT over 12s (instant)
    [8050] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8052] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8053] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10447] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10448] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [29228] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [25457] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Frost Shock (all ranks) - 38.6% coefficient (instant)
    [8056] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0,
              tags = { T.Frost, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [8058] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0,
              tags = { T.Frost, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10472] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0,
              tags = { T.Frost, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10473] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0,
              tags = { T.Frost, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [25464] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0,
              tags = { T.Frost, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },

    -- ===================
    -- TOTEM DAMAGE (Limited scaling)
    -- ===================

    -- Fire Nova Totem (all ranks) - 21.4% coefficient on explosion
    [1535] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8498] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8499] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [11314] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [11315] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [25546] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [25547] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Searing Totem (all ranks) - 16.7% coefficient per attack
    [3599] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [6363] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [6364] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [6365] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10437] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10438] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [25533] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0,
              tags = { T.Fire, T.Totem, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Magma Totem (all ranks) - 6.7% coefficient per tick
    [8190] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.Ground, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10585] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.Ground, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10586] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.Ground, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10587] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.Ground, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [25552] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Totem, T.Ground, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Lightning Shield (all ranks) - 33% coefficient per charge (reactive damage)
    [324] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [325] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [905] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [945] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [8134] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [10431] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [10432] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [25469] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
    [25472] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0,
              tags = { T.Nature, T.Proc, T.Self, T.Instant, T.Damage, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },

    -- ===================
    -- RESTORATION HEALING SPELLS
    -- ===================

    -- Healing Wave (all ranks) - 85.7% coefficient (3.0s cast)
    [331] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [332] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [547] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [913] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [939] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [959] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [8005] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10395] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10396] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25357] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25391] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25396] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Lesser Healing Wave (all ranks) - 42.9% coefficient (1.5s cast)
    [8004] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [8008] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [8010] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10466] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10467] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10468] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25420] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true,
              tags = { T.Nature, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Chain Heal (all ranks) - 71.4% coefficient (2.5s cast, jumps to 2 additional targets)
    [1064] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true,
              tags = { T.Nature, T.Chain, T.Multitarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit, T.Bounce } },
    [10622] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true,
              tags = { T.Nature, T.Chain, T.Multitarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit, T.Bounce } },
    [10623] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true,
              tags = { T.Nature, T.Chain, T.Multitarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit, T.Bounce } },
    [25422] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true,
              tags = { T.Nature, T.Chain, T.Multitarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit, T.Bounce } },
    [25423] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true,
              tags = { T.Nature, T.Chain, T.Multitarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit, T.Bounce } },

    -- Earth Shield (all ranks) - 28.6% coefficient per charge (instant)
    [974] = { name = "Earth Shield", coefficient = 0.286, school = "nature", castTime = 0, isHealing = true,
              tags = { T.Nature, T.Proc, T.SingleTarget, T.Friendly, T.Instant, T.Healing, T.Buff, T.OnHit, T.SpellPower, T.CanCrit } },
}

-- Register Shaman spells with the main addon
SpellTooltips.RegisterSpellData(ShamanSpells)
