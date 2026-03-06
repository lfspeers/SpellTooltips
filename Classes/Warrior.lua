-- SpellTooltips Warrior Spell Data
-- TBC Classic physical ability coefficients
-- Source: Wowhead TBC Classic, Elitist Jerks archives

SpellTooltips = SpellTooltips or {}

local WarriorSpells = {
    -- =====================
    -- MORTAL STRIKE (Arms 31pt talent)
    -- 100% weapon damage + flat bonus, normalized
    -- =====================
    [12294] = { name = "Mortal Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 85, isNormalized = true },
    [21551] = { name = "Mortal Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 110, isNormalized = true },
    [21552] = { name = "Mortal Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 135, isNormalized = true },
    [21553] = { name = "Mortal Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 160, isNormalized = true },
    [25248] = { name = "Mortal Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 185, isNormalized = true },
    [30330] = { name = "Mortal Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 210, isNormalized = true },

    -- =====================
    -- BLOODTHIRST (Fury 31pt talent)
    -- 45% of AP as damage (no weapon damage)
    -- =====================
    [23881] = { name = "Bloodthirst", school = "physical", isPhysical = true, apCoefficient = 0.45 },
    [23892] = { name = "Bloodthirst", school = "physical", isPhysical = true, apCoefficient = 0.45 },
    [23893] = { name = "Bloodthirst", school = "physical", isPhysical = true, apCoefficient = 0.45 },
    [23894] = { name = "Bloodthirst", school = "physical", isPhysical = true, apCoefficient = 0.45 },
    [25251] = { name = "Bloodthirst", school = "physical", isPhysical = true, apCoefficient = 0.45 },
    [30335] = { name = "Bloodthirst", school = "physical", isPhysical = true, apCoefficient = 0.45 },

    -- =====================
    -- HEROIC STRIKE
    -- Next melee attack deals weapon damage + flat bonus
    -- Not normalized (uses actual weapon speed)
    -- =====================
    [78] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 11 },
    [284] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 21 },
    [285] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 32 },
    [1608] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 44 },
    [11564] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 58 },
    [11565] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 80 },
    [11566] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 111 },
    [11567] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 138 },
    [25286] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 157 },
    [29707] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 176 },
    [30324] = { name = "Heroic Strike", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 208 },

    -- =====================
    -- OVERPOWER
    -- 100% weapon damage + flat bonus, normalized
    -- Can only be used after target dodges
    -- =====================
    [7384] = { name = "Overpower", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 5, isNormalized = true },
    [7887] = { name = "Overpower", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 15, isNormalized = true },
    [11584] = { name = "Overpower", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 25, isNormalized = true },
    [11585] = { name = "Overpower", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 35, isNormalized = true },

    -- =====================
    -- SLAM
    -- 100% weapon damage + flat bonus
    -- 1.5s cast time, resets swing timer
    -- =====================
    [1464] = { name = "Slam", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 32 },
    [8820] = { name = "Slam", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 43 },
    [11604] = { name = "Slam", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 68 },
    [11605] = { name = "Slam", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 87 },
    [25241] = { name = "Slam", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 105 },
    [25242] = { name = "Slam", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 140 },

    -- =====================
    -- WHIRLWIND
    -- 100% weapon damage to up to 4 targets
    -- Normalized weapon speed
    -- =====================
    [1680] = { name = "Whirlwind", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, isNormalized = true },

    -- =====================
    -- CLEAVE
    -- 100% weapon damage + flat bonus to 2 targets
    -- =====================
    [845] = { name = "Cleave", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 5 },
    [7369] = { name = "Cleave", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 18 },
    [11608] = { name = "Cleave", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 32 },
    [11609] = { name = "Cleave", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 50 },
    [20569] = { name = "Cleave", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 70 },
    [25231] = { name = "Cleave", school = "physical", isPhysical = true, weaponDamagePercent = 1.0, flatDamage = 100 },

    -- =====================
    -- SHIELD SLAM (Protection 31pt talent)
    -- Flat damage based on block value (not weapon damage)
    -- Note: Block value scaling is complex, using base damage only
    -- =====================
    [23922] = { name = "Shield Slam", school = "physical", isPhysical = true, flatDamage = 225 },
    [23923] = { name = "Shield Slam", school = "physical", isPhysical = true, flatDamage = 264 },
    [23924] = { name = "Shield Slam", school = "physical", isPhysical = true, flatDamage = 303 },
    [23925] = { name = "Shield Slam", school = "physical", isPhysical = true, flatDamage = 342 },
    [25258] = { name = "Shield Slam", school = "physical", isPhysical = true, flatDamage = 381 },
    [30356] = { name = "Shield Slam", school = "physical", isPhysical = true, flatDamage = 420 },

    -- =====================
    -- REVENGE
    -- Flat damage (can only use after block/dodge/parry)
    -- Low damage, high threat
    -- =====================
    [6572] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 45 },
    [6574] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 65 },
    [7379] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 90 },
    [11600] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 115 },
    [11601] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 145 },
    [25288] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 180 },
    [25269] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 200 },
    [30357] = { name = "Revenge", school = "physical", isPhysical = true, flatDamage = 219 },

    -- =====================
    -- DEVASTATE (Protection talent - TBC)
    -- 50% weapon damage per Sunder Armor stack on target
    -- Plus applies Sunder Armor
    -- =====================
    [20243] = { name = "Devastate", school = "physical", isPhysical = true, weaponDamagePercent = 0.50, isNormalized = true },
    [30016] = { name = "Devastate", school = "physical", isPhysical = true, weaponDamagePercent = 0.50, isNormalized = true },
    [30022] = { name = "Devastate", school = "physical", isPhysical = true, weaponDamagePercent = 0.50, isNormalized = true },

    -- =====================
    -- REND
    -- Bleed DoT, damage based on AP (not weapon damage)
    -- Ticks every 3 seconds
    -- =====================
    [772] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [6546] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [6547] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [6548] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [11572] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [11573] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [11574] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 5 },
    [25208] = { name = "Rend", school = "physical", isPhysical = true, isBleed = true, isDot = true, ticks = 7 },

    -- =====================
    -- HAMSTRING
    -- Flat damage + slow
    -- =====================
    [1715] = { name = "Hamstring", school = "physical", isPhysical = true, flatDamage = 5 },
    [7372] = { name = "Hamstring", school = "physical", isPhysical = true, flatDamage = 18 },
    [7373] = { name = "Hamstring", school = "physical", isPhysical = true, flatDamage = 45 },
    [25212] = { name = "Hamstring", school = "physical", isPhysical = true, flatDamage = 63 },

    -- =====================
    -- THUNDER CLAP
    -- AoE flat damage + attack speed slow
    -- =====================
    [6343] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 10 },
    [8198] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 23 },
    [8204] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 37 },
    [8205] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 55 },
    [11580] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 82 },
    [11581] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 103 },
    [25264] = { name = "Thunder Clap", school = "physical", isPhysical = true, flatDamage = 123 },

    -- =====================
    -- SUNDER ARMOR
    -- No damage, just armor reduction (not tracked here)
    -- =====================

    -- =====================
    -- Execute is EXCLUDED
    -- Reason: Damage scales with remaining rage, too dynamic to calculate
    -- =====================
}

SpellTooltips.RegisterSpellData(WarriorSpells, "WARRIOR")
