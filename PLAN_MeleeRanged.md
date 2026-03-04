# Plan: Melee and Ranged Abilities Support

## Overview

Melee and ranged abilities scale differently from spells:
- **Spells**: Scale with Spell Power using spell coefficients
- **Physical abilities**: Scale with Attack Power (AP) and often include weapon damage

## Key Differences from Spell Power

### 1. Attack Power Scaling
- AP bonus = (Attack Power / 14) * coefficient
- Coefficient is typically based on weapon speed or normalized speed
- Most instant attacks use **normalized weapon speed**:
  - Daggers: 1.7s
  - One-hand: 2.4s
  - Two-hand: 3.3s
  - Ranged: 2.8s

### 2. Weapon Damage Component
Many abilities include base weapon damage:
- "Weapon damage + X"
- "X% of weapon damage"
- "Weapon damage + (AP * coefficient)"

### 3. Ability Types

| Type | Scaling | Examples |
|------|---------|----------|
| Instant melee | Normalized AP + weapon | Sinister Strike, Mortal Strike |
| Next-swing | Unnormalized AP + weapon | Heroic Strike |
| Ranged | Normalized AP + weapon | Aimed Shot, Arcane Shot |
| Special | Fixed AP coefficient | Rupture, Eviscerate |
| Hybrid | AP + SP components | Some Paladin/Shaman abilities |

## Implementation Plan

### Phase 1: Core Infrastructure

1. **Add AP detection in Utils.lua**
   ```lua
   function Utils.GetPlayerAttackPower()
       local base, posBuff, negBuff = UnitAttackPower("player")
       return base + posBuff + negBuff
   end

   function Utils.GetPlayerRangedAttackPower()
       local base, posBuff, negBuff = UnitRangedAttackPower("player")
       return base + posBuff + negBuff
   end
   ```

2. **Add weapon info helpers in Core.lua**
   ```lua
   local function GetWeaponDamage(slot)
       -- slot: 16 = main hand, 17 = off hand, 18 = ranged
       local low, high = UnitDamage("player") -- for main hand
       return low, high
   end

   local function GetNormalizedSpeed(weaponType)
       local normalized = {
           DAGGER = 1.7,
           ONEHAND = 2.4,
           TWOHAND = 3.3,
           RANGED = 2.8,
       }
       return normalized[weaponType] or 2.4
   end
   ```

3. **New spell data fields**
   ```lua
   {
       name = "Sinister Strike",
       isPhysical = true,           -- Uses AP instead of SP
       apCoefficient = 0.0,         -- Direct AP scaling (if any)
       weaponDamage = true,         -- Includes weapon damage
       bonusDamage = 68,            -- Flat bonus damage
       normalized = true,           -- Uses normalized speed
       weaponType = "ONEHAND",      -- For normalization
   }
   ```

### Phase 2: New Tags

Add to Tags.lua:
```lua
-- Scaling Type
AttackPower = "AttackPower",
WeaponDamage = "WeaponDamage",
Normalized = "Normalized",

-- Weapon Types
MainHand = "MainHand",
OffHand = "OffHand",
Ranged = "Ranged",
TwoHand = "TwoHand",
```

### Phase 3: Tooltip Processing

1. **Detect physical abilities**
   - Check `isPhysical` flag on spell data
   - Use AP instead of SP for calculations

2. **Calculate damage**
   ```lua
   local function CalculatePhysicalDamage(spellData, weaponLow, weaponHigh)
       local ap = Utils.GetPlayerAttackPower()
       local normalizedSpeed = GetNormalizedSpeed(spellData.weaponType)

       -- AP contribution
       local apBonus = (ap / 14) * normalizedSpeed

       -- Total damage
       local minDmg = weaponLow + apBonus + (spellData.bonusDamage or 0)
       local maxDmg = weaponHigh + apBonus + (spellData.bonusDamage or 0)

       return minDmg, maxDmg
   end
   ```

3. **Pattern matching for physical tooltips**
   - "Deals X damage"
   - "An instant strike that causes X damage"
   - "weapon damage plus X"
   - "X% weapon damage"

### Phase 4: Class Abilities

