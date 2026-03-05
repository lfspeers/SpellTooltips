-- SpellTooltips Paladin Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local PaladinSpells = {
    -- Avenger's Shield (all ranks)
    -- Coefficient: ~9.5% (1.0s cast / 3.5 / 3 targets)
    [31935] = { name = "Avenger's Shield", coefficient = 0.095, school = "holy", castTime = 1.0 },
    [32699] = { name = "Avenger's Shield", coefficient = 0.095, school = "holy", castTime = 1.0 },
    [32700] = { name = "Avenger's Shield", coefficient = 0.095, school = "holy", castTime = 1.0 },

    -- Consecration (all ranks) - 8 ticks over 8 seconds, 11.9% SP per tick
    [20116] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true, ticks = 8 },
    [20922] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true, ticks = 8 },
    [20923] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true, ticks = 8 },
    [20924] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true, ticks = 8 },
    [26573] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true, ticks = 8 },
    [27173] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true, ticks = 8 },

    -- Exorcism (all ranks)
    [879] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [5614] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [5615] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [10312] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [10313] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [10314] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [27138] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },
    [33632] = { name = "Exorcism", coefficient = 0.429, school = "holy", castTime = 1.5 },

    -- Flash of Light (all ranks)
    [19750] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [19939] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [19940] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [19941] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [19942] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [19943] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },
    [27137] = { name = "Flash of Light", coefficient = 0.429, school = "holy", castTime = 1.5, isHealing = true },

    -- Hammer of Wrath (all ranks)
    [24239] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [24274] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [24275] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [27180] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [32772] = { name = "Hammer of Wrath", coefficient = 0.429, school = "holy", castTime = 0.0 },

    -- Holy Light (all ranks)
    [635] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [639] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [647] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [1026] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [1042] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [3472] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [10328] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [10329] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [25292] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [27135] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },
    [27136] = { name = "Holy Light", coefficient = 0.714, school = "holy", castTime = 2.5, isHealing = true },

    -- Holy Shield (all ranks)
    [20925] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0.0 },
    [20927] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0.0 },
    [20928] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0.0 },
    [27179] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0.0 },
    [32778] = { name = "Holy Shield", coefficient = 0.05, school = "holy", castTime = 0.0 },

    -- Holy Shock (all ranks)
    [20473] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [20929] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [20930] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [27174] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0.0 },
    [33072] = { name = "Holy Shock", coefficient = 0.429, school = "holy", castTime = 0.0 },

    -- Holy Wrath (all ranks)
    [2812] = { name = "Holy Wrath", coefficient = 0.19, school = "holy", castTime = 2.0 },
    [10318] = { name = "Holy Wrath", coefficient = 0.19, school = "holy", castTime = 2.0 },
    [27139] = { name = "Holy Wrath", coefficient = 0.19, school = "holy", castTime = 2.0 },

    -- Seal of Righteousness (all ranks)
    -- Melee proc: SP * 0.092 * WeaponSpeed (1H) or SP * 0.108 * WeaponSpeed (2H)
    -- Plus weapon damage component: 0.03 * AvgWeaponDmg
    -- Judgement: Base + 73% SP
    [20154] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20287] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20288] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20289] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20290] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20291] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20292] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [20293] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
    [27155] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.108, weaponDmgCoeff = 0, judgementCoef = 0.73 },
}

-- Register Paladin spells with the main addon
SpellTooltips.RegisterSpellData(PaladinSpells, "PALADIN")

-- Physical abilities are handled by the separate PhysicalTooltips addon
