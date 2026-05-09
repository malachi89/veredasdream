# Enemy System (`obj_enemy`)

## Architecture

All enemies inherit from `obj_enemy` (parent) → `objects/obj_enemy/`.
`obj_enemy` is a child of `obj_enemy` itself (no further parent).

### Inheritance Chain

```
obj_enemy (parent, abstract)
  ├── obj_enemy_slime (slime_black)
  ├── obj_enemy_slime_blue (slime_blue)
  ├── obj_enemy_slime_golden (slime_golden)
  ├── obj_enemy_slime_green (slime_green)
  ├── obj_enemy_slime_pink (slime_pink)
  ├── obj_enemy_slime_purple (slime_purple)
  ├── obj_enemy_myconid_blue (myconid_blue)
  ├── obj_enemy_myconid_green (myconid_green)
  ├── obj_enemy_myconid_pink (myconid_pink)
  ├── obj_enemy_goblin (goblin)
  ├── obj_enemy_skeleton (skeleton)
  ├── obj_enemy_sprout_slime_blue (sprout_slime_blue)
  ├── obj_enemy_sprout_slime_pink (sprout_slime_pink)
  └── obj_enemy_venom_bloom (venom_bloom)
```

---

## `global.enemy_data` (defined in `script_init.gml`)

All enemy stats are data-driven via `global.enemy_data`. Each entry must include:

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Display name |
| `object` | ref | GML object to spawn |
| `sprite` | ref | Default sprite (slime only — single-strip) |
| `sprite_idle` | ref | Idle animation (multi-sprite enemies) |
| `sprite_walk` | ref | Walking animation |
| `sprite_run` | ref | Running/chasing animation (goblin only) |
| `sprite_attack` | ref | Attack animation |
| `sprite_damage` | ref | Damage/hurt animation |
| `sprite_dead` | ref | Death animation |
| `move_speed` | float | Base movement speed (px/frame) |
| `chase_speed_mult` | float | Chase speed multiplier (`move_speed * chase_speed_mult`) |
| `hp` | int | Hit points |
| `max_hp` | int | Maximum hit points |
| `chase_timer` | int | Max chase duration (frames before giving up) |
| `attack_damage` | int | Damage dealt to player per hit |
| `attack_cooldown` | int | Frames between attacks |
| `attack_range` | int | Distance in px for attack to connect |
| `death_anim_frames` | int | Duration of death animation before destroy |
| `product_drops` | array | Item keys dropped on death (random pick) |

### Slime-style entries (single sprite, state strips in one sprite):
```gml
slime_black: {
    name: "Slime Negro",
    object: obj_enemy_slime,
    sprite: sprite_enemy_slime_black,
    move_speed: 0.8,
    chase_speed_mult: 1.5,
    hp: 5,
    ...
}
```

### Multi-sprite entries (myconid/goblin/sprout_slime — separate sprites per state):
```gml
myconid_blue: {
    name: "Micónido Azul",
    object: obj_enemy_myconid_blue,
    sprite_idle: sprite_enemy_myconid_blue_idle,
    sprite_walk: sprite_enemy_myconid_blue_walk,
    sprite_attack: sprite_enemy_myconid_blue_attack,
    sprite_damage: sprite_enemy_myconid_blue_damage,
    sprite_dead: sprite_enemy_myconid_blue_dead,
    move_speed: 0.7,
    chase_speed_mult: 1.4,
    hp: 6,
    ...
}
```

### Stationary entries (venom_bloom — no movement, custom state machine):
No `move_speed`, `chase_speed_mult`, or `chase_timer` fields. `object` is the only required reference besides stats.
```gml
venom_bloom: {
    name: "Venom Bloom",
    object: obj_enemy_venom_bloom,
    sprite_idle: sprite_venom_bloom_idle,  // requerido por el sistema de colección
    hp: 22, max_hp: 22,
    attack_damage: 6, attack_cooldown: 80, attack_range: 56,
    death_anim_frames: 48,
    product_drops: ["forage_f12", "ore_plata"],
    dye_drops: ["dye_lilac"],
}
```

---

## Parent `obj_enemy` Events

### Create (`Create_0.gml`)

