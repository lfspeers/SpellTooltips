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
SpellTooltips.AuraInfo = {
    -- =====================
    -- PALADIN AURAS
    -- =====================

    -- Sanctity Aura: +10% Holy damage (Paladin)
    -- The aura buff appears on the player when active
    SANCTITY_AURA = {
        spellID = 20218,
        name = "Sanctity Aura",
        bonus = 0.10,
        school = "holy",
        class = "PALADIN",
    },

    -- Note: Improved Sanctity Aura (+2% all damage) is a talent that modifies
    -- Sanctity Aura. It doesn't create a separate buff, so we can't detect it
    -- via buff scanning. The bonus would need talent checking to implement.

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
function SpellTooltips.Auras.GetSchoolMultiplier(school)
    if not school then return 1.0, {} end

    SpellTooltips.Auras.RefreshCache()

    local totalBonus = 0
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
                totalBonus = totalBonus + info.bonus
                table.insert(contributingAuras, {
                    name = info.name,
                    bonus = info.bonus,
                    key = key,
                })
            end
        end
    end

    return 1 + totalBonus, contributingAuras
end

-- Get physical damage multiplier from active auras
-- Returns multiplier and list of contributing auras
function SpellTooltips.Auras.GetPhysicalMultiplier()
    SpellTooltips.Auras.RefreshCache()

    local totalBonus = 0
    local contributingAuras = {}

    for key, info in pairs(SpellTooltips.AuraInfo) do
        -- Check if aura buff is active on player
        local isActive = auraCache[key] and auraCache[key].active

        if isActive then
            -- Physical damage only benefits from "all" school auras
            if info.school == "all" then
                totalBonus = totalBonus + info.bonus
                table.insert(contributingAuras, {
                    name = info.name,
                    bonus = info.bonus,
                    key = key,
                })
            end
        end
    end

    return 1 + totalBonus, contributingAuras
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
                table.insert(activeList, {
                    key = key,
                    name = info.name,
                    bonus = info.bonus,
                    school = info.school,
                    stacks = cacheEntry.stacks,
                })
            end
        end
    end

    return activeList
end