#### Rogue
| Ability | Type | Notes |
|---------|------|-------|
| Sinister Strike | Norm MH + flat | +68 damage (rank 10) |
| Backstab | Norm MH * 1.5 + flat | Must be behind, +255 |
| Eviscerate | Flat + AP | Per combo point |
| Rupture | DoT, AP scaling | Per combo point |
| Hemorrhage | Norm MH + flat | Debuff |

#### Warrior
| Ability | Type | Notes |
|---------|------|-------|
| Mortal Strike | Norm MH + flat | +210 damage |
| Bloodthirst | 45% AP | No weapon damage |
| Whirlwind | Norm MH | Hits 4 targets |
| Execute | Flat + rage | Rage conversion |
| Heroic Strike | Next-swing + flat | Not normalized |

#### Hunter
| Ability | Type | Notes |
|---------|------|-------|
| Aimed Shot | Norm Ranged + flat | +870 damage |
| Multi-Shot | Norm Ranged + flat | +205 damage |
| Arcane Shot | RAP + flat | Magic damage |
| Steady Shot | Norm Ranged + flat | +150 + ammo |
| Serpent Sting | RAP DoT | 0.2 RAP per tick |

#### Retribution Paladin (Hybrid - Priority)

Ret Paladin is unique: abilities deal **Holy damage** but scale with **melee stats**.

**Seals (Weapon Damage Based)**
| Seal | Proc Damage | Judgement | Notes |
|------|-------------|-----------|-------|
| Seal of Command | 70% weapon dmg | 47% weapon + 9% SP + flat | Holy damage, 7 PPM |
| Seal of Blood | 35% weapon dmg | 70% weapon + flat | Self-damage component |
| Seal of the Martyr | 35% weapon dmg | 70% weapon + flat | Alliance version |
| Seal of Righteousness | Flat + SP | 73% SP | Already implemented |
| Seal of Vengeance | DoT stacking | Stacking debuff | Already implemented |

**Abilities**
| Ability | Type | Scaling | Notes |
|---------|------|---------|-------|
| Crusader Strike | 110% weapon | Holy damage | 6 sec CD, refreshes judgements |
| Judgement | Varies by seal | See above | 10 sec CD |
| Hammer of Wrath | 15% SP + 15% AP | Holy damage | Execute phase only |
| Consecration | SP only | Holy DoT | Already implemented |
| Exorcism | SP only | Holy + bonus vs UD/Demon | Already implemented |

**Ret Paladin Calculation Example - Seal of Command**
```lua
-- Seal proc (on melee hit)
local weaponDmg = (weaponLow + weaponHigh) / 2
local sealDamage = weaponDmg * 0.70  -- 70% weapon damage

-- Judgement of Command
local judgeDamage = (weaponDmg * 0.47) + (spellPower * 0.09) + flatBonus
-- If target stunned: damage * 2
```

**Ret Talents Affecting Damage**
| Talent | Effect | Affects |
|--------|--------|---------|
| Vengeance | +3/6/9/12/15% Holy dmg after crit | All Holy damage |
| Crusade | +1/2/3% dmg vs Humanoid/Demon/Undead/Elem | All damage |
| Sanctity Aura | +10% Holy damage | Party-wide |
| Improved Sanctity Aura | +2% damage to party | Stacks with Sanctity |
| Two-Handed Weapon Spec | +2/4/6% 2H damage | Physical portion |
| Fanaticism | +5/10/15/20/25% Judgement crit | Judgements only |
| Sanctified Seals | +1/2/3% melee crit | All melee |

**Implementation Notes for Ret:**
1. Need both weapon damage AND spell power for most abilities
2. Vengeance stacks - need to track buff or show "with X stacks"
3. Sanctity Aura bonus should be detected via buff
4. Holy damage but uses melee crit, not spell crit
5. Two-Handed Weapon Spec only affects weapon damage portion

**Seal of Command Spell Data**
```lua
[20375] = {
    name = "Seal of Command",
    school = "holy",
    isSeal = true,
    weaponDamagePercent = 0.70,  -- 70% weapon damage
    ppm = 7,                      -- 7 procs per minute
    -- Judgement portion
    judgement = {
        weaponDamagePercent = 0.47,
        spCoefficient = 0.09,
        flatDamage = 93,  -- Rank 6
        doubleIfStunned = true,
    },
}
```

