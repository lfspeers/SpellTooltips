-- SpellTooltips Mage Spell Data
-- TBC Classic Mage spell coefficients

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local MageSpells = {
    -- Fireball (all ranks)
    -- 100% coefficient for direct, small DoT component
    [133] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [143] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [145] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [3140] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8400] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8401] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8402] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10148] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10149] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10150] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10151] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [25306] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [27070] = { name = "Fireball", coefficient = 1.0, dotCoefficient = 0.0, school = "fire", castTime = 3.5,
              tags = { T.Fire, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Frostbolt (all ranks)
    -- 81.4% coefficient
    [116] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [205] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [837] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [7322] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [8406] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [8407] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [8408] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10179] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10180] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10181] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [25304] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [27071] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [27072] = { name = "Frostbolt", coefficient = 0.814, school = "frost", castTime = 3.0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },

    -- Arcane Missiles (all ranks)
    -- 100% total coefficient (channeled, 5 waves at 20% each)
    [5143] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [5144] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [5145] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [8416] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [8417] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [10211] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [10212] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [25345] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [27075] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [38699] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },
    [38704] = { name = "Arcane Missiles", coefficient = 1.0, school = "arcane", isChanneled = true, ticks = 5, castTime = 5.0,
              tags = { T.Arcane, T.Channeled, T.SingleTarget, T.Damage, T.SpellPower, T.CanCrit } },

    -- Pyroblast (all ranks)
    -- 115% direct, 5% DoT
    [11366] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [12505] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [12522] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [12523] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [12524] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [12525] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [12526] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [18809] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [27132] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [33938] = { name = "Pyroblast", coefficient = 1.15, dotCoefficient = 0.05, school = "fire", castTime = 6.0, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Projectile, T.SingleTarget, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Fire Blast (all ranks)
    -- 42.8% coefficient (instant)
    [2136] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [2137] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [2138] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8412] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8413] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10197] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10199] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27078] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27079] = { name = "Fire Blast", coefficient = 0.428, school = "fire", castTime = 0,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Frost Nova (all ranks)
    -- 4.3% coefficient
    [122] = { name = "Frost Nova", coefficient = 0.043, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.AoE, T.Instant, T.Damage, T.Root, T.SpellPower, T.CanCrit } },
    [865] = { name = "Frost Nova", coefficient = 0.043, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.AoE, T.Instant, T.Damage, T.Root, T.SpellPower, T.CanCrit } },
    [6131] = { name = "Frost Nova", coefficient = 0.043, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.AoE, T.Instant, T.Damage, T.Root, T.SpellPower, T.CanCrit } },
    [10230] = { name = "Frost Nova", coefficient = 0.043, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.AoE, T.Instant, T.Damage, T.Root, T.SpellPower, T.CanCrit } },
    [27088] = { name = "Frost Nova", coefficient = 0.043, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.AoE, T.Instant, T.Damage, T.Root, T.SpellPower, T.CanCrit } },

    -- Cone of Cold (all ranks)
    -- 19.3% coefficient
    [120] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.Cone, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [8492] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.Cone, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10159] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.Cone, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10160] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.Cone, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [10161] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.Cone, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },
    [27087] = { name = "Cone of Cold", coefficient = 0.193, school = "frost", castTime = 0, isAoE = true,
              tags = { T.Frost, T.Direct, T.Cone, T.Instant, T.Damage, T.Slow, T.SpellPower, T.CanCrit } },

    -- Arcane Explosion (all ranks)
    -- 21.4% coefficient (instant AoE)
    [1449] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8437] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8438] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [8439] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10201] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [10202] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27080] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27082] = { name = "Arcane Explosion", coefficient = 0.214, school = "arcane", castTime = 0, isAoE = true,
              tags = { T.Arcane, T.Direct, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Blizzard (all ranks)
    -- 95.2% total coefficient (11.9% per tick x 8 ticks)
    -- Cannot crit in TBC
    [10] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [6141] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [8427] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [10185] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [10186] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [10187] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },
    [27085] = { name = "Blizzard", coefficient = 0.952, school = "frost", isChanneled = true, castTime = 8.0, isAoE = true, canCrit = false,
              tags = { T.Frost, T.Channeled, T.Ground, T.AoE, T.Damage, T.Slow, T.SpellPower, T.NoCrit } },

    -- Flamestrike (all ranks)
    -- 23.6% direct, minimal DoT scaling (AoE)
    [2120] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [2121] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8422] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [8423] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10215] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [10216] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },
    [27086] = { name = "Flamestrike", coefficient = 0.236, dotCoefficient = 0.03, school = "fire", castTime = 3.0, isAoE = true, isDot = true,
              tags = { T.Fire, T.Direct, T.DoT, T.Ground, T.AoE, T.Cast, T.Damage, T.SpellPower, T.CanCrit } },

    -- Scorch (all ranks)
    -- 42.8% coefficient (1.5s cast)
    [2948] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8444] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8445] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [8446] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [10205] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [10206] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [10207] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [27073] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },
    [27074] = { name = "Scorch", coefficient = 0.428, school = "fire", castTime = 1.5,
              tags = { T.Fire, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.SpellPower, T.CanCrit } },

    -- Arcane Blast
    -- 71.4% coefficient (2.5s base cast)
    [30451] = { name = "Arcane Blast", coefficient = 0.714, school = "arcane", castTime = 2.5,
              tags = { T.Arcane, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.Debuff, T.Stacks, T.SpellPower, T.CanCrit } },

    -- Ice Lance
    -- 14.3% coefficient (instant, triples on frozen targets)
    [30455] = { name = "Ice Lance", coefficient = 0.143, school = "frost", castTime = 0,
              tags = { T.Frost, T.Direct, T.Projectile, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Dragon's Breath (all ranks)
    -- 19.3% coefficient (instant cone AoE, Fire talent)
    [31661] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.Cone, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },
    [33041] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.Cone, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },
    [33042] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.Cone, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },
    [33043] = { name = "Dragon's Breath", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.Cone, T.Instant, T.Damage, T.Stun, T.SpellPower, T.CanCrit } },

    -- Blast Wave (all ranks)
    -- 19.3% coefficient (instant AoE knockback, Fire talent)
    [11113] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },
    [13018] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },
    [13019] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },
    [13020] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },
    [13021] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },
    [27133] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },
    [33933] = { name = "Blast Wave", coefficient = 0.193, school = "fire", castTime = 0, isAoE = true,
              tags = { T.Fire, T.Direct, T.AoE, T.Instant, T.Damage, T.Knockback, T.Slow, T.SpellPower, T.CanCrit } },

    -- ===================
    -- ABSORPTION SPELLS
    -- ===================

    -- Ice Barrier (all ranks) - 10% coefficient (instant, Frost talent)
    [11426] = { name = "Ice Barrier", coefficient = 0.10, school = "frost", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Frost, T.Absorb, T.Self, T.Instant, T.Buff, T.SpellPower } },
    [13031] = { name = "Ice Barrier", coefficient = 0.10, school = "frost", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Frost, T.Absorb, T.Self, T.Instant, T.Buff, T.SpellPower } },
    [13032] = { name = "Ice Barrier", coefficient = 0.10, school = "frost", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Frost, T.Absorb, T.Self, T.Instant, T.Buff, T.SpellPower } },
    [13033] = { name = "Ice Barrier", coefficient = 0.10, school = "frost", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Frost, T.Absorb, T.Self, T.Instant, T.Buff, T.SpellPower } },
    [27134] = { name = "Ice Barrier", coefficient = 0.10, school = "frost", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Frost, T.Absorb, T.Self, T.Instant, T.Buff, T.SpellPower } },
    [33405] = { name = "Ice Barrier", coefficient = 0.10, school = "frost", castTime = 0, isAbsorb = true, canCrit = false,
              tags = { T.Frost, T.Absorb, T.Self, T.Instant, T.Buff, T.SpellPower } },
}

-- Register Mage spells with the main addon
SpellTooltips.RegisterSpellData(MageSpells)
