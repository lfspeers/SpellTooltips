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

#### Paladin (Hybrid)
| Ability | Type | Notes |
|---------|------|-------|
| Crusader Strike | Norm MH | 110% weapon damage |
| Seal of Command | % weapon damage | Procs on hit |

#### Shaman (Hybrid)
| Ability | Type | Notes |
|---------|------|-------|
| Stormstrike | Dual MH | 2x weapon damage |
| Windfury | Extra attacks | Bonus AP |

### Phase 5: Talent Support

Physical talents to support:
- **Rogue**: Aggression, Lethality, Murder, Opportunity
- **Warrior**: Impale, Two-Handed Spec, Sword Spec
- **Hunter**: Ranged Weapon Spec, Mortal Shots, Barrage

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

1. Core infrastructure (AP, weapon damage)
2. Rogue abilities (most straightforward)
3. Warrior abilities
4. Hunter abilities
5. Hybrid abilities (Paladin, Shaman)

## Questions to Resolve

1. Show weapon damage breakdown or just final number?
2. Include armor reduction estimate?
3. Handle dual-wield display?
4. Support for weapon procs (Windfury, Sword Spec)?
