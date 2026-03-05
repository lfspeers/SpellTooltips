# SpellTooltips

A World of Warcraft addon for TBC Anniversary (Classic Era) that enhances **caster spell** tooltips with spell power calculations, showing actual damage values based on your current gear and talents.

> **Note:** Physical ability tooltips (Warrior, Rogue, Hunter melee, Druid feral) are handled by the separate **PhysicalTooltips** addon.

## Features

- **Real-time damage calculation**: Updates tooltip damage values to reflect your current spell power
- **Talent integration**: Automatically detects and applies talent bonuses (coefficient and multiplier)
- **Aura detection**: Tracks active damage-boosting buffs (Sanctity Aura, Ferocious Inspiration)
- **Damage breakdown**: Shows base damage, spell power bonus, talent multipliers, and aura bonuses
- **School-colored damage**: Damage values in tooltips are colored by spell school (fire, frost, arcane, etc.)
- **Conditional talent notes**: Shows conditional bonuses like Molten Fury (+20% below 20% HP)

## Installation

1. Download or clone this repository
2. Copy the `SpellTooltips` folder to your WoW TBC Classic `Interface/AddOns/` directory
3. Restart WoW or type `/reload` in-game
4. Enable the addon at character selection if needed

## Usage

Simply hover over any supported caster spell in your spellbook or action bar. The tooltip will display:

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

### Slash Commands

| Command | Description |
|---------|-------------|
| `/stt` | Show addon info and commands |
| `/stt debug` | Toggle debug mode (shows processing info) |
| `/stt talents` | Show detected talents and their indices |
| `/stt spells` | Show registered spell IDs |
| `/stt auras` | Show active damage-boosting auras |
| `/stt seal` | Debug Seal of Righteousness calculation (Paladin) |

## Supported Classes

SpellTooltips supports **caster spells** for all classes with spell power scaling:

- **Mage**: Fire, Frost, Arcane spells
- **Paladin**: Holy damage/healing spells, Seal of Righteousness
- **Warlock**: Shadow/Fire damage, DoTs
- **Priest**: Shadow damage, Holy damage/healing
- **Druid**: Balance (Wrath, Starfire, Moonfire), Restoration healing
- **Shaman**: Elemental (Lightning, Shocks), Restoration healing

Classes without spell power scaling spells (Warrior, Rogue, Hunter) have empty registrations - their physical abilities are handled by the PhysicalTooltips addon.

## Spell Coefficients

All coefficients are datamined from Wowhead for TBC Classic accuracy.

### Example: Mage Fire Spells

| Spell | Direct | DoT | Notes |
|-------|--------|-----|-------|
| Fireball | 100% | 0% | DoT does not scale |
| Pyroblast | 115% | 5% | |
| Fire Blast | 42.8% | - | Instant |
| Scorch | 42.8% | - | 1.5s cast |

See the full coefficient tables in the sections below for each class.

## Talent Support

The addon automatically detects and applies talent bonuses:

### Coefficient Modifiers
Talents that increase spell power coefficient (e.g., Empowered Fireball +15% to Fireball coefficient)

### Damage Multipliers
Talents that increase all damage for a school (e.g., Fire Power +10% fire damage)

### Crit Chance Bonuses
Talents that increase critical strike chance (shown in tooltip breakdown)

### Crit Damage Multipliers
Talents that increase critical strike damage (e.g., Ice Shards +100% frost crit damage)

## Aura Support

The addon detects active party/raid buffs that affect damage calculations:

| Aura | Source | Bonus | Affects |
|------|--------|-------|---------|
| Sanctity Aura | Paladin | +10% | Holy damage spells |
| Ferocious Inspiration | Hunter (BM) | +3% | All damage |

Aura bonuses are shown in the tooltip breakdown as "Auras: +X%".

## File Structure

```
SpellTooltips/
├── SpellTooltips.toc    # Addon manifest
├── Core.lua             # Main tooltip logic (caster spells only)
├── Utils.lua            # Helper functions
├── SpellData.lua        # Spell lookup functions
├── TalentData.lua       # Talent definitions and caching
├── AuraData.lua         # Aura/buff detection for damage multipliers
├── Tags.lua             # Spell classification tags
├── SpellTests.lua       # Testing framework
├── Classes/
│   ├── Mage.lua         # Mage spell coefficients
│   ├── Paladin.lua      # Paladin Holy spells + Seals
│   ├── Warlock.lua      # Warlock spell coefficients
│   ├── Priest.lua       # Priest spell coefficients
│   ├── Druid.lua        # Druid Balance/Resto spells
│   ├── Shaman.lua       # Shaman Elemental/Resto spells
│   ├── Rogue.lua        # Empty (physical in PhysicalTooltips)
│   ├── Warrior.lua      # Empty (physical in PhysicalTooltips)
│   └── Hunter.lua       # Empty (uses RAP, not spell power)
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
- Spells with coefficient 0.0 (no spell power scaling) are skipped

## Version History

### 3.0.1 (Current)
- Fixed One-Handed Weapon Specialization to only apply with 1H weapons equipped
- Fixed Seal of Righteousness damage formula
- Added weapon caching system (refreshes on equipment change)
- Added `/stt seal` debug command for Paladin seal calculations
- Fixed aura multipliers to be multiplicative (Sanctity × Ferocious Inspiration)

### 3.0.0
- **Major refactor**: Separated caster spells from physical abilities
- Physical ability support moved to separate **PhysicalTooltips** addon
- SpellTooltips now only handles caster spells with spell power scaling
- Significantly simplified codebase and reduced performance overhead
- Removed all physical ability processing code

### 2.4.0
- Added aura/buff detection for damage multipliers
- Major performance optimization: talent bonuses pre-computed on login

### 2.3.0
- Added Hunter class support

### 2.2.0
- Added Warrior class support

### 2.1.0
- Added weapon type detection for normalized damage

### 2.0.0
- Added physical damage ability support (Rogue, etc.)

### 1.5.0
- Added Shaman spell support - All caster classes now supported!

### 1.0.0
- Initial release with Mage spell support

## Related Addons

- **PhysicalTooltips**: Companion addon for physical ability tooltips (Warrior, Rogue, Hunter, Druid feral)

## Credits

- Spell coefficients sourced from [Wowhead TBC Classic](https://www.wowhead.com/tbc/)
- Built for TBC Anniversary (Interface 20504)

## License

MIT License
