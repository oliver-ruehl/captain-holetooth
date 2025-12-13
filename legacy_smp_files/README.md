# Legacy SMP Files Archive

## Overview
This folder contains **26 legacy SMP (Godot 2.x Sample) audio files** that have been archived for historical reference only.

**Status**: ❌ NOT USED - All sounds are now in OGG format

---

## Why These Files Were Archived

1. **Format Incompatibility**: SMP format is Godot 2.x only (deprecated in Godot 3.x, removed in Godot 4.x)
2. **OGG Replacements Exist**: All 26 sounds have complete OGG equivalents
3. **Game Uses OGG Only**: The active sound system (`src/audio/sfx/sfx.gd`) loads OGG files exclusively
4. **Code Verification**: Zero references to `.smp` files in any GDScript code
5. **Better Format**: OGG is superior for game audio (smaller file size, better compression)

---

## File Contents

### Sound Effects (25 files from src/audio/sfx/)
- ambience-forest.smp
- bronze_bell.smp
- chime.smp
- click.smp
- cork_pop.smp
- flupp.smp
- item_pickup.smp
- jump.smp
- land.smp
- pin_sound_1.smp through pin_sound_8.smp
- punch.smp
- schwuit.smp
- shoot.smp
- step.smp
- wood_knock.smp
- yan_secret_pin.smp
- Puzzle_Other_GemMix_Gem_Mix_04.smp
- Puzzle_Spell_SkillActivation_Skill_Activation_04.smp

### Ambient/Special (1 file from src/objects/torch/)
- 46273__phreaksaccount__fire-small-loop.smp

---

## Migration Status

| Sound | SMP (Legacy) | OGG (Active) | Game Uses |
|-------|-------------|-------------|-----------|
| flupp | ✅ Archived | ✅ Active | OGG |
| schwuit | ✅ Archived | ✅ Active | OGG |
| click | ✅ Archived | ✅ Active | OGG |
| All others | ✅ Archived | ✅ Active | OGG |

---

## Can These Files Be Deleted?

**YES** - Safe to delete completely
- Total size: ~6.1 MB
- Impact: ZERO (no code references)
- Risk: ZERO (replacements exist)

To delete:
```bash
rm -rf legacy_smp_files/
```

---

## Active OGG Files Location

All replacement audio files are located at:
- `src/audio/sfx/*.ogg` (25 sound effects)
- `src/audio/music/*.ogg` (7 music tracks)

---

## Historical Reference

These files are kept for reference purposes:
- Archive date: Migrated during Godot 3 → Godot 4.5.1 transition
- Original format: Godot 2.x SMP (Sample Library)
- Replacement format: Ogg Vorbis (OGG)
- Quality: Equal or improved (OGG compression)

---

**Recommendation**: Safe to archive/delete. The game is 100% functional without these files.
