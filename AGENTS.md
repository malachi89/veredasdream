# AGENTS.md — Veredas Dream

GameMaker Studio 2 (GML) farming/life sim RPG. Spanish in-game text; English code identifiers.

## Key gotchas

- **NO CLI build/lint/test.** Open GameMaker Studio 2 IDE to compile. No linter, no typecheck, no test runner.
- **Variable names + comments in English; user-facing strings in Spanish.** E.g. `scr_notify("Juego guardado")`.
- **Two separate animal objects:** `obj_farm_animal` (real farm animals) vs `obj_wild_animal` (forest creatures + debug test animals). Their death/drop logic differs.
- **Item key system:** `scr_get_item_data()` and `obj_item_parent` Step both search the same DB list. **Keep both in sync when adding a new database.**
- **Buildings have a placeholder → real pattern.** `obj_*_placeholder` is placed first, then `scr_buy_building()` or collection unlocks convert it to the real object.
- **`scr_sleep_and_save` resets `is_riding` and `mount_is_bear`** on the player. Mounts don't persist across days.
- **`global.local_player`** is the authoritative player object (owns inventory, money, energy, held_item).

## Essential file locations

| File | Purpose |
|------|---------|
| `scripts/script_init/script_init.gml` | All enums, global DBs (`seed_data`, `tool_data`, `placeable_data`, etc.) |
| `scripts/script_inventory_functions/script_inventory_functions.gml` | Save/load, room persistence, drops, sleep, notify, item data lookup |
| `scripts/script_player_actions/script_player_actions.gml` | `scr_use_item()`, `scr_buy_building()`, `scr_upgrade_tool()` |
| `scripts/scr_collection_catalog/scr_collection_catalog.gml` | Building unlocks via collection (greenhouse, stable) |
| `scripts/script_net/script_net.gml` | LAN co-op multiplayer |
| `objects/obj_controller/Step_0.gml` | Game master, day cycle, room transitions, debug console |
| `objects/obj_player/Step_0.gml` | Movement, tool use, fishing, horse mounting |
| `objects/obj_wild_animal/Step_0.gml` | Wild animal death/drops/kill tracking |
| `scripts/scr_populate_graveyard/scr_populate_graveyard.gml` | Spawns 2–4 skeletons in the graveyard room on entry |

## Debug console (Enter in-game)

`add_item`, `add_animal`, `buy_building`, `upgrade_tool`, `set_money`, `set_energy`, `heal`, `set_day`, `set_hour`, `set_season`, `set_weather`, `unlock`, `next_day`, `next_season`, `next_hour`, `toggle_rain`, `minigame`, `spawn_seeds`, `spawn_enemy <key>`. See `documents/CLAUDE.md` for full details.

## Architecture at a glance

- **Persistent singletons:** `obj_controller`, `obj_player`, `obj_camera`, `obj_inventory`
- **Rooms not persistent.** State saved to `global.room_states` on exit, restored on re-enter.
- **Save:** JSON to `saves/savegame.json`.
- **Multiplayer:** LAN 2-player TCP/UDP. Always check `global.net_role`.
- **Tiles:** 16px grid. Tile ID 72 = tilled, 168 = tilled+watered.
- **Weight system:** Fish + cheese use `weight` field (kg float). `base_sell_price * qty * weight` in shipping.

## Existing docs (start here for deeper context)

`documents/CLAUDE.md` (comprehensive reference), `CRAFTING.md`, `WORKBENCH.md`, `BEAR_ATTACK.md`, `FARM_EVENTS.md`, `MINES.md`, `ENEMY.md`, `HEALTH.md`, `COLLECTIONS.md`.
