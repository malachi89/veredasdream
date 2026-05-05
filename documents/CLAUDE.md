# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Veredas Dream** is a farming/life simulation RPG built in **GameMaker Studio 2** (GML). It is a Spanish-language project inspired by games like Stardew Valley. The project file is `Veredas Dream.yyp`. All development happens in GameMaker Studio 2's IDE — there is no CLI build system, linter, or test runner.

## Language

All in-game text, variable names, comments, and notifications are in **Spanish**. Code identifiers (variable names, function names, struct keys) must be in **English**. When adding new content, follow this convention (e.g., `scr_notify("Juego guardado")`).

## Architecture

### Persistent Singletons
The game revolves around these persistent singleton objects:

- **`obj_controller`** — Game master. Initializes all globals, manages the day/time cycle, handles room transitions, runs the debug console, and coordinates the day-end/save flow. Only one instance is ever allowed. The `start_new_day()` and `update_tilesets()` functions live here.
- **`obj_inventory`** — UI-only singleton for the local player's inventory display. **All actual inventory data (slots, money, energy) lives in `obj_player`.** `obj_inventory` delegates `add_item`/swap/split to `global.local_player`. Manages visual slot rendering and window resize.
- **`obj_player`** — Handles movement (WASD + Shift to run), tool use (left-click → `scr_use_item()`), horse mounting (F key), fishing state machine, and **owns all per-player data**: `inventory_array` (10 slots), `backpack_array` (64 slots), `shipping_array` (64 slots), `money`, `energy`, `held_item`.
- **`obj_camera`** — Follows `global.local_player`.

### Global State (initialized in `obj_controller`)
All game-wide data lives in `global.*` structs defined in `script_init.gml`:

**Item databases:**
- `global.seed_data` — 43 crop seeds (spring/summer/fall/winter)
- `global.crop_data` — Harvested crop items
- `global.tool_data` — 10 tools: `watering_can`, `pickaxe`, `axe`, `sickle`, `hoe`, `shovel`, `fishing_rod`, `bugnet`, `sword`, `bow`
- `global.tool_progression` — 9 quality tiers (OXIDADO → VITOLANIO) with per-tier stats
- `global.placeable_data` — Placeables: `chest`, `workbench`, and 7 machines (`machine_curtidora`, `machine_telar`, `machine_mantequillera`, `machine_mermeladora`, `machine_prensa_queso`, `machine_horno`, `machine_colmena`). Entries with `machine_type` key spawn `obj_machine` on placement; entries with `is_workbench: true` spawn `obj_workbench`. Entries may have `tile_w`/`tile_h` to override the auto-calculated tile size (`ceil(sprite_width / 16)`).
- `global.item_groups` — Named arrays of item keys for group-ingredient recipes: `milk_any`, `leather_any`, `yarn_any`, `crop_any`. See `WORKBENCH.md`.
- `global.material_data` — `wood`, `stone`
- `global.forage_data` — 119 forage items (mushrooms `forage_m*`, herbs `forage_h*`, flowers `forage_f*`), rarity 1–5
- `global.fish_data`, `global.fish_pool` — 99 fish with rarity weights; `fish_pool` is a flat array for O(1) random selection. Each entry has `weight_min`/`weight_max` (kg); `base_sell_price` is **price per kg**. A random weight is assigned on catch and stored in the inventory slot struct.
- `global.insect_data`, `global.insect_pool` — 60 insects (ants, snails, butterflies, moths, crickets, etc.); weighted pool
- `global.animal_data` — Per-animal stats for `chicken`, `cow`, `duck`, `goat`, `ostrich`, `pig`, `sheep`: `move_speed`, `hp`, `max_hp`, `variants[]`, `product_drops[]` (food/product on death), `crafting_drops[]` (raw crafting material, 50% chance on death)
- `global.wild_animal_data` — Forest animals: `capibara`, `deer`, `fox`, `frog`, `penguin`, `rabbit`, `turtle`, `bear`. Each has `product_drops[]` (1 item chosen randomly on death). Bear has ~26% chance to drop `honey` (5 entries among 14 pelt colors).
- `global.animal_product_data` — 20 products: eggs, milk, cheese, butter, honey, meat, wool (keyed e.g. `"egg_chicken_brown_reg"`, `"milk_reg"`, `"steak"`, `"wool"`). `cheese` and `goat_cheese` are weight-based: `base_sell_price` is per-kg; the prensa_queso assigns a random weight on output (small milk → 0.3–0.5 kg, large milk → 0.5–1.0 kg).
- `global.crafting_material_data` — 126 crafting materials (9 types × 14 colors). Types: `thread`, `cloth`, `string`, `leather`, `pelt`, `feathers`, `rabbit_pelt`, `yarn`, `cow_hide`. Colors: `red orange yellow green blue lilac purple turquoise pink lime amber brown black white`. Keys follow `"<type>_<color>"` (e.g. `"pelt_red"`, `"yarn_white"`). Sprite: `sprite_crafting_material`. Raw drops (from animals): pelt, cow_hide, rabbit_pelt, yarn, feathers, string. Craft-only: leather, thread, cloth. See `CRAFTING.md` for full crafting chains and drop sources.
- `global.npc_data`, `global.shop_data` — 21 NPCs; only "Miraculos" shop is active. `shop_data` also has a `"workbench"` key used by `obj_workbench` (see `WORKBENCH.md`).

