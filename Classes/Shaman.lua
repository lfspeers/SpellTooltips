-- SpellTooltips Shaman Spell Data
-- Generated from LibSpellDB on 2026-03-04
-- TBC Classic spell coefficients

SpellTooltips = SpellTooltips or {}

local ShamanSpells = {
    -- Bloodlust (all ranks)
    [2825] = { name = "Bloodlust", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Chain Heal (all ranks)
    [1064] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true },
    [10622] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true },
    [10623] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true },
    [25422] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true },
    [25423] = { name = "Chain Heal", coefficient = 0.714, school = "nature", castTime = 2.5, isHealing = true },

    -- Chain Lightning (all ranks) - 2.0s cast, 57.1% coefficient
    [421] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [930] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [2860] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [10605] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [25439] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.0 },
    [25442] = { name = "Chain Lightning", coefficient = 0.571, school = "nature", castTime = 2.0 },

    -- Cure Disease (all ranks)
    [2870] = { name = "Cure Disease", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Cure Poison (all ranks)
    [526] = { name = "Cure Poison", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Disease Cleansing Totem (all ranks)
    [8170] = { name = "Disease Cleansing Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Earth Shield (all ranks)
    [974] = { name = "Earth Shield", coefficient = 0.286, school = "nature", castTime = 0.0, isHealing = true },
    [32593] = { name = "Earth Shield", coefficient = 0.286, school = "nature", castTime = 0.0, isHealing = true },
    [32594] = { name = "Earth Shield", coefficient = 0.286, school = "nature", castTime = 0.0, isHealing = true },

    -- Earth Shock (all ranks)
    [8042] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [8044] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [8045] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [8046] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [10412] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [10413] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [10414] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },
    [25454] = { name = "Earth Shock", coefficient = 0.386, school = "nature", castTime = 0.0 },

    -- Elemental Mastery (all ranks)
    [16166] = { name = "Elemental Mastery", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Fire Elemental Totem (all ranks)
    [2894] = { name = "Fire Elemental Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Fire Nova Totem (all ranks)
    [1535] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },
    [8498] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },
    [8499] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },
    [11314] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },
    [11315] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },
    [25546] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },
    [25547] = { name = "Fire Nova Totem", coefficient = 0.214, school = "fire", castTime = 0.0 },

    -- Flame Shock (all ranks) - DD + 12 sec DoT, 4 ticks (every 3 sec)
    [8050] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },
    [8052] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },
    [8053] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },
    [10447] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },
    [10448] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },
    [25457] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },
    [29228] = { name = "Flame Shock", coefficient = 0.15, dotCoefficient = 0.52, school = "fire", castTime = 0.0, isDot = true, ticks = 4 },

    -- Healing Stream Totem (all ranks) - Heals party every 2 sec
    -- Per-tick coefficient ~4.5% (scales with Restorative Totems talent)
    [5394] = { name = "Healing Stream Totem", coefficient = 0.045, school = "nature", castTime = 0.0, isHealing = true },
    [6375] = { name = "Healing Stream Totem", coefficient = 0.045, school = "nature", castTime = 0.0, isHealing = true },
    [6377] = { name = "Healing Stream Totem", coefficient = 0.045, school = "nature", castTime = 0.0, isHealing = true },
    [10462] = { name = "Healing Stream Totem", coefficient = 0.045, school = "nature", castTime = 0.0, isHealing = true },
    [10463] = { name = "Healing Stream Totem", coefficient = 0.045, school = "nature", castTime = 0.0, isHealing = true },
    [25567] = { name = "Healing Stream Totem", coefficient = 0.045, school = "nature", castTime = 0.0, isHealing = true },

    -- Healing Wave (all ranks)
    [331] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [332] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [547] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [913] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [939] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [959] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [8005] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [10395] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [10396] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [25357] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [25391] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },
    [25396] = { name = "Healing Wave", coefficient = 0.857, school = "nature", castTime = 3.0, isHealing = true },

    -- Heroism (all ranks)
    [32182] = { name = "Heroism", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Lesser Healing Wave (all ranks)
    [8004] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },
    [8008] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },
    [8010] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },
    [10466] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },
    [10467] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },
    [10468] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },
    [25420] = { name = "Lesser Healing Wave", coefficient = 0.429, school = "nature", castTime = 1.5, isHealing = true },

    -- Lightning Bolt (all ranks)
    [403] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [529] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [548] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [915] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [943] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [6041] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [10391] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [10392] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [15207] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [15208] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [25448] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },
    [25449] = { name = "Lightning Bolt", coefficient = 0.794, school = "nature", castTime = 2.5 },

    -- Lightning Shield (all ranks)
    [324] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [325] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [905] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [945] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [8134] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [10431] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [10432] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [25469] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },
    [25472] = { name = "Lightning Shield", coefficient = 0.33, school = "nature", castTime = 0.0 },

    -- Magma Totem (all ranks)
    [8190] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0.0 },
    [10585] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0.0 },
    [10586] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0.0 },
    [10587] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0.0 },
    [25552] = { name = "Magma Totem", coefficient = 0.067, school = "fire", castTime = 0.0 },

    -- Mana Tide Totem (all ranks)
    [16190] = { name = "Mana Tide Totem", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Nature's Swiftness (all ranks)
    [16188] = { name = "Nature's Swiftness", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Poison Cleansing Totem (all ranks)
    [8166] = { name = "Poison Cleansing Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Purge (all ranks)
    [370] = { name = "Purge", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [8012] = { name = "Purge", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [27626] = { name = "Purge", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Frost Shock (all ranks) - 38.6% coefficient (instant)
    [8056] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0.0 },
    [8058] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0.0 },
    [10472] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0.0 },
    [10473] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0.0 },
    [25464] = { name = "Frost Shock", coefficient = 0.386, school = "frost", castTime = 0.0 },

    -- Searing Totem (all ranks) - ~17% coefficient per hit
    [3599] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },
    [6363] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },
    [6364] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },
    [6365] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },
    [10437] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },
    [10438] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },
    [25533] = { name = "Searing Totem", coefficient = 0.167, school = "fire", castTime = 0.0 },

    -- Totem of Wrath (all ranks)
    [30706] = { name = "Totem of Wrath", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Water Shield (all ranks)
    [24398] = { name = "Water Shield", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },
    [33736] = { name = "Water Shield", coefficient = 0.0, school = "unknown", castTime = 0.0, isHealing = true },

    -- Windfury Totem (all ranks)
    [8512] = { name = "Windfury Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10613] = { name = "Windfury Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [10614] = { name = "Windfury Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [25585] = { name = "Windfury Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },
    [25587] = { name = "Windfury Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- Wrath of Air Totem (all ranks)
    [3738] = { name = "Wrath of Air Totem", coefficient = 0.0, school = "unknown", castTime = 0.0 },

    -- =====================
    -- STORMSTRIKE (Enhancement talent)
    -- Instant melee attack with both weapons
    -- Deals 100% weapon damage on each hit
    -- Debuffs target: +20% nature damage taken
    -- NOT normalized - uses actual weapon speed
    -- =====================
    [17364] = { name = "Stormstrike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0 },
}

-- Register Shaman spells with the main addon
SpellTooltips.RegisterSpellData(ShamanSpells, "SHAMAN")
