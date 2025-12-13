# Captain Holetooth - Next Steps for Godot 4.5.1

## ✓ Completed (Automated)
- [x] Audio conversion (.smp → .ogg)
- [x] Scene format migration (format=1 → format=3) 
- [x] Deprecated node updates (Position2D, Sprite)
- [x] Signal callback updates (body_enter → body_entered)
- [x] Enum reference fixes (CCD_MODE)
- [x] Legacy file cleanup (.flags)
- [x] Project backup created

## ⚠️ Remaining (Requires Godot Editor)

### Step 1: Binary Scene Conversion (5 min)
1. Open project in Godot 4.5.1
2. Godot will detect binary .scn files and offer conversion
3. Confirm conversion to .tscn format
4. Files affected:
   - src/objects/cave_foliage/cave_foliage.scn
   - src/objects/plants/random_flowers.scn
   - src/objects/snowballs/snowballs.scn

### Step 2: Particle System Conversion (10 min)
1. Open each scene and find Particles2D nodes
2. Right-click node → "Convert to GPUParticles2D"
3. Adjust settings if needed (GPU faster, CPU more compatible)
4. Scenes to update (10 total):
   - src/objects/torch/torch.tscn
   - src/objects/thruster/thruster.tscn
   - src/objects/snow/simple_snow.tscn
   - src/objects/rewards/random_coin.tscn
   - src/objects/character_cards/character_card.tscn
   - src/objects/birds/birds.tscn
   - src/levels/flyhome/player_ship/player_ship.tscn
   - src/actors/player/ship/ship.tscn
   - src/actors/enemies/explosion_particle.tscn
   - src/actors/enemies/forest_crawler/forest_crawler.tscn

### Step 3: Gameplay Testing (30-60 min)
1. Play through each level
2. Test player controls (keyboard and controller)
3. Verify audio plays on actions
4. Check enemy behavior
5. Confirm save/load works
6. Test minigame (Yankandy)

## Quick Test Checklist
- [ ] Project opens without errors
- [ ] Menu loads and displays correctly
- [ ] Player spawns in first level
- [ ] Keyboard controls work (arrow keys + space)
- [ ] Controller input works
- [ ] Jump sound plays
- [ ] Enemies appear and move
- [ ] Can collect items
- [ ] Can reach checkpoint
- [ ] Save/load from menu works
- [ ] All levels accessible

## Optional Improvements (Phase 7)
These are NOT required for migration completion:

1. **Code Consolidation**
   - Merge duplicate state in global.gd and game.gd
   - Simplify save system

2. **Documentation**
   - Add comments to complex systems
   - Create developer guide

3. **Performance**
   - Profile frame rate
   - Optimize particle effects
   - Check memory usage

## Controller Support Verification
The project already supports controller input with:
- ui_left / ui_right (movement)
- ui_up (jump)
- ui_accept (shoot)
- ui_down (special)

These are configured in project settings and should work automatically.

## Estimated Timeline
- Binary scene conversion: ~5 minutes
- Particle updates: ~10 minutes
- Quick testing: ~15 minutes
- Full gameplay testing: ~1 hour
- **Total: ~90 minutes to fully complete migration**

## Troubleshooting

### If scenes won't load
- Check MIGRATION_LOG.md for which scenes were updated
- Look for script errors in the console
- Verify all .ogg audio files exist in src/audio/sfx/

### If audio doesn't play
- Verify sfx.gd references .ogg files correctly
- Check AudioStreamPlayer nodes in scenes
- Look for errors in the console output

### If particles look wrong
- Verify conversion to GPUParticles2D was successful
- Check particle material settings
- Compare with backup if needed

### If controller doesn't work
- Verify input mapping in Project Settings
- Check if controller is recognized by system
- Test with keyboard controls first

## Success Confirmation
Project is fully migrated when:
1. ✓ All scenes load without errors
2. ✓ Game is playable from start to finish
3. ✓ Audio works for all actions
4. ✓ Physics feels correct
5. ✓ Save/load functions
6. ✓ Controller input responds

Good luck! 🎮
