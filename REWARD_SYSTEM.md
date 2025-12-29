# Reward System Documentation

## Overview
Simple pickup reward system for kids - items disappear when collected, no counting displayed.

## How It Works

### 1. **Collecting Rewards**
- Player touches a reward → it disappears with animation
- Collected rewards are saved automatically
- Already collected rewards won't appear again

### 2. **Reset Functionality (Debug Mode)**
- Press **R** key → resets all collected rewards and reloads the scene
- **Only works when Debug Mode is ON**
- High score is preserved during reset

### 3. **Debug Mode Toggle**
Located in: **Main Menu → Options → Debug Tab**

- **CheckBox: "Debug Mode"**
  - ✅ ON: "R" key reset is enabled
  - ❌ OFF: "R" key does nothing
- Setting is saved and persists between game sessions
- Default: ON (for development)

## File Structure

```
src/objects/interactive/rewards/
├── reward.gd           # Main reward script (handles collection & persistence)
├── reward.tscn         # Reward scene (can be placed in any level)
├── random_coin.gd      # Randomizes reward appearance
└── reward_groups/      # Pre-made reward formations
```

## Technical Details

### Reward Collection
- Each reward has a unique `reward_id` (auto-generated from node path)
- Collected IDs are stored in `Game.db["collected_rewards"]`
- On `_ready()`, rewards check if they were already collected → if yes, `queue_free()`

### Reset Logic (game.gd:26-35)
```gdscript
func _input(event):
    if event.is_action_pressed("reload") and Global.debug_mode:
        # Clear all collected rewards
        db = {"high_score": high_score}
        save_game()
        load_game()
        get_tree().reload_current_scene()
```

### Debug Mode Persistence
- Saved in: `Game.db["debug_mode"]`
- Loaded in: `Global._ready()`
- Toggle updates both `Global.debug_mode` and saves to disk

## Adding Rewards to Levels

1. Open any level scene (e.g., `forest.tscn`)
2. Instance `res://src/objects/interactive/rewards/reward.tscn`
3. Place it anywhere in the level
4. Done! It automatically works with the system

## For Release

**Disable debug mode before releasing:**
1. Open Main Menu
2. Go to Options → Debug Tab
3. Uncheck "Debug Mode"
4. Or set `Global.debug_mode = 0` in code

This prevents players from resetting progress with the "R" key.
