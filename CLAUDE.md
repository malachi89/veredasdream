# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Veredas Dream** — farming/life sim RPG in **GameMaker Studio 2** (GML). Spanish in-game text; English code identifiers. No CLI build, lint, or test runner — all compilation is done through the GMS2 IDE.

- Project file: `Veredas Dream.yyp`
- Deeper reference docs: `documents/CLAUDE.md`, `documents/ENEMY.md`, `documents/CRAFTING.md`, `documents/WORKBENCH.md`, `documents/MINES.md`, `documents/HEALTH.md`, `documents/COLLECTIONS.md`, `documents/FARM_EVENTS.md`

## Key Gotchas

- **Two separate animal objects:** `obj_farm_animal` (real farm animals) vs `obj_wild_animal` (forest creatures + debug test animals). Death/drop logic differs between them.
- **Item key sync:** When adding a new item database, update both `scr_get_item_data()` and `obj_item_parent`'s Step event — they both search the same databases.
- **Buildings use placeholder → real pattern:** `obj_*_placeholder` is placed first; `scr_buy_building()` or collection unlocks convert it to the real object.
- **`scr_sleep_and_save` resets `is_riding` and `mount_is_bear`** on the player — mounts don't persist across days.
- **`global.local_player`** is the authoritative player object (owns inventory, money, energy, held_item).
- **Multiplayer:** Always check `global.net_role` before host-authoritative operations (drops, day advancement, shipping).
- **Tile IDs:** `72` = tilled soil, `168` = tilled + watered. 16px grid throughout.

## Essential File Locations

| File | Purpose |
|------|---------|
| `scripts/script_init/script_init.gml` | All enums and global DBs (`seed_data`, `tool_data`, `enemy_data`, `placeable_data`, etc.) |
| `scripts/script_inventory_functions/script_inventory_functions.gml` | Save/load, room persistence, drops, sleep, notify, item data lookup |
| `scripts/script_player_actions/script_player_actions.gml` | `scr_use_item()`, `scr_buy_building()`, `scr_upgrade_tool()` |
| `scripts/scr_collection_catalog/scr_collection_catalog.gml` | Building unlocks via collection |
| `scripts/script_net/script_net.gml` | LAN co-op multiplayer |
| `objects/obj_controller/Step_0.gml` | Game master: day cycle, room transitions, debug console |
| `objects/obj_player/Step_0.gml` | Movement, tool use, fishing, horse mounting |
| `objects/obj_wild_animal/Step_0.gml` | Wild animal AI, death/drops/kill tracking |
| `objects/obj_enemy/` | Parent class for all combat enemies |

## Architecture at a Glance

**Persistent singletons:** `obj_controller`, `obj_player`, `obj_camera`, `obj_inventory`

**Rooms:** Not persistent. State saved to `global.room_states` on exit, restored on re-enter via `scr_capture_current_room_state` / `scr_restore_room_state`. Off-screen crop advancement runs via `scr_advance_stored_room_states()` each new day.

**Save:** JSON to `saves/savegame.json` via `scr_save_game()`. Loaded at startup in `obj_controller` Create.

**Item keys:** String identifiers (e.g. `"tomato_seeds"`, `"fish_00"`, `"pelt_red"`). `scr_get_item_data(_key)` searches all databases in order. Inventory slots are `-1` (empty) or `{ key, quantity [, quality] [, weight] }`. Weight (kg float) is present on fish and cheese; for those `base_sell_price` is per-kg.

**Enemy system:** All enemies inherit from `obj_enemy`. Stats are data-driven via `global.enemy_data` in `script_init.gml`. Children set `enemy_key`, call `event_inherited()`, then load their stats. Slimes use a single 48-frame sprite strip (4 directions × 4 frames × 3 states). Myconids/Skeletons use 4-direction quarter sprites. Goblins/Sprout Slimes use 3-direction third sprites (LEFT mirrors RIGHT). Venom Bloom is stationary with a custom state machine (no `event_inherited()` in Step): starts frozen looking like a forageable, wakes up when the player approaches, then idles or attacks depending on distance. See `documents/ENEMY.md` for full layout tables and sound clip assignments.

**Graveyard system:** Room `graveyard` contains `obj_coffin` instances placed in the editor. `scr_populate_graveyard()` spawns 2–4 `obj_enemy_skeleton` at random non-colliding positions on room entry (uses `collision_rectangle` for overlap check). Coffins (press **E** within 40px) open with one of 5 sprites and randomly: spawn a skeleton at a nearby free tile (15%), drop a random crop/gemstone item (35%), or nothing (50%). `obj_enemy` escapes collision on its first step (handles cases where it spawns inside geometry). Skeleton entry in `global.enemy_data` key `"skeleton"` — hp 24, attack 6, drops gemstones.

**Drop system:** `inventory_drop_item(_key, _qty, _px, _py)` creates `obj_item_parent` on `"Instances"` layer and registers it in `global.room_drops`. All rooms that need drops must have an `"Instances"` layer.

**Weight selling:** `scr_process_shipping` applies `subtotal = base_sell_price × qty × weight` for items with a `weight` field. Format via `scr_format_weight(_w)`: `< 1 kg` → grams, `1–999` → kg, `≥ 1000` → tonnes.

**Machines:** `obj_machine` states: `0` idle, `1` processing, `2` ready. E key to insert input or collect output. Picked up with axe only; cannot pick up if state 1 or 2. Entries with `machine_type` in `placeable_data` spawn `obj_machine`; entries with `is_workbench: true` spawn `obj_workbench`; entries with `is_alchemy: true` spawn `obj_machine_alchemy`.

**Alchemy machine (`obj_machine_alchemy`):** Works like the workbench (same wide-panel shop UI, multi-ingredient recipes). Item key `"machine_alchemy"`, crafted at the workbench (60 madera + 40 piedra + 5 miel). Recipes live in `global.shop_data[$ "machine_alchemy"]`. Picked up with axe.

**Potions (`global.potion_data`):** Keys `potion_energy`, `potion_health`, `potion_animals`, `potion_strength`. Type `ITEM_TYPE.POTION`. Consumed on left-click (no energy cost). Effects: energy/HP to max; spawn 2–3 farm animals near the player; double sword damage for 3 min (10 800 frames via `damage_mult` / `damage_mult_timer` on `obj_player`). `scr_get_item_data` and `obj_item_parent` both search `global.potion_data`.

## Debug Console (press Enter in-game)

| Command | Effect |
|---------|--------|
| `add_item <key> <qty>` | Add to inventory |
| `add_animal <id>` | Spawn farm animal at cursor |
| `buy_building <name>` | Instant build (`chicken_coop`, `barn`, `stable`, `mill`, `greenhouse`) |
| `upgrade_tool <key>` | Upgrade one tier |
| `set_money / set_energy / heal` | Player stats |
| `set_day / set_hour / set_season / set_weather` | Time/weather |
| `unlock <0-7>` | Unlock mine door |
| `next_day / next_season / next_hour` | Advance time |
| `toggle_rain` | Force rain tomorrow |
| `spawn_enemy <key>` | Spawn enemy at cursor (`slime_blue`, `goblin`, `skeleton`, `sprout_slime_blue`, `venom_bloom`, etc.) |
| `minigame` | Open insect catching minigame |
| `spawn_seeds <qty>` | Spawn tomato seeds |

## Settings (`settings.ini`)

- `[Time] TimeSpeedMultiplier` (default `1.0`)
- `[Time] DaysPerSeason` (default `28`)
- `[Audio] MusicVolume` (default `0.0`)
