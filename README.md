# SpellTooltips

A World of Warcraft addon for TBC Anniversary (Classic Era) that enhances spell and ability tooltips with damage calculations, showing actual damage values based on your current gear, talents, and stats.

## Features

- **Real-time damage calculation**: Updates tooltip damage values based on Spell Power, Attack Power, or Ranged Attack Power
- **Full class coverage**: Supports both caster spells (SP) and physical abilities (AP/RAP) for all classes
- **Talent integration**: Automatically detects and applies talent bonuses (coefficient, multiplier, crit)
- **Aura detection**: Tracks active damage-boosting buffs (Sanctity Aura, Ferocious Inspiration)
- **Damage breakdown**: Shows base damage, stat bonuses, talent multipliers, and aura bonuses
- **School-colored damage**: Damage values colored by school (fire, frost, physical, etc.)
- **Special ability notes**: Shows requirements like "Behind target" or "Stealth required"

## Installation

1. Download or clone this repository
2. Copy the `SpellTooltips` folder to your WoW TBC Classic `Interface/AddOns/` directory
3. Restart WoW or type `/reload` in-game
4. Enable the addon at character selection if needed

## Usage

Simply hover over any supported spell or ability in your spellbook or action bar. The tooltip will display calculated damage values.

### Caster Spell Example (Mage)
```
Frostbolt
Rank 13
195 Mana                           30 yd range
3 sec cast

Launches a bolt of frost at the enemy, causing 1096 to 1140 Frost
damage and slowing movement speed by 40% for 9 sec.

Base: 530-570
Bonus: +457 (91.4% SP)
Talents: +11%
```

### Physical Ability Example (Warrior)
```
Mortal Strike
Rank 6

A vicious strike that deals 856-912 damage and wounds the
target, reducing the effectiveness of any healing by 50% for 10 sec.

Damage: 856-912 (100% wpn + +210 flat)
Crit: 1712-1824 (25.4% @ 2.00x)
Talents: +15%
```

### Ranged Ability Example (Hunter)
```
Steady Shot

A steady shot that causes 450-520 damage.

Damage: 450-520 (100% wpn + 20% RAP + +150 flat)
Crit: 900-1040 (28.2% @ 2.30x)
```

### Slash Commands

| Command | Description |
|---------|-------------|
| `/stt` | Show addon info and commands |
| `/stt debug` | Toggle debug mode (shows processing info) |
| `/stt talents` | Show detected talents and their indices |
| `/stt spells` | Show registered spell IDs |
| `/stt auras` | Show active damage-boosting auras |
| `/stt seal` | Debug Seal of Righteousness calculation (Paladin) |

**Tip:** Hold Shift while hovering to see the original unmodified tooltip.

## Supported Classes

### Caster Spells (Spell Power)
- **Mage**: Fire, Frost, Arcane spells (~30 spells)
- **Warlock**: Shadow/Fire damage, DoTs (~25 spells)
- **Priest**: Shadow damage, Holy damage/healing (~35 spells)
- **Druid**: Balance (Wrath, Starfire, Moonfire), Restoration healing (~20 spells)
- **Shaman**: Elemental (Lightning, Shocks), Restoration healing (~30 spells)
- **Paladin**: Holy damage/healing spells, Seals (~20 spells)

### Physical Abilities (Attack Power)
- **Warrior**: Mortal Strike, Bloodthirst, Heroic Strike, Whirlwind, etc. (~45 abilities)
- **Rogue**: Sinister Strike, Backstab, Ambush, Mutilate, etc. (~35 abilities)
- **Paladin**: Crusader Strike, Seal of Command (~5 abilities)
- **Druid (Feral)**: Claw, Shred, Mangle, Maul, Swipe, etc. (~25 abilities)
- **Shaman**: Stormstrike (~1 ability)

### Ranged Abilities (Ranged Attack Power)
- **Hunter**: Arcane Shot, Steady Shot, Aimed Shot, Multi-Shot, Serpent Sting, etc. (~50 abilities)

### Excluded Abilities

Some abilities are excluded due to dynamic resource scaling that changes frequently:
- **Execute** (Warrior) - Damage scales with remaining rage
- **Ferocious Bite** (Druid) - Converts remaining energy to damage
- **Eviscerate, Rupture, Envenom** (Rogue) - Combo point scaling
- **Rip** (Druid) - Combo point scaling

## Ability Data Format

### Caster Spells
```lua
[spellID] = {
    name = "Spell Name",
    coefficient = 0.857,      -- SP scaling
    school = "fire",          -- Damage school
    castTime = 2.5,           -- Cast time in seconds
    isHealing = true,         -- Optional: healing spell
    isDot = true,             -- Optional: DoT spell
    ticks = 8,                -- Optional: number of DoT ticks
}
```

### Physical Abilities
```lua
[spellID] = {
    name = "Ability Name",
    school = "physical",
    isPhysical = true,
    weaponDamagePercent = 1.0,   -- 100% weapon damage
    apCoefficient = 0.45,        -- 45% of AP
    flatDamage = 98,             -- Flat damage bonus
    isNormalized = true,         -- Uses normalized weapon speed
    isBleed = true,              -- Ignores armor
    requiresBehind = true,       -- Must be behind target
}
```

