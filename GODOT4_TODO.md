# Captain Holetooth - Godot 4 TODO List

## Current Status

**Good News:** The project is already on **Godot 4.5**! The migration from Godot 2 is mostly complete, but there are some critical bugs and legacy code that need fixing.

---

## 🔴 Critical Issues (Must Fix)

### 1. Fix Bullet Collision Detection
**File:** `src/actors/player/bullet.gd` (lines 30, 49)

**Problem:** 
- Code assumes TileMap collisions return TileMap object (not true in Godot 4)
- Calls non-existent method `body.get_closest_point_to(global_position)`

**What to do:**
- Use physics raycast or shape query to get collision normal
- Remove the invalid `get_closest_point_to()` call
- Check for `body is StaticBody2D` instead of `body is TileMap`

### 2. Remove Hardcoded Scene Paths
**Files:** 
- `src/actors/player/buddies/limkolomro_the_bat/limkolomro.gd` (line 12)
- `src/levels/mountain/mountain.gd` (line 12)

**Problem:** 
- Uses absolute paths like `get_node("/root/scn3/player")`
- Will crash if scene structure changes

**What to do:**
- Add player node to a "player" group
- Use `get_tree().get_first_node_in_group("player")` instead
- Or use export variables and node references

---

## 🟡 High Priority Issues

### 3. Update Deprecated Physics API
**File:** `src/actors/enemies/forest_crawler/forest_crawler.gd` (line 34)

**Problem:** Uses deprecated `s.get_linear_velocity()`

**What to do:** Change to `s.linear_velocity` (direct property access)

### 4. Complete Missing Enemy Animation
**File:** `src/actors/enemies/forest_crawler/forest_crawler.gd` (lines 66, 76, 82)

**Problem:** Turn animation is commented out with TODO

**What to do:**
- Either create the "turn" animation in AnimationPlayer and uncomment the code
- Or remove the TODO and commented code if not needed

### 5. Implement Achievement Notification
**File:** `src/actors/player/player.gd` (line 106)

**Problem:** Achievement system tracks jumps but doesn't notify player

**What to do:**
- Create notification UI element
- Display achievement when player jumps 50+ times
- Use existing HUD or dialog system

---

## 🟢 Optional Improvements

### 6. Remove Redundant set_process() Calls
These are unnecessary in Godot 4 (but harmless):
- `src/ui/dialog.gd:71`
- `src/levels/flyhome/rail.gd:9`
- `src/levels/flyhome/flying_npc.gd:60, 73`

### 7. Modernize Random Number Generation
These files use legacy RNG (still works, just outdated):
- `src/utils/uuid.gd:7`
- `src/levels/minigames/yankandy/ball_script.gd:20`
- `src/objects/plants/random_flowers.gd:23`
- `src/objects/cave_foliage/cave_foliage.gd:23`
- `src/objects/rewards/random_coin.gd:14`

**Optional:** Migrate to `RandomNumberGenerator` class

### 8. Optimize Texture Loading
**File:** `src/objects/rewards/random_coin.gd:14` (line 17)

**Problem:** Runtime `load()` can cause stuttering

**What to do:** Preload textures or cache them

---

## Testing Checklist

After fixing critical issues, test:

**Core Gameplay:**
- [ ] Player movement, jumping, shooting
- [ ] Bullet bouncing (CRITICAL - currently broken)
- [ ] Enemy AI and collision
- [ ] Limkolomro bat following player (CRITICAL - hardcoded path)

**All Levels:**
- [ ] Castle (inside/outside)
- [ ] Forest
- [ ] Mountain
- [ ] Flyhome (ship mode)
- [ ] Yankandy minigame

**Systems:**
- [ ] Save/load
- [ ] Score and collectibles
- [ ] Character cards
- [ ] Dialogs
- [ ] Scene transitions
- [ ] Checkpoints
- [ ] Audio
- [ ] Localization (EN/DE)

---

## Quick Start Guide

**Recommended order:**
1. Fix bullet collision (Issue #1)
2. Fix hardcoded paths (Issue #2)
3. Update deprecated physics call (Issue #3)
4. Test everything thoroughly
5. Polish (Issues #4-8)

**Estimated time:** 7-12 hours total

---

## What's Already Working ✅

- Signal connections (modern syntax)
- Scene instantiation
- Export variables (@export)
- Tween system
- Input actions
- Audio system
- Scene file format

**Bottom line:** The codebase is solid! Just fix the 2 critical bugs and you're good to go.
