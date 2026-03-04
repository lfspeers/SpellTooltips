-- SpellTooltips Talent Data
-- Talent definitions and lookup functions for coefficient/damage modifiers

SpellTooltips = SpellTooltips or {}
SpellTooltips.Talents = {}

-- Cache for talent ranks (refreshed on talent changes)
local talentCache = {}
local cacheValid = false

-- Talent definitions
-- type: "coefficient" modifies spell power coefficient, "multiplier" modifies final damage
SpellTooltips.TalentInfo = {
    -- Coefficient modifiers (additive to base coefficient)
    EMPOWERED_FIREBALL = {
        tab = 2,
        index = 21,
        maxRanks = 5,
        perRank = 0.03,
        affects = { "Fireball" },
        type = "coefficient",
        name = "Empowered Fireball",
        class = "MAGE",
    },
    EMPOWERED_FROSTBOLT = {
        tab = 3,
        index = 21,
        maxRanks = 5,
        perRank = 0.02,
        affects = { "Frostbolt" },
        type = "coefficient",
        name = "Empowered Frostbolt",
        class = "MAGE",
    },
    EMPOWERED_ARCANE_MISSILES = {
        tab = 1,
        index = 20,
        maxRanks = 3,
        perRank = 0.15,
        affects = { "Arcane Missiles" },
        type = "coefficient",
        name = "Empowered Arcane Missiles",
        class = "MAGE",
    },

    -- Damage multipliers (additive within same school)
    FIRE_POWER = {
        tab = 2,
        index = 13,
        maxRanks = 5,
        perRank = 0.02,
        school = "fire",
        type = "multiplier",
        name = "Fire Power",
        class = "MAGE",
    },
    PLAYING_WITH_FIRE = {
        tab = 2,
        index = 17,
        maxRanks = 3,
        perRank = 0.01,
        school = "fire",
        type = "multiplier",
        name = "Playing with Fire",
        class = "MAGE",
    },
    PIERCING_ICE = {
        tab = 3,
        index = 8,
        maxRanks = 3,
        perRank = 0.02,
        school = "frost",
        type = "multiplier",
        name = "Piercing Ice",
        class = "MAGE",
    },
    ARCTIC_WINDS = {
        tab = 3,
        index = 20,
        maxRanks = 5,
        perRank = 0.01,
        school = "frost",
        type = "multiplier",
        name = "Arctic Winds",
        class = "MAGE",
    },

    -- Conditional multipliers (shown as notes, not applied to base calculation)
    MOLTEN_FURY = {
        tab = 2,
        index = 19,
        maxRanks = 2,
        perRank = 0.10,
        school = "fire",
        type = "conditional",
        condition = "target below 20% HP",
        name = "Molten Fury",
        class = "MAGE",
    },

    -- Note: Arcane Instability and Mind Mastery increase the spell damage STAT,
    -- which is already reflected in GetSpellBonusDamage(). Not damage multipliers.

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Arcane Impact: +2% crit to Arcane Blast, Arcane Explosion
    ARCANE_IMPACT = {
        tab = 1, index = 6, maxRanks = 3,
        perRank = 0.02,
        affects = { "Arcane Blast", "Arcane Explosion" },
        type = "crit",
        name = "Arcane Impact",
        class = "MAGE",
    },

    -- Arcane Instability: +1% crit to ALL spells (damage bonus already in GetSpellBonusDamage)
    ARCANE_INSTABILITY = {
        tab = 1, index = 19, maxRanks = 3,
        perRank = 0.01,
        type = "crit",
        name = "Arcane Instability",
        class = "MAGE",
    },

    -- Incineration: +2% crit to Fire Blast, Scorch
    INCINERATION = {
        tab = 2, index = 1, maxRanks = 2,
        perRank = 0.02,
        affects = { "Fire Blast", "Scorch" },
        type = "crit",
        name = "Incineration",
        class = "MAGE",
    },

    -- Critical Mass: +2% crit to ALL fire spells
    CRITICAL_MASS = {
        tab = 2, index = 15, maxRanks = 3,
        perRank = 0.02,
        school = "fire",
        type = "crit",
        name = "Critical Mass",
        class = "MAGE",
    },

    -- Improved Frostbolt: +1% crit to Frostbolt (in addition to cast time reduction)
    IMPROVED_FROSTBOLT = {
        tab = 3, index = 1, maxRanks = 5,
        perRank = 0.01,
        affects = { "Frostbolt" },
        type = "crit",
        name = "Improved Frostbolt",
        class = "MAGE",
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Spell Power: +25% crit damage bonus to ALL spells
    SPELL_POWER = {
        tab = 1, index = 22, maxRanks = 2,
        perRank = 0.25,
        type = "critdamage",
        name = "Spell Power",
        class = "MAGE",
    },

    -- Ice Shards: +20% crit damage to frost spells
    ICE_SHARDS = {
        tab = 3, index = 15, maxRanks = 5,
        perRank = 0.20,
        school = "frost",
        type = "critdamage",
        class = "MAGE",
        name = "Ice Shards",
    },

    -- =====================
    -- PALADIN TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Holy, Tab 2 = Protection, Tab 3 = Retribution
    -- Note: Talent indices need verification in-game with /stt scan

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Holy Power: +1% crit to ALL spells (Holy tree)
    HOLY_POWER = {
        tab = 1, index = 13, maxRanks = 5,
        perRank = 0.01,
        type = "crit",
        name = "Holy Power",
        class = "PALADIN",
    },

    -- Sanctified Light: +2% crit to Holy Light (Holy tree)
    SANCTIFIED_LIGHT = {
        tab = 1, index = 11, maxRanks = 3,
        perRank = 0.02,
        affects = { "Holy Light" },
        type = "crit",
        name = "Sanctified Light",
        class = "PALADIN",
    },

    -- Conviction: +1% crit to ALL spells and melee (Retribution tree)
    CONVICTION = {
        tab = 3, index = 8, maxRanks = 5,
        perRank = 0.01,
        type = "crit",
        name = "Conviction",
        class = "PALADIN",
    },

    -- Fanaticism: +3% crit to Judgement spells (Retribution tree)
    FANATICISM = {
        tab = 3, index = 20, maxRanks = 5,
        perRank = 0.03,
        affects = { "Judgement of Righteousness", "Judgement of Command", "Judgement of Blood", "Judgement of the Martyr" },
        type = "crit",
        name = "Fanaticism",
        class = "PALADIN",
    },

    -- ===================
    -- DAMAGE/HEALING MULTIPLIERS
    -- ===================

    -- Sanctity Aura: +10% Holy damage (flat, not per-rank) (Retribution tree)
    -- Note: This is an aura that must be active, treated as talent for calculation
    SANCTITY_AURA = {
        tab = 3, index = 6, maxRanks = 1,
        perRank = 0.10,
        school = "holy",
        type = "multiplier",
        name = "Sanctity Aura",
        class = "PALADIN",
    },

    -- Healing Light: +4% healing to Holy Light and Flash of Light (Holy tree)
    HEALING_LIGHT = {
        tab = 1, index = 5, maxRanks = 3,
        perRank = 0.04,
        affects = { "Holy Light", "Flash of Light" },
        type = "multiplier",
        name = "Healing Light",
        class = "PALADIN",
    },

    -- Improved Holy Shield: +10% Holy Shield damage per rank (Protection tree)
    IMPROVED_HOLY_SHIELD = {
        tab = 2, index = 22, maxRanks = 2,
        perRank = 0.10,
        affects = { "Holy Shield" },
        type = "multiplier",
        name = "Improved Holy Shield",
        class = "PALADIN",
    },

    -- Improved Seal of Righteousness: +3% damage per rank (Holy tree)
    -- Affects both the Seal and the Judgement
    IMPROVED_SEAL_OF_RIGHTEOUSNESS = {
        tab = 1, index = 10, maxRanks = 5,
        perRank = 0.03,
        affects = { "Seal of Righteousness", "Judgement of Righteousness" },
        type = "multiplier",
        name = "Improved Seal of Righteousness",
        class = "PALADIN",
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Vengeance: +1% damage per rank after crit, stacks 3x (5 ranks = 15% at 3 stacks) (Retribution tree)
    VENGEANCE = {
        tab = 3, index = 2, maxRanks = 5,
        perRank = 0.01, -- per rank per stack
        maxStacks = 3,
        school = "holy",
        type = "conditional",
        condition = "after critical strike (stacks 3x)",
        name = "Vengeance",
        class = "PALADIN",
    },

    -- Crusade: +3% damage vs Humanoids, Demons, Undead, Elementals (Retribution tree)
    CRUSADE = {
        tab = 3, index = 16, maxRanks = 3,
        perRank = 0.03,
        type = "conditional",
        condition = "vs Humanoids, Demons, Undead, Elementals",
        name = "Crusade",
        class = "PALADIN",
    },

    -- =====================
    -- WARLOCK TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Affliction, Tab 2 = Demonology, Tab 3 = Destruction

    -- ===================
    -- COEFFICIENT MODIFIERS
    -- ===================

    -- Empowered Corruption: +12% coefficient per rank to Corruption
    EMPOWERED_CORRUPTION = {
        tab = 1, index = 14, maxRanks = 3,
        perRank = 0.12,
        affects = { "Corruption" },
        type = "coefficient",
        name = "Empowered Corruption",
        class = "WARLOCK",
    },

    -- Shadow and Flame: +4% coefficient per rank to Shadow Bolt and Incinerate
    SHADOW_AND_FLAME = {
        tab = 3, index = 20, maxRanks = 5,
        perRank = 0.04,
        affects = { "Shadow Bolt", "Incinerate" },
        type = "coefficient",
        name = "Shadow and Flame",
        class = "WARLOCK",
    },

    -- ===================
    -- DAMAGE MULTIPLIERS
    -- ===================

    -- Shadow Mastery: +2% shadow damage per rank
    SHADOW_MASTERY = {
        tab = 1, index = 21, maxRanks = 5,
        perRank = 0.02,
        school = "shadow",
        type = "multiplier",
        name = "Shadow Mastery",
        class = "WARLOCK",
    },

    -- Contagion: +1% damage to Corruption, Curse of Agony, Seed of Corruption
    CONTAGION = {
        tab = 1, index = 20, maxRanks = 5,
        perRank = 0.01,
        affects = { "Corruption", "Curse of Agony", "Seed of Corruption" },
        type = "multiplier",
        name = "Contagion",
        class = "WARLOCK",
    },

    -- Emberstorm: +2% fire damage per rank
    EMBERSTORM = {
        tab = 3, index = 9, maxRanks = 5,
        perRank = 0.02,
        school = "fire",
        type = "multiplier",
        name = "Emberstorm",
        class = "WARLOCK",
    },

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Devastation: +1% crit to Destruction spells per rank
    DEVASTATION = {
        tab = 3, index = 7, maxRanks = 5,
        perRank = 0.01,
        affects = { "Shadow Bolt", "Incinerate", "Searing Pain", "Soul Fire", "Shadowburn",
                    "Conflagrate", "Shadowfury", "Immolate", "Rain of Fire", "Hellfire" },
        type = "crit",
        name = "Devastation",
        class = "WARLOCK",
    },

    -- Backlash: +1% crit to all spells per rank
    BACKLASH = {
        tab = 3, index = 12, maxRanks = 3,
        perRank = 0.01,
        type = "crit",
        name = "Backlash",
        class = "WARLOCK",
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Ruin: +100% crit damage to Destruction spells
    RUIN = {
        tab = 3, index = 13, maxRanks = 1,
        perRank = 1.00,
        affects = { "Shadow Bolt", "Incinerate", "Searing Pain", "Soul Fire", "Shadowburn",
                    "Conflagrate", "Shadowfury", "Immolate", "Rain of Fire", "Hellfire" },
        type = "critdamage",
        name = "Ruin",
        class = "WARLOCK",
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Improved Shadow Bolt: +4% shadow damage taken after SB crit (ISB debuff)
    IMPROVED_SHADOW_BOLT = {
        tab = 3, index = 1, maxRanks = 5,
        perRank = 0.04,
        school = "shadow",
        type = "conditional",
        condition = "after Shadow Bolt crit (ISB debuff, 4 charges)",
        name = "Improved Shadow Bolt",
        class = "WARLOCK",
    },

    -- Malediction: +1% spell damage taken by target with Curse of Shadows/Elements
    MALEDICTION = {
        tab = 1, index = 24, maxRanks = 3,
        perRank = 0.01,
        type = "conditional",
        condition = "target has Curse of Shadows/Elements",
        name = "Malediction",
        class = "WARLOCK",
    },

    -- Soul Siphon: +2% Drain Life/Soul damage per affliction on target
    SOUL_SIPHON = {
        tab = 1, index = 6, maxRanks = 2,
        perRank = 0.02,
        affects = { "Drain Life", "Drain Soul" },
        type = "conditional",
        condition = "per affliction on target (max +16%)",
        name = "Soul Siphon",
        class = "WARLOCK",
    },

    -- Demonic Sacrifice (Shadow): +15% shadow damage when Succubus sacrificed
    DEMONIC_SACRIFICE_SHADOW = {
        tab = 2, index = 18, maxRanks = 1,
        perRank = 0.15,
        school = "shadow",
        type = "conditional",
        condition = "Succubus sacrificed",
        name = "Demonic Sacrifice (Shadow)",
        class = "WARLOCK",
    },

    -- Demonic Sacrifice (Fire): +15% fire damage when Imp sacrificed
    DEMONIC_SACRIFICE_FIRE = {
        tab = 2, index = 18, maxRanks = 1,
        perRank = 0.15,
        school = "fire",
        type = "conditional",
        condition = "Imp sacrificed",
        name = "Demonic Sacrifice (Fire)",
        class = "WARLOCK",
    },

    -- =====================
    -- PRIEST TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Discipline, Tab 2 = Holy, Tab 3 = Shadow

    -- ===================
    -- COEFFICIENT MODIFIERS
    -- ===================

    -- Empowered Healing: +4% coefficient to Greater Heal, Flash Heal, Binding Heal
    EMPOWERED_HEALING = {
        tab = 2, index = 15, maxRanks = 5,
        perRank = 0.04,
        affects = { "Greater Heal", "Flash Heal", "Binding Heal" },
        type = "coefficient",
        name = "Empowered Healing",
        class = "PRIEST",
    },

    -- Empowered Renew: +3% coefficient to Renew per rank (affects HoT portion)
    EMPOWERED_RENEW = {
        tab = 2, index = 20, maxRanks = 5,
        perRank = 0.03,
        affects = { "Renew" },
        type = "coefficient",
        name = "Empowered Renew",
        class = "PRIEST",
    },

    -- ===================
    -- DAMAGE/HEALING MULTIPLIERS
    -- ===================

    -- Darkness: +2% shadow damage per rank
    DARKNESS = {
        tab = 3, index = 3, maxRanks = 5,
        perRank = 0.02,
        school = "shadow",
        type = "multiplier",
        name = "Darkness",
        class = "PRIEST",
    },

    -- Shadowform: +15% shadow damage (1 rank talent)
    SHADOWFORM = {
        tab = 3, index = 21, maxRanks = 1,
        perRank = 0.15,
        school = "shadow",
        type = "multiplier",
        name = "Shadowform",
        class = "PRIEST",
    },

    -- Searing Light: +5% damage to Smite, Holy Fire
    SEARING_LIGHT = {
        tab = 2, index = 6, maxRanks = 2,
        perRank = 0.05,
        affects = { "Smite", "Holy Fire" },
        type = "multiplier",
        name = "Searing Light",
        class = "PRIEST",
    },

    -- Focused Power: +2% damage to Smite, Mind Blast, Mass Dispel
    FOCUSED_POWER = {
        tab = 1, index = 16, maxRanks = 2,
        perRank = 0.02,
        affects = { "Smite", "Mind Blast" },
        type = "multiplier",
        name = "Focused Power",
        class = "PRIEST",
    },

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Holy Specialization: +1% crit to Holy spells per rank
    HOLY_SPECIALIZATION = {
        tab = 2, index = 3, maxRanks = 5,
        perRank = 0.01,
        school = "holy",
        type = "crit",
        name = "Holy Specialization",
        class = "PRIEST",
    },

    -- Mind Melt: +2% crit to Mind Blast, Mind Flay
    MIND_MELT = {
        tab = 3, index = 18, maxRanks = 2,
        perRank = 0.02,
        affects = { "Mind Blast", "Mind Flay" },
        type = "crit",
        name = "Mind Melt",
        class = "PRIEST",
    },

    -- Focused Will: +1% crit to all spells per rank
    FOCUSED_WILL = {
        tab = 1, index = 20, maxRanks = 3,
        perRank = 0.01,
        type = "crit",
        name = "Focused Will",
        class = "PRIEST",
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Shadow Weaving: +2% shadow damage taken (stacking debuff, max 5 stacks)
    SHADOW_WEAVING = {
        tab = 3, index = 13, maxRanks = 5,
        perRank = 0.02,
        school = "shadow",
        type = "conditional",
        condition = "stacking debuff on target (max 5 stacks = 10%)",
        name = "Shadow Weaving",
        class = "PRIEST",
    },

    -- Misery: +1% spell damage taken by target (debuff)
    MISERY = {
        tab = 3, index = 20, maxRanks = 5,
        perRank = 0.01,
        type = "conditional",
        condition = "target has SW:P, Mind Flay, or VT (all spell damage)",
        name = "Misery",
        class = "PRIEST",
    },

    -- Pain and Suffering: +2% SW:D damage when SW:P is active
    PAIN_AND_SUFFERING = {
        tab = 3, index = 14, maxRanks = 3,
        perRank = 0.02,
        affects = { "Shadow Word: Death" },
        type = "conditional",
        condition = "Shadow Word: Pain active on target",
        name = "Pain and Suffering",
        class = "PRIEST",
    },

    -- =====================
    -- DRUID TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Balance, Tab 2 = Feral, Tab 3 = Restoration

    -- ===================
    -- COEFFICIENT MODIFIERS
    -- ===================

    -- Wrath of Cenarius: +4% coefficient to Starfire per rank
    WRATH_OF_CENARIUS_STARFIRE = {
        tab = 1, index = 22, maxRanks = 5,
        perRank = 0.04,
        affects = { "Starfire" },
        type = "coefficient",
        name = "Wrath of Cenarius",
        class = "DRUID",
    },

    -- Wrath of Cenarius: +2% coefficient to Wrath per rank
    WRATH_OF_CENARIUS_WRATH = {
        tab = 1, index = 22, maxRanks = 5,
        perRank = 0.02,
        affects = { "Wrath" },
        type = "coefficient",
        name = "Wrath of Cenarius",
        class = "DRUID",
    },

    -- Empowered Touch: +10% coefficient to Healing Touch per rank
    EMPOWERED_TOUCH = {
        tab = 3, index = 18, maxRanks = 2,
        perRank = 0.10,
        affects = { "Healing Touch" },
        type = "coefficient",
        name = "Empowered Touch",
        class = "DRUID",
    },

    -- Empowered Rejuvenation: +4% coefficient to all HoTs per rank
    EMPOWERED_REJUVENATION = {
        tab = 3, index = 21, maxRanks = 5,
        perRank = 0.04,
        affects = { "Rejuvenation", "Regrowth", "Lifebloom", "Tranquility" },
        type = "coefficient",
        name = "Empowered Rejuvenation",
        class = "DRUID",
    },

    -- ===================
    -- DAMAGE/HEALING MULTIPLIERS
    -- ===================

    -- Moonfury: +2% damage to Starfire, Moonfire, Wrath per rank
    MOONFURY = {
        tab = 1, index = 21, maxRanks = 5,
        perRank = 0.02,
        affects = { "Starfire", "Moonfire", "Wrath" },
        type = "multiplier",
        name = "Moonfury",
        class = "DRUID",
    },

    -- Gift of Nature: +2% healing to all healing spells per rank
    GIFT_OF_NATURE = {
        tab = 3, index = 12, maxRanks = 5,
        perRank = 0.02,
        type = "multiplier",
        isHealing = true,
        name = "Gift of Nature",
        class = "DRUID",
    },

    -- Improved Rejuvenation: +5% healing to Rejuvenation per rank
    IMPROVED_REJUVENATION = {
        tab = 3, index = 10, maxRanks = 3,
        perRank = 0.05,
        affects = { "Rejuvenation" },
        type = "multiplier",
        name = "Improved Rejuvenation",
        class = "DRUID",
    },

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Focused Starlight: +2% crit to Starfire, Wrath per rank
    FOCUSED_STARLIGHT = {
        tab = 1, index = 2, maxRanks = 2,
        perRank = 0.02,
        affects = { "Starfire", "Wrath" },
        type = "crit",
        name = "Focused Starlight",
        class = "DRUID",
    },

    -- Improved Moonfire: +5% crit to Moonfire per rank
    IMPROVED_MOONFIRE = {
        tab = 1, index = 3, maxRanks = 2,
        perRank = 0.05,
        affects = { "Moonfire" },
        type = "crit",
        name = "Improved Moonfire",
        class = "DRUID",
    },

    -- Natural Perfection: +1% crit to all spells per rank
    NATURAL_PERFECTION = {
        tab = 3, index = 19, maxRanks = 3,
        perRank = 0.01,
        type = "crit",
        name = "Natural Perfection",
        class = "DRUID",
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Vengeance (Druid): +20% crit damage to Balance spells per rank
    VENGEANCE_DRUID = {
        tab = 1, index = 17, maxRanks = 5,
        perRank = 0.20,
        affects = { "Starfire", "Moonfire", "Wrath" },
        type = "critdamage",
        name = "Vengeance",
        class = "DRUID",
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Nature's Grace: Next cast -0.5s after crit (not a damage modifier, shown as note)
    NATURES_GRACE = {
        tab = 1, index = 11, maxRanks = 1,
        perRank = 0.5,
        type = "conditional",
        condition = "next spell cast time reduced by 0.5s after crit",
        name = "Nature's Grace",
        class = "DRUID",
    },

    -- =====================
    -- SHAMAN TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Elemental, Tab 2 = Enhancement, Tab 3 = Restoration

    -- ===================
    -- DAMAGE/HEALING MULTIPLIERS
    -- ===================

    -- Concussion: +1% damage to Lightning Bolt, Chain Lightning, Shocks per rank
    CONCUSSION = {
        tab = 1, index = 2, maxRanks = 5,
        perRank = 0.01,
        affects = { "Lightning Bolt", "Chain Lightning", "Earth Shock", "Flame Shock", "Frost Shock" },
        type = "multiplier",
        name = "Concussion",
        class = "SHAMAN",
    },

    -- Purification: +2% healing to all healing spells per rank
    PURIFICATION = {
        tab = 3, index = 14, maxRanks = 5,
        perRank = 0.02,
        type = "multiplier",
        isHealing = true,
        name = "Purification",
        class = "SHAMAN",
    },

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Call of Thunder: +1% crit to Lightning Bolt, Chain Lightning per rank
    CALL_OF_THUNDER = {
        tab = 1, index = 8, maxRanks = 5,
        perRank = 0.01,
        affects = { "Lightning Bolt", "Chain Lightning" },
        type = "crit",
        name = "Call of Thunder",
        class = "SHAMAN",
    },

    -- Tidal Mastery: +1% crit to all healing and lightning spells per rank
    TIDAL_MASTERY = {
        tab = 3, index = 11, maxRanks = 5,
        perRank = 0.01,
        type = "crit",
        name = "Tidal Mastery",
        class = "SHAMAN",
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Elemental Fury: +100% crit damage to elemental spells (1 rank)
    ELEMENTAL_FURY = {
        tab = 1, index = 13, maxRanks = 1,
        perRank = 1.00,
        affects = { "Lightning Bolt", "Chain Lightning", "Earth Shock", "Flame Shock", "Frost Shock",
                    "Fire Nova Totem", "Searing Totem", "Magma Totem" },
        type = "critdamage",
        name = "Elemental Fury",
        class = "SHAMAN",
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Elemental Mastery: Next spell guaranteed crit (talent ability)
    ELEMENTAL_MASTERY_TALENT = {
        tab = 1, index = 16, maxRanks = 1,
        perRank = 1.00,
        type = "conditional",
        condition = "next spell guaranteed critical strike",
        name = "Elemental Mastery",
        class = "SHAMAN",
    },

    -- Lightning Overload: Chance for extra LB/CL at 50% damage
    LIGHTNING_OVERLOAD = {
        tab = 1, index = 20, maxRanks = 5,
        perRank = 0.04,
        affects = { "Lightning Bolt", "Chain Lightning" },
        type = "conditional",
        condition = "chance to proc additional cast at 50% damage",
        name = "Lightning Overload",
        class = "SHAMAN",
    },

    -- Healing Way: +6% Healing Wave per stack (max 3 stacks)
    HEALING_WAY = {
        tab = 3, index = 13, maxRanks = 3,
        perRank = 0.06,
        affects = { "Healing Wave" },
        type = "conditional",
        condition = "stacking buff on target (max 3 stacks = 18%)",
        name = "Healing Way",
        class = "SHAMAN",
    },

    -- Totem of Wrath: +3% crit to party (totem)
    TOTEM_OF_WRATH = {
        tab = 1, index = 21, maxRanks = 1,
        perRank = 0.03,
        type = "conditional",
        condition = "Totem of Wrath active (party aura)",
        name = "Totem of Wrath",
        class = "SHAMAN",
    },

}

-- Get the number of points in a specific talent
function SpellTooltips.Talents.GetTalentRanks(tab, index)
    local cacheKey = tab .. "_" .. index
    if cacheValid and talentCache[cacheKey] then
        return talentCache[cacheKey]
    end

    local name, iconTexture, tier, column, rank, maxRank, isExceptional, available = GetTalentInfo(tab, index)
    local ranks = rank or 0

    talentCache[cacheKey] = ranks
    return ranks
end

-- Get talent ranks by talent key (e.g., "EMPOWERED_FIREBALL")
function SpellTooltips.Talents.GetTalentRanksByKey(talentKey)
    local talentInfo = SpellTooltips.TalentInfo[talentKey]
    if not talentInfo then return 0 end

    -- Check if talent is for a specific class
    if talentInfo.class then
        local _, playerClass = UnitClass("player")
        if talentInfo.class ~= playerClass then
            return 0  -- Talent is for a different class
        end
    end

    return SpellTooltips.Talents.GetTalentRanks(talentInfo.tab, talentInfo.index)
end

-- Get coefficient bonus for a specific spell name
function SpellTooltips.Talents.GetCoefficientBonus(spellName)
    local totalBonus = 0

    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        if talentInfo.type == "coefficient" and talentInfo.affects then
            for _, affectedSpell in ipairs(talentInfo.affects) do
                if affectedSpell == spellName then
                    local ranks = SpellTooltips.Talents.GetTalentRanksByKey(key)
                    totalBonus = totalBonus + (ranks * talentInfo.perRank)
                    break
                end
            end
        end
    end

    return totalBonus
end

-- Get damage multiplier for a specific school
-- Returns multiplier (e.g., 1.13 for 13% bonus) and list of contributing talents
function SpellTooltips.Talents.GetSchoolMultiplier(school)
    if not school then return 1.0, {} end

    local totalBonus = 0
    local contributingTalents = {}
    school = string.lower(school)

    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        if talentInfo.type == "multiplier" and talentInfo.school == school then
            local ranks = SpellTooltips.Talents.GetTalentRanksByKey(key)
            if ranks > 0 then
                local bonus = ranks * talentInfo.perRank
                totalBonus = totalBonus + bonus
                table.insert(contributingTalents, {
                    name = talentInfo.name,
                    bonus = bonus,
                    ranks = ranks,
                    maxRanks = talentInfo.maxRanks,
                })
            end
        end
    end

    return 1 + totalBonus, contributingTalents
end

-- Get spell-specific damage multiplier (for talents with "affects" list)
-- Returns multiplier (e.g., 1.15 for 15% bonus) and list of contributing talents
function SpellTooltips.Talents.GetSpellMultiplier(spellName)
    if not spellName then return 1.0, {} end

    local totalBonus = 0
    local contributingTalents = {}

    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        if talentInfo.type == "multiplier" and talentInfo.affects then
            -- Check if this talent affects the given spell
            for _, affectedSpell in ipairs(talentInfo.affects) do
                if affectedSpell == spellName then
                    local ranks = SpellTooltips.Talents.GetTalentRanksByKey(key)
                    if ranks > 0 then
                        local bonus = ranks * talentInfo.perRank
                        totalBonus = totalBonus + bonus
                        table.insert(contributingTalents, {
                            name = talentInfo.name,
                            bonus = bonus,
                            ranks = ranks,
                            maxRanks = talentInfo.maxRanks,
                        })
                    end
                    break
                end
            end
        end
    end

    return 1 + totalBonus, contributingTalents
end

-- Get modified coefficient for a spell (base + talent bonus)
-- Returns modified coefficient and the bonus amount
function SpellTooltips.Talents.GetModifiedCoefficient(spellData)
    if not spellData then return 0, 0 end

    local baseCoeff = spellData.coefficient or 0
    local bonus = SpellTooltips.Talents.GetCoefficientBonus(spellData.name)

    return baseCoeff + bonus, bonus
end

-- Invalidate the talent cache (call on talent changes)
function SpellTooltips.Talents.InvalidateCache()
    talentCache = {}
    cacheValid = false
end

-- Validate/refresh the cache
function SpellTooltips.Talents.RefreshCache()
    talentCache = {}
    cacheValid = true

    -- Pre-populate cache for all tracked talents
    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        SpellTooltips.Talents.GetTalentRanks(talentInfo.tab, talentInfo.index)
    end
end

-- Calculate full spell damage with talents
-- Returns: finalMin, finalMax, bonusDamage, modifiedCoeff, coeffBonus, multiplier, talents, critChance, critMultiplier, expectedDamage
function SpellTooltips.Talents.CalculateSpellDamage(baseDamageMin, baseDamageMax, spellPower, spellData)
    if not spellData then
        return baseDamageMin, baseDamageMax, 0, 0, 0, 1.0, {}, 0, 1.5, baseDamageMin
    end

    -- Get modified coefficient
    local modifiedCoeff, coeffBonus = SpellTooltips.Talents.GetModifiedCoefficient(spellData)

    -- Calculate bonus damage from spell power
    local bonusDamage = spellPower * modifiedCoeff

    -- Get school multiplier and spell-specific multiplier
    local schoolMultiplier, schoolTalents = SpellTooltips.Talents.GetSchoolMultiplier(spellData.school)
    local spellMultiplier, spellTalents = SpellTooltips.Talents.GetSpellMultiplier(spellData.name)

    -- Combine multipliers
    local multiplier = schoolMultiplier * spellMultiplier
    local talents = {}
    for _, t in ipairs(schoolTalents) do table.insert(talents, t) end
    for _, t in ipairs(spellTalents) do table.insert(talents, t) end

    -- Calculate final damage
    local finalMin = (baseDamageMin + bonusDamage) * multiplier
    local finalMax = (baseDamageMax + bonusDamage) * multiplier

    -- Crit calculations
    local baseCritChance = SpellTooltips.Utils.GetPlayerSpellCritChance(spellData.school)
    local critBonus = SpellTooltips.Talents.GetCritChanceBonus(spellData.name, spellData.school)
    local totalCritChance = baseCritChance + critBonus

    local critMultiplier = SpellTooltips.Talents.GetCritDamageMultiplier(spellData.school)

    -- Expected damage: avgDamage * (1 + critChance * (critMultiplier - 1))
    local avgDamage = (finalMin + finalMax) / 2
    local expectedDamage = avgDamage * (1 + (totalCritChance / 100) * (critMultiplier - 1))

    return math.floor(finalMin), math.floor(finalMax), math.floor(bonusDamage), modifiedCoeff, coeffBonus, multiplier, talents, totalCritChance, critMultiplier, math.floor(expectedDamage)
end

-- Get conditional talent bonuses for a school (like Molten Fury)
-- Returns list of conditional talents with their bonuses
function SpellTooltips.Talents.GetConditionalTalents(school, spellName)
    local conditionals = {}
    local schoolLower = school and string.lower(school) or nil

    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        if talentInfo.type == "conditional" then
            local ranks = SpellTooltips.Talents.GetTalentRanksByKey(key)
            if ranks > 0 then
                -- Check if talent applies to this school or spell
                local applies = false

                -- School-based conditional (e.g., Molten Fury, Shatter)
                if talentInfo.school and schoolLower and talentInfo.school == schoolLower then
                    applies = true
                -- Spell-specific conditional
                elseif talentInfo.affects and spellName then
                    for _, affectedSpell in ipairs(talentInfo.affects) do
                        if affectedSpell == spellName then
                            applies = true
                            break
                        end
                    end
                -- Global conditional (no school/spell restriction, like Arcane Potency)
                elseif not talentInfo.school and not talentInfo.affects then
                    applies = true
                end

                if applies then
                    local bonus = ranks * talentInfo.perRank
                    table.insert(conditionals, {
                        name = talentInfo.name,
                        bonus = bonus,
                        condition = talentInfo.condition,
                        ranks = ranks,
                        maxRanks = talentInfo.maxRanks,
                    })
                end
            end
        end
    end

    return conditionals
end

-- Get crit chance bonus from talents for a specific spell/school
-- Returns total crit bonus as a percentage (e.g., 6.0 for +6%)
function SpellTooltips.Talents.GetCritChanceBonus(spellName, school)
    local totalBonus = 0
    local schoolLower = school and string.lower(school) or nil

    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        if talentInfo.type == "crit" then
            local ranks = SpellTooltips.Talents.GetTalentRanksByKey(key)
            if ranks > 0 then
                local applies = false

                -- Spell-specific crit (e.g., Arcane Impact, Incineration, Improved Frostbolt)
                if talentInfo.affects then
                    for _, affectedSpell in ipairs(talentInfo.affects) do
                        if affectedSpell == spellName then
                            applies = true
                            break
                        end
                    end
                -- School-wide crit (e.g., Critical Mass)
                elseif talentInfo.school and schoolLower and talentInfo.school == schoolLower then
                    applies = true
                -- Global crit bonus (e.g., Arcane Instability)
                elseif not talentInfo.school and not talentInfo.affects then
                    applies = true
                end

                if applies then
                    totalBonus = totalBonus + (ranks * talentInfo.perRank * 100)
                end
            end
        end
    end

    return totalBonus
end

-- Get crit damage multiplier for a school
-- Base crit damage in TBC is 150% (1.5x multiplier)
-- Returns total multiplier (e.g., 2.5 for 250% crit damage with Ice Shards)
function SpellTooltips.Talents.GetCritDamageMultiplier(school)
    local baseCritMultiplier = 1.5  -- 150% base crit damage in TBC
    local bonusMultiplier = 0
    local schoolLower = school and string.lower(school) or nil

    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        if talentInfo.type == "critdamage" then
            local ranks = SpellTooltips.Talents.GetTalentRanksByKey(key)
            if ranks > 0 then
                local applies = false

                -- School-specific crit damage (e.g., Ice Shards)
                if talentInfo.school and schoolLower and talentInfo.school == schoolLower then
                    applies = true
                -- Global crit damage bonus (e.g., Spell Power)
                elseif not talentInfo.school then
                    applies = true
                end

                if applies then
                    bonusMultiplier = bonusMultiplier + (ranks * talentInfo.perRank)
                end
            end
        end
    end

    return baseCritMultiplier + bonusMultiplier
end
