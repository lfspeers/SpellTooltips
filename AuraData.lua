-- SpellTooltips Aura Data
-- Aura definitions and detection functions for party/player buff damage multipliers

SpellTooltips = SpellTooltips or {}
SpellTooltips.Auras = {}

-- Cache for active auras (refreshed on UNIT_AURA)
local auraCache = {}
local cacheValid = false

-- Aura definitions (damage multipliers only)
-- Note: Crit buffs (Moonkin Aura, Leader of the Pack, Totem of Wrath) are already
-- reflected in GetSpellCritChance() / GetCritChance() so we don't track them here.
-- Improved Sanctity Aura talent info (for checking when Sanctity Aura is active)
-- Note: The +2% all damage bonus is already reflected in the game's weapon damage tooltip
local IMPROVED_SANCTITY_AURA_TALENT = {
    tab = 3,
    index = 17,
    maxRanks = 2,
    perRank = 0.01,  -- 1% per rank = 2% at 2/2
    isIncludedInWeaponDamage = true,  -- Already applied by game to weapon damage
}

SpellTooltips.AuraInfo = {
    -- =====================
    -- PALADIN AURAS
    -- =====================

    -- Sanctity Aura: +10% Holy damage (Paladin)
    -- The aura buff appears on the player when active
    -- Improved Sanctity Aura talent adds +1% ALL damage per rank (checked separately)
    SANCTITY_AURA = {
        spellID = 20218,
        name = "Sanctity Aura",
        bonus = 0.10,
        school = "holy",
        class = "PALADIN",
        -- Improved Sanctity Aura adds +2% all damage when this aura is active
        improvedTalent = IMPROVED_SANCTITY_AURA_TALENT,
    },

    -- Vengeance: +1% damage per talent rank per stack, stacks 3x (Retribution talent)
    -- At 5/5 with 3 stacks = +15% physical and holy damage
    -- Buff procs after landing a critical strike
    VENGEANCE = {
        spellID = 20055,  -- Vengeance buff (rank 5, but all ranks use same buff name)
        name = "Vengeance",
        school = "all",  -- Affects physical and holy
        class = "PALADIN",
        isStacking = true,
        maxStacks = 3,
        -- Bonus is calculated dynamically based on talent ranks and stack count
        talentInfo = {
            tab = 3,
            index = 2,
            maxRanks = 5,
            perRank = 0.01,  -- 1% per rank per stack
        },
    },

    -- =====================
    -- HUNTER AURAS
    -- =====================

    -- Ferocious Inspiration: +3% damage to party after pet crit (Beast Mastery Hunter)
    -- This is a proc-based buff that appears on the player
    FEROCIOUS_INSPIRATION = {
        spellID = 34460,
        name = "Ferocious Inspiration",
        bonus = 0.03,
        school = "all",
        class = "HUNTER",
    },

    -- =====================
    -- MAGE AURAS
    -- =====================

    -- Arcane Empowerment: +3% all damage to party (Arcane Mage talent proc)
    -- Triggers when mage deals Arcane damage, buff appears on party members
    ARCANE_EMPOWERMENT = {
        spellID = 31583,
        name = "Arcane Empowerment",
        bonus = 0.03,
        school = "all",
        class = "MAGE",
    },

    -- =====================
    -- PRIEST AURAS
    -- =====================

    -- Power Infusion: +20% spell damage, -20% mana cost for 15s (Disc Priest)
    POWER_INFUSION = {
        spellID = 10060,
        name = "Power Infusion",
        bonus = 0.20,
        school = "all",  -- Affects all spell damage
        class = "PRIEST",
        isSpellOnly = true,  -- Only affects spells, not physical
    },

    -- Shadowform: +15% shadow damage (Shadow Priest self-buff)
    -- Note: Also tracked as talent, but buff must be active
    SHADOWFORM = {
        spellID = 15473,
        name = "Shadowform",
        bonus = 0.15,
        school = "shadow",
        class = "PRIEST",
        isSelfOnly = true,
    },

    -- =====================
    -- SHAMAN AURAS
    -- =====================

    -- Unleashed Rage: +10% AP to party after melee crit (Enhancement Shaman)
    -- Note: This is AP not damage%, but tracked for display purposes
    UNLEASHED_RAGE = {
        spellID = 30809,
        name = "Unleashed Rage",
        bonus = 0.0,  -- AP buff, not direct damage %
        school = "physical",
        class = "SHAMAN",
        isAPBuff = true,  -- Flag to indicate this is AP, not damage %
        apBonus = 0.10,   -- +10% AP
    },

    -- =====================
    -- WARLOCK AURAS
    -- =====================

    -- Demonic Pact: N/A in TBC (added in WotLK)

    -- =====================
    -- DRUID AURAS
    -- =====================

    -- Moonkin Aura: +5% spell crit (Balance Druid)
    -- Note: Crit bonus already reflected in GetSpellCritChance(), tracked for display
    MOONKIN_AURA = {
        spellID = 24907,
        name = "Moonkin Aura",
        bonus = 0.0,  -- Crit, not damage %
        school = "all",
        class = "DRUID",
        isCritBuff = true,
        critBonus = 0.05,  -- +5% spell crit
    },

    -- Leader of the Pack: +5% melee/ranged crit (Feral Druid)
    -- Note: Crit bonus already reflected in GetCritChance(), tracked for display
    LEADER_OF_THE_PACK = {
        spellID = 17007,
        name = "Leader of the Pack",
        bonus = 0.0,  -- Crit, not damage %
        school = "physical",
        class = "DRUID",
        isCritBuff = true,
        critBonus = 0.05,  -- +5% melee/ranged crit
    },

    -- =====================
    -- WARRIOR AURAS
    -- =====================

    -- Battle Shout: +AP (tracked for display)
    BATTLE_SHOUT = {
        spellID = 2048,
        name = "Battle Shout",
        bonus = 0.0,
        school = "physical",
        class = "WARRIOR",
        isAPBuff = true,
    },

    -- Commanding Shout: +HP (not damage, but tracked)
    -- Not adding as it doesn't affect damage

    -- =====================
    -- CONSUMABLE/EXTERNAL BUFFS
    -- =====================

    -- Drums of Battle: +80 haste rating (Leatherworking)
    DRUMS_OF_BATTLE = {
        spellID = 35476,
        name = "Drums of Battle",
        bonus = 0.0,  -- Haste, not direct damage
        school = "all",
        isHasteBuff = true,
    },

    -- Bloodlust: +30% haste (Shaman - Horde)
    BLOODLUST = {
        spellID = 2825,
        name = "Bloodlust",
        bonus = 0.0,  -- Haste, not direct damage
        school = "all",
        class = "SHAMAN",
        isHasteBuff = true,
        hasteBonus = 0.30,
    },

    -- Heroism: +30% haste (Shaman - Alliance)
    HEROISM = {
        spellID = 32182,
        name = "Heroism",
        bonus = 0.0,  -- Haste, not direct damage
        school = "all",
        class = "SHAMAN",
        isHasteBuff = true,
        hasteBonus = 0.30,
    },
}