**World state:**
- `global.room_states` — Persisted state per room (crops, tiles, chests, buildings, horses)
- `global.room_drops` — Dropped item instances per room
- `global.next_drop_uid` — Incrementing ID for drop persistence
- `global.money`, `global.day`, `global.season`, `global.year`, `global.game_hour/minute`
- `global.farm_populated`, `global.debug_test_animals`, `global.farm_needs_repopulate_test_animals`
- `global.forest_needs_repopulate`, `global.forest_days_since_rare`, `global.forest_days_since_rare_insect`

**Multiplayer:**
- `global.net_role` — `NET_ROLE.NONE` (single-player), `NET_ROLE.HOST`, or `NET_ROLE.CLIENT`
- `global.local_player` — Points to the local `obj_player` instance

### Scripts (GML functions, not objects)
- **`script_init.gml`** — Defines all enums (`NET_ROLE`, `NET_CMD`, `DIR`, `STATE`, `FISHING_STATE`, `HORSE_STATE`, `ANIMAL_STATE`, `ITEM_TYPE`, `TOOL_TYPE`, `SEASON`, `QUALITY`) and all global databases.
- **`script_inventory_functions.gml`** — Room persistence (`scr_capture_current_room_state`, `scr_restore_room_state`), save/load (`scr_save_game`, `scr_apply_loaded_game`), drop system (`inventory_drop_item`, `scr_register_room_drop`), `scr_sleep_and_save`, `scr_process_shipping` (uses `weight` field when present: `price = base_sell_price * quantity * weight`), `scr_notify`, `scr_get_item_data`, `scr_format_weight(_w)` (converts kg float → display string: `< 1` → `"80g"`, `1–999` → `"45kg"`, `≥ 1000` → `"4.5t"`).
- **`script_player_actions.gml`** — `scr_use_item()`: central dispatcher for tool use, planting, harvesting, and placeable logic. Also `scr_buy_building()` and `scr_upgrade_tool()`.
- **`script_net.gml`** — LAN multiplayer over TCP/UDP. Packet format: `[u32 payload_size][u8 cmd][payload]`. 40+ `NET_CMD` messages for state sync (HANDSHAKE, FULL_SNAPSHOT, PLAYER_STATE, TIME_UPDATE, NEW_DAY, CMD_USE_ITEM, CMD_PICKUP, CMD_BUGNET, SLEEP_REQUEST, etc.). Full snapshot includes `mine_state`.
- **`scr_add_animal`** — Places a random-variant `obj_farm_animal` at mouse position.
- **`scr_populate_farm`** / **`scr_advance_common_trees`** — Farm generation and tree state advancement.
- **`scr_populate_forest`** — Spawns daily forage items, wild animals, and insects in the forest room.
- **`scr_populate_test_animals`** — Dev helper. Spawns all wild and farm animal types as **`obj_wild_animal`** instances (with `is_farm_animal = true` and `is_test_animal = true` for farm types). These are NOT `obj_farm_animal`.

### Animal Systems — Two Separate Objects

**`obj_farm_animal`** — Real farm animals bought/placed on the farm. `animal_type` and `variant` set via `init_animal_type`/`init_variant` object properties or `scr_add_animal`. Death: always drops 1 item from `product_drops`, then 50% chance to also drop 1 raw crafting item from `crafting_drops`.

**`obj_wild_animal`** — Forest creatures AND the debug test animals from `scr_populate_test_animals`. Key variables: `animal_key` (the type string), `is_farm_animal` (true for farm types spawned as test animals), `is_test_animal`. Death code: if `is_farm_animal`, drops 1 product from `global.animal_data[$ animal_key].product_drops`; otherwise drops 1 guaranteed raw crafting item from `global.wild_animal_data[$ animal_key].product_drops`.

Both share `ANIMAL_STATE` (IDLE, WANDERING, FLEEING) and `hurt_flash_timer`.

