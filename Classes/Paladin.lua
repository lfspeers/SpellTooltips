-- SpellTooltips Paladin Spell Data
-- TBC Classic Paladin spell coefficients (Wowhead datamined)

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local PaladinSpells = {
    -- ===================
    -- DAMAGE SPELLS
    -- ===================

    -- Consecration (all ranks) - 95.2% total (11.9% per tick x 8 ticks)
    -- AoE DoT that pulses every second for 8 seconds
    [26573] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0, isAoE = true, isDot = true,
              tags = { T.Holy, T.Ground, T.DoT, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20116] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0, isAoE = true, isDot = true,
              tags = { T.Holy, T.Ground, T.DoT, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20922] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0, isAoE = true, isDot = true,
              tags = { T.Holy, T.Ground, T.DoT, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20923] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0, isAoE = true, isDot = true,
              tags = { T.Holy, T.Ground, T.DoT, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20924] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0, isAoE = true, isDot = true,
              tags = { T.Holy, T.Ground, T.DoT, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27173] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0, isAoE = true, isDot = true,
              tags = { T.Holy, T.Ground, T.DoT, T.AoE, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Holy Shock (all ranks) - 42.9% coefficient (instant)
    [20473] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [20929] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [20930] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [27174] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },
    [33072] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.Healing, T.SpellPower, T.CanCrit } },

    -- Exorcism (all ranks) - 42.9% coefficient (1.5s cast)
    -- Only usable against Demons and Undead
    [879] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [5614] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [5615] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [10312] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [10313] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [10314] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [27138] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Cast, T.Damage, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },

    -- Hammer of Wrath (all ranks) - 42.9% coefficient (instant)
    -- Only usable on targets below 20% HP
    [24275] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Projectile, T.SingleTarget, T.Instant, T.Damage, T.Execute, T.SpellPower, T.CanCrit } },
    [24274] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Projectile, T.SingleTarget, T.Instant, T.Damage, T.Execute, T.SpellPower, T.CanCrit } },
    [24239] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Projectile, T.SingleTarget, T.Instant, T.Damage, T.Execute, T.SpellPower, T.CanCrit } },
    [27180] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Projectile, T.SingleTarget, T.Instant, T.Damage, T.Execute, T.SpellPower, T.CanCrit } },

    -- Holy Wrath (all ranks) - 28.6% coefficient (2s cast)
    -- AoE damage against Demons and Undead
    [2812] = { name = "Holy Wrath", coefficient = 0.286, school = "holy", castTime = 2.0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Cast, T.Damage, T.Stun, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [10318] = { name = "Holy Wrath", coefficient = 0.286, school = "holy", castTime = 2.0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Cast, T.Damage, T.Stun, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },
    [27139] = { name = "Holy Wrath", coefficient = 0.286, school = "holy", castTime = 2.0, isAoE = true,
              tags = { T.Holy, T.Direct, T.AoE, T.Cast, T.Damage, T.Stun, T.VsUndead, T.VsDemon, T.SpellPower, T.CanCrit } },

    -- Judgement of Righteousness (all ranks) - 72.8% coefficient (instant)
    [20187] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20280] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20281] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20282] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20283] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20284] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20285] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20286] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27157] = { name = "Judgement of Righteousness", coefficient = 0.728, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Judgement of Command (all ranks) - 42.9% coefficient (instant)
    -- Deals double damage if target is stunned
    [20467] = { name = "Judgement of Command", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20425] = { name = "Judgement of Command", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20961] = { name = "Judgement of Command", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20962] = { name = "Judgement of Command", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [20963] = { name = "Judgement of Command", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },
    [27167] = { name = "Judgement of Command", coefficient = 0.429, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Avenger's Shield (all ranks) - 7.1% coefficient (Protection talent, bounces to 3 targets)
    [31935] = { name = "Avenger's Shield", coefficient = 0.071, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Chain, T.Projectile, T.Multitarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit, T.Bounce } },
    [32699] = { name = "Avenger's Shield", coefficient = 0.071, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Chain, T.Projectile, T.Multitarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit, T.Bounce } },
    [32700] = { name = "Avenger's Shield", coefficient = 0.071, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.Chain, T.Projectile, T.Multitarget, T.Instant, T.Damage, T.Silence, T.SpellPower, T.CanCrit, T.Bounce } },

    -- Holy Shield (all ranks) - 5% coefficient per block (Protection talent)
    -- 4 charges base, 8 with Improved Holy Shield talent
    -- isSecondary = true to show only damage bonus, no crit info
    [20925] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0, canCrit = false, isSecondary = true,
              tags = { T.Holy, T.Direct, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20927] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0, canCrit = false, isSecondary = true,
              tags = { T.Holy, T.Direct, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20928] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0, canCrit = false, isSecondary = true,
              tags = { T.Holy, T.Direct, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [27179] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0, canCrit = false, isSecondary = true,
              tags = { T.Holy, T.Direct, T.Proc, T.Instant, T.Damage, T.SpellPower } },

    -- Judgement of Blood - 43% coefficient (from Seal of Blood, Horde)
    -- Deals 295-325 Holy damage, costs 33% of damage dealt as health
    [31898] = { name = "Judgement of Blood", coefficient = 0.43, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- Judgement of the Martyr - 43% coefficient (from Seal of the Martyr, Alliance)
    -- Same as Judgement of Blood but for Alliance
    [53726] = { name = "Judgement of the Martyr", coefficient = 0.43, school = "holy", castTime = 0,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Instant, T.Damage, T.SpellPower, T.CanCrit } },

    -- ===================
    -- SEAL SPELLS (with spell power scaling)
    -- ===================

    -- Seal of Righteousness (all ranks)
    -- Coefficient: 0.092 × weaponSpeed (1H) or 0.108 × weaponSpeed (2H)
    -- Adds Holy damage to each melee swing
    [21084] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20287] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20288] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20289] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20290] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20291] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20292] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [20293] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },
    [27155] = { name = "Seal of Righteousness", school = "holy", castTime = 0,
              isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108,
              tags = { T.Holy, T.Proc, T.Instant, T.Damage, T.SpellPower } },

    -- Seal of Vengeance (Alliance) - 20% per stack, 100% at 5 stacks
    -- Stacking Holy DoT on melee hits
    [31801] = { name = "Seal of Vengeance", school = "holy", castTime = 0,
              isSeal = true, isStackingDot = true,
              coefficientPerStack = 0.20, maxStacks = 5,
              tags = { T.Holy, T.DoT, T.Instant, T.Damage, T.SpellPower } },

    -- Seal of Corruption (Horde) - Same as Vengeance
    [53736] = { name = "Seal of Corruption", school = "holy", castTime = 0,
              isSeal = true, isStackingDot = true,
              coefficientPerStack = 0.20, maxStacks = 5,
              tags = { T.Holy, T.DoT, T.Instant, T.Damage, T.SpellPower } },

    -- ===================
    -- HEALING SPELLS
    -- ===================

    -- Holy Light (all ranks) - 71.4% healing coefficient (2.5s cast)
    [635] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [639] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [647] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [1026] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [1042] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [3472] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10328] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [10329] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [25292] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [27135] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [27136] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },

    -- Flash of Light (all ranks) - 42.9% healing coefficient (1.5s cast)
    [19750] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [19939] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [19940] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [19941] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [19942] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [19943] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
    [27137] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true,
              tags = { T.Holy, T.Direct, T.SingleTarget, T.Friendly, T.Cast, T.Healing, T.SpellPower, T.CanCrit } },
}

-- Register Paladin spells with the main addon
SpellTooltips.RegisterSpellData(PaladinSpells)
