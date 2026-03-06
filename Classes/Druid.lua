-- SpellTooltips Druid Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local DruidSpells = {
    -- =====================
    -- CLAW (Cat Form)
    -- Flat damage + normalized AP scaling
    -- Generates 1 combo point
    -- Normalized speed: 1.0 (feral forms)
    -- =====================
    [1082] = { name = "Claw", school = "physical", isPhysical = true, flatDamage = 16, isNormalized = true, normalizedSpeed = 1.0 },
    [3029] = { name = "Claw", school = "physical", isPhysical = true, flatDamage = 26, isNormalized = true, normalizedSpeed = 1.0 },
    [5201] = { name = "Claw", school = "physical", isPhysical = true, flatDamage = 43, isNormalized = true, normalizedSpeed = 1.0 },
    [9849] = { name = "Claw", school = "physical", isPhysical = true, flatDamage = 64, isNormalized = true, normalizedSpeed = 1.0 },
    [9850] = { name = "Claw", school = "physical", isPhysical = true, flatDamage = 91, isNormalized = true, normalizedSpeed = 1.0 },
    [27000] = { name = "Claw", school = "physical", isPhysical = true, flatDamage = 130, isNormalized = true, normalizedSpeed = 1.0 },

    -- Faerie Fire (Feral) (all ranks) - no damage, armor debuff only
    [16857] = { name = "Faerie Fire (Feral)", coefficient = 0.0, school = "nature", castTime = 0.0 },
    [17390] = { name = "Faerie Fire (Feral)", coefficient = 0.0, school = "nature", castTime = 0.0 },
    [17391] = { name = "Faerie Fire (Feral)", coefficient = 0.0, school = "nature", castTime = 0.0 },
    [17392] = { name = "Faerie Fire (Feral)", coefficient = 0.0, school = "nature", castTime = 0.0 },
    [27011] = { name = "Faerie Fire (Feral)", coefficient = 0.0, school = "nature", castTime = 0.0 },

    -- =====================
    -- FEROCIOUS BITE is EXCLUDED
    -- Reason: Damage scales with combo points AND converts remaining energy to damage
    -- Too dynamic to calculate accurately
    -- =====================
    -- Keeping entries but not modifying tooltips

    -- Force of Nature (all ranks)
    [33831] = { name = "Force of Nature", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Frenzied Regeneration (all ranks)
    [22842] = { name = "Frenzied Regeneration", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [22895] = { name = "Frenzied Regeneration", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [22896] = { name = "Frenzied Regeneration", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [26999] = { name = "Frenzied Regeneration", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Healing Touch (all ranks)
    [5185] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [5186] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [5187] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [5188] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [5189] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [6778] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [8903] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [9758] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [9888] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [9889] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [25297] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [26978] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },
    [26979] = { name = "Healing Touch", coefficient = 1.0, school = "nature", castTime = 3.5, isHealing = true },

    -- Hibernate (all ranks)
    [2637] = { name = "Hibernate", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [18657] = { name = "Hibernate", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [18658] = { name = "Hibernate", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Hurricane (all ranks) - 10 sec channel, 10 ticks
    [16914] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, ticks = 10 },
    [17401] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, ticks = 10 },
    [17402] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, ticks = 10 },
    [27012] = { name = "Hurricane", coefficient = 0.107, school = "nature", castTime = 10.0, isChanneled = true, ticks = 10 },

    -- Innervate (all ranks)
    [29166] = { name = "Innervate", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Insect Swarm (all ranks) - 12 sec DoT, 6 ticks (every 2 sec)
    [5570] = { name = "Insect Swarm", coefficient = 0.0, dotCoefficient = 0.76, school = "nature", castTime = 0.0, isDot = true, ticks = 6 },
    [24974] = { name = "Insect Swarm", coefficient = 0.0, dotCoefficient = 0.76, school = "nature", castTime = 0.0, isDot = true, ticks = 6 },
    [24975] = { name = "Insect Swarm", coefficient = 0.0, dotCoefficient = 0.76, school = "nature", castTime = 0.0, isDot = true, ticks = 6 },
    [24976] = { name = "Insect Swarm", coefficient = 0.0, dotCoefficient = 0.76, school = "nature", castTime = 0.0, isDot = true, ticks = 6 },
    [24977] = { name = "Insect Swarm", coefficient = 0.0, dotCoefficient = 0.76, school = "nature", castTime = 0.0, isDot = true, ticks = 6 },
    [27013] = { name = "Insect Swarm", coefficient = 0.0, dotCoefficient = 0.76, school = "nature", castTime = 0.0, isDot = true, ticks = 6 },

    -- =====================
    -- LACERATE (Bear Form) - TBC
    -- Bleed DoT that stacks up to 5 times
    -- Each application deals flat damage + 0.1% AP per tick
    -- =====================
    [33745] = { name = "Lacerate", school = "physical", isPhysical = true, isBleed = true, isDot = true, flatDamage = 31, apCoefficient = 0.01 },

    -- Lifebloom (all ranks) - 7 sec HoT, 7 ticks + bloom at end
    [33763] = { name = "Lifebloom", coefficient = 0.343, dotCoefficient = 0.52, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 7 },
    [33778] = { name = "Lifebloom", coefficient = 0.343, dotCoefficient = 0.52, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 7 },

    -- =====================
    -- MANGLE (Bear) - TBC Feral talent
    -- 115% paw damage + flat bonus, applies bleed debuff
    -- =====================
    [33878] = { name = "Mangle (Bear)", school = "physical", isPhysical = true, flatDamage = 128, weaponDamagePercent = 1.15, isNormalized = true, normalizedSpeed = 2.5 },
    [33986] = { name = "Mangle (Bear)", school = "physical", isPhysical = true, flatDamage = 155, weaponDamagePercent = 1.15, isNormalized = true, normalizedSpeed = 2.5 },
    [33987] = { name = "Mangle (Bear)", school = "physical", isPhysical = true, flatDamage = 182, weaponDamagePercent = 1.15, isNormalized = true, normalizedSpeed = 2.5 },

    -- =====================
    -- MANGLE (Cat) - TBC Feral talent
    -- 160% paw damage + flat bonus, applies bleed debuff
    -- Generates 1 combo point
    -- =====================
    [33876] = { name = "Mangle (Cat)", school = "physical", isPhysical = true, flatDamage = 146, weaponDamagePercent = 1.6, isNormalized = true, normalizedSpeed = 1.0 },
    [33982] = { name = "Mangle (Cat)", school = "physical", isPhysical = true, flatDamage = 177, weaponDamagePercent = 1.6, isNormalized = true, normalizedSpeed = 1.0 },
    [33983] = { name = "Mangle (Cat)", school = "physical", isPhysical = true, flatDamage = 208, weaponDamagePercent = 1.6, isNormalized = true, normalizedSpeed = 1.0 },

    -- =====================
    -- MAUL (Bear Form)
    -- Next melee attack deals paw damage + flat bonus
    -- Uses rage
    -- =====================
    [6807] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 18, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [6808] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 27, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [6809] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 37, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [7092] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 49, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [8972] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 71, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [9745] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 101, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [9880] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 128, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [9881] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 147, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },
    [26996] = { name = "Maul", school = "physical", isPhysical = true, flatDamage = 176, weaponDamagePercent = 1.0, isNormalized = true, normalizedSpeed = 2.5 },

    -- Moonfire (all ranks) - DD + 12 sec DoT, 4 ticks (every 3 sec)
    [563] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8921] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8924] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8925] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8926] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8927] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8928] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [8929] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [9833] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [9834] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [9835] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [26987] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },
    [26988] = { name = "Moonfire", coefficient = 0.15, dotCoefficient = 0.52, school = "arcane", castTime = 0.0, isDot = true, ticks = 4 },

    -- Moonkin Form (all ranks)
    [24858] = { name = "Moonkin Form", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Nature's Swiftness (all ranks)
    [17116] = { name = "Nature's Swiftness", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- =====================
    -- RAKE (Cat Form)
    -- Initial hit + bleed DoT
    -- Generates 1 combo point
    -- Initial: flat damage, DoT: 3 ticks over 9 seconds
    -- =====================
    [1822] = { name = "Rake", school = "physical", isPhysical = true, isBleed = true, isDot = true, flatDamage = 19, ticks = 3 },
    [1823] = { name = "Rake", school = "physical", isPhysical = true, isBleed = true, isDot = true, flatDamage = 29, ticks = 3 },
    [1824] = { name = "Rake", school = "physical", isPhysical = true, isBleed = true, isDot = true, flatDamage = 45, ticks = 3 },
    [9904] = { name = "Rake", school = "physical", isPhysical = true, isBleed = true, isDot = true, flatDamage = 64, ticks = 3 },
    [27003] = { name = "Rake", school = "physical", isPhysical = true, isBleed = true, isDot = true, flatDamage = 78, ticks = 3 },

    -- Regrowth (all ranks) - DD heal + 21 sec HoT, 7 ticks (every 3 sec)
    [8936] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [8938] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [8939] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [8940] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [8941] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [9750] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [9856] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [9857] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [9858] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },
    [26980] = { name = "Regrowth", coefficient = 0.286, dotCoefficient = 0.7, school = "nature", castTime = 2.0, isHealing = true, isDot = true, ticks = 7 },

    -- Rejuvenation (all ranks) - 12 sec HoT, 4 ticks (every 3 sec)
    [774] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [1058] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [1430] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [2090] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [2091] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [3627] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [8910] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [9839] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [9840] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [9841] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [25299] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [26981] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },
    [26982] = { name = "Rejuvenation", coefficient = 0.0, dotCoefficient = 0.8, school = "nature", castTime = 0.0, isHealing = true, isDot = true, ticks = 4 },

    -- =====================
    -- RIP is EXCLUDED
    -- Reason: Damage and duration scale with combo points
    -- Too dynamic to calculate accurately
    -- =====================
    -- Keeping entries but not modifying tooltips

    -- =====================
    -- SHRED (Cat Form)
    -- 225% paw damage + flat bonus
    -- Must be behind target
    -- Generates 1 combo point
    -- =====================
    [5221] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 36, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [6800] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 54, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [8992] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 72, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [9829] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 99, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [9830] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 144, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [27001] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 180, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [27002] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 216, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },
    [27555] = { name = "Shred", school = "physical", isPhysical = true, flatDamage = 252, weaponDamagePercent = 2.25, isNormalized = true, normalizedSpeed = 1.0, requiresBehind = true },

    -- Starfire (all ranks)
    [2912] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [8949] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [8950] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [8951] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [9875] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [9876] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [25298] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },
    [26986] = { name = "Starfire", coefficient = 1.0, school = "arcane", castTime = 3.5 },

    -- Swiftmend (all ranks) - Instant heal consuming Rejuv/Regrowth HoT
    -- Heals for remaining HoT amount + ~50% SP coefficient
    [18562] = { name = "Swiftmend", coefficient = 0.5, school = "nature", castTime = 0.0, isHealing = true },

    -- =====================
    -- SWIPE (Bear Form)
    -- AoE melee attack, flat damage + AP scaling (~7% AP)
    -- Hits up to 3 targets
    -- =====================
    [769] = { name = "Swipe", school = "physical", isPhysical = true, flatDamage = 18, apCoefficient = 0.07 },
    [779] = { name = "Swipe", school = "physical", isPhysical = true, flatDamage = 25, apCoefficient = 0.07 },
    [780] = { name = "Swipe", school = "physical", isPhysical = true, flatDamage = 36, apCoefficient = 0.07 },
    [9754] = { name = "Swipe", school = "physical", isPhysical = true, flatDamage = 60, apCoefficient = 0.07 },
    [9908] = { name = "Swipe", school = "physical", isPhysical = true, flatDamage = 83, apCoefficient = 0.07 },
    [26997] = { name = "Swipe", school = "physical", isPhysical = true, flatDamage = 108, apCoefficient = 0.07 },

    -- Tranquility (all ranks) - 8 sec channel, 4 ticks (every 2 sec)
    [740] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isHealing = true, isChanneled = true, ticks = 4 },
    [8918] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isHealing = true, isChanneled = true, ticks = 4 },
    [9862] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isHealing = true, isChanneled = true, ticks = 4 },
    [9863] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isHealing = true, isChanneled = true, ticks = 4 },
    [26983] = { name = "Tranquility", coefficient = 1.14, school = "nature", castTime = 8.0, isHealing = true, isChanneled = true, ticks = 4 },

    -- Wrath (all ranks)
    [5176] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [5177] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [5178] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [5179] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [5180] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [6780] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [8905] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [9912] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [26984] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [26985] = { name = "Wrath", coefficient = 0.571, school = "nature", castTime = 2.0 },

}

-- Register Druid spells with the main addon
SpellTooltips.RegisterSpellData(DruidSpells, "DRUID")
