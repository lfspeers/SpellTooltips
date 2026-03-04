# SpellTooltips

A World of Warcraft addon for TBC Anniversary (Classic Era) that enhances spell tooltips with spell power calculations, showing actual damage values based on your current gear and talents.

## Features

- **Real-time damage calculation**: Updates tooltip damage values to reflect your current spell power
- **Talent integration**: Automatically detects and applies talent bonuses (coefficient and multiplier)
- **Damage breakdown**: Shows base damage, spell power bonus, and talent multipliers
- **School-colored damage**: Damage values in tooltips are colored by spell school (fire, frost, arcane, etc.)
- **Conditional talent notes**: Shows conditional bonuses like Molten Fury (+20% below 20% HP)

## Installation

1. Download or clone this repository
2. Copy the `SpellTooltips` folder to your WoW TBC Classic `Interface/AddOns/` directory
3. Restart WoW or type `/reload` in-game
4. Enable the addon at character selection if needed

## Usage

Simply hover over any supported mage spell in your spellbook or action bar. The tooltip will display:

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
| `/stt scan 1\|2\|3` | Scan talent tree |
| `/stt scan 1\|2\|3 save` | Scan and save to SavedVariables file |
| `/stt test` | Show test commands |
| `/stt test start` | Start tracking damage from combat log |
| `/stt test stop` | Stop tracking damage |
| `/stt test report` | Show damage comparison report |
| `/stt test clear` | Clear recorded test data |

## Supported Classes

Currently supports **Mage**, **Paladin**, **Warlock**, **Priest**, **Druid**, and **Shaman**.

## Spell Coefficients (Wowhead Datamined)

### Fire Spells

| Spell | Direct | DoT | Notes |
|-------|--------|-----|-------|
| Fireball | 100% | 0% | DoT does not scale |
| Pyroblast | 115% | 5% | |
| Fire Blast | 42.8% | - | Instant |
| Scorch | 42.8% | - | 1.5s cast |
| Flamestrike | 23.6% | 3% | AoE |
| Dragon's Breath | 19.3% | - | Instant cone AoE, talent |
| Blast Wave | 19.3% | - | Instant AoE knockback, talent |

### Frost Spells

| Spell | Coefficient | Notes |
|-------|-------------|-------|
| Frostbolt | 81.4% | Reduced due to slow effect |
| Ice Lance | 14.3% | Triples on frozen targets |
| Frost Nova | 4.3% | Instant AoE CC |
| Cone of Cold | 19.3% | Instant AoE |
| Blizzard | 95.2% | Channeled AoE (11.9% × 8 ticks) |

### Arcane Spells

| Spell | Coefficient | Notes |
|-------|-------------|-------|
| Arcane Missiles | 100% | Channeled (20% × 5 waves) |
| Arcane Blast | 71.4% | 2.5s cast |
| Arcane Explosion | 21.4% | Instant AoE |

## Talent Support

### Coefficient Modifiers

These talents increase the spell power coefficient of specific spells:

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Empowered Fireball | Fire | 5 | +3% | +15% | Fireball |
| Empowered Frostbolt | Frost | 5 | +2% | +10% | Frostbolt |
| Empowered Arcane Missiles | Arcane | 3 | +15% | +45% | Arcane Missiles |

### Damage Multipliers

These talents increase all damage for their school:

| Talent | Tree | Ranks | Per Rank | Max |
|--------|------|-------|----------|-----|
| Fire Power | Fire | 5 | +2% | +10% |
| Playing with Fire | Fire | 3 | +1% | +3% |
| Piercing Ice | Frost | 3 | +2% | +6% |
| Arctic Winds | Frost | 5 | +1% | +5% |

### Conditional Multipliers

These are shown as notes but not applied to base calculations:

| Talent | Tree | Ranks | Per Rank | Max | Condition |
|--------|------|-------|----------|-----|-----------|
| Molten Fury | Fire | 2 | +10% | +20% | Target below 20% HP |

### Crit Chance Bonuses

These talents increase critical strike chance for specific spells or schools:

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Arcane Impact | Arcane | 3 | +2% | +6% | Arcane Blast, Arcane Explosion |
| Arcane Instability | Arcane | 3 | +1% | +3% | All spells |
| Incineration | Fire | 2 | +2% | +4% | Fire Blast, Scorch |
| Critical Mass | Fire | 3 | +2% | +6% | All fire spells |
| Improved Frostbolt | Frost | 5 | +1% | +5% | Frostbolt |

### Crit Damage Multipliers

