# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Veredas Dream** is a farming/life simulation RPG built in **GameMaker Studio 2** (GML). It is a Spanish-language project inspired by games like Stardew Valley. The project file is `Veredas Dream.yyp`. All development happens in GameMaker Studio 2's IDE — there is no CLI build system, linter, or test runner.

## Language

All in-game text, variable names, comments, and notifications are in **Spanish**. Code identifiers (variable names, function names, struct keys) must be in **English**. When adding new content, follow this convention (e.g., `scr_notify("Juego guardado")`).

## Architecture

### Persistent Singletons
The game revolves around three persistent singleton objects:

- **`obj_controller`** — Game master. Initializes all globals, manages the day/time cycle, handles room transitions, runs the debug console, and coordinates the day-end/save flow. Only one instance is ever allowed. The `start_new_day()` and `update_tilesets()` functions live here.
- **`obj_inventory`** — Manages the hotbar (10 slots), backpack (64 slots), and shipping bin (64 slots). Exposes `add_item(_key, _qty)` and inventory swap/split functions. Initial player equipment is hardcoded in `Create_0.gml`.
- **`obj_player`** — Handles movement (WASD + Shift to run), tool use (left-click → `scr_use_item()`), horse mounting (F key), and fishing state machine.

### Global State (initialized in `obj_controller`)
All game-wide data lives in `global.*` structs:
- `global.seed_data`, `global.crop_data`, `global.tool_data`, `global.placeable_data` — item databases (defined in `script_init.gml`)
- `global.fish_data`, `global.fish_pool` — fishing database and weighted catch pool (defined in `script_init.gml`)
- `global.animal_data` — per-animal movement stats (chicken, cow, duck, goat, ostrich, pig, sheep)
- `global.room_states` — persisted state per room (crops, tilled tiles, chests, buildings, horses)
- `global.room_drops` — dropped item instances per room
- `global.money`, `global.day`, `global.season`, `global.year`, `global.game_hour/minute`

### Scripts (GML functions, not objects)
- **`script_init.gml`** — Defines all enums (`DIR`, `STATE`, `FISHING_STATE`, `ITEM_TYPE`, `TOOL_TYPE`, `SEASON`, `QUALITY`) and populates all global item databases including fish.
- **`script_inventory_functions.gml`** — Room persistence (`scr_capture_current_room_state`, `scr_restore_room_state`), save/load (`scr_save_game`, `scr_apply_loaded_game`), drop system, `scr_sleep_and_save`, `scr_process_shipping`, `scr_notify`, `scr_get_item_data`.
- **`script_player_actions.gml`** — `scr_use_item()`: the central dispatcher for all tool use, planting, and placeable logic. Also contains `scr_buy_building()` and `scr_upgrade_tool()`.
- **`scr_add_animal`** — Places a random variant of an animal at mouse position.
- **`scr_populate_farm`** / **`scr_advance_common_trees`** — Farm generation and tree state advancement.

### Room Persistence Pattern
Rooms are not persistent by default. When the player leaves a room, `scr_capture_current_room_state()` saves crops/tiles/chests/buildings/horses into `global.room_states[room_name]`. When re-entering, `obj_controller`'s Step event calls `scr_restore_room_state()` and `scr_restore_room_drops()`. Off-screen room crop/tile advancement is handled by `scr_advance_stored_room_states()` on each new day.

### Save System
Save data is JSON written to `saves/savegame.json` via `scr_save_game()`. The save includes time, money, player position, inventory state, and all room states. Loading is attempted at startup in `obj_controller`'s Create event.

### Tile Conventions (16px grid)
- Tile ID `72` = tilled soil
- Tile ID `168` = tilled + watered soil
- Layer `Tiles_tilled_watered` — the tilemap for farm soil state
- Layer `Tiles_details` — blocks planting (objects/decorations)
- Layer `Instances_Crops` — where `obj_crop` and `obj_tree` instances are created
- Layer `Tiles_seasonal_props` — seasonal decorations, tileset swapped by `update_tilesets()`

### Seasonal Tilesets
`update_tilesets()` swaps tilesets on `Tiles_background`, `Tiles_details`, and `Tiles_seasonal_props` based on `global.season_index`. Fruit trees are destroyed on entering winter.

### Item Key System
Items are identified by string keys (e.g., `"tomato_seeds"`, `"watering_can"`, `"chest"`, `"fish_00"`). `scr_get_item_data(_key)` searches all global databases (seed, crop, tool, placeable, fish) and returns the data struct. Inventory slots are either `-1` (empty) or a struct `{ key, quantity [, quality] }`.

### Buildings
Farm buildings start as placeholder objects (`obj_barn_placeholder`, etc.). `scr_buy_building(_name)` destroys the placeholder and creates the real object at the same position. Building state is captured and restored via the room state system.

### Fishing System
The fishing rod triggers `STATE.FISHING` in `obj_player`. The state machine progresses through sub-states defined in the `FISHING_STATE` enum:
1. **CASTING** — plays 15 frames of cast animation, then transitions to WAITING.
2. **WAITING** — loops until a random bite timer (180–480 frames) fires.
3. **BITE** — player has 120 frames (2 seconds) to press LMB or Space to reel in. Missing the window returns to IDLE with "¡Se escapó!".
4. **REELING** — plays 15 frames, then transitions to CATCHING.
5. **CATCHING** — plays 15 frames, then picks a fish from `global.fish_pool` using weighted random selection, adds it to inventory, and deducts 10 energy.

Fish are keyed as `"fish_00"` through `"fish_98"` using `sprite_all_fishes`. Rarity weights: common=50, uncommon=20, rare=7, very_rare=2, legendary=1. `global.fish_pool` is a flat array built from these weights for O(1) random selection.

Water tile detection is **deferred** — the rod currently works from any tile.

## Debug Commands (press Enter in-game to open the console)
| Command | Description |
|---|---|
| `add_item <key> <qty>` | Add items to inventory (e.g. `add_item tomato_seeds 5`) |
| `add_animal <id>` | Place a random animal variant at mouse position (e.g. `add_animal chicken`) |
| `upgrade_tool <key>` | Upgrade a tool one quality tier (e.g. `upgrade_tool hoe`) |
| `buy_building <name>` | Instantly build (e.g. `buy_building chicken_coop`) |
| `set_money <amount>` | Set player money directly (e.g. `set_money 9999`) |
| `set_energy <amount>` | Set player energy (capped at max) |
| `heal` | Restore player to full energy |
| `set_day <n>` | Set the current day within the season (1–`days_per_season`) |
| `set_hour <h>` | Set the game hour (0–23), resets minutes to 0 |
| `set_season <name>` | Change season: `spring`, `summer`, `fall`, or `winter` |

Building names: `chicken_coop`, `barn`, `stable`, `mill`, `greenhouse`

Animal ids: `chicken`, `cow`, `duck`, `goat`, `ostrich`, `pig`, `sheep`

## Debug Hotkeys
- `O` — advance one day
- `P` — advance one season
- `U` — drop 5 tomato seeds at player position

## Settings
Runtime configuration is read from `settings.ini`:
- `[Time] TimeSpeedMultiplier` (default `1.0`)
- `[Time] DaysPerSeason` (default `28`)
- `[Audio] MusicVolume` (default `0.0`)