-- Buff name to AuraInfo key lookup (for faster scanning)
local buffNameToKey = {}
for key, info in pairs(SpellTooltips.AuraInfo) do
    buffNameToKey[info.name] = key
end

-- Scan player buffs and update cache
function SpellTooltips.Auras.ScanPlayerBuffs()
    auraCache = {}

    -- Scan player buffs (index 1-40)
    for i = 1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
              nameplateShowPersonal, spellId = UnitBuff("player", i)

        if not name then break end  -- No more buffs

        -- Check if this buff matches any of our tracked auras
        local auraKey = buffNameToKey[name]
        if auraKey then
            auraCache[auraKey] = {
                active = true,
                stacks = count or 1,
                source = source,
                spellId = spellId,
            }
        end
    end

    cacheValid = true
end

-- Invalidate the aura cache (call on UNIT_AURA for player)
function SpellTooltips.Auras.InvalidateCache()
    cacheValid = false
    auraCache = {}
end

-- Refresh the cache if invalid
function SpellTooltips.Auras.RefreshCache()
    if not cacheValid then
        SpellTooltips.Auras.ScanPlayerBuffs()
    end
end

-- Check if a specific aura is active
function SpellTooltips.Auras.IsAuraActive(auraKey)
    SpellTooltips.Auras.RefreshCache()
    return auraCache[auraKey] and auraCache[auraKey].active or false
end