Sets default values for all enemies:
- `state = ANIMAL_STATE.IDLE`
- `dir` = random direction
- `frame_anim = 0`, `anim_frames = 4`
- `move_speed = 0.6`, `chase_speed_mult = 1.5`
- `hp = 1`, `max_hp = 1`
- `chase_timer = 0`, `chase_timer_max = 600`
- `attack_damage = 1`, `attack_cooldown_max = 30`, `attack_range = 32`
- `hurt_flash_timer = 0`
- `is_dying = 0`, `death_anim_frames = 48`
- idle/wander timers
- `product_drops = []`

Children call `event_inherited()` and then override values from `global.enemy_data`.

### Step (`Step_0.gml`)

1. **Depth**: `depth = -bbox_bottom`
2. **Animation**: `frame_anim += 0.15`, wraps at `anim_frames` with `while` loops (safe against float edge cases)
3. **Hurt flash**: `hurt_flash_timer` counts down
4. **Death**: When `is_dying > 0`, counts down, drops item from `product_drops` at 0, then `instance_destroy()`
5. **HP**: When `hp <= 0`, sets `is_dying = death_anim_frames`
6. **State machine**:
   - `IDLE`: counts down `idle_timer`, transitions to `WANDERING`
   - `WANDERING`: moves at `move_speed` in current `dir`, collision via `place_meeting(x + _dx, y + _dy, obj_collision)`
   - `CHASING`: moves toward player at `move_speed * chase_speed_mult`, slides along walls on blocked axes, attacks when within `attack_range` dealing `attack_damage`, cooldown via `attack_cooldown_max`, gives up after `chase_timer` expires (faster if player > 500px away)

### Draw (`Draw_0.gml`)

Generic fallback: draws `sprite_index[floor(frame_anim)]` with shadow and health bar. Children override.

### Destroy (`Destroy_0.gml`)

Removes self from `global.forest_wild_animals` tracking array by matching `enemy_key` and nearest position.

---

## Children: Per-Enemy Customization

Each child must provide:

