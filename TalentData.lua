-- SpellTooltips Talent Data
-- Talent definitions and lookup functions for coefficient/damage modifiers

SpellTooltips = SpellTooltips or {}
SpellTooltips.Talents = {}

-- Cache for talent ranks (refreshed on talent changes)
local talentCache = {}
local cacheValid = false

-- Pre-computed bonus caches (built once on login/talent change)
local computedCache = {
    schoolMultipliers = {},      -- { fire = 0.10, frost = 0.06, ... } (bonus, not multiplier)
    schoolMultipliers1H = {},    -- School multipliers that require 1H weapon
    schoolMultipliers2H = {},    -- School multipliers that require 2H weapon
    spellMultipliers = {},       -- { ["Fireball"] = 0.0, ["Holy Light"] = 0.12, ... }
    -- Multipliers already included in tooltip base (still apply to SP bonus)
    spellMultipliersIncluded = {}, -- { ["Holy Shield"] = 0.20, ... }
    coefficientBonuses = {},     -- { ["Fireball"] = 0.15, ... }
    critBonusBySchool = {},      -- { fire = 6, frost = 3, ... }
    critBonusBySpell = {},       -- { ["Fire Blast"] = 4, ... }
    critBonusGlobal = 0,         -- Global crit bonus (all spells)
    critDamageBySchool = {},     -- { frost = 1.0, ... } (bonus over base 1.5)
    critDamageGlobal = 0,        -- Global crit damage bonus
    physicalMultiplierGlobal = 0, -- Global physical damage bonus
    physicalMultiplierBySpell = {}, -- { ["Sinister Strike"] = 0.06, ... }
    physicalMultiplierBySchool = {}, -- { holy = 0.10, ... } for holy damage physical abilities
    physicalMultiplier2H = 0,    -- Bonus for 2H weapons (Two-Handed Weapon Spec)
    physicalMultiplier1H = 0,    -- Bonus for 1H weapons (One-Handed Weapon Spec)
}
local computedCacheValid = false

-- Forward declarations for local functions (must be declared before use)
local EnsureComputedCache
local BuildComputedCache

-- Weapon type detection helpers
local INVSLOT_MAINHAND = 16

-- Check if player has a one-handed weapon equipped
local function IsOneHandedWeaponEquipped()
    -- Check main hand weapon slot
    local itemLink = GetInventoryItemLink("player", INVSLOT_MAINHAND)
    if not itemLink then return false end

    -- Get item subclass to determine weapon type
    local _, _, _, _, _, _, itemSubType = GetItemInfo(itemLink)
    if not itemSubType then return false end

    -- One-handed weapon types
    local oneHandedTypes = {
        ["One-Handed Axes"] = true,
        ["One-Handed Maces"] = true,
        ["One-Handed Swords"] = true,
        ["Daggers"] = true,
        ["Fist Weapons"] = true,
    }

    return oneHandedTypes[itemSubType] or false
end

-- Check if player has a two-handed weapon equipped
local function IsTwoHandedWeaponEquipped()
    local itemLink = GetInventoryItemLink("player", INVSLOT_MAINHAND)
    if not itemLink then return false end

    local _, _, _, _, _, _, itemSubType = GetItemInfo(itemLink)
    if not itemSubType then return false end

    local twoHandedTypes = {
        ["Two-Handed Axes"] = true,
        ["Two-Handed Maces"] = true,
        ["Two-Handed Swords"] = true,
        ["Polearms"] = true,
        ["Staves"] = true,
    }

    return twoHandedTypes[itemSubType] or false
end