These talents increase critical strike damage (base is 150% in TBC):

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Spell Power | Arcane | 2 | +25% | +50% | All spells |
| Ice Shards | Frost | 5 | +20% | +100% | Frost spells |

## Paladin Spell Coefficients (Wowhead Datamined)

### Damage Spells

| Spell | Coefficient | Cast Time | Notes |
|-------|-------------|-----------|-------|
| Consecration | 95.2% | Instant | AoE DoT (11.9% per tick x 8 ticks) |
| Holy Shock | 42.9% | Instant | |
| Exorcism | 42.9% | 1.5s | Demons/Undead only |
| Hammer of Wrath | 42.9% | Instant | Target below 20% HP |
| Holy Wrath | 28.6% | 2s | AoE, Demons/Undead only |
| Judgement of Righteousness | 72.8% | Instant | |
| Judgement of Command | 42.9% | Instant | Double damage if target stunned |
| Avenger's Shield | 7.1% | Instant | Protection talent, bounces 3 targets |
| Holy Shield | 5% | Instant | Per block, 4 charges (8 with Improved Holy Shield) |
| Judgement of Blood | 43% | Instant | From Seal of Blood (Horde) |
| Judgement of the Martyr | 43% | Instant | From Seal of the Martyr (Alliance) |

### Seal Spells (with Spell Power Scaling)

| Spell | Coefficient | Notes |
|-------|-------------|-------|
| Seal of Righteousness | 9.2% × speed (1H) / 10.8% × speed (2H) | Per melee hit, scales with weapon speed |
| Seal of Vengeance | 20% per stack (100% at 5) | Alliance, stacking DoT |
| Seal of Corruption | 20% per stack (100% at 5) | Horde, stacking DoT |

### Healing Spells

| Spell | Coefficient | Cast Time | Notes |
|-------|-------------|-----------|-------|
| Holy Light | 71.4% | 2.5s | |
| Flash of Light | 42.9% | 1.5s | |

## Paladin Talent Support

### Crit Chance Bonuses

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Holy Power | Holy | 5 | +1% | +5% | All spells |
| Sanctified Light | Holy | 3 | +2% | +6% | Holy Light |
| Conviction | Retribution | 5 | +1% | +5% | All spells |
| Fanaticism | Retribution | 5 | +3% | +15% | Judgement spells |

### Damage/Healing Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Sanctity Aura | Retribution | 1 | +10% | +10% | Holy damage (aura must be active) |
| Healing Light | Holy | 3 | +4% | +12% | Holy Light, Flash of Light |
| Improved Holy Shield | Protection | 2 | +10% | +20% | Holy Shield |

### Conditional Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Condition |
|--------|------|-------|----------|-----|-----------|
| Vengeance | Retribution | 3 | +5% | +15% | After critical strike (stacks 3x) |
| Crusade | Retribution | 3 | +3% | +9% | vs Humanoids, Demons, Undead, Elementals |

### Already in Spell Power

These Paladin talents modify your spell power stat directly and are already reflected in `GetSpellBonusDamage()`:

- Holy Guidance (+35% of Intellect as spell power)
- Divine Intellect (+10% total Intellect)

## Warlock Spell Coefficients (Wowhead Datamined)

### Direct Damage Spells

| Spell | Coefficient | Cast Time | Notes |
|-------|-------------|-----------|-------|
| Shadow Bolt | 85.7% | 3.0s | Main nuke |
| Incinerate | 71.4% | 2.5s | TBC spell |
| Searing Pain | 42.9% | 1.5s | High threat |
| Soul Fire | 115% | 6.0s | Long cast |
| Shadowburn | 42.9% | Instant | Talent, execute |
| Conflagrate | 42.9% | Instant | Consumes Immolate |
| Shadowfury | 19.5% | Instant | AoE stun |
| Death Coil | 21.4% | Instant | Horror + heal |

### DoT Spells

| Spell | Direct | DoT | Duration | Notes |
|-------|--------|-----|----------|-------|
| Immolate | 20% | 65% | 15s | |
| Corruption | - | 93.6% | 18s | Instant cast |
| Curse of Agony | - | 120% | 24s | Backloaded damage |
| Curse of Doom | - | 200% | 60s | Single tick |
| Siphon Life | - | 100% | 30s | Talent |
| Unstable Affliction | - | 100% | 18s | Talent, dispel damage |

### Channeled/AoE Spells