#### Enhancement Shaman (Hybrid - Priority)

Enhancement uses both melee attacks and nature/fire spells. Key mechanic is **Windfury Weapon**.

**Weapon Enchants (Self-Buffs)**
| Enchant | Effect | Scaling |
|---------|--------|---------|
| Windfury Weapon | 20% chance: 2 extra attacks + 445 AP | Flat AP bonus |
| Flametongue Weapon | +X Fire damage per hit | 10% SP per hit |
| Rockbiter Weapon | Flat threat/damage | Threat only in TBC |

**Abilities**
| Ability | Type | Scaling | Notes |
|---------|------|---------|-------|
| Stormstrike | 2x weapon damage | Nature debuff | +20% nature dmg taken |
| Earth Shock | Nature instant | 38.6% SP | Interrupt |
| Flame Shock | Nature DoT + instant | 15% + 52% SP | Direct + DoT |
| Frost Shock | Frost instant | 38.6% SP | Slow |
| Shamanistic Rage | Mana regen | 30% AP = mana | Damage reduction |

**Windfury Calculation**
```lua
-- On melee hit, 20% chance to proc
local function CalculateWindfuryDamage(weaponLow, weaponHigh)
    local baseAP = Utils.GetPlayerAttackPower()
    local wfBonusAP = 445  -- Rank 5
    local totalAP = baseAP + wfBonusAP

    -- Two extra attacks with bonus AP
    local apBonus = (totalAP / 14) * normalizedSpeed
    local minDmg = weaponLow + apBonus
    local maxDmg = weaponHigh + apBonus

    return minDmg * 2, maxDmg * 2  -- Two attacks
end
```

**Enhancement Talents**
| Talent | Effect | Affects |
|--------|--------|---------|
| Elemental Weapons | +10/20/30% WF dmg, +20/40% FT dmg | Weapon enchants |
| Weapon Mastery | +2/4/6/8/10% melee damage | All melee |
| Unleashed Rage | +2/4/6/8/10% AP on crit | Party buff |
| Dual Wield Spec | +2/4/6% DW hit | Dual wield hit |
| Stormstrike | Talent ability | See above |
| Shamanistic Focus | -30% shock mana on crit | Shocks |

**Flametongue Weapon Calculation**
```lua
[8024] = {
    name = "Flametongue Weapon",
    school = "fire",
    isWeaponEnchant = true,
    flatDamage = 64,     -- Per hit, rank 8
    spCoefficient = 0.10, -- 10% SP per hit
    weaponSpeedScaling = true,  -- Scales with weapon speed
}
-- Damage per hit = (flatDamage + SP * 0.10) * (weaponSpeed / 2.6)
```

#### Feral Druid (Priority)

Feral is complex: Cat and Bear forms use different mechanics.

**Forms**
| Form | Weapon | Stats |
|------|--------|-------|
| Cat Form | Feral AP = (Level*2 + STR*2 + Weapon Feral AP) | Crit, Hit |
| Bear Form | Feral AP + armor from items | Crit, Defense |

**Cat Abilities**
| Ability | Type | Scaling | Notes |
|---------|------|---------|-------|
| Mangle (Cat) | 160% + flat | 264 damage | Bleed debuff |
| Shred | 225% + flat | 405 damage | Must be behind |
| Rake | DoT + initial | AP scaling | Bleed |
| Rip | DoT | AP per combo point | Bleed, finisher |
| Ferocious Bite | Flat + CP + energy | Converts energy | Finisher |
| Claw | 115% + flat | Low damage | Filler |
| Ravage | 385% + flat | 514 damage | Opener only |
| Pounce | Stun + bleed | AP DoT | Opener |

**Bear Abilities**
| Ability | Type | Scaling | Notes |
|---------|------|---------|-------|
| Mangle (Bear) | 115% + flat | 155 damage | Bleed debuff |
| Maul | Next-swing + flat | +176 damage | Not normalized |
| Swipe | Flat AoE | 84 damage | Threat |
| Lacerate | Stacking DoT | AP scaling | Bleed, stacks 5x |