### Ranged Abilities
```lua
[spellID] = {
    name = "Shot Name",
    school = "physical",
    isPhysical = true,
    isRanged = true,             -- Uses RAP instead of AP
    weaponDamagePercent = 1.0,   -- 100% weapon damage
    rapCoefficient = 0.20,       -- 20% of RAP
    flatDamage = 150,            -- Flat damage bonus
}
```

## Talent Support

The addon automatically detects and applies talent bonuses:

- **Coefficient Modifiers**: Talents that increase spell power coefficient (e.g., Empowered Fireball)
- **Damage Multipliers**: Talents that increase all damage for a school (e.g., Fire Power)
- **Physical Multipliers**: Talents that increase physical damage (e.g., Two-Handed Weapon Specialization)
- **Crit Chance Bonuses**: Talents that increase critical strike chance
- **Crit Damage Multipliers**: Talents that increase critical strike damage (e.g., Ice Shards)

## Aura Support

The addon detects active party/raid buffs that affect damage calculations:

| Aura | Source | Bonus | Affects |
|------|--------|-------|---------|
| Sanctity Aura | Paladin | +10% | Holy damage spells |
| Ferocious Inspiration | Hunter (BM) | +3% | All damage |

## File Structure

```
SpellTooltips/
├── SpellTooltips.toc    # Addon manifest
├── Core.lua             # Main tooltip logic (SP + AP/RAP)
├── Utils.lua            # Helper functions
├── SpellData.lua        # Spell lookup functions
├── TalentData.lua       # Talent definitions and caching
├── AuraData.lua         # Aura/buff detection
├── Tags.lua             # Spell classification tags
├── SpellTests.lua       # Testing framework
├── Classes/
│   ├── Mage.lua         # Mage spell coefficients
│   ├── Warlock.lua      # Warlock spell coefficients
│   ├── Priest.lua       # Priest spell coefficients
│   ├── Druid.lua        # Druid spells + feral abilities
│   ├── Shaman.lua       # Shaman spells + Stormstrike
│   ├── Paladin.lua      # Paladin spells + physical
│   ├── Warrior.lua      # Warrior physical abilities
│   ├── Rogue.lua        # Rogue physical abilities
│   └── Hunter.lua       # Hunter RAP abilities
└── README.md
```

## Troubleshooting

### Tooltip not updating
1. Check if the addon is loaded: `/stt`
2. Enable debug mode: `/stt debug`
3. Verify spell is registered: `/stt spells`

### Talent bonuses not applying
1. Check talent detection: `/stt talents`
2. Respec or relog to refresh talent cache

### Wrong damage values
- The addon uses Wowhead datamined coefficients for TBC
- Abilities with no scaling (coefficient 0.0) are skipped
- Hold Shift to see original tooltip and compare

## Version History

### 4.1.0 (Current)
- **Fix**: Corrected weapon damage calculations - abilities now properly use base vs total weapon damage
  - Seal of Command, Seal of Righteousness: Use base weapon damage (without AP)
  - Steady Shot: Uses base ranged damage + separate RAP scaling (no double-counting)
  - Standard physical abilities (Mortal Strike, etc.): Use total weapon damage (correct)
- **Fix**: Corrected crit damage multiplier formula for all classes
  - Talents now properly increase the crit BONUS, not the total
  - Example: Ice Shards 5/5 = 2.0x crit (was incorrectly showing 2.5x)
  - Spell Power + Ice Shards = 2.25x crit (correct stacking)
- **Fix**: Fixed Seal of Command stunned damage to properly double base damage
- **Fix**: Judgement of Righteousness coefficient corrected to 71.4% (was 73%)
- **Added**: Crit damage display for Judgement sections in seal tooltips
- **Added**: Crit damage display for multi-part spells
- **Added**: Proper categorization of crit damage talents (physical/school/spell-specific)
- **Added**: DAMAGE_FORMULAS.md - comprehensive damage calculation reference

### 4.0.0
- **Major feature**: Added Attack Power (AP) and Ranged Attack Power (RAP) support
- All melee and ranged physical abilities now supported
- Added Warrior abilities: Mortal Strike, Bloodthirst, Heroic Strike, Whirlwind, etc.
- Added Rogue abilities: Sinister Strike, Backstab, Ambush, Mutilate, etc.
- Added Hunter abilities: Arcane Shot, Steady Shot, Aimed Shot, Multi-Shot, etc.
- Updated Druid feral abilities: Claw, Shred, Mangle, Maul, Swipe, etc.
- Added Shaman Stormstrike
- Added normalized weapon speed support (1.7/2.4/3.3/2.8/1.0)
- Added special ability notes (Behind target, Stealth required, Bleed)
- Unified SP and AP/RAP into single addon

### 3.0.1
- Fixed One-Handed Weapon Specialization to only apply with 1H weapons equipped
- Fixed Seal of Righteousness damage formula
- Added weapon caching system (refreshes on equipment change)
- Added `/stt seal` debug command for Paladin seal calculations
- Fixed aura multipliers to be multiplicative

### 3.0.0
- Major refactor of caster spell handling
- Improved talent detection system
- Added aura/buff detection for damage multipliers

### 2.0.0
- Initial caster spell support for all classes

### 1.0.0
- Initial release with Mage spell support

## Credits

- Spell coefficients sourced from [Wowhead TBC Classic](https://www.wowhead.com/tbc/)
- AP/RAP formulas from Elitist Jerks TBC archives
- Built for TBC Anniversary (Interface 20504)

## License

MIT License
