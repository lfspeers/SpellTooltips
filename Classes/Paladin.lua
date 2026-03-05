-- SpellTooltips Paladin Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local T = SpellTooltips.Tags

local PaladinSpells = {
    -- Avenger's Shield (all ranks)
    [31935] = { name = "Avenger's Shield", coefficient = 0.071, school = "holy", castTime = 0.0 },

    -- Avenging Wrath (all ranks)
    [31884] = { name = "Avenging Wrath", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Blessing of Light (all ranks)
    [19977] = { name = "Blessing of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [19978] = { name = "Blessing of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [19979] = { name = "Blessing of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [27144] = { name = "Blessing of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Cleanse (all ranks)
    [4987] = { name = "Cleanse", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Consecration (all ranks)
    [20116] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true },
    [20922] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true },
    [20923] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true },
    [20924] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true },
    [26573] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true },
    [27173] = { name = "Consecration", coefficient = 0.952, school = "holy", castTime = 0.0, isDot = true },

    -- Crusader Strike (all ranks)
    [35395] = { name = "Crusader Strike", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Divine Favor (all ranks)
    [20216] = { name = "Divine Favor", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Divine Illumination (all ranks)
    [31842] = { name = "Divine Illumination", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

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

    -- Greater Blessing of Light (all ranks)
    [25890] = { name = "Greater Blessing of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [27145] = { name = "Greater Blessing of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

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
    [2812] = { name = "Holy Wrath", coefficient = 0.286, school = "holy", castTime = 2.0 },
    [10318] = { name = "Holy Wrath", coefficient = 0.286, school = "holy", castTime = 2.0 },
    [27139] = { name = "Holy Wrath", coefficient = 0.286, school = "holy", castTime = 2.0 },

    -- Judgement (all ranks)
    [20271] = { name = "Judgement", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Lay on Hands (all ranks)
    [633] = { name = "Lay on Hands", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [2800] = { name = "Lay on Hands", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [10310] = { name = "Lay on Hands", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [27154] = { name = "Lay on Hands", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Purify (all ranks)
    [1152] = { name = "Purify", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Retribution Aura (all ranks)
    [7294] = { name = "Retribution Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10298] = { name = "Retribution Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10299] = { name = "Retribution Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10300] = { name = "Retribution Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10301] = { name = "Retribution Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27150] = { name = "Retribution Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Sanctity Aura (all ranks)
    [20218] = { name = "Sanctity Aura", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Seal of Blood (all ranks)
    [31892] = { name = "Seal of Blood", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Seal of Command (all ranks)
    [20375] = { name = "Seal of Command", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20915] = { name = "Seal of Command", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20918] = { name = "Seal of Command", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20919] = { name = "Seal of Command", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20920] = { name = "Seal of Command", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27170] = { name = "Seal of Command", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Seal of Light (all ranks)
    [20165] = { name = "Seal of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [20347] = { name = "Seal of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [20348] = { name = "Seal of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [20349] = { name = "Seal of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [27160] = { name = "Seal of Light", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Seal of Righteousness (all ranks)
    -- Melee proc: SP × weapon speed × baseCoeff (9.2% for 1H, 6.6% for 2H)
    -- Judgement: Base + 25% SP
    [20154] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20287] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20288] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20289] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20290] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20291] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20292] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [20293] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },
    [27155] = { name = "Seal of Righteousness", school = "holy", isSeal = true, baseCoeff1H = 0.092, baseCoeff2H = 0.066, judgementCoef = 0.25 },

    -- Seal of Vengeance (all ranks)
    [31801] = { name = "Seal of Vengeance", coefficient = 0.0, school = "holy", castTime = 0.0 },

    -- Seal of Wisdom (all ranks)
    [20166] = { name = "Seal of Wisdom", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20356] = { name = "Seal of Wisdom", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20357] = { name = "Seal of Wisdom", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27166] = { name = "Seal of Wisdom", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Seal of the Crusader (all ranks)
    [20162] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20305] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20306] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20307] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [20308] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [21082] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27158] = { name = "Seal of the Crusader", coefficient = 0.0, school = "unknown", castTime = 0.0 },

}

-- Register Paladin spells with the main addon
SpellTooltips.RegisterSpellData(PaladinSpells, "PALADIN")

-- ===================
-- PALADIN PHYSICAL ABILITIES (v2.1.0)
-- Weapon-based damage abilities that don't scale with spell power
-- ===================

local PaladinPhysical = {
    -- ===================
    -- CRUSADER STRIKE
    -- ===================
    -- 110% normalized weapon damage as Holy damage
    -- 6 second cooldown, refreshes all Judgements on target
    [35395] = {
        name = "Crusader Strike",
        weaponPct = 1.1,
        school = "holy",
        normalized = true,  -- Auto-detect: 3.3 for 2H, 2.4 for 1H
    },

    -- ===================
    -- SEAL OF COMMAND
    -- ===================
    -- Melee Proc: 70% weapon damage as Holy (7 PPM)
    -- Judgement: 70% weapon damage + 29% SP (doubled if stunned)
    [20375] = {
        name = "Seal of Command",
        weaponPct = 0.70,
        school = "holy",
        isSeal = true,
        judgement = { weaponPct = 0.70, spCoef = 0.29, bonusIfStunned = 1.0 },
    },
    [20915] = {
        name = "Seal of Command",
        weaponPct = 0.70,
        school = "holy",
        isSeal = true,
        judgement = { weaponPct = 0.70, spCoef = 0.29, bonusIfStunned = 1.0 },
    },
    [20918] = {
        name = "Seal of Command",
        weaponPct = 0.70,
        school = "holy",
        isSeal = true,
        judgement = { weaponPct = 0.70, spCoef = 0.29, bonusIfStunned = 1.0 },
    },
    [20919] = {
        name = "Seal of Command",
        weaponPct = 0.70,
        school = "holy",
        isSeal = true,
        judgement = { weaponPct = 0.70, spCoef = 0.29, bonusIfStunned = 1.0 },
    },
    [20920] = {
        name = "Seal of Command",
        weaponPct = 0.70,
        school = "holy",
        isSeal = true,
        judgement = { weaponPct = 0.70, spCoef = 0.29, bonusIfStunned = 1.0 },
    },
    [27170] = {
        name = "Seal of Command",
        weaponPct = 0.70,
        school = "holy",
        isSeal = true,
        judgement = { weaponPct = 0.70, spCoef = 0.29, bonusIfStunned = 1.0 },
    },

    -- ===================
    -- SEAL OF BLOOD (Horde) / SEAL OF THE MARTYR (Alliance)
    -- ===================
    -- Melee Proc: 35% weapon damage as Holy per hit
    -- Judgement: 33% weapon damage + 22% SP
    -- Self damage: 10% of damage dealt
    [31892] = {
        name = "Seal of Blood",
        weaponPct = 0.35,
        school = "holy",
        isSeal = true,
        selfDamage = 0.10,
        judgement = { weaponPct = 0.33, spCoef = 0.22, selfDamage = 0.33 },
    },
    [348704] = {
        name = "Seal of the Martyr",
        weaponPct = 0.35,
        school = "holy",
        isSeal = true,
        selfDamage = 0.10,
        judgement = { weaponPct = 0.33, spCoef = 0.22, selfDamage = 0.33 },
    },
}

-- Register Paladin physical abilities
SpellTooltips.RegisterPhysicalData(PaladinPhysical, "PALADIN")
