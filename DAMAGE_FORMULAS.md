# SpellTooltips Damage Calculation Reference

This document describes how damage is calculated for every ability type in the addon.

---

## Table of Contents

1. [Master Formulas](#master-formulas)
2. [Multiplier System](#multiplier-system)
3. [Critical Strikes](#critical-strikes)
4. [Abilities by Class](#abilities-by-class)

---

## Master Formulas

### 1. Caster Spells (Spell Power Scaling)

**Direct Damage:**
```
finalDamage = (baseDamage + SP * coefficient) * talentMultiplier * auraMultiplier
```

**DoT/HoT (per tick):**
```
tickDamage = (baseTickDamage + SP * dotCoefficient / ticks) * talentMultiplier * auraMultiplier
```

**Channeled Spells:**
```
perTickDamage = (basePerTick + SP * coefficient / ticks) * talentMultiplier * auraMultiplier
```

| Field | Description |
|-------|-------------|
| `coefficient` | SP scaling for direct damage (0.0 - 1.15) |
| `dotCoefficient` | SP scaling for DoT/HoT total (0.0 - 1.2) |
| `ticks` | Number of ticks for DoT/HoT/channeled |
| `castTime` | Cast time in seconds (affects coefficient display) |

---

### 2. Physical Abilities (Weapon + AP Scaling)

**Standard Physical (weapon damage only):**
```
finalDamage = (weaponDamage * weaponPercent + flatDamage) * talentMultiplier * auraMultiplier
```
- `weaponDamage` = total weapon damage (includes AP contribution from white swings)

**Physical with Separate AP Scaling (e.g., Steady Shot):**
```
finalDamage = (baseWeaponDamage * weaponPercent + AP * apCoeff + flatDamage) * talentMultiplier * auraMultiplier
```
- `baseWeaponDamage` = weapon tooltip damage (WITHOUT AP contribution)
- Uses base damage to avoid double-counting AP

**Pure AP Scaling (e.g., Bloodthirst):**
```
finalDamage = (AP * apCoefficient) * talentMultiplier * auraMultiplier
```

**Normalized vs Non-Normalized:**
- Normalized abilities use fixed weapon speeds for AP contribution:
  - Dagger: 1.7s
  - One-Hand: 2.4s
  - Two-Hand: 3.3s
  - Ranged: 2.8s
  - Feral: 1.0s (cat), 2.5s (bear)
- Non-normalized use actual weapon speed

| Field | Description |
|-------|-------------|
| `weaponDamagePercent` | Weapon damage multiplier (0.5 - 2.5) |
| `apCoefficient` | Melee AP scaling (0.0 - 0.45) |
| `rapCoefficient` | Ranged AP scaling (0.0 - 0.20) |
| `flatDamage` | Flat bonus damage added |
| `isNormalized` | Uses normalized weapon speed |
| `normalizedSpeed` | Override normalized speed |

---

### 3. Paladin Seals

**Seal of Command (Proc):**
```
procDamage = (baseWeaponDamage * 0.70 + SP * 0.29) * talentMultiplier * auraMultiplier
```
- Uses BASE weapon damage (not AP-modified)
- 7 PPM proc rate

**Seal of Command (Stunned/Incapacitated):**
```
stunnedDamage = baseProcDamage * 2
```
- Simply doubles the proc damage vs stunned targets

**Seal of Command (Judgement):**
```
judgementDamage = (baseJudgement + SP * 0.43) * talentMultiplier * auraMultiplier
```
- Uses melee crit chance

**Seal of Righteousness (Proc):**
```
procDamage = baseDamage + SP * (0.092 or 0.108) * weaponSpeed + baseWeaponDamage * 0.03
```
- 1H weapons: 0.092 coefficient per weapon speed
- 2H weapons: 0.108 coefficient per weapon speed
- Plus 3% of average weapon damage

**Seal of Righteousness (Judgement):**
```
judgementDamage = (baseJudgement + SP * 0.714) * talentMultiplier * auraMultiplier
```
- Uses spell crit chance

---

## Multiplier System

### Talent Multipliers

Applied multiplicatively to final damage:
- **School Multipliers**: Affect all spells of a damage school (e.g., Fire Power +10%)
- **Spell Multipliers**: Affect specific spells (e.g., Improved Mortal Strike)
- **Physical Multipliers**: Affect physical abilities (e.g., Two-Handed Weapon Spec)

### Aura Multipliers

Applied multiplicatively after talents:
- Sanctity Aura: +10% holy damage
- Ferocious Inspiration: +3% all damage
- Curse of Elements: +10% arcane/fire/frost damage

**Total Multiplier:**
```
totalMultiplier = talentSchoolMult * talentSpellMult * auraMult
```

---

## Critical Strikes

Crit talents increase the **bonus** portion, not the total multiplier.

### Spell Crit
```
baseCritBonus = 0.5 (50% extra damage)
finalCritBonus = baseCritBonus * (1 + talentBonus)
critMultiplier = 1.0 + finalCritBonus
```

Example - Frost Mage with 5/5 Ice Shards (+100% crit bonus):
```
finalCritBonus = 0.5 * (1 + 1.0) = 0.5 * 2.0 = 1.0
critMultiplier = 1.0 + 1.0 = 2.0 (200% crit damage)
```

### Physical/Melee Crit
```
baseCritBonus = 1.0 (100% extra damage)
finalCritBonus = baseCritBonus * (1 + talentBonus)
critMultiplier = 1.0 + finalCritBonus
```

Example - Warrior with 2/2 Impale (+20% crit bonus):
```
finalCritBonus = 1.0 * (1 + 0.20) = 1.0 * 1.2 = 1.2
critMultiplier = 1.0 + 1.2 = 2.2 (220% crit damage)
```

### Crit Damage Talent Categories

| Category | Talents | Applies To |
|----------|---------|------------|
| Global Spell | Spell Power (Mage) | All spells |
| School-Specific | Ice Shards (Mage) | Frost spells only |
| Spell-Specific | Ruin (Warlock), Vengeance (Druid), Elemental Fury (Shaman) | Listed spells only |
| Physical | Impale (Warrior), Lethality (Rogue), Mortal Shots (Hunter) | Physical abilities only |

Multiple bonuses stack additively before multiplying the base bonus:
```
talentBonus = globalBonus + schoolBonus + spellBonus
finalCritBonus = baseCritBonus * (1 + talentBonus)
```

---

## Abilities by Class

### Druid

#### Balance (Caster)

| Ability | School | Coefficient | DoT Coeff | Ticks | Notes |
|---------|--------|-------------|-----------|-------|-------|
| Moonfire | Arcane | 15% | 52% | 4 | DD + DoT |
| Starfire | Arcane | 100% | - | - | 3.5s cast |
| Wrath | Nature | 57.1% | - | - | 2.0s cast |
| Hurricane | Nature | 10.7% | - | 10 | Channeled |
| Insect Swarm | Nature | - | 76% | 6 | DoT only |

#### Feral (Physical)

| Ability | Weapon% | Flat | Normalized | Speed | Notes |
|---------|---------|------|------------|-------|-------|
| Claw | - | 16-130 | Yes | 1.0 | Cat |
| Shred | 225% | 36-252 | Yes | 1.0 | Behind target |
| Mangle (Cat) | 160% | 146-208 | Yes | 1.0 | +30% bleed |
| Mangle (Bear) | 115% | 128-182 | Yes | 2.5 | +30% bleed |
| Maul | 100% | 18-176 | Yes | 2.5 | Bear |
| Rake | - | 19-78 | - | - | Bleed DoT |
| Swipe | - | 18-108 | - | - | +7% AP |
| Lacerate | - | 31 | - | - | +1% AP, stacking |

#### Restoration (Healing)

| Ability | Coefficient | DoT Coeff | Ticks | Notes |
|---------|-------------|-----------|-------|-------|
| Healing Touch | 100% | - | - | 3.5s cast |
| Regrowth | 28.6% | 70% | 7 | DD + HoT |
| Rejuvenation | - | 80% | 4 | HoT only |
| Lifebloom | 34.3% | 52% | 7 | HoT + bloom |
| Swiftmend | 50% | - | - | Consumes HoT |
| Tranquility | 114% | - | 4 | Channeled |

---

### Hunter

| Ability | Weapon% | RAP Coeff | Flat | Notes |
|---------|---------|-----------|------|-------|
| Steady Shot | 100% | 20% | 150 | Uses BASE ranged dmg |
| Aimed Shot | 100% | - | 70-870 | |
| Multi-Shot | 100% | - | 0-205 | |
| Auto Shot | 100% | - | - | |
| Arcane Shot | - | 15% | 13-273 | Arcane school |
| Raptor Strike | 100% | - | 5-170 | Melee, normalized |
| Serpent Sting | - | 20% | - | DoT, 5 ticks |
| Volley | - | 10% | - | Channeled, 6 ticks |

---

### Mage

#### Fire

| Ability | Coefficient | DoT Coeff | Ticks | Notes |
|---------|-------------|-----------|-------|-------|
| Fireball | 100% | - | - | 3.5s cast |
| Fire Blast | 42.8% | - | - | Instant |
| Scorch | 42.8% | - | - | 1.5s cast |
| Flamestrike | 23.6% | 3% | 4 | DD + DoT |
| Blast Wave | 19.3% | - | - | AoE instant |
| Dragon's Breath | 19.3% | - | - | AoE instant |
| Incinerate | 71.4% | - | - | 2.5s cast |

#### Frost

| Ability | Coefficient | Notes |
|---------|-------------|-------|
| Frostbolt | 81.4% | 3.0s cast |
| Cone of Cold | 19.3% | AoE instant |
| Blizzard | 95.2% | Channeled, 8 ticks |
| Ice Barrier | 10% | Absorb |

#### Arcane

| Ability | Coefficient | Ticks | Notes |
|---------|-------------|-------|-------|
| Arcane Blast | 71.4% | - | 2.5s cast |
| Arcane Missiles | 100% | 5 | Channeled |

---

### Paladin

#### Holy/Retribution

| Ability | Type | Scaling | Notes |
|---------|------|---------|-------|
| Seal of Command | Proc | 70% wpn + 29% SP | 7 PPM |
| Seal of Command | Judgement | 43% SP | Melee crit |
| Seal of Righteousness | Proc | 9.2-10.8% SP/speed | +3% wpn |
| Seal of Righteousness | Judgement | 71.4% SP | Spell crit |
| Crusader Strike | Physical | 110% wpn | |
| Consecration | Holy | 95.2% SP | 8 ticks |
| Exorcism | Holy | 42.9% SP | vs Undead/Demon |
| Hammer of Wrath | Holy | 42.9% SP | Execute range |
| Holy Shock | Holy | 42.9% SP | |
| Avenger's Shield | Holy | 9.5% SP | Prot talent |
| Holy Shield | Holy | 5% SP | Per block |

#### Healing

| Ability | Coefficient | Notes |
|---------|-------------|-------|
| Holy Light | 71.4% | 2.5s cast |
| Flash of Light | 42.9% | 1.5s cast |

---

### Priest

#### Shadow

| Ability | Coefficient | DoT Coeff | Ticks | Notes |
|---------|-------------|-----------|-------|-------|
| Mind Blast | 42.9% | - | - | 1.5s cast |
| Shadow Word: Death | 42.9% | - | - | Instant |
| Shadow Word: Pain | - | 110% | 6 | DoT only |
| Mind Flay | 57% | - | 3 | Channeled |
| Vampiric Touch | - | 100% | 5 | DoT |
| Devouring Plague | - | 80% | 8 | DoT |

#### Holy

| Ability | Coefficient | DoT Coeff | Notes |
|---------|-------------|-----------|-------|
| Smite | 71.4% | - | 2.5s cast |
| Holy Fire | 85.7% | 16.5% | DD + DoT |
| Holy Nova | 10.7% | - | AoE instant |

#### Healing

| Ability | Coefficient | DoT Coeff | Notes |
|---------|-------------|-----------|-------|
| Greater Heal | 85.7% | - | 3.0s cast |
| Flash Heal | 42.9% | - | 1.5s cast |
| Renew | - | 100% | HoT |
| Prayer of Healing | 28.6% | - | Group heal |
| Circle of Healing | 28.6% | - | Smart heal |
| Prayer of Mending | 42.9% | - | Bouncing |
| Binding Heal | 42.9% | - | Self + target |
| Power Word: Shield | 10% | - | Absorb |

---

### Rogue

| Ability | Weapon% | Flat | Normalized | Notes |
|---------|---------|------|------------|-------|
| Sinister Strike | 100% | 3-98 | Yes | |
| Backstab | 150% | 15-255 | Yes | Behind target |
| Ambush | 250% | 28-200 | Yes | Stealth |
| Hemorrhage | 110% | - | Yes | +dmg debuff |
| Mutilate | 100% | 101-141 | Yes | Behind, dual |
| Ghostly Strike | 125% | - | Yes | |
| Riposte | 150% | - | Yes | After parry |
| Shiv | 100% | - | Yes | Off-hand |
| Garrote | - | - | - | Bleed DoT |
| Gouge | - | 16-89 | - | Flat only |
| Kick | - | 27-112 | - | Flat only |

**Excluded:** Eviscerate, Rupture, Envenom (combo point scaling)

---

### Shaman

#### Elemental

| Ability | Coefficient | DoT Coeff | Ticks | Notes |
|---------|-------------|-----------|-------|-------|
| Lightning Bolt | 79.4% | - | - | 2.5s cast |
| Chain Lightning | 57.1% | - | - | 2.0s cast |
| Earth Shock | 38.6% | - | - | Instant |
| Frost Shock | 38.6% | - | - | Instant |
| Flame Shock | 15% | 52% | 4 | DD + DoT |

#### Totems

| Ability | Coefficient | Notes |
|---------|-------------|-------|
| Searing Totem | 16.7% | Per attack |
| Magma Totem | 6.7% | Per pulse |
| Fire Nova Totem | 21.4% | Explosion |

#### Enhancement

| Ability | Weapon% | Notes |
|---------|---------|-------|
| Stormstrike | 100% | NOT normalized |

#### Restoration

| Ability | Coefficient | Notes |
|---------|-------------|-------|
| Healing Wave | 85.7% | 3.0s cast |
| Lesser Healing Wave | 42.9% | 1.5s cast |
| Chain Heal | 71.4% | Bouncing |
| Earth Shield | 28.6% | Per charge |
| Healing Stream | 4.5% | Per tick |

---

### Warlock

#### Destruction

| Ability | Coefficient | DoT Coeff | Ticks | Notes |
|---------|-------------|-----------|-------|-------|
| Shadow Bolt | 85.7% | - | - | 3.0s cast |
| Incinerate | 71.4% | - | - | 2.5s cast |
| Searing Pain | 42.9% | - | - | 1.5s cast |
| Shadowburn | 42.9% | - | - | Instant |
| Conflagrate | 42.9% | - | - | Consumes Immolate |
| Soul Fire | 115% | - | - | 6.0s cast |
| Rain of Fire | 33% | - | 4 | Channeled |
| Hellfire | 28.6% | - | 15 | Channeled, self-dmg |

#### Affliction

| Ability | Coefficient | DoT Coeff | Ticks | Notes |
|---------|-------------|-----------|-------|-------|
| Corruption | - | 93.6% | 6 | DoT only |
| Curse of Agony | - | 120% | 12 | DoT, ramping |
| Curse of Doom | - | 200% | 1 | 60s DoT |
| Immolate | 20% | 65% | 5 | DD + DoT |
| Siphon Life | - | 100% | 10 | DoT + heal |
| Unstable Affliction | - | 100% | 5 | DoT |
| Drain Life | 71.4% | - | 5 | Channeled |
| Drain Soul | 42.9% | - | 5 | Channeled |
| Death Coil | 21.4% | - | - | Instant |

#### Special

| Ability | Notes |
|---------|-------|
| Seed of Corruption | DoT (25%) + Explosion (22%) |

---

### Warrior

| Ability | Weapon% | Flat | AP Coeff | Normalized | Notes |
|---------|---------|------|----------|------------|-------|
| Mortal Strike | 100% | 85-210 | - | Yes | |
| Bloodthirst | - | - | 45% | - | Pure AP |
| Heroic Strike | 100% | 11-208 | - | No | |
| Slam | 100% | 32-140 | - | No | Cast time |
| Whirlwind | 100% | - | - | Yes | AoE |
| Cleave | 100% | 5-100 | - | No | 2 targets |
| Overpower | 100% | 5-35 | - | Yes | After dodge |
| Devastate | 50% | - | - | Yes | Per Sunder |
| Shield Slam | - | 225-420 | - | - | Block value |
| Revenge | - | 45-219 | - | - | Flat only |
| Thunder Clap | - | 10-123 | - | - | AoE |
| Hamstring | - | 5-63 | - | - | |
| Rend | - | - | - | - | Bleed DoT |

**Excluded:** Execute (rage scaling)

---

## Field Reference

| Field | Type | Description |
|-------|------|-------------|
| `coefficient` | number | SP scaling for direct damage |
| `dotCoefficient` | number | SP scaling for DoT/HoT total |
| `ticks` | number | Number of ticks |
| `castTime` | number | Cast time in seconds |
| `school` | string | Damage school |
| `isHealing` | bool | Healing spell |
| `isDot` | bool | DoT/HoT spell |
| `isChanneled` | bool | Channeled spell |
| `isAbsorb` | bool | Absorption spell |
| `isPhysical` | bool | Physical ability |
| `isRanged` | bool | Ranged ability |
| `weaponDamagePercent` | number | Weapon damage multiplier |
| `apCoefficient` | number | Melee AP scaling |
| `rapCoefficient` | number | Ranged AP scaling |
| `flatDamage` | number | Flat bonus damage |
| `isNormalized` | bool | Uses normalized speed |
| `normalizedSpeed` | number | Override normalized speed |
| `isBleed` | bool | Bleed (ignores armor) |
| `requiresBehind` | bool | Must be behind target |
| `requiresStealth` | bool | Must be in stealth |
| `isSeal` | bool | Paladin seal |
| `spCoeff` | number | SP scaling for seals |
| `judgementCoef` | number | Judgement SP scaling |

---

## Sources

- Wowhead TBC Classic
- Elitist Jerks Archives
- In-game testing