| Spell | Coefficient | Type | Notes |
|-------|-------------|------|-------|
| Drain Life | 71.4% | 5s channel | Also heals |
| Drain Soul | 42.9% | 15s channel | Soul shard |
| Hellfire | 28.6%/tick | Channeled AoE | Damages self |
| Rain of Fire | 33% total | Channeled AoE | |
| Seed of Corruption | 22% | AoE explosion | |

## Warlock Talent Support

### Coefficient Modifiers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Empowered Corruption | Affliction | 3 | +12% | +36% | Corruption |
| Shadow and Flame | Destruction | 5 | +4% | +20% | Shadow Bolt, Incinerate |

### Damage Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Shadow Mastery | Affliction | 5 | +2% | +10% | Shadow damage |
| Contagion | Affliction | 5 | +1% | +5% | Corruption, CoA, Seed |
| Emberstorm | Destruction | 5 | +2% | +10% | Fire damage |

### Crit Chance Bonuses

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Devastation | Destruction | 5 | +1% | +5% | Destruction spells |
| Backlash | Destruction | 3 | +1% | +3% | All spells |

### Crit Damage Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Ruin | Destruction | 1 | +100% | +100% | Destruction spells |

### Conditional Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Condition |
|--------|------|-------|----------|-----|-----------|
| Improved Shadow Bolt | Destruction | 5 | +4% | +20% | After SB crit (ISB debuff) |
| Malediction | Affliction | 3 | +1% | +3% | Target has Curse of Shadows/Elements |
| Soul Siphon | Affliction | 2 | +2% | +16% | Per affliction on target (max 4) |
| Demonic Sacrifice | Demonology | 1 | +15% | +15% | Imp (fire) or Succubus (shadow) |

### Already in Spell Power

These Warlock talents modify your spell power stat directly and are already reflected in `GetSpellBonusDamage()`:

- Demonic Knowledge (+12% of pet Stamina+Intellect as spell power)
- Fel Armor (spell damage from Spirit)

## Priest Spell Coefficients (Wowhead Datamined)

### Shadow Damage Spells

| Spell | Coefficient | Cast Time | Notes |
|-------|-------------|-----------|-------|
| Mind Blast | 42.9% | 1.5s | 8s cooldown |
| Shadow Word: Death | 42.9% | Instant | Backlash damage |
| Mind Flay | 57% | 3s channel | Slows target |
| Shadow Word: Pain | 110% DoT | Instant | 18s duration |
| Vampiric Touch | 100% DoT | 1.5s | Mana return, talent |
| Devouring Plague | 80% DoT | Instant | Undead only |

### Holy Damage Spells

| Spell | Direct | DoT | Cast Time | Notes |
|-------|--------|-----|-----------|-------|
| Smite | 71.4% | - | 2.5s | |
| Holy Fire | 85.7% | 16.5% | 3.5s | |
| Holy Nova | 10.7% | - | Instant | AoE damage + heal |

### Healing Spells

| Spell | Coefficient | Cast Time | Notes |
|-------|-------------|-----------|-------|
| Greater Heal | 85.7% | 3.0s | |
| Heal | 85.7% | 3.0s | |
| Flash Heal | 42.9% | 1.5s | |
| Binding Heal | 42.9% | 1.5s | Heals self + target |
| Renew | 100% HoT | Instant | 15s duration |
| Prayer of Healing | 28.6% | 3.0s | AoE heal |
| Circle of Healing | 28.6% | Instant | AoE heal, talent |
| Prayer of Mending | 42.9% | Instant | Bounces on damage |

## Priest Talent Support

### Coefficient Modifiers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Empowered Healing | Holy | 5 | +4% | +20% | Greater Heal, Flash Heal, Binding Heal |
| Empowered Renew | Holy | 5 | +3% | +15% | Renew |

### Damage/Healing Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Darkness | Shadow | 5 | +2% | +10% | Shadow damage |
| Shadowform | Shadow | 1 | +15% | +15% | Shadow damage |
| Searing Light | Holy | 2 | +5% | +10% | Smite, Holy Fire |
| Focused Power | Discipline | 2 | +2% | +4% | Smite, Mind Blast |

### Crit Chance Bonuses

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Holy Specialization | Holy | 5 | +1% | +5% | Holy spells |
| Mind Melt | Shadow | 2 | +2% | +4% | Mind Blast, Mind Flay |
| Focused Will | Discipline | 3 | +1% | +3% | All spells |

### Conditional Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Condition |
|--------|------|-------|----------|-----|-----------|
| Shadow Weaving | Shadow | 5 | +2% | +10% | Stacking debuff (5 stacks) |
| Misery | Shadow | 5 | +1% | +5% | Target debuff (all spell damage) |
| Pain and Suffering | Shadow | 3 | +2% | +6% | SW:D with SW:P active |