### Room Persistence Pattern
Rooms are not persistent by default. When the player leaves a room, `scr_capture_current_room_state()` saves crops/tiles/chests/buildings/horses into `global.room_states[room_name]`. When re-entering, `obj_controller`'s Step event calls `scr_restore_room_state()` and `scr_restore_room_drops()`. Off-screen crop/tile advancement is handled by `scr_advance_stored_room_states()` on each new day.

### Save System
Save data is JSON written to `saves/savegame.json` via `scr_save_game()`. Includes time, money, player position, inventory state, all room states, room drops, and `next_drop_uid`. Loading is attempted at startup in `obj_controller`'s Create event.

### Item Key System
Items are identified by string keys (e.g., `"tomato_seeds"`, `"watering_can"`, `"fish_00"`, `"egg_chicken_brown_reg"`, `"forage_m00"`, `"pelt_red"`). `scr_get_item_data(_key)` searches all databases in order: `seed_data`, `crop_data`, `tool_data`, `placeable_data`, `material_data`, `forage_data`, `fish_data`, `insect_data`, `animal_product_data`, `crafting_material_data`. Returns `undefined` if not found.

`obj_item_parent` (world-drop pickup) also searches the same databases in its Step event to resolve the sprite and pickup name. **Both `scr_get_item_data` and `obj_item_parent` must be kept in sync when adding a new database.** Inventory slots are either `-1` (empty) or a struct `{ key, quantity [, quality] [, weight] }`. The `weight` field (kg float) is present on fish and cheese/goat_cheese; for those items `base_sell_price` is per-kg. `add_item(_key, _qty, _weight)` accepts an optional third parameter to attach weight to the new slot.

### Drop System
`inventory_drop_item(_key, _qty, _px, _py, _delay=15)` — Creates an `obj_item_parent` on the `"Instances"` layer at the given position, registers it in `global.room_drops`, and (in multiplayer HOST mode) broadcasts the room state. All rooms that need drops must have an `"Instances"` layer.

### Tile Conventions (16px grid)
- Tile ID `72` = tilled soil
- Tile ID `168` = tilled + watered soil
- Layer `Tiles_tilled_watered` — tilemap for farm soil state
- Layer `Tiles_details` — blocks planting
- Layer `Instances_Crops` — where `obj_crop` and `obj_tree` instances are created
- Layer `Tiles_seasonal_props` — seasonal decorations, tileset swapped by `update_tilesets()`

### Seasonal Tilesets
`update_tilesets()` swaps tilesets on `Tiles_background`, `Tiles_details`, and `Tiles_seasonal_props` based on `global.season_index`. Fruit trees are destroyed on entering winter.

### Buildings
Farm buildings start as placeholder objects (`obj_barn_placeholder`, etc.). `scr_buy_building(_name)` destroys the placeholder and creates the real object at the same position. Building state is captured and restored via the room state system.

### Fishing System
The fishing rod triggers `STATE.FISHING` in `obj_player`. Sub-states via `FISHING_STATE`:
1. **CASTING** — 15 frames, then WAITING.
2. **WAITING** — random bite timer (180–480 frames).
3. **BITE** — 120 frames to press LMB/Space; miss → "¡Se escapó!".
4. **REELING** — 15 frames.
5. **CATCHING** — picks from `global.fish_pool`, rolls a random weight within the fish's `weight_min`/`weight_max` range, adds to inventory via `add_item(_key, 1, _weight)`, deducts 10 energy. Catch notification includes the weight (e.g. `"¡Atrapaste un Salmón (3kg)!"`).

### Crafting Machine System
`obj_machine` is a multi-state placeable (`machine_type` set on creation). States: `0` = idle, `1` = processing, `2` = ready. Player interacts with E key to insert input (state 0→1) or collect output (state 2→0). `global.machine_data` holds recipes per machine type. `scr_match_machine_recipe(_type, _input_key)` returns the matching recipe struct or `undefined`. Machines with `passive: true` (colmena) produce output automatically on a timer. Recipes may include `weight_min`/`weight_max` — when present the machine rolls a random weight on completion and stores it in `output_weight`. **Machines are picked up with the axe** (not right-click); cannot pick up if processing (state 1) or item ready (state 2).

### Workbench System
`obj_workbench` is a crafting station. Press **E** to open crafting menu; pick up with **axe**. Recipes live in `global.shop_data[$ "workbench"]` and use the standard shop format extended with `group_keys` for multi-item ingredients. Helper functions `scr_count_item_group` and `scr_remove_items_from_group` handle group checks/removals. The shop UI uses a wider panel (760px) with sprite-box ingredient display instead of text. See `WORKBENCH.md` for full recipe list and UI dimensions.