### Create
- Set `enemy_key` to the key in `global.enemy_data`
- Call `event_inherited()` (runs parent's Create for defaults)
- Load all variables from `global.enemy_data[enemy_key]`
- Compute `anim_frames` based on the sprite's directional division:
  - Slimes: `sprite_get_number(sprite_index) / 4` (4 directions × 4 frames = 16 per state, but full sprite is 48 with 3 states)
  - Myconids/Skeletons: `sprite_get_number(sprite_idle) / 4` (4 directional quarters)
  - Goblins/Sprout Slimes: `sprite_get_number(sprite_idle) / 3` (3 directional thirds)
  - Venom Bloom: `anim_frames = 1` initial (frozen); updated when state changes sprite
- Set `hurt_anim_timer = 0`

### Step
```gml
event_inherited();
if (hurt_anim_timer > 0) hurt_anim_timer -= 1;
```

### Draw — Override with custom sprite/state mapping

### Destroy
```gml
event_inherited();
```

---

## Slime Frame Layout (48 frames, strips of 4)

Sprite: `sprite_enemy_slime_<color>` — 48 frames, 32×32.

All slime colors share the same frame strip layout:

| State | LEFT | RIGHT | DOWN | UP |
|-------|------|-------|------|-----|
| IDLE | 0-3 | 0-3 (mirror) | 4-7 | 8-11 |
| CHASING (jump) | 12-15 | 12-15 (mirror) | 16-19 | 20-23 |
| DAMAGE | 24-27 | 24-27 (mirror) | 28-31 | 32-35 |
| DEATH | 36-39 | 36-39 (mirror) | 40-43 | 40-43 (UP reuses DOWN) |

`anim_frames = 4` (each strip is 4 frames). RIGHT flips LEFT via `_xscale = -1`.

---

## Myconid Frame Layout (multi-sprite, directional quarters)

Each myconid has 5 sprites per color: `_idle`, `_walk`, `_attack`, `_damage`, `_dead`.

Each sprite's total frames are divided into 4 equal quarters:
- Quarter 0 (first `frames/4`): **DOWN**
- Quarter 1 (second `frames/4`): **UP**
- Quarter 2 (third `frames/4`): **RIGHT**
- Quarter 3 (fourth `frames/4`): **LEFT**

`anim_frames = sprite_get_number(sprite_idle) / 4`

Sprite selection by state:
| State | Distance | Sprite |
|-------|----------|--------|
| IDLE | — | `sprite_idle` |
| WANDERING | — | `sprite_walk` |
| CHASING | far (`≥ attack_range + 16`) | `sprite_walk` |
| CHASING | close (`< attack_range + 16`) | `sprite_attack` |
| DAMAGE | — | `sprite_damage` |
| DEATH | — | `sprite_dead` |

All directions are drawn normally (no mirroring) since each has its own quarter.

---

## Goblin Frame Layout (multi-sprite, directional thirds)

Each goblin has 6 sprites: `_idle`, `_walk`, `_run`, `_attack`, `_damage`, `_dead`.

Each sprite's total frames are divided into 3 equal thirds:
- Third 0 (first `frames/3`): **DOWN**
- Third 1 (second `frames/3`): **UP**
- Third 2 (third `frames/3`): **RIGHT**
- **LEFT**: mirrors RIGHT via `_xscale = -1`

`anim_frames = sprite_get_number(sprite_idle) / 3`

Sprite selection by state:
| State | Distance | Sprite |
|-------|----------|--------|
| IDLE | — | `sprite_idle` |
| WANDERING | — | `sprite_walk` |
| CHASING | far (`≥ attack_range + 16`) | `sprite_run` |
| CHASING | close (`< attack_range + 16`) | `sprite_attack` |
| DAMAGE | — | `sprite_damage` |
| DEATH | — | `sprite_dead` |

---

## Arrow Interaction (`obj_arrow/Step_0.gml`)

The arrow checks for `obj_enemy` (parent) via:
```gml
var _hit = instance_place(x, y, obj_wild_animal);
if (_hit == noone) _hit = instance_place(x, y, obj_farm_animal);
if (_hit == noone) _hit = instance_place(x, y, obj_enemy);
```

On hit:
1. Deals `damage` to `_hit.hp`
2. Sets `_hit.hurt_flash_timer = 15`
3. If `object_is_ancestor(_hit.object_index, obj_enemy)`: sets `hurt_anim_timer = 15` (if the variable exists), starts `CHASING` state with `chase_timer = chase_timer_max`
4. Sets direction away from arrow impact point

---

## Debug Command

`spawn_enemy <enemy_key>` — spawns an enemy at the mouse cursor (snapped to 16px grid). Checks for collision before spawning.

Example: `spawn_enemy slime_blue`, `spawn_enemy myconid_pink`, `spawn_enemy goblin`

All enemy keys: `slime_black`, `slime_blue`, `slime_golden`, `slime_green`, `slime_pink`, `slime_purple`, `myconid_blue`, `myconid_green`, `myconid_pink`, `goblin`, `skeleton`, `sprout_slime_blue`, `sprout_slime_pink`, `venom_bloom`

---

## Skeleton (`obj_enemy_skeleton`)

Uses the **myconid frame layout** (multi-sprite, 4-direction quarters). Stats from `global.enemy_data[$ "skeleton"]`:
- HP: 24, attack: 6, attack cooldown: 40, attack range: 32
- Move speed: 0.84, chase speed mult: 1.4, chase timer: 720
- Drops: random gem from `["gemstone_ruby","gemstone_sapphire","gemstone_emerald"]`
- Sounds: `sound_skeleton_dead`, `sound_skeleton_walk`, `sound_skeleton_general`

Skeletons spawn in the `graveyard` room via `scr_populate_graveyard()` (2–4 per visit) and can also be summoned by `obj_coffin` when the player opens it (15% chance).

### Coffin (`obj_coffin`)

Placed in the graveyard room in the editor. Press **E** within 40px to open. Opens with one of 5 animated sprites (`sprite_coffin_opened_1` through `_5`). Outcomes (50% nothing / 15% skeleton spawn / 35% random item drop from a pool of crops and gems).

---

## Sprout Slimes (`obj_enemy_sprout_slime_blue`, `obj_enemy_sprout_slime_pink`)

Moving enemies that use the **goblin frame layout** (directional thirds, LEFT mirrors RIGHT). No attack animation — use `sprite_walk` while chasing.

### Stats

| Key | HP | ATK | ATK cooldown | ATK range | Speed | Chase mult | Chase timer |
|-----|-----|-----|-------------|-----------|-------|------------|-------------|
| `sprout_slime_blue` | 18 | 3 | 45 | 32 | 0.9 | ×1.8 | 480 |
| `sprout_slime_pink` | 35 | 4 | 40 | 32 | 0.75 | ×1.6 | 540 |

### Sprites (multi-sprite, directional thirds)

| State | Sprite |
|-------|--------|
| IDLE / WANDERING | `sprite_sprout_slime_<color>_idle` |
| CHASING | `sprite_sprout_slime_<color>_walk` |
| DAMAGE | `sprite_sprout_slime_<color>_damage` |
| DEATH | `sprite_sprout_slime_<color>_dead` |

Each sprite has 6 frames divided into 3 thirds (2 frames/direction): third 0 = DOWN, third 1 = UP, third 2 = RIGHT. LEFT mirrors RIGHT via `_xscale = -1`.

`anim_frames = sprite_get_number(active_sprite) / 3`

### Drops

| Key | product_drops | dye_drops |
|-----|---------------|-----------|
| `sprout_slime_blue` | `coal`, `forage_h04` | `dye_lilac` (exclusive) |
| `sprout_slime_pink` | `ore_bronce`, `forage_h13` | `dye_orange` |

### Sound (`sound_sprout_slime`, 5.067 s) — via `scr_play_sound_clip`

Sound fields are **not** set in `enemy_data` (stay `undefined`). The child's Step handles all clips manually:

| Trigger | Clip |
|---------|------|
| Hurt (`hurt_anim_timer == 15`) | 0.25 – 1.00 s |
| Chase movement (every 90 frames) | 2.50 – 3.00 s |
| Death (is_dying just started) | 4.20 – 5.00 s |

Aggro detection is proactive (detects player within 200px without needing to be hit first), same as skeleton.

### Forest spawn
Added to the `_enemy_slimes` pool in `scr_populate_forest.gml` (3–6 slimes total per day, randomly selected from the combined pool).

---

## Venom Bloom (`obj_enemy_venom_bloom`)

**Stationary plant enemy** with a custom state machine. Does **not** call `event_inherited()` in Step — the parent's IDLE/WANDERING/CHASING logic is completely bypassed. `move_speed = 0`.

### Stats

| HP | ATK | ATK cooldown | ATK range |
|----|-----|-------------|-----------|
| 22 | 6 | 80 frames | 56 px |

### State machine (`vb_state`)

| State | Value | Description |
|-------|-------|-------------|
| DORMANT | 0 | Frozen on frame 0 of wake_up sprite. Looks like a forageable. Triggers on player within 100px or when hit. |
| WAKING | 1 | Plays `sprite_venom_bloom_wake_up` once (full animation). Plays `sound_venom_bloom` (full). |
| IDLE | 2 | Loops `sprite_venom_bloom_idle`. Plays idle sound clip (0.9–1.56s) randomly (1/300). Transitions to ATTACKING if player < 90px. |
| ATTACKING | 3 | Loops `sprite_venom_bloom_attack`. Deals `attack_damage` to player when within 56px (cooldown 80 frames). Plays attack clip (0.0–0.8s). Returns to IDLE if player > 130px. |

Death plays `sound_venom_bloom` (full) and switches to `sprite_venom_bloom_dead`.

### Sprites (no directional layout — stationary)

| State | Sprite | Frames |
|-------|--------|--------|
| DORMANT / WAKING | `sprite_venom_bloom_wake_up` | 6+ |
| IDLE | `sprite_venom_bloom_idle` | 3 |
| ATTACKING | `sprite_venom_bloom_attack` | 4 |
| DEATH | `sprite_venom_bloom_dead` | 5 |

No mirroring. `xscale = 1` always.

### Drops

| product_drops | dye_drops |
|---------------|-----------|
| `forage_f12`, `ore_plata` | `dye_lilac` |

### Sound (`sound_venom_bloom`, 1.56 s)

| Trigger | Method |
|---------|--------|
| Wake up / death | `audio_play_sound(sound_venom_bloom, 1, false)` (full) |
| Attack | `scr_play_sound_clip(sound_venom_bloom, 0.0, 0.8)` |
| Idle (random) | `scr_play_sound_clip(sound_venom_bloom, 0.9, 1.56)` |
| Hurt (hp decreased) | `scr_play_sound_clip(sound_venom_bloom, 0.3, 1.0)` |

Hurt detection: compares `hp` against `vb_prev_hp` each frame (set in Create). Arrow/sword reduce hp externally; the change is caught on the next Step.

### Forest spawn
Separate spawn block in `scr_populate_forest.gml` after the goblin block: **1–2 per day**.

### Drop logic
Death/drops are handled entirely within the custom Step (not the parent). Logic mirrors parent: one random `product_drops` item + 1/3 chance for one random `dye_drops` item.