### Already in Spell Power

These Priest talents modify your spell power stat directly and are already reflected in `GetSpellBonusDamage()`:

- Spiritual Guidance (+25% of Spirit as spell power)
- Mental Strength (+10% total Intellect)

## Druid Spell Coefficients (Wowhead Datamined)

### Balance Damage Spells

| Spell | Direct | DoT | Cast Time | Notes |
|-------|--------|-----|-----------|-------|
| Wrath | 57.1% | - | 2.0s | Nature damage |
| Starfire | 100% | - | 3.5s | Arcane damage |
| Moonfire | 15% | 52% | Instant | 12s duration |
| Insect Swarm | - | 76% | Instant | 12s duration, talent |
| Hurricane | 10.7%/tick | - | 10s channel | AoE |

### Restoration Healing Spells

| Spell | Direct | HoT | Cast Time | Notes |
|-------|--------|-----|-----------|-------|
| Healing Touch | 100% | - | 3.5s | |
| Regrowth | 28.6% | 70% | 2.0s | 21s HoT |
| Rejuvenation | - | 80% | Instant | 12s duration |
| Lifebloom | 34.3% bloom | 52% | Instant | Stacks 3x |
| Tranquility | 114% total | - | 8s channel | AoE heal |
| Swiftmend | - | - | Instant | Consumes HoT |

## Druid Talent Support

### Coefficient Modifiers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Wrath of Cenarius | Balance | 5 | +4% / +2% | +20% / +10% | Starfire / Wrath |
| Empowered Touch | Restoration | 2 | +10% | +20% | Healing Touch |
| Empowered Rejuvenation | Restoration | 5 | +4% | +20% | All HoTs |

### Damage/Healing Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Moonfury | Balance | 5 | +2% | +10% | Starfire, Moonfire, Wrath |
| Gift of Nature | Restoration | 5 | +2% | +10% | All healing spells |
| Improved Rejuvenation | Restoration | 3 | +5% | +15% | Rejuvenation |

### Crit Chance Bonuses

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Focused Starlight | Balance | 2 | +2% | +4% | Starfire, Wrath |
| Improved Moonfire | Balance | 2 | +5% | +10% | Moonfire |
| Natural Perfection | Restoration | 3 | +1% | +3% | All spells |

### Crit Damage Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Vengeance | Balance | 5 | +20% | +100% | Balance spells |

### Conditional Multipliers

| Talent | Tree | Ranks | Per Rank | Condition |
|--------|------|-------|----------|-----------|
| Nature's Grace | Balance | 1 | -0.5s | Next cast after crit |

### Already in Spell Power

These Druid talents modify your spell power stat directly and are already reflected in `GetSpellBonusDamage()`:

- Lunar Guidance (+25% of Intellect as spell power)
- Dreamstate (mana regen, not spell power)

## Shaman Spell Coefficients (Wowhead Datamined)

### Elemental Damage Spells

| Spell | Direct | DoT | Cast Time | Notes |
|-------|--------|-----|-----------|-------|
| Lightning Bolt | 79.4% | - | 2.5s | Main nuke |
| Chain Lightning | 57.1% | - | 2.5s | Jumps to 2 targets (70% each) |
| Earth Shock | 38.6% | - | Instant | Interrupts |
| Flame Shock | 15% | 52% | Instant | 12s DoT |
| Frost Shock | 38.6% | - | Instant | Slows |

### Totem Damage

| Spell | Coefficient | Notes |
|-------|-------------|-------|
| Fire Nova Totem | 21.4% | AoE explosion |
| Searing Totem | 16.7%/attack | Per attack |
| Magma Totem | 6.7%/tick | Per tick |

### Other Damage

| Spell | Coefficient | Notes |
|-------|-------------|-------|
| Lightning Shield | 33%/charge | Reactive damage on hit |

### Restoration Healing Spells

| Spell | Coefficient | Cast Time | Notes |
|-------|-------------|-----------|-------|
| Healing Wave | 85.7% | 3.0s | |
| Lesser Healing Wave | 42.9% | 1.5s | |
| Chain Heal | 71.4% | 2.5s | Jumps to 2 targets (50% each) |
| Earth Shield | 28.6%/charge | Instant | 6 charges |

## Shaman Talent Support

### Damage/Healing Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Concussion | Elemental | 5 | +1% | +5% | LB, CL, Shocks |
| Purification | Restoration | 5 | +2% | +10% | All healing spells |