### Weight-Based Selling
Items can carry a `weight` field (kg float) in their slot struct. `scr_process_shipping` applies it: `subtotal = base_sell_price × quantity × weight`. Items without `weight` default to multiplier 1 (unchanged behavior). The inventory UI displays weight in the slot corner and in the tooltip (with estimated sell value). Format via `scr_format_weight`: grams for `< 1 kg`, kg for `1–999`, tonnes for `≥ 1000`. Currently weight-bearing items: **fish** (99 types, assigned on catch) and **cheese/goat_cheese** (assigned by prensa_queso on completion).

### Placement Selector
When a placeable item is selected, `obj_controller` Step computes `selector_w/selector_h` from the sprite dimensions (`ceil(sprite_width / 16)`), or from `tile_w`/`tile_h` override fields if present in `placeable_data`. Draw_0 renders the green/red box starting at `(gx, gy)` — no centering — so the box aligns with where the object actually places. Tools use a centered area-selector instead. Sprite preview also draws at `(gx + place_offset_x, gy + place_offset_y)`. Inventory icon scaling uses `16 / max(sprite_width, sprite_height)` so tall sprites (e.g. colmena 16×32) fit within the slot.

### Insect Catching System
The `bugnet` tool is used in the forest to catch insects. The timing minigame (`obj_minigame_timing`) has 4 difficulty levels (0=Easy to 3=Extreme) controlling indicator speed and hitbox precision. Caught insects are added to inventory via `global.insect_data`.

### Bow & Arrow System
The `bow` tool fires `obj_arrow` projectiles toward the mouse. Arrows deal 1 damage (overridden by bow quality). `obj_arrow` Step checks collision with `obj_wild_animal` first, then `obj_farm_animal` using `instance_place`. Hit animals enter `ANIMAL_STATE.FLEEING` and take `hp` damage.

### Multiplayer
Two-player LAN co-op. `global.net_role` determines behavior throughout the codebase — always check it before any operation that should be host-authoritative (drops, day advancement, shipping). `obj_remote_player` renders the remote player's avatar. Sleep must be coordinated: client sends a sleep request, host confirms before advancing the day.

### Forest System
`scr_populate_forest()` runs daily to respawn forage items, insects (`obj_insect`), and wild animals (`obj_wild_animal`) in the forest room. Rare spawns are gated by `global.forest_days_since_rare` / `global.forest_days_since_rare_insect` counters. Items and creatures persist via `global.room_drops` / `global.room_states`.

## Debug Commands (press Enter in-game to open the console)
| Command | Description |
|---|---|
| `add_item <key> <qty>` | Add items to inventory (e.g. `add_item tomato_seeds 5`) |
| `add_animal <id>` | Place a random `obj_farm_animal` variant at mouse position |
| `upgrade_tool <key>` | Upgrade a tool one quality tier (e.g. `upgrade_tool hoe`) |
| `buy_building <name>` | Instantly build (e.g. `buy_building chicken_coop`) |
| `set_money <amount>` | Set player money |
| `set_energy <amount>` | Set player energy (capped at max) |
| `heal` | Restore player to full energy |
| `set_day <n>` | Set the current day within the season (1–`days_per_season`) |
| `set_hour <h>` | Set the game hour (0–23), resets minutes to 0 |
| `set_season <name>` | Change season: `spring`, `summer`, `fall`, or `winter` |

Building names: `chicken_coop`, `barn`, `stable`, `mill`, `greenhouse`

Animal ids: `chicken`, `cow`, `duck`, `goat`, `ostrich`, `pig`, `sheep`

## Debug Console Commands (Enter para abrir)
| Command | Description |
|---------|-------------|
| `add_item <key> <qty>` | Add items to inventory |
| `add_animal <id>` | Spawn animal |
| `upgrade_tool <key>` | Upgrade tool one tier |
| `buy_building <name>` | Build (chicken_coop, barn, stable, mill, greenhouse) |
| `set_money <amount>` | Set money |
| `set_energy <amount>` | Set energy |
| `heal` | Restore energy and HP |
| `set_day <n>` | Set day (1-28) |
| `set_hour <h>` | Set hour (0-23) |
| `set_season <name>` | Set season (spring, summer, fall, winter) |
| `set_weather <type>` | Weather (rain, sunny) |
| `unlock <0-7>` | Unlock mine door |
| `next_day` | Advance one day |
| `next_season` | Advance one season |
| `next_hour` | Advance one hour |
| `toggle_rain` | Toggle forced rain for tomorrow |
| `minigame` | Open insect catching minigame |
| `spawn_seeds <qty>` | Spawn tomato seeds |

## Settings
Runtime configuration is read from `settings.ini`:
- `[Time] TimeSpeedMultiplier` (default `1.0`)
- `[Time] DaysPerSeason` (default `28`)
- `[Audio] MusicVolume` (default `0.0`)
