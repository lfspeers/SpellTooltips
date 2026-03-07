# Changelog

## [4.2.0] - 2026-03-07

### Added
- CurseForge packaging workflow for automatic releases
- Support for all 9 classes: Mage, Paladin, Warlock, Priest, Druid, Shaman, Rogue, Warrior, Hunter

### Fixed
- Corrected 72 talent indices across all classes to match in-game talent trees
- Fixed Hunter Mortal Shots not being recognized as ranged crit damage talent
- Fixed Seal of Righteousness judgement multiplier calculation
- Improved crit multiplier display precision (now shows 2.25x instead of 2.2x)

### Changed
- Crit damage display now uses 2 decimal places for better precision

---

## [4.1.0] - 2026-03-06

### Added
- Physical ability support for melee classes (Warriors, Rogues, Paladins, Druids, Shamans, Hunters)
- Attack Power and Ranged Attack Power coefficient calculations
- Weapon damage scaling with normalization support
- Aura detection system for damage-boosting buffs (Sanctity Aura, Vengeance, Shadowform, etc.)
- Performance optimizations with caching for weapon stats, talents, and auras

### Fixed
- Damage calculation formulas now match in-game values
- Crit damage multiplier formula corrected for all talent types
- One-Handed Weapon Specialization detection fixed

### Features
- **Caster Spells**: Shows spell power contribution, coefficients, and talent modifiers
- **Physical Abilities**: Shows AP/RAP scaling, weapon damage, and flat bonuses
- **Crit Info**: Displays crit chance and crit damage multiplier with talent bonuses
- **Aura Tracking**: Automatically detects active damage-boosting buffs
- **Talent Integration**: Pre-computes talent bonuses on login for fast tooltip generation

### Slash Commands
- `/stt debug` - Toggle debug mode
- `/stt talents` - Show detected talents
- `/stt auras` - Show active damage-boosting auras
- `/stt spells` - List registered spell IDs
- `/stt seal` - Debug Seal of Righteousness (Paladin)

---

## [3.0.0] - Initial Release

### Added
- Spell tooltip enhancements for TBC Classic
- Spell power coefficient display
- Damage calculation with talent modifiers
- Support for direct damage, DoTs, HoTs, and channeled spells
