-- SpellTooltips Spell Tests
-- Compares calculated damage to actual combat log damage

SpellTooltips = SpellTooltips or {}
SpellTooltips.Tests = {}

local Tests = SpellTooltips.Tests

-- Test results storage
local testResults = {}
local isTracking = false

-- Tolerance for damage comparison (percentage)
local TOLERANCE = 0.02  -- 2% tolerance for rounding/resist variance

-- Combat log frame
local combatFrame = CreateFrame("Frame")

-- Get expected damage range for a spell
local function GetExpectedDamage(spellID)
    local spellData = SpellTooltips.GetSpellDataByID(spellID)
    if not spellData then return nil end

    local spellPower = SpellTooltips.GetSpellPowerForSpell(spellData)
    local modifiedCoeff = SpellTooltips.Talents.GetModifiedCoefficient(spellData)
    local multiplier = SpellTooltips.Talents.GetSchoolMultiplier(spellData.school)
    local bonusDamage = spellPower * modifiedCoeff

    -- We need base damage from tooltip, but we don't have it stored
    -- So we'll compare using coefficient contribution only
    return {
        spellData = spellData,
        spellPower = spellPower,
        coefficient = modifiedCoeff,
        multiplier = multiplier,
        bonusDamage = math.floor(bonusDamage * multiplier),
    }
end

-- Record a damage event
local function RecordDamage(spellID, spellName, damage, isCrit, resisted, school)
    if not testResults[spellID] then
        testResults[spellID] = {
            name = spellName,
            hits = {},
            crits = {},
            expected = GetExpectedDamage(spellID),
        }
    end

    local result = testResults[spellID]
    if isCrit then
        table.insert(result.crits, { damage = damage, resisted = resisted or 0 })
    else
        table.insert(result.hits, { damage = damage, resisted = resisted or 0 })
    end
end

-- Combat log event handler
local function OnCombatLogEvent(self, event, ...)
    if not isTracking then return end

    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
          destGUID, destName, destFlags, destRaidFlags = ...

    -- Only track our own damage
    if sourceGUID ~= UnitGUID("player") then return end

    -- Check for spell damage events
    if subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" then
        local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(12, ...)
        RecordDamage(spellID, spellName, amount, critical, resisted, spellSchool)
    end
end

-- Start tracking
function Tests.Start()
    isTracking = true
    testResults = {}
    combatFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    combatFrame:SetScript("OnEvent", function(self, event)
        OnCombatLogEvent(self, event, CombatLogGetCurrentEventInfo())
    end)
    print("|cFF00FF00SpellTooltips|r Test tracking |cFF00FF00STARTED|r. Cast spells to record damage.")
end

-- Stop tracking
function Tests.Stop()
    isTracking = false
    combatFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    print("|cFF00FF00SpellTooltips|r Test tracking |cFFFF0000STOPPED|r.")
end

-- Analyze and report results
function Tests.Report()
    print("|cFF00FF00SpellTooltips|r === Damage Test Report ===")

    local issues = {}

    for spellID, result in pairs(testResults) do
        local hitCount = #result.hits
        local critCount = #result.crits

        if hitCount > 0 or critCount > 0 then
            -- Calculate average non-crit damage
            local avgHit = 0
            if hitCount > 0 then
                local total = 0
                for _, hit in ipairs(result.hits) do
                    total = total + hit.damage
                end
                avgHit = total / hitCount
            end

            -- Calculate average crit damage
            local avgCrit = 0
            if critCount > 0 then
                local total = 0
                for _, crit in ipairs(result.crits) do
                    total = total + crit.damage
                end
                avgCrit = total / critCount
            end

            -- Get expected info
            local expected = result.expected
            local spellData = expected and expected.spellData

            -- Check crit multiplier if we have both hits and crits
            local actualCritMult = 0
            if avgHit > 0 and avgCrit > 0 then
                actualCritMult = avgCrit / avgHit
            end

            -- Report
            print(string.format("|cFFFFFF00[%d] %s|r", spellID, result.name))
            print(string.format("  Hits: %d (avg: %.0f)", hitCount, avgHit))
            print(string.format("  Crits: %d (avg: %.0f)", critCount, avgCrit))

            if expected then
                print(string.format("  SP Bonus: +%d (%.1f%% coeff, %.0f%% mult)",
                    expected.bonusDamage,
                    expected.coefficient * 100,
                    expected.multiplier * 100))
            end

            if actualCritMult > 0 then
                local expectedCritMult = 1.5
                if spellData then
                    expectedCritMult = SpellTooltips.Talents.GetCritDamageMultiplier(spellData.school)
                end
                local critDiff = math.abs(actualCritMult - expectedCritMult)
                local critStatus = critDiff < 0.05 and "|cFF00FF00OK|r" or "|cFFFF0000MISMATCH|r"
                print(string.format("  Crit Mult: %.2fx (expected %.2fx) %s", actualCritMult, expectedCritMult, critStatus))

                if critDiff >= 0.05 then
                    table.insert(issues, string.format("%s: Crit multiplier %.2fx vs expected %.2fx", result.name, actualCritMult, expectedCritMult))
                end
            end

            -- Check if spell is marked canCrit=false but we got crits
            if spellData and spellData.canCrit == false and critCount > 0 then
                print("  |cFFFF0000WARNING: Spell marked canCrit=false but crits were recorded!|r")
                table.insert(issues, string.format("%s: Marked canCrit=false but got %d crits", result.name, critCount))
            end

            -- Check if spell should crit but didn't
            if spellData and spellData.canCrit ~= false and hitCount > 10 and critCount == 0 then
                print(string.format("  |cFFFFFF00NOTE: No crits recorded in %d hits (may need more samples)|r", hitCount))
            end
        end
    end

    -- Summary
    print("|cFF00FF00SpellTooltips|r === Summary ===")
    if #issues > 0 then
        print("|cFFFF0000Issues found:|r")
        for _, issue in ipairs(issues) do
            print("  - " .. issue)
        end
    else
        print("|cFF00FF00No issues detected.|r")
    end
end

-- Clear results
function Tests.Clear()
    testResults = {}
    print("|cFF00FF00SpellTooltips|r Test results cleared.")
end

-- Get raw results for inspection
function Tests.GetResults()
    return testResults
end

-- Slash command integration
local originalSlashHandler = SlashCmdList["SPELLTOOLTIPS"]
SlashCmdList["SPELLTOOLTIPS"] = function(msg)
    if msg == "test start" then
        Tests.Start()
    elseif msg == "test stop" then
        Tests.Stop()
    elseif msg == "test report" then
        Tests.Report()
    elseif msg == "test clear" then
        Tests.Clear()
    elseif msg == "test" then
        print("|cFF00FF00SpellTooltips|r Test commands:")
        print("  /stt test start - Start tracking damage")
        print("  /stt test stop - Stop tracking")
        print("  /stt test report - Show damage report")
        print("  /stt test clear - Clear recorded data")
    else
        originalSlashHandler(msg)
    end
end
