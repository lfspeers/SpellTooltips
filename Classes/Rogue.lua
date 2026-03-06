-- SpellTooltips Rogue Spell Data
-- TBC Classic physical ability coefficients
-- Source: Wowhead TBC Classic, Elitist Jerks archives
-- Note: Combo point finishers (Eviscerate, Rupture, Envenom) are EXCLUDED
--       due to variable damage based on combo points

SpellTooltips = SpellTooltips or {}

local RogueSpells = {
    -- =====================
    -- SINISTER STRIKE
    -- 100% weapon damage + flat bonus (normalized)
    -- Generates 1 combo point
    -- =====================
    [1752] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 3, isNormalized = true },
    [1757] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 6, isNormalized = true },
    [1758] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 10, isNormalized = true },
    [1759] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 15, isNormalized = true },
    [1760] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 22, isNormalized = true },
    [8621] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 33, isNormalized = true },
    [11293] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 52, isNormalized = true },
    [11294] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 68, isNormalized = true },
    [26861] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 80, isNormalized = true },
    [26862] = { name = "Sinister Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 98, isNormalized = true },

    -- =====================
    -- BACKSTAB
    -- 150% weapon damage + flat bonus (normalized, requires dagger)
    -- Must be behind target
    -- Generates 1 combo point
    -- =====================
    [53] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 15, isNormalized = true, requiresBehind = true },
    [2589] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 30, isNormalized = true, requiresBehind = true },
    [2590] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 48, isNormalized = true, requiresBehind = true },
    [2591] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 69, isNormalized = true, requiresBehind = true },
    [8721] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 90, isNormalized = true, requiresBehind = true },
    [11279] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 135, isNormalized = true, requiresBehind = true },
    [11280] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 165, isNormalized = true, requiresBehind = true },
    [11281] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 210, isNormalized = true, requiresBehind = true },
    [25300] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 225, isNormalized = true, requiresBehind = true },
    [26863] = { name = "Backstab", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, flatDamage = 255, isNormalized = true, requiresBehind = true },

    -- =====================
    -- HEMORRHAGE (Subtlety talent)
    -- 110% weapon damage (normalized)
    -- Debuff increases physical damage taken
    -- Generates 1 combo point
    -- =====================
    [16511] = { name = "Hemorrhage", school = "physical", isPhysical = true, weaponDamagePercent = 1.10, isNormalized = true },
    [17347] = { name = "Hemorrhage", school = "physical", isPhysical = true, weaponDamagePercent = 1.10, isNormalized = true },
    [17348] = { name = "Hemorrhage", school = "physical", isPhysical = true, weaponDamagePercent = 1.10, isNormalized = true },
    [26864] = { name = "Hemorrhage", school = "physical", isPhysical = true, weaponDamagePercent = 1.10, isNormalized = true },

    -- =====================
    -- AMBUSH
    -- 250% weapon damage + flat bonus (normalized, requires dagger)
    -- Must be in stealth
    -- Generates 2 combo points
    -- =====================
    [8676] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 28, isNormalized = true, requiresStealth = true },
    [8724] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 50, isNormalized = true, requiresStealth = true },
    [8725] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 86, isNormalized = true, requiresStealth = true },
    [11267] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 110, isNormalized = true, requiresStealth = true },
    [11268] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 140, isNormalized = true, requiresStealth = true },
    [11269] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 182, isNormalized = true, requiresStealth = true },
    [27441] = { name = "Ambush", school = "physical", isPhysical = true, weaponDamagePercent = 2.5, flatDamage = 200, isNormalized = true, requiresStealth = true },

    -- =====================
    -- MUTILATE (Assassination talent - TBC)
    -- 100% MH damage + 100% OH damage + flat per hand (normalized)
    -- Requires daggers in both hands
    -- Must be behind target
    -- Generates 2 combo points
    -- Note: This shows MH damage only; OH is separate hit
    -- =====================
    [1329] = { name = "Mutilate", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 101, isNormalized = true, requiresBehind = true },
    [34411] = { name = "Mutilate", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 113, isNormalized = true, requiresBehind = true },
    [34412] = { name = "Mutilate", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 126, isNormalized = true, requiresBehind = true },
    [34413] = { name = "Mutilate", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 141, isNormalized = true, requiresBehind = true },

    -- =====================
    -- GARROTE
    -- Bleed DoT (from stealth)
    -- Generates 1 combo point
    -- Ticks every 3 seconds for 18 seconds (6 ticks)
    -- =====================
    [703] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [8631] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [8632] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [8633] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [11289] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [11290] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [26839] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },
    [26884] = { name = "Garrote", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 6, requiresStealth = true },

    -- =====================
    -- GOUGE
    -- Flat damage + incapacitate
    -- Generates 1 combo point
    -- =====================
    [1776] = { name = "Gouge", school = "physical", isPhysical = true, flatDamage = 16 },
    [1777] = { name = "Gouge", school = "physical", isPhysical = true, flatDamage = 27 },
    [8629] = { name = "Gouge", school = "physical", isPhysical = true, flatDamage = 42 },
    [11285] = { name = "Gouge", school = "physical", isPhysical = true, flatDamage = 58 },
    [11286] = { name = "Gouge", school = "physical", isPhysical = true, flatDamage = 73 },
    [38764] = { name = "Gouge", school = "physical", isPhysical = true, flatDamage = 89 },

    -- =====================
    -- SHIV
    -- Off-hand weapon damage (normalized) + applies poison
    -- Generates 1 combo point
    -- Note: Uses off-hand weapon damage
    -- =====================
    [5938] = { name = "Shiv", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, isNormalized = true },

    -- =====================
    -- GHOSTLY STRIKE (Subtlety talent)
    -- 125% weapon damage (normalized)
    -- Generates 1 combo point
    -- =====================
    [14278] = { name = "Ghostly Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.25, isNormalized = true },

    -- =====================
    -- RIPOSTE (Combat talent)
    -- 150% weapon damage (normalized)
    -- Can only use after parry
    -- Generates 1 combo point
    -- =====================
    [14251] = { name = "Riposte", school = "physical", isPhysical = true, weaponDamagePercent = 1.5, isNormalized = true },

    -- =====================
    -- KICK
    -- Flat damage + interrupt
    -- =====================
    [1766] = { name = "Kick", school = "physical", isPhysical = true, flatDamage = 27 },
    [1767] = { name = "Kick", school = "physical", isPhysical = true, flatDamage = 42 },
    [1768] = { name = "Kick", school = "physical", isPhysical = true, flatDamage = 64 },
    [1769] = { name = "Kick", school = "physical", isPhysical = true, flatDamage = 82 },
    [38768] = { name = "Kick", school = "physical", isPhysical = true, flatDamage = 112 },

    -- =====================
    -- EVISCERATE is EXCLUDED
    -- Reason: Damage scales with combo points, too dynamic
    -- =====================

    -- =====================
    -- RUPTURE is EXCLUDED
    -- Reason: Damage/duration scales with combo points, too dynamic
    -- =====================

    -- =====================
    -- ENVENOM is EXCLUDED
    -- Reason: Damage scales with combo points and poison stacks
    -- =====================

    -- =====================
    -- SLICE AND DICE (no damage)
    -- KIDNEY SHOT (no damage)
    -- EXPOSE ARMOR (no damage)
    -- These are utility finishers, not included
    -- =====================
}

SpellTooltips.RegisterSpellData(RogueSpells, "ROGUE")
