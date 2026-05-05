# Bear Attack System

## Overview
When the player attacks a bear (with a bow/arrow), the bear enters a **CHASING** state instead of fleeing. It pursues the player, using the attack sprite, and deals damage on contact.

## Architecture

### New State
- `ANIMAL_STATE.CHASING` added to the enum in `script_init.gml`.

### New Variables (obj_wild_animal)
- `chase_timer` — countdown for how long the bear chases (~6s; depletes 3x faster if player is >500px away).
- `attack_cooldown` — 60-frame delay between bear attacks.

## Behavior Flow

1. **Arrow hits bear** (`obj_arrow/Step_0.gml:27-33`):
   - Plays bear roar sound (`sound_bear` random segment).
   - Sets state to `CHASING`, `chase_timer = 360`, `is_panicked = true`.

2. **Chase** (`obj_wild_animal/Step_0.gml:101-153`):
   - Faces toward the player each frame.
   - Moves at `move_speed * 2.5` (2 px/frame for bear).
   - **Stops at 28px** from the player to avoid jittering/overlap.
   - Uses `place_meeting` for collision checks (respects walls, fences, etc.).

3. **Attack** (`obj_wild_animal/Step_0.gml:134-140`):
   - When within 32px and cooldown expired: deals **2 HP** damage directly to `obj_player`, sets `hurt_timer = 60`, plays `sound_hurt`.
   - 1-second cooldown between attacks.

4. **Calm down**: When `chase_timer <= 0`, returns to `IDLE`.

### Sprite
- Bear in CHASING state draws with `sprite_player_bear_attack_bear_brown` (16 frames, 4 per direction) instead of the walk sprite (`obj_wild_animal/Draw_0.gml:28-31`).

### Player Contact Damage
- Player's Step event handles **FLEEING** animals only (1 HP). CHASING damage is handled entirely by the bear to avoid double-dipping.

## Modified Files
| File | Change |
|---|---|
| `scripts/script_init.gml` | Added `CHASING` to `ANIMAL_STATE` enum |
| `objects/obj_wild_animal/Create_0.gml` | Added `chase_timer`, `attack_cooldown` |
| `objects/obj_wild_animal/Step_0.gml` | CHASING state: chase, stop at 28px, attack within 32px, collision with `place_meeting` |
| `objects/obj_wild_animal/Draw_0.gml` | CHASING bear uses `sprite_player_bear_attack_bear_brown` |
| `objects/obj_arrow/Step_0.gml` | Arrow hit → CHASING for bears (with roar) |
| `scripts/scr_populate_test_animals.gml` | Debug bear spawned at farm (900,600) with normal move speed |
