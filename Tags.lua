-- SpellTooltips Tag System
-- Provides consistent tagging for spell classification

SpellTooltips = SpellTooltips or {}

-- ===================
-- TAG CONSTANTS
-- ===================

SpellTooltips.Tags = {
    -- School (damage/healing type)
    Fire = "Fire",
    Frost = "Frost",
    Shadow = "Shadow",
    Holy = "Holy",
    Nature = "Nature",
    Arcane = "Arcane",
    Physical = "Physical",
    Frostfire = "Frostfire",  -- Dual school

    -- Delivery Method (how the spell reaches target)
    Direct = "Direct",           -- Instant hit on target
    DoT = "DoT",                 -- Damage over time
    HoT = "HoT",                 -- Heal over time
    Channeled = "Channeled",     -- Channeled spell
    Projectile = "Projectile",   -- Travels to target
    Ground = "Ground",           -- Placed on ground (Consecration, Blizzard)
    Totem = "Totem",             -- Summoned totem
    Proc = "Proc",               -- Reactive/triggered damage (Lightning Shield)
    Chain = "Chain",             -- Jumps between targets (Chain Lightning)

    -- Target Type (what it can hit)
    SingleTarget = "SingleTarget",
    AoE = "AoE",                 -- Area of effect (all in radius)
    Cone = "Cone",               -- Cone/arc in front (Cone of Cold, Dragon's Breath)
    Multitarget = "Multitarget", -- Hits multiple distinct targets (Multishot)
    Self = "Self",               -- Affects caster
    Friendly = "Friendly",       -- Targets friendly units
    Hostile = "Hostile",         -- Targets hostile units

    -- Cast Type
    Instant = "Instant",         -- No cast time
    Cast = "Cast",               -- Has cast time

    -- Effect Type
    Damage = "Damage",
    Healing = "Healing",
    Absorb = "Absorb",
    Buff = "Buff",
    Debuff = "Debuff",
    Slow = "Slow",
    Stun = "Stun",
    Silence = "Silence",
    Root = "Root",
    Knockback = "Knockback",

    -- Conditional
    Execute = "Execute",         -- Only below health threshold
    VsUndead = "VsUndead",       -- Only vs Undead
    VsDemon = "VsDemon",         -- Only vs Demons
    VsElemental = "VsElemental", -- Only vs Elementals
    Consumes = "Consumes",       -- Consumes another effect (Conflagrate)
    OnHit = "OnHit",             -- Triggers when hit (Lightning Shield)
    OnCrit = "OnCrit",           -- Triggers on crit
    Stacks = "Stacks",           -- Can stack (Lifebloom)

    -- Scaling
    SpellPower = "SpellPower",       -- Scales with spell power
    AttackPower = "AttackPower",     -- Scales with attack power
    NoScaling = "NoScaling",         -- Does not scale
    BonusCoeff = "BonusCoeff",       -- Has talent-modified coefficient

    -- Special Mechanics
    Binary = "Binary",           -- Cannot be partially resisted
    CanCrit = "CanCrit",         -- Can critically strike
    NoCrit = "NoCrit",           -- Cannot crit (most DoTs)
    Bounce = "Bounce",           -- Bounces between targets
    Splash = "Splash",           -- Deals splash damage
}

local T = SpellTooltips.Tags

-- ===================
-- HELPER FUNCTIONS
-- ===================

-- Check if a spell has a specific tag
function SpellTooltips.HasTag(spellData, tag)
    if not spellData or not spellData.tags then return false end
    for _, t in ipairs(spellData.tags) do
        if t == tag then return true end
    end
    return false
end

-- Check if a spell has ALL of the specified tags
function SpellTooltips.HasAllTags(spellData, ...)
    if not spellData or not spellData.tags then return false end
    local requiredTags = {...}
    for _, required in ipairs(requiredTags) do
        local found = false
        for _, t in ipairs(spellData.tags) do
            if t == required then
                found = true
                break
            end
        end
        if not found then return false end
    end
    return true
end

-- Check if a spell has ANY of the specified tags
function SpellTooltips.HasAnyTag(spellData, ...)
    if not spellData or not spellData.tags then return false end
    local searchTags = {...}
    for _, search in ipairs(searchTags) do
        for _, t in ipairs(spellData.tags) do
            if t == search then return true end
        end
    end
    return false
end

-- Get all spells with a specific tag
function SpellTooltips.GetSpellsByTag(tag)
    local results = {}
    for spellID, spellData in pairs(SpellTooltips.SpellData) do
        if SpellTooltips.HasTag(spellData, tag) then
            results[spellID] = spellData
        end
    end
    return results
end

-- Get all spells matching ALL specified tags
function SpellTooltips.GetSpellsByAllTags(...)
    local results = {}
    local requiredTags = {...}
    for spellID, spellData in pairs(SpellTooltips.SpellData) do
        if SpellTooltips.HasAllTags(spellData, unpack(requiredTags)) then
            results[spellID] = spellData
        end
    end
    return results
end

-- Get all spells matching ANY of the specified tags
function SpellTooltips.GetSpellsByAnyTag(...)
    local results = {}
    local searchTags = {...}
    for spellID, spellData in pairs(SpellTooltips.SpellData) do
        if SpellTooltips.HasAnyTag(spellData, unpack(searchTags)) then
            results[spellID] = spellData
        end
    end
    return results
end

-- Get all tags for a spell
function SpellTooltips.GetTags(spellData)
    if not spellData or not spellData.tags then return {} end
    return spellData.tags
end

-- Get tags as a formatted string (for display)
function SpellTooltips.GetTagsString(spellData, separator)
    if not spellData or not spellData.tags then return "" end
    separator = separator or ", "
    return table.concat(spellData.tags, separator)
end

-- Count spells by tag (useful for statistics)
function SpellTooltips.CountSpellsByTag()
    local counts = {}
    for spellID, spellData in pairs(SpellTooltips.SpellData) do
        if spellData.tags then
            for _, tag in ipairs(spellData.tags) do
                counts[tag] = (counts[tag] or 0) + 1
            end
        end
    end
    return counts
end

-- Get unique spell names by tag (since multiple ranks share same name)
function SpellTooltips.GetUniqueSpellNamesByTag(tag)
    local names = {}
    local seen = {}
    for spellID, spellData in pairs(SpellTooltips.SpellData) do
        if SpellTooltips.HasTag(spellData, tag) and not seen[spellData.name] then
            table.insert(names, spellData.name)
            seen[spellData.name] = true
        end
    end
    table.sort(names)
    return names
end

-- Validate that a spell has required tags based on its properties
-- Returns list of suggested tags based on spell data
function SpellTooltips.SuggestTags(spellData)
    local suggested = {}

    -- School
    if spellData.school then
        local school = spellData.school:sub(1,1):upper() .. spellData.school:sub(2)
        table.insert(suggested, school)
    end

    -- Cast type
    if spellData.castTime == 0 then
        table.insert(suggested, T.Instant)
    else
        table.insert(suggested, T.Cast)
    end

    -- Channeled
    if spellData.isChanneled then
        table.insert(suggested, T.Channeled)
    end

    -- DoT/HoT
    if spellData.isDot then
        if spellData.isHealing then
            table.insert(suggested, T.HoT)
        else
            table.insert(suggested, T.DoT)
        end
    end

    -- AoE
    if spellData.isAoE then
        table.insert(suggested, T.AoE)
    else
        table.insert(suggested, T.SingleTarget)
    end

    -- Healing vs Damage
    if spellData.isHealing then
        table.insert(suggested, T.Healing)
    else
        table.insert(suggested, T.Damage)
    end

    -- Scaling
    if spellData.coefficient and spellData.coefficient > 0 then
        table.insert(suggested, T.SpellPower)
    elseif spellData.dotCoefficient and spellData.dotCoefficient > 0 then
        table.insert(suggested, T.SpellPower)
    end

    -- Crit
    if spellData.canCrit == false then
        table.insert(suggested, T.NoCrit)
    else
        table.insert(suggested, T.CanCrit)
    end

    return suggested
end
