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
  └── obj_enemy_goblin (goblin)
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

### Multi-sprite entries (myconid/goblin — separate sprites per state):
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
  - Myconids: `sprite_get_number(sprite_idle) / 4` (4 directional quarters)
  - Goblins: `sprite_get_number(sprite_idle) / 3` (3 directional thirds)
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

All enemy keys: `slime_black`, `slime_blue`, `slime_golden`, `slime_green`, `slime_pink`, `slime_purple`, `myconid_blue`, `myconid_green`, `myconid_pink`, `goblin`