-- Expose weapon check functions
SpellTooltips.Talents.IsOneHandedWeaponEquipped = IsOneHandedWeaponEquipped
SpellTooltips.Talents.IsTwoHandedWeaponEquipped = IsTwoHandedWeaponEquipped

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

    -- Note: Sanctity Aura is tracked in AuraData.lua since it must be active to apply

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
    -- Note: Game tooltip already includes this bonus in base damage value
    IMPROVED_HOLY_SHIELD = {
        tab = 2, index = 22, maxRanks = 2,
        perRank = 0.10,
        affects = { "Holy Shield" },
        type = "multiplier",
        name = "Improved Holy Shield",
        class = "PALADIN",
        includedInTooltip = true,
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

    -- One-Handed Weapon Specialization: +1% ALL damage per rank when 1H equipped (Protection tree)
    ONE_HANDED_WEAPON_SPEC_PALADIN = {
        tab = 2, index = 7, maxRanks = 5,
        perRank = 0.01,
        type = "multiplier",
        name = "One-Handed Weapon Specialization",
        class = "PALADIN",
        school = "all",  -- Applies to ALL damage types
        requires1H = true,
    },

    -- Two-Handed Weapon Specialization: +2% damage with 2H weapons per rank (Retribution tree)
    TWO_HANDED_WEAPON_SPEC = {
        tab = 3, index = 7, maxRanks = 3,
        perRank = 0.02,
        type = "multiplier",
        name = "Two-Handed Weapon Specialization",
        class = "PALADIN",
        isPhysical = true,
        requires2H = true,
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

    -- ===================
    -- FERAL COMBAT TALENTS (Cat Form)
    -- ===================

    -- Feral Aggression: +3% Ferocious Bite damage per rank (5 ranks)
    FERAL_AGGRESSION = {
        tab = 2, index = 1, maxRanks = 5,
        perRank = 0.03,
        affects = { "Ferocious Bite" },
        type = "multiplier",
        name = "Feral Aggression",
        class = "DRUID",
    },

    -- Savage Fury: +4% Claw, Rake, Mangle, Maim damage per rank (2 ranks)
    SAVAGE_FURY = {
        tab = 2, index = 15, maxRanks = 2,
        perRank = 0.10,
        affects = { "Claw", "Rake", "Mangle (Cat)", "Mangle (Bear)", "Maim" },
        type = "multiplier",
        name = "Savage Fury",
        class = "DRUID",
    },

    -- Predatory Instincts: +3% crit damage in cat form per rank (5 ranks)
    -- Note: Only applies when in Cat Form
    PREDATORY_INSTINCTS = {
        tab = 2, index = 24, maxRanks = 5,
        perRank = 0.03,
        type = "critdamage",
        condition = "cat form only",
        name = "Predatory Instincts",
        class = "DRUID",
    },

    -- Naturalist: +2% physical damage per rank (5 ranks) - Restoration tree
    -- Applies to all feral abilities
    NATURALIST = {
        tab = 3, index = 2, maxRanks = 5,
        perRank = 0.02,
        type = "physical_multiplier",
        name = "Naturalist",
        class = "DRUID",
    },

    -- =====================
    -- HUNTER TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Beast Mastery, Tab 2 = Marksmanship, Tab 3 = Survival

    -- ===================
    -- DAMAGE MULTIPLIERS
    -- ===================

    -- Improved Arcane Shot: +3% Arcane Shot damage per rank (5 ranks)
    IMPROVED_ARCANE_SHOT = {
        tab = 2, index = 4, maxRanks = 5,
        perRank = 0.03,
        affects = { "Arcane Shot" },
        type = "multiplier",
        name = "Improved Arcane Shot",
        class = "HUNTER",
    },

    -- Ranged Weapon Specialization: +1% ranged damage per rank (5 ranks)
    RANGED_WEAPON_SPEC = {
        tab = 2, index = 22, maxRanks = 5,
        perRank = 0.01,
        type = "ranged_multiplier",
        name = "Ranged Weapon Specialization",
        class = "HUNTER",
    },

    -- Monster Slaying: +1% damage to beasts, giants, dragonkin per rank (3 ranks)
    MONSTER_SLAYING = {
        tab = 3, index = 4, maxRanks = 3,
        perRank = 0.01,
        type = "conditional",
        condition = "vs beasts, giants, dragonkin",
        name = "Monster Slaying",
        class = "HUNTER",
    },

    -- Humanoid Slaying: +1% damage to humanoids per rank (3 ranks)
    HUMANOID_SLAYING = {
        tab = 3, index = 5, maxRanks = 3,
        perRank = 0.01,
        type = "conditional",
        condition = "vs humanoids",
        name = "Humanoid Slaying",
        class = "HUNTER",
    },

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Lethal Shots: +1% ranged crit per rank (5 ranks)
    LETHAL_SHOTS = {
        tab = 2, index = 3, maxRanks = 5,
        perRank = 0.01,
        type = "crit",
        isRanged = true,
        name = "Lethal Shots",
        class = "HUNTER",
    },

    -- Killer Instinct: +1% crit per rank (3 ranks)
    KILLER_INSTINCT = {
        tab = 3, index = 16, maxRanks = 3,
        perRank = 0.01,
        type = "crit",
        name = "Killer Instinct",
        class = "HUNTER",
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Mortal Shots: +6% ranged crit damage per rank (5 ranks = +30%)
    MORTAL_SHOTS = {
        tab = 2, index = 9, maxRanks = 5,
        perRank = 0.06,
        type = "critdamage",
        isRanged = true,
        name = "Mortal Shots",
        class = "HUNTER",
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

    -- ===================
    -- ENHANCEMENT SHAMAN TALENTS (Physical)
    -- ===================

    -- Weapon Mastery: +2% melee damage per rank (all weapons)
    WEAPON_MASTERY = {
        tab = 2, index = 13, maxRanks = 5,
        perRank = 0.02,
        type = "multiplier",
        name = "Weapon Mastery",
        class = "SHAMAN",
        isPhysical = true,
    },

    -- Dual Wield Specialization (Shaman): +3% off-hand damage per rank
    DUAL_WIELD_SPEC_SHAMAN = {
        tab = 2, index = 19, maxRanks = 3,
        perRank = 0.03,
        type = "multiplier",
        name = "Dual Wield Specialization",
        class = "SHAMAN",
        isPhysical = true,
        offhandOnly = true,
    },

    -- Elemental Weapons: +10% Windfury/Flametongue/Frostbrand damage per rank
    ELEMENTAL_WEAPONS = {
        tab = 2, index = 10, maxRanks = 3,
        perRank = 0.10,
        affects = { "Windfury Weapon", "Flametongue Weapon", "Frostbrand Weapon" },
        type = "multiplier",
        name = "Elemental Weapons",
        class = "SHAMAN",
        isPhysical = true,
    },

    -- Unleashed Rage: +2% AP after melee crit per rank (buff)
    UNLEASHED_RAGE = {
        tab = 2, index = 21, maxRanks = 5,
        perRank = 0.02,
        type = "conditional",
        condition = "after melee critical strike (party buff)",
        name = "Unleashed Rage",
        class = "SHAMAN",
        isPhysical = true,
    },

    -- Mental Quickness: +10% of AP as spell damage per rank
    MENTAL_QUICKNESS = {
        tab = 2, index = 15, maxRanks = 3,
        perRank = 0.10,
        type = "conditional",
        condition = "adds 10% AP as spell damage",
        name = "Mental Quickness",
        class = "SHAMAN",
    },

    -- =====================
    -- WARRIOR TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Arms, Tab 2 = Fury, Tab 3 = Protection

    -- ===================
    -- DAMAGE MULTIPLIERS
    -- ===================

    -- Two-Handed Weapon Specialization (Arms): +2% damage with 2H per rank
    TWO_HANDED_WEAPON_SPEC_WARRIOR = {
        tab = 1, index = 19, maxRanks = 5,
        perRank = 0.02,
        type = "multiplier",
        name = "Two-Handed Weapon Specialization",
        class = "WARRIOR",
        isPhysical = true,
        requires2H = true,
    },

    -- One-Handed Weapon Specialization (Arms): +2% damage with 1H per rank
    ONE_HANDED_WEAPON_SPEC = {
        tab = 1, index = 23, maxRanks = 5,
        perRank = 0.02,
        type = "multiplier",
        name = "One-Handed Weapon Specialization",
        class = "WARRIOR",
        isPhysical = true,
        requires1H = true,
    },

    -- Dual Wield Specialization (Fury): +5% off-hand damage per rank
    DUAL_WIELD_SPEC_WARRIOR = {
        tab = 2, index = 18, maxRanks = 5,
        perRank = 0.05,
        type = "multiplier",
        name = "Dual Wield Specialization",
        class = "WARRIOR",
        isPhysical = true,
        offhandOnly = true,
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Impale (Arms): +10% crit damage per rank
    IMPALE = {
        tab = 1, index = 10, maxRanks = 2,
        perRank = 0.10,
        type = "critdamage",
        name = "Impale",
        class = "WARRIOR",
        isPhysical = true,
    },

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Improved Overpower (Arms): +25% crit chance to Overpower per rank
    IMPROVED_OVERPOWER = {
        tab = 1, index = 7, maxRanks = 2,
        perRank = 0.25,
        affects = { "Overpower" },
        type = "crit",
        name = "Improved Overpower",
        class = "WARRIOR",
        isPhysical = true,
    },

    -- Cruelty (Fury): +1% crit to all attacks per rank
    CRUELTY = {
        tab = 2, index = 3, maxRanks = 5,
        perRank = 0.01,
        type = "crit",
        name = "Cruelty",
        class = "WARRIOR",
        isPhysical = true,
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Enrage (Fury): +5% damage after crit per rank
    ENRAGE = {
        tab = 2, index = 14, maxRanks = 5,
        perRank = 0.05,
        type = "conditional",
        condition = "for 12s after being crit",
        name = "Enrage",
        class = "WARRIOR",
        isPhysical = true,
    },

    -- Death Wish (Fury): +20% damage active ability
    DEATH_WISH = {
        tab = 2, index = 17, maxRanks = 1,
        perRank = 0.20,
        type = "conditional",
        condition = "when Death Wish is active",
        name = "Death Wish",
        class = "WARRIOR",
        isPhysical = true,
    },

    -- Rampage (Fury): +AP stacking buff after crit
    RAMPAGE_TALENT = {
        tab = 2, index = 21, maxRanks = 1,
        perRank = 0.0, -- AP buff, not % modifier
        type = "conditional",
        condition = "+50 AP stacking (5x) after melee crit",
        name = "Rampage",
        class = "WARRIOR",
        isPhysical = true,
    },

    -- ===================
    -- PROTECTION TALENTS
    -- ===================

    -- Shield Mastery (Protection): +10% block value per rank
    SHIELD_MASTERY = {
        tab = 3, index = 8, maxRanks = 3,
        perRank = 0.10,
        type = "multiplier",
        name = "Shield Mastery",
        class = "WARRIOR",
        isPhysical = true,
        affectsBlockValue = true,
    },

    -- =====================
    -- ROGUE TALENTS
    -- =====================
    -- Talent trees: Tab 1 = Assassination, Tab 2 = Combat, Tab 3 = Subtlety
    -- Note: Talent indices need verification in-game with /stt scan

    -- ===================
    -- CRIT CHANCE TALENTS
    -- ===================

    -- Malice: +1% crit to all abilities per rank
    MALICE = {
        tab = 1, index = 5, maxRanks = 5,
        perRank = 0.01,
        type = "crit",
        name = "Malice",
        class = "ROGUE",
        isPhysical = true,
    },

    -- ===================
    -- CRIT DAMAGE TALENTS
    -- ===================

    -- Lethality: +6% crit damage per rank to physical crits
    LETHALITY = {
        tab = 1, index = 11, maxRanks = 5,
        perRank = 0.06,
        type = "critdamage",
        name = "Lethality",
        class = "ROGUE",
        isPhysical = true,
    },

    -- ===================
    -- DAMAGE MULTIPLIERS
    -- ===================

    -- Aggression: +2% damage to Sinister Strike, Backstab, Eviscerate per rank
    AGGRESSION = {
        tab = 2, index = 15, maxRanks = 3,
        perRank = 0.02,
        affects = { "Sinister Strike", "Backstab", "Eviscerate" },
        type = "multiplier",
        name = "Aggression",
        class = "ROGUE",
        isPhysical = true,
    },

    -- Opportunity: +4% damage to Backstab, Mutilate, Garrote, Ambush per rank
    OPPORTUNITY = {
        tab = 3, index = 6, maxRanks = 5,
        perRank = 0.04,
        affects = { "Backstab", "Mutilate", "Garrote", "Ambush" },
        type = "multiplier",
        name = "Opportunity",
        class = "ROGUE",
        isPhysical = true,
    },

    -- Vile Poisons: +4% Envenom/Instant Poison damage per rank
    VILE_POISONS = {
        tab = 1, index = 15, maxRanks = 5,
        perRank = 0.04,
        affects = { "Envenom" },
        type = "multiplier",
        name = "Vile Poisons",
        class = "ROGUE",
        isPhysical = true,
    },

    -- Dual Wield Specialization: +2% off-hand damage per rank
    DUAL_WIELD_SPEC = {
        tab = 2, index = 6, maxRanks = 5,
        perRank = 0.02,
        type = "multiplier",
        name = "Dual Wield Specialization",
        class = "ROGUE",
        isPhysical = true,
        offhandOnly = true,
    },

    -- ===================
    -- CONDITIONAL MULTIPLIERS
    -- ===================

    -- Murder: +2% damage vs humanoids, giants, beasts, dragonkin per rank
    MURDER = {
        tab = 1, index = 9, maxRanks = 2,
        perRank = 0.02,
        type = "conditional",
        condition = "vs Humanoids, Giants, Beasts, Dragonkin",
        name = "Murder",
        class = "ROGUE",
        isPhysical = true,
    },

    -- Find Weakness: +2% damage per rank after opener (Ambush, Garrote, Cheap Shot)
    FIND_WEAKNESS = {
        tab = 1, index = 20, maxRanks = 5,
        perRank = 0.02,
        type = "conditional",
        condition = "for 10s after Ambush, Garrote, or Cheap Shot",
        name = "Find Weakness",
        class = "ROGUE",
        isPhysical = true,
    },

    -- Shadowstep: +20% damage for 10s after use
    SHADOWSTEP = {
        tab = 3, index = 21, maxRanks = 1,
        perRank = 0.20,
        type = "conditional",
        condition = "for 10s after Shadowstep",
        name = "Shadowstep",
        class = "ROGUE",
        isPhysical = true,
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
    if not spellName then return 0 end

    EnsureComputedCache()
    return computedCache.coefficientBonuses[spellName] or 0
end

-- Get damage multiplier for a specific school
-- Returns multiplier (e.g., 1.13 for 13% bonus) and list of contributing talents
-- Also includes "all" school bonuses (like One-Handed Weapon Specialization)
function SpellTooltips.Talents.GetSchoolMultiplier(school)
    if not school then return 1.0, {} end

    EnsureComputedCache()
    school = string.lower(school)

    -- Get school-specific bonus + "all" school bonus
    local schoolBonus = computedCache.schoolMultipliers[school] or 0
    local allBonus = computedCache.schoolMultipliers["all"] or 0

    -- Add weapon-conditional bonuses if appropriate weapon is equipped
    if IsOneHandedWeaponEquipped() then
        schoolBonus = schoolBonus + (computedCache.schoolMultipliers1H[school] or 0)
        allBonus = allBonus + (computedCache.schoolMultipliers1H["all"] or 0)
    elseif IsTwoHandedWeaponEquipped() then
        schoolBonus = schoolBonus + (computedCache.schoolMultipliers2H[school] or 0)
        allBonus = allBonus + (computedCache.schoolMultipliers2H["all"] or 0)
    end

    local totalBonus = schoolBonus + allBonus

    -- Return empty talent list for now (we don't track individual talents in computed cache)
    return 1 + totalBonus, {}
end

-- Get spell-specific damage multiplier (for talents with "affects" list)
-- Returns multiplier (e.g., 1.15 for 15% bonus) and list of contributing talents
function SpellTooltips.Talents.GetSpellMultiplier(spellName)
    if not spellName then return 1.0, {} end

    EnsureComputedCache()

    local bonus = computedCache.spellMultipliers[spellName] or 0
    return 1 + bonus, {}
end

-- Get spell-specific multiplier for talents already included in tooltip base
-- These still need to be applied to the SP bonus portion
function SpellTooltips.Talents.GetSpellMultiplierIncluded(spellName)
    if not spellName then return 1.0 end

    EnsureComputedCache()

    local bonus = computedCache.spellMultipliersIncluded[spellName] or 0
    return 1 + bonus
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
    computedCacheValid = false
end

-- Build the pre-computed bonus caches (called once on login/talent change)
BuildComputedCache = function()
    local _, playerClass = UnitClass("player")

    -- Reset all computed values
    computedCache.schoolMultipliers = {}
    computedCache.schoolMultipliers1H = {}
    computedCache.schoolMultipliers2H = {}
    computedCache.spellMultipliers = {}
    computedCache.spellMultipliersIncluded = {}
    computedCache.coefficientBonuses = {}
    computedCache.critBonusBySchool = {}
    computedCache.critBonusBySpell = {}
    computedCache.critBonusGlobal = 0
    computedCache.critDamageBySchool = {}
    computedCache.critDamageGlobal = 0
    computedCache.physicalMultiplierGlobal = 0
    computedCache.physicalMultiplierBySpell = {}
    computedCache.physicalMultiplierBySchool = {}
    computedCache.physicalMultiplier2H = 0
    computedCache.physicalMultiplier1H = 0

    -- Iterate through all talents once and build caches
    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        -- Skip talents from other classes
        if talentInfo.class and talentInfo.class ~= playerClass then
            -- Skip
        else
            local ranks = SpellTooltips.Talents.GetTalentRanks(talentInfo.tab, talentInfo.index)
            if ranks > 0 then
                local bonus = ranks * talentInfo.perRank

                -- Coefficient bonuses (affects specific spells)
                if talentInfo.type == "coefficient" and talentInfo.affects then
                    for _, spellName in ipairs(talentInfo.affects) do
                        computedCache.coefficientBonuses[spellName] =
                            (computedCache.coefficientBonuses[spellName] or 0) + bonus
                    end

                -- Damage multipliers
                elseif talentInfo.type == "multiplier" then
                    -- Talents already factored into game tooltip base damage
                    -- Still need to apply to SP bonus, so track separately
                    if talentInfo.includedInTooltip and talentInfo.affects then
                        for _, spellName in ipairs(talentInfo.affects) do
                            computedCache.spellMultipliersIncluded[spellName] =
                                (computedCache.spellMultipliersIncluded[spellName] or 0) + bonus
                        end

                    -- School-based multiplier (Fire Power, etc.)
                    elseif talentInfo.school and not talentInfo.isPhysical then
                        -- Check for weapon-conditional talents
                        if talentInfo.requires1H then
                            computedCache.schoolMultipliers1H[talentInfo.school] =
                                (computedCache.schoolMultipliers1H[talentInfo.school] or 0) + bonus
                        elseif talentInfo.requires2H then
                            computedCache.schoolMultipliers2H[talentInfo.school] =
                                (computedCache.schoolMultipliers2H[talentInfo.school] or 0) + bonus
                        else
                            computedCache.schoolMultipliers[talentInfo.school] =
                                (computedCache.schoolMultipliers[talentInfo.school] or 0) + bonus
                        end

                    -- Spell-specific multiplier
                    elseif talentInfo.affects then
                        for _, spellName in ipairs(talentInfo.affects) do
                            computedCache.spellMultipliers[spellName] =
                                (computedCache.spellMultipliers[spellName] or 0) + bonus
                        end

                    -- Physical damage multipliers
                    elseif talentInfo.isPhysical then
                        if talentInfo.requires2H then
                            computedCache.physicalMultiplier2H = computedCache.physicalMultiplier2H + bonus
                        elseif talentInfo.requires1H then
                            computedCache.physicalMultiplier1H = computedCache.physicalMultiplier1H + bonus
                        elseif talentInfo.affects then
                            for _, spellName in ipairs(talentInfo.affects) do
                                computedCache.physicalMultiplierBySpell[spellName] =
                                    (computedCache.physicalMultiplierBySpell[spellName] or 0) + bonus
                            end
                        elseif talentInfo.school then
                            computedCache.physicalMultiplierBySchool[talentInfo.school] =
                                (computedCache.physicalMultiplierBySchool[talentInfo.school] or 0) + bonus
                        end
                    end

                -- Physical multiplier type (Naturalist, etc.)
                elseif talentInfo.type == "physical_multiplier" then
                    computedCache.physicalMultiplierGlobal = computedCache.physicalMultiplierGlobal + bonus

                -- Crit chance bonuses (multiply by 100 to convert to percentage)
                elseif talentInfo.type == "crit" then
                    local critBonus = bonus * 100
                    if talentInfo.school then
                        computedCache.critBonusBySchool[talentInfo.school] =
                            (computedCache.critBonusBySchool[talentInfo.school] or 0) + critBonus
                    elseif talentInfo.affects then
                        for _, spellName in ipairs(talentInfo.affects) do
                            computedCache.critBonusBySpell[spellName] =
                                (computedCache.critBonusBySpell[spellName] or 0) + critBonus
                        end
                    else
                        -- Global crit bonus (no school or affects restriction)
                        computedCache.critBonusGlobal = computedCache.critBonusGlobal + critBonus
                    end

                -- Crit damage bonuses
                elseif talentInfo.type == "critdamage" then
                    if talentInfo.school then
                        computedCache.critDamageBySchool[talentInfo.school] =
                            (computedCache.critDamageBySchool[talentInfo.school] or 0) + bonus
                    else
                        computedCache.critDamageGlobal = computedCache.critDamageGlobal + bonus
                    end
                end
            end
        end
    end

    computedCacheValid = true
end

-- Ensure computed cache is valid
EnsureComputedCache = function()
    if not computedCacheValid then
        BuildComputedCache()
    end
end

-- Validate/refresh the cache
function SpellTooltips.Talents.RefreshCache()
    talentCache = {}
    cacheValid = true

    -- Pre-populate cache for all tracked talents and build computed cache
    for key, talentInfo in pairs(SpellTooltips.TalentInfo) do
        SpellTooltips.Talents.GetTalentRanks(talentInfo.tab, talentInfo.index)
    end

    -- Build the computed bonus caches
    BuildComputedCache()
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
    EnsureComputedCache()

    local totalBonus = computedCache.critBonusGlobal

    if school then
        local schoolLower = string.lower(school)
        totalBonus = totalBonus + (computedCache.critBonusBySchool[schoolLower] or 0)
    end

    if spellName then
        totalBonus = totalBonus + (computedCache.critBonusBySpell[spellName] or 0)
    end

    return totalBonus
end

-- Get physical ability multiplier (checks for weapon-type requirements)
-- Also includes school-based multipliers for abilities that deal spell damage (e.g., Holy)
-- Returns multiplier (e.g., 1.16 for 16% bonus) and list of contributing talents
function SpellTooltips.Talents.GetPhysicalMultiplier(spellName, is2HWeapon, damageSchool)
    EnsureComputedCache()

    local totalBonus = computedCache.physicalMultiplierGlobal

    -- Add "all" school bonus (unconditional talents only)
    totalBonus = totalBonus + (computedCache.schoolMultipliers["all"] or 0)

    -- Add weapon-conditional "all" school bonuses (e.g., One-Handed Weapon Specialization)
    if is2HWeapon then
        totalBonus = totalBonus + (computedCache.schoolMultipliers2H["all"] or 0)
    else
        -- Assume 1H if not 2H
        totalBonus = totalBonus + (computedCache.schoolMultipliers1H["all"] or 0)
    end

    -- Add spell-specific bonus
    if spellName then
        totalBonus = totalBonus + (computedCache.physicalMultiplierBySpell[spellName] or 0)
    end

    -- Add school-based bonus (e.g., Sanctity Aura for Holy damage abilities)
    if damageSchool then
        local schoolLower = string.lower(damageSchool)
        totalBonus = totalBonus + (computedCache.physicalMultiplierBySchool[schoolLower] or 0)
    end

    -- Add weapon-type specific physical multipliers (pre-computed)
    if is2HWeapon then
        totalBonus = totalBonus + computedCache.physicalMultiplier2H
    else
        totalBonus = totalBonus + computedCache.physicalMultiplier1H
    end

    return 1 + totalBonus, {}
end

-- Get crit damage multiplier for a school
-- Base crit damage in TBC is 150% (1.5x multiplier)
-- Returns total multiplier (e.g., 2.5 for 250% crit damage with Ice Shards)
function SpellTooltips.Talents.GetCritDamageMultiplier(school)
    EnsureComputedCache()

    local baseCritMultiplier = 1.5  -- 150% base crit damage in TBC
    local bonusMultiplier = computedCache.critDamageGlobal

    if school then
        local schoolLower = string.lower(school)
        bonusMultiplier = bonusMultiplier + (computedCache.critDamageBySchool[schoolLower] or 0)
    end

    return baseCritMultiplier + bonusMultiplier
end