### Crit Chance Bonuses

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Call of Thunder | Elemental | 5 | +1% | +5% | Lightning Bolt, Chain Lightning |
| Tidal Mastery | Restoration | 5 | +1% | +5% | All healing + lightning spells |

### Crit Damage Multipliers

| Talent | Tree | Ranks | Per Rank | Max | Affects |
|--------|------|-------|----------|-----|---------|
| Elemental Fury | Elemental | 1 | +100% | +100% | All elemental spells |

### Conditional Multipliers

| Talent | Tree | Ranks | Per Rank | Condition |
|--------|------|-------|----------|-----------|
| Elemental Mastery | Elemental | 1 | 100% crit | Next spell guaranteed crit |
| Lightning Overload | Elemental | 5 | +4% | Proc extra LB/CL at 50% damage |
| Healing Way | Restoration | 3 | +6% | Stacking buff (max 3 = 18%) |
| Totem of Wrath | Elemental | 1 | +3% crit | Party aura from totem |

### Already in Spell Power

These Shaman talents modify your spell power stat directly and are already reflected in `GetSpellBonusDamage()`:

- Nature's Blessing (+30% of Intellect as healing power)
- Unrelenting Storm (mana regen, not spell power)

### Already in Spell Power (Mage)

These talents modify your spell power stat directly and are already reflected in `GetSpellBonusDamage()`:

- Arcane Instability (+1/2/3% spell damage)
- Mind Mastery (+up to 25% of Intellect as spell damage)

## File Structure

```
SpellTooltips/
├── SpellTooltips.toc    # Addon manifest
├── Core.lua             # Main tooltip logic
├── Utils.lua            # Helper functions
├── SpellData.lua        # Spell lookup functions
├── TalentData.lua       # Talent definitions
├── SpellTests.lua       # Testing framework (combat log comparison)
├── Classes/
│   ├── Mage.lua         # Mage spell coefficients
│   ├── Paladin.lua      # Paladin spell coefficients
│   ├── Warlock.lua      # Warlock spell coefficients
│   ├── Priest.lua       # Priest spell coefficients
│   ├── Druid.lua        # Druid spell coefficients
│   └── Shaman.lua       # Shaman spell coefficients
├── deploy.bat           # Deployment script for Windows
└── README.md            # This file
```

## Testing

The addon includes a testing framework to validate damage calculations against actual combat log data:

1. Start tracking: `/stt test start`
2. Cast spells on target dummies or mobs
3. Stop tracking: `/stt test stop`
4. View results: `/stt test report`

The report compares expected crit multipliers with actual values and flags any mismatches (tolerance: 2%).

## Troubleshooting

### Tooltip not updating
1. Check if the addon is loaded: `/stt`
2. Enable debug mode: `/stt debug`
3. Verify spell is registered: `/stt spells`

### Talent bonuses not applying
1. Check talent detection: `/stt talents`
2. Scan the talent tree: `/stt scan 1` (or 2/3 for Fire/Frost)
3. Compare indices with your talent tree

### Wrong damage values
- The addon uses Wowhead datamined coefficients for TBC
- If values seem off, test actual damage in-game and report

## Future Plans

- Configuration options via `/stt config`
- Support for set bonuses and trinket effects

## Version History

### 1.5.1
- Fixed talent class filtering bug where talents from other classes were incorrectly applied
- All talents now properly filtered by player class
- Fixed deploy.bat script for Windows compatibility

### 1.5.0
- Added Shaman spell support (Elemental damage, Restoration healing, Totems)
- Added Shaman talent support (Elemental Fury, Lightning Overload, Healing Way)
- All caster classes now supported!

### 1.4.0
- Added Druid spell support (Balance damage, Restoration healing)
- Added Druid talent support (Moonfury, Vengeance, Empowered Rejuvenation)

### 1.3.0
- Added Priest spell support (Shadow damage, Holy damage, healing spells)
- Added Priest talent support (Shadowform, Shadow Weaving, Empowered Healing)

### 1.2.0
- Added Warlock spell support (direct damage, DoTs, channeled, AoE)
- Added Warlock talent support (coefficient modifiers, multipliers, Ruin crit damage)

### 1.1.0
- Added Paladin spell support (damage and healing spells)
- Added Paladin talent support (crit, multipliers, conditionals)

### 1.0.0
- Initial release
- Mage spell support
- Talent detection and integration
- Wowhead datamined coefficients

## Credits

- Spell coefficients sourced from [Wowhead TBC Classic](https://www.wowhead.com/tbc/)
- Built for TBC Anniversary (Interface 20504)

## License

This addon is provided as-is for personal use.