**Feral AP Calculation**
```lua
local function GetFeralAttackPower()
    -- In forms, weapon is hidden but contributes "Feral AP"
    -- Total = (Level * 2) + (STR * 2) + Weapon Feral AP + Gear AP
    local base, pos, neg = UnitAttackPower("player")
    return base + pos + neg
end

-- Cat abilities use normalized 1.0s speed (very fast)
local CAT_NORMALIZED_SPEED = 1.0
```

**Bleed Calculations**
Bleeds scale with AP but ignore armor:
```lua
-- Rip (5 combo points)
local ripBaseDamage = 1092  -- 6 ticks base
local ripAPBonus = ap * 0.24 * comboPoints  -- ~24% AP per CP
local totalRip = ripBaseDamage + ripAPBonus

-- Rake
local rakeInitial = 78 + (ap * 0.01)
local rakeDoT = 108 + (ap * 0.06)  -- Over 9 sec
```

**Feral Talents**
| Talent | Effect | Affects |
|--------|--------|---------|
| Predatory Strikes | +50/100/150% level to AP | Feral AP |
| Savage Fury | +20% Claw/Rake/Mangle dmg | Those abilities |
| Shredding Attacks | -9/-18 Shred energy | Shred |
| Feral Aggression | +3/6/9/12/15% FB dmg | Ferocious Bite |
| Heart of the Wild | +20% STR in Cat | Cat form |
| Survival of the Fittest | +3% stats | All |
| Primal Fury | Extra CP on crit | Combo generation |
| Leader of the Pack | +5% melee crit | Party buff |

**Display Format for Feral**
```
Mangle (Cat)
Mangle the target, dealing 420-480 damage and causing
the target to take 30% additional damage from bleeds.

Feral AP: 2450
Base damage: 264
AP bonus: +156-196 (160% weapon)
Crit: 32.4% (+100% dmg)
```

### Phase 5: Talent Support

Physical talents to support:
- **Rogue**: Aggression, Lethality, Murder, Opportunity
- **Warrior**: Impale, Two-Handed Spec, Sword Spec
- **Hunter**: Ranged Weapon Spec, Mortal Shots, Barrage
- **Ret Paladin**: Vengeance, Crusade, Two-Handed Spec, Fanaticism, Sanctity Aura
- **Enh Shaman**: Elemental Weapons, Weapon Mastery, Unleashed Rage, Stormstrike
- **Feral Druid**: Predatory Strikes, Savage Fury, Heart of the Wild, Leader of the Pack

### Phase 6: Display Format

For physical abilities, show:
```
Sinister Strike
An instant strike that causes 450-520 damage.

Weapon: 382-420
AP bonus: +68 (2.4s normalized)
Flat bonus: +68
Crit: 25.4% (+100% dmg)
```

## File Changes Required

1. **Utils.lua**: Add AP/RAP functions
2. **Core.lua**: Add weapon helpers, physical damage calculation
3. **Tags.lua**: Add physical-related tags
4. **TalentData.lua**: Add physical talent definitions
5. **Classes/Rogue.lua**: New file
6. **Classes/Warrior.lua**: New file
7. **Classes/Hunter.lua**: New file
8. **Classes/Paladin.lua**: Add physical abilities
9. **Classes/Shaman.lua**: Add physical abilities

## Considerations

### Dual Wield
- Main hand and off-hand have separate damage
- Off-hand does 50% damage (or 75% with talents)
- Some abilities only use main hand

### Armor Reduction
- Physical damage is reduced by armor
- Consider showing "before armor" vs "after armor"?
- Probably too complex, just show raw damage

### Critical Strikes
- Physical crit = 200% damage (vs 150% for spells)
- Some talents modify this (Impale, Lethality)

### Hit Rating
- Physical hit cap differs from spell hit
- Dual wield has additional miss chance

## Priority Order

1. Core infrastructure (AP, weapon damage, normalized speeds)
2. **Retribution Paladin** - Seals, Judgements, Crusader Strike
3. **Enhancement Shaman** - Windfury, Stormstrike, weapon enchants
4. **Feral Druid** - Cat abilities, Bear abilities, bleeds
5. Rogue abilities
6. Warrior abilities
7. Hunter abilities

## Questions to Resolve

1. Show weapon damage breakdown or just final number?
2. Include armor reduction estimate?
3. Handle dual-wield display?
4. Support for weapon procs (Windfury, Sword Spec)?