-- Get damage multiplier from active auras for a specific school
-- Returns multiplier (e.g., 1.10 for 10% bonus) and list of contributing auras
-- Auras are MULTIPLICATIVE with each other (1.1 × 1.03 = 1.133)
function SpellTooltips.Auras.GetSchoolMultiplier(school)
    if not school then return 1.0, {} end

    SpellTooltips.Auras.RefreshCache()

    local multiplier = 1.0
    local contributingAuras = {}
    local schoolLower = string.lower(school)

    for key, info in pairs(SpellTooltips.AuraInfo) do
        -- Check if aura buff is active on player
        local isActive = auraCache[key] and auraCache[key].active

        if isActive then
            -- Check if this aura applies to the given school
            local applies = false

            if info.school == "all" then
                applies = true
            elseif info.school and info.school == schoolLower then
                applies = true
            end

            if applies then
                local bonus = info.bonus or 0

                -- Handle stacking buffs with talent-based bonuses (e.g., Vengeance)
                if info.isStacking and info.talentInfo then
                    local Talents = SpellTooltips.Talents
                    if Talents and Talents.GetTalentRanks then
                        local talent = info.talentInfo
                        local ranks = Talents.GetTalentRanks(talent.tab, talent.index)
                        local stacks = auraCache[key].stacks or 1
                        bonus = ranks * talent.perRank * stacks
                    end
                end

                if bonus > 0 then
                    multiplier = multiplier * (1 + bonus)
                    table.insert(contributingAuras, {
                        name = info.name,
                        bonus = bonus,
                        key = key,
                    })
                end
            end

            -- Check for improved talent that adds ALL damage bonus
            if info.improvedTalent then
                local Talents = SpellTooltips.Talents
                if Talents and Talents.GetTalentRanks then
                    local talent = info.improvedTalent
                    local ranks = Talents.GetTalentRanks(talent.tab, talent.index)
                    local improvedBonus = ranks * talent.perRank
                    if improvedBonus > 0 then
                        multiplier = multiplier * (1 + improvedBonus)
                        table.insert(contributingAuras, {
                            name = "Improved " .. info.name,
                            bonus = improvedBonus,
                            key = key .. "_IMPROVED",
                        })
                    end
                end
            end
        end
    end

    return multiplier, contributingAuras
end

-- Get physical damage multiplier from active auras
-- Note: Some bonuses are already included in weapon damage by the game and are skipped here
-- Returns multiplier and list of contributing auras
-- Auras are MULTIPLICATIVE with each other
function SpellTooltips.Auras.GetPhysicalMultiplier()
    SpellTooltips.Auras.RefreshCache()

    local multiplier = 1.0
    local contributingAuras = {}

    for key, info in pairs(SpellTooltips.AuraInfo) do
        -- Check if aura buff is active on player
        local isActive = auraCache[key] and auraCache[key].active

        if isActive then
            -- Physical damage only benefits from "all" school auras
            if info.school == "all" then
                local bonus = info.bonus or 0

                -- Handle stacking buffs with talent-based bonuses (e.g., Vengeance)
                if info.isStacking and info.talentInfo then
                    local Talents = SpellTooltips.Talents
                    if Talents and Talents.GetTalentRanks then
                        local talent = info.talentInfo
                        local ranks = Talents.GetTalentRanks(talent.tab, talent.index)
                        local stacks = auraCache[key].stacks or 1
                        bonus = ranks * talent.perRank * stacks
                    end
                end

                if bonus > 0 then
                    multiplier = multiplier * (1 + bonus)
                    table.insert(contributingAuras, {
                        name = info.name,
                        bonus = bonus,
                        key = key,
                    })
                end
            end

            -- Check for improved talent that adds ALL damage bonus
            -- Skip if already included in weapon damage by the game
            if info.improvedTalent and not info.improvedTalent.isIncludedInWeaponDamage then
                local Talents = SpellTooltips.Talents
                if Talents and Talents.GetTalentRanks then
                    local talent = info.improvedTalent
                    local ranks = Talents.GetTalentRanks(talent.tab, talent.index)
                    local improvedBonus = ranks * talent.perRank
                    if improvedBonus > 0 then
                        multiplier = multiplier * (1 + improvedBonus)
                        table.insert(contributingAuras, {
                            name = "Improved " .. info.name,
                            bonus = improvedBonus,
                            key = key .. "_IMPROVED",
                        })
                    end
                end
            end
        end
    end

    return multiplier, contributingAuras
end

-- Get list of all active auras (for display/debugging)
-- Returns table of active aura info
function SpellTooltips.Auras.GetActiveAuras()
    SpellTooltips.Auras.RefreshCache()

    local activeList = {}

    for key, cacheEntry in pairs(auraCache) do
        if cacheEntry.active then
            local info = SpellTooltips.AuraInfo[key]
            if info then
                local auraEntry = {
                    key = key,
                    name = info.name,
                    bonus = info.bonus,
                    school = info.school,
                    stacks = cacheEntry.stacks,
                }

                -- Include special buff type info for display
                if info.isCritBuff then
                    auraEntry.isCritBuff = true
                    auraEntry.critBonus = info.critBonus
                end
                if info.isHasteBuff then
                    auraEntry.isHasteBuff = true
                    auraEntry.hasteBonus = info.hasteBonus
                end
                if info.isAPBuff then
                    auraEntry.isAPBuff = true
                    auraEntry.apBonus = info.apBonus
                end
                if info.isSpellOnly then
                    auraEntry.isSpellOnly = true
                end

                table.insert(activeList, auraEntry)
            end
        end
    end

    return activeList
end
