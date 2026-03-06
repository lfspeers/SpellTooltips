-- SpellTooltips Hunter Spell Data
-- TBC Classic RAP (Ranged Attack Power) ability coefficients
-- Source: Wowhead TBC Classic, Elitist Jerks archives

SpellTooltips = SpellTooltips or {}

local HunterSpells = {
    -- =====================
    -- ARCANE SHOT
    -- Instant shot dealing Arcane damage
    -- ~15% RAP coefficient (instant cast)
    -- =====================
    [3044] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 13 },
    [14281] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 21 },
    [14282] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 33 },
    [14283] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 59 },
    [14284] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 83 },
    [14285] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 115 },
    [14286] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 145 },
    [14287] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 183 },
    [27019] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 200 },
    [27022] = { name = "Arcane Shot", school = "arcane", isPhysical = true, isRanged = true, rapCoefficient = 0.15, flatDamage = 273 },

    -- =====================
    -- STEADY SHOT (TBC)
    -- 100% ranged weapon damage + flat bonus + 20% RAP
    -- 1.5s cast, resets auto-shot
    -- =====================
    [34120] = { name = "Steady Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, rapCoefficient = 0.20, flatDamage = 150 },

    -- =====================
    -- AIMED SHOT
    -- 100% ranged weapon damage + flat bonus
    -- 3.0s cast (reduced by talents)
    -- =====================
    [19434] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 70 },
    [20900] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 125 },
    [20901] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 200 },
    [20902] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 330 },
    [20903] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 460 },
    [20904] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 600 },
    [27065] = { name = "Aimed Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 870 },

    -- =====================
    -- MULTI-SHOT
    -- 100% ranged weapon damage + flat bonus to up to 3 targets
    -- =====================
    [2643] = { name = "Multi-Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 0 },
    [14288] = { name = "Multi-Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 40 },
    [14289] = { name = "Multi-Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 80 },
    [14290] = { name = "Multi-Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 120 },
    [25294] = { name = "Multi-Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 150 },
    [27021] = { name = "Multi-Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0, flatDamage = 205 },

    -- =====================
    -- AUTO SHOT (for reference)
    -- 100% ranged weapon damage, uses weapon speed
    -- =====================
    [75] = { name = "Auto Shot", school = "physical", isPhysical = true, isRanged = true, weaponDamagePercent = 1.0 },

    -- =====================
    -- SERPENT STING
    -- Nature DoT, scales with RAP (~4% per tick, 5 ticks over 15s)
    -- Total: ~20% RAP over full duration
    -- =====================
    [1978] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13549] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13550] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13551] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13552] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13553] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13554] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [13555] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [25295] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },
    [27016] = { name = "Serpent Sting", school = "nature", isPhysical = true, isRanged = true, isDot = true, ticks = 5, rapCoefficient = 0.20 },

    -- =====================
    -- IMMOLATION TRAP
    -- Fire DoT (trap effect), 15 sec, 5 ticks
    -- ~10% RAP total over duration
    -- =====================
    [13795] = { name = "Immolation Trap", school = "fire", isPhysical = true, isDot = true, ticks = 5, rapCoefficient = 0.10 },
    [14302] = { name = "Immolation Trap", school = "fire", isPhysical = true, isDot = true, ticks = 5, rapCoefficient = 0.10 },
    [14303] = { name = "Immolation Trap", school = "fire", isPhysical = true, isDot = true, ticks = 5, rapCoefficient = 0.10 },
    [14304] = { name = "Immolation Trap", school = "fire", isPhysical = true, isDot = true, ticks = 5, rapCoefficient = 0.10 },
    [14305] = { name = "Immolation Trap", school = "fire", isPhysical = true, isDot = true, ticks = 5, rapCoefficient = 0.10 },
    [27023] = { name = "Immolation Trap", school = "fire", isPhysical = true, isDot = true, ticks = 5, rapCoefficient = 0.10 },

    -- =====================
    -- EXPLOSIVE TRAP
    -- Fire AoE + DoT, 20 sec, 10 ticks
    -- Initial hit ~10% RAP, DoT ~10% RAP
    -- =====================
    [13813] = { name = "Explosive Trap", school = "fire", isPhysical = true, isDot = true, ticks = 10, rapCoefficient = 0.10 },
    [14316] = { name = "Explosive Trap", school = "fire", isPhysical = true, isDot = true, ticks = 10, rapCoefficient = 0.10 },
    [14317] = { name = "Explosive Trap", school = "fire", isPhysical = true, isDot = true, ticks = 10, rapCoefficient = 0.10 },
    [27025] = { name = "Explosive Trap", school = "fire", isPhysical = true, isDot = true, ticks = 10, rapCoefficient = 0.10 },

    -- =====================
    -- RAPTOR STRIKE
    -- 100% melee weapon damage + flat bonus (normalized)
    -- Melee ability, uses melee AP
    -- =====================
    [2973] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 5, isNormalized = true },
    [14260] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 11, isNormalized = true },
    [14261] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 21, isNormalized = true },
    [14262] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 34, isNormalized = true },
    [14263] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 50, isNormalized = true },
    [14264] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 80, isNormalized = true },
    [14265] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 110, isNormalized = true },
    [14266] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 140, isNormalized = true },
    [27014] = { name = "Raptor Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 170, isNormalized = true },

    -- =====================
    -- MONGOOSE BITE
    -- Flat damage (can only use after dodge)
    -- Melee ability
    -- =====================
    [1495] = { name = "Mongoose Bite", school = "physical", isPhysical = true, flatDamage = 25 },
    [14269] = { name = "Mongoose Bite", school = "physical", isPhysical = true, flatDamage = 45 },
    [14270] = { name = "Mongoose Bite", school = "physical", isPhysical = true, flatDamage = 75 },
    [14271] = { name = "Mongoose Bite", school = "physical", isPhysical = true, flatDamage = 115 },
    [36916] = { name = "Mongoose Bite", school = "physical", isPhysical = true, flatDamage = 150 },

    -- =====================
    -- WING CLIP
    -- Flat damage + slow
    -- =====================
    [2974] = { name = "Wing Clip", school = "physical", isPhysical = true, flatDamage = 5 },
    [14267] = { name = "Wing Clip", school = "physical", isPhysical = true, flatDamage = 12 },
    [14268] = { name = "Wing Clip", school = "physical", isPhysical = true, flatDamage = 25 },
    [27633] = { name = "Wing Clip", school = "physical", isPhysical = true, flatDamage = 40 },

    -- =====================
    -- KILL COMMAND (TBC - Beast Mastery talent)
    -- Pet ability modifier (+127 pet damage for 5 attacks)
    -- Note: This affects pet, not hunter damage directly
    -- =====================
    [34026] = { name = "Kill Command", school = "physical", isPhysical = true, flatDamage = 127 },

    -- =====================
    -- VOLLEY
    -- Channeled AoE, arcane damage, 6 sec channel, 6 volleys
    -- ~10% RAP per volley hit
    -- =====================
    [1510] = { name = "Volley", school = "arcane", isPhysical = true, isRanged = true, isChanneled = true, castTime = 6.0, ticks = 6, rapCoefficient = 0.10 },
    [14294] = { name = "Volley", school = "arcane", isPhysical = true, isRanged = true, isChanneled = true, castTime = 6.0, ticks = 6, rapCoefficient = 0.10 },
    [14295] = { name = "Volley", school = "arcane", isPhysical = true, isRanged = true, isChanneled = true, castTime = 6.0, ticks = 6, rapCoefficient = 0.10 },
    [27020] = { name = "Volley", school = "arcane", isPhysical = true, isRanged = true, isChanneled = true, castTime = 6.0, ticks = 6, rapCoefficient = 0.10 },

    -- =====================
    -- CONCUSSIVE SHOT (no damage)
    -- SCATTER SHOT (no damage, disorient only)
    -- DISTRACTING SHOT (no damage, taunt only)
    -- FREEZING TRAP (no damage)
    -- FROST TRAP (no damage)
    -- These are utility abilities, not included
    -- =====================
}

SpellTooltips.RegisterSpellData(HunterSpells, "HUNTER")
