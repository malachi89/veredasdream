# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Veredas Dream** is a farming simulation game built in GameMaker Studio 2 using GML (GameMaker Language). The game features a seasonal time system, farming mechanics with crop growth, inventory management, horse riding, and persistent world state across room transitions.

## Building and Running

Open the project in GameMaker Studio 2:
- **Run in debug mode**: Press `F5`
- **Build executable**: Press `F7`
- **Project file**: `Veredas Dream.yyp`

Configuration settings are in `datafiles/settings.ini` and affect time speed, season length, and audio volume.

## Architecture

### Core Systems and Object Roles

**obj_controller** (persistent, single instance)
- Manages game time (minutes, hours, days, seasons, years)
- Handles daily progression: crop growth, soil drying, tileset updates
- Draws HUD (calendar, time, money)
- Manages save/load system and room state persistence
- Controls sleep menu and shipping summary UI
- Must be singleton - destroys duplicates in Create event

**obj_inventory** (persistent, single instance)
- Manages 10-slot hotbar and larger backpack
- Handles item pickup, drag-and-drop UI, item dropping
- Draws inventory UI and item tooltips
- Must be singleton - destroys duplicates in Create event

**obj_player** (NOT persistent)
- State machine: `STATE.IDLE`, `STATE.WALK`, `STATE.RUN`, `STATE.ACTING`
- Handles movement with grid-based tool interaction (16x16 cells)
- Manages layered sprite rendering (body, clothes, hair, eyes)
- Interacts with world: tilling, watering, planting, harvesting
- Horse mounting/dismounting logic
- Created fresh in each room, position restored from global variables

**obj_crop**
- Represents planted crops in the world
- Growth controlled by days_passed, is_watered state
- Sprite selection based on crop_type (e.g., "tomato", "cabbage")
- Harvesting adds crops to inventory and destroys instance

**obj_horse_parent** / **obj_horse1** / **obj_horse2**
- AI-controlled horses with states: IDLE, PACING, PREPARING_TO_EAT, EATING
- Player can mount/dismount (increases movement speed)
- Uses layered rendering when mounted (horse body + saddle + player layers)

**obj_transition**
- Invisible trigger zones for room transitions
- Sets destination room and player spawn coordinates
- Uses `target_room`, `target_x`, `target_y` variables

### Global Data Architecture

All game data centralized in `scripts/script_init/script_init.gml`:

**Enums**: `DIR`, `STATE`, `HORSE_STATE`, `ITEM_TYPE`, `TOOL_TYPE`, `SEASON`, `QUALITY`

**Data Structs**:
- `global.seed_data`: Seed properties (name, seasons, growth_time, crop_base_name, prices)
- `global.crop_data`: Harvested crop properties (name, seasons, prices)
- `global.tool_data`: Tool properties (name, tool_type, sprite, subimg, sellable, droppable)

**Persistence Globals**:
- `global.room_states`: Stores crops and tilled_tiles per room (e.g., `global.room_states[$ "farm"]`)
- `global.room_drops`: Stores dropped items per room with unique IDs
- `global.save_file_path`: JSON save file location

### Persistence System

**Room State Tracking** (`script_inventory_functions.gml`):
- `scr_capture_current_room_state()`: Saves current room's crops and tilled tiles to global.room_states
- `scr_restore_room_state(room_name)`: Recreates crops and tilled tiles when entering a room
- `scr_advance_stored_room_states(current_room)`: Ages crops and dries soil in inactive rooms during day advancement

**Item Drops** (also in `script_inventory_functions.gml`):
- Items dropped on ground get unique `persistent_drop_id`
- Tracked in `global.room_drops[$ room_name]` array
- Recreated when re-entering a room

**Save/Load**:
- Saves to JSON format via `scr_write_save_game()` and `scr_read_save_game()`
- Stores time, money, inventory, room states, dropped items, player position
- Load happens in obj_controller Create event, restored in obj_player Other_4 (Room Start)

### Layer Architecture

GameMaker rooms use named layers. Common layers:
- `Tiles_background`: Seasonal tileset (ts_farm_spring/summer/fall/winter)
- `Tiles_details`: Decorative details using seasonal tileset
- `Tiles_tilled_watered`: Soil state (tile 72 = dry tilled, tile 168 = wet tilled)
- `Instances`: Game objects (player, crops, items, NPCs)

Tileset swapping happens in `update_tilesets()` when season changes.

### Player Action System

When player uses a tool (in `script_player_actions.gml`):
1. Check grid cell at interaction point (calculated from player direction)
2. Tool-specific logic:
   - **HOE**: Creates tilled soil tile (72) on Tiles_tilled_watered layer
   - **WATERING_CAN**: Changes tilled tile to watered (168)
   - **SEED**: Plants crop instance if soil is tilled, consumes seed from inventory
   - **PICKAXE/AXE/SWORD/BOW**: Combat/resource gathering (future implementation)
3. Triggers `STATE.ACTING` with tool-specific animation

### Animation System

Player sprites are layered and directional:
- **Naming convention**: `sprite_player_[layer]_[state]` (e.g., `sprite_player_clothes_walk`)
- **Layers**: skin, clothes, hair, eyes, tool/weapon overlay
- **Directions**: Mapped via DIR enum (DOWN=0, UP=1, RIGHT=2, LEFT=3)
- **Horse riding**: Separate sprite sets `sprite_player_horse1_[layer]_[state]`

Each sprite has 4 subimages (one per direction). Animation frame advancement handled in Step event.

## Development Workflow

### Common Patterns

**Adding a New Crop**:
1. Add seed entry to `global.seed_data` in `script_init.gml`
2. Add crop entry to `global.crop_data`
3. Import crop sprite (5-7 frames for growth stages) to sprites/
4. Ensure `crop_base_name` matches between seed and crop entries

**Adding a New Tool**:
1. Add enum value to `TOOL_TYPE` in `script_init.gml`
2. Add tool entry to `global.tool_data`
3. Add tool sprite frame to `sprite_tools` or create new sprite
4. Implement action logic in `script_player_actions.gml`
5. Create animation sprites: `sprite_player_[layer]_[toolname]` for all layers

**Creating a New Room**:
1. Create room in GameMaker IDE with required layers
2. Add room name to `RoomOrderNodes` in `.yyp` file (auto-generated)
3. Add transition objects (obj_transition) with target room properties
4. Initialize room state in `global.room_states` if needed

### Debug Commands

Keyboard shortcuts for testing (defined in obj_controller Step event):
- `P`: Cycle through seasons (Spring → Summer → Fall → Winter)
- `O`: Advance to next day (triggers crop growth, soil drying)
- `U`: Drop 5 Tomato Seeds at player position (for inventory testing)

See `KEYBINDINGS.md` for full control scheme.

### Important Constraints

**Singleton Pattern**: obj_controller and obj_inventory must exist only once. They check `instance_number()` in Create event and self-destruct if duplicates exist.

**Persistence Markers**:
- obj_controller: `persistent = true`
- obj_inventory: `persistent = true`
- obj_player: NOT persistent (recreated per room, position restored via globals)

**Room Transitions**: Player position and direction stored in `global.pending_player_*` variables, applied in obj_player Other_4 event.

**Crop Growth**: Crops only grow when watered (tile 168). Daily advancement uses `scr_advance_stored_room_states()` to process inactive rooms.

**Item Stacking**: Items with same `item_key` stack in inventory. Tools are non-stackable (max_stack = 1).

## File Organization

```
objects/
  obj_controller/       - Game time, UI, persistence
  obj_inventory/        - Inventory system
  obj_player/           - Player character
  obj_crop/             - Crop instances
  obj_horse_parent/     - Base horse logic
  obj_horse1/           - Horse variant 1
  obj_item_parent/      - Dropped item base
  obj_transition/       - Room transition triggers
  obj_bed/              - Sleep interaction
  obj_shipping_bin/     - Sell crops

scripts/
  script_init/                    - Enums and global data
  script_inventory_functions/     - Persistence helpers
  script_player_actions/          - Tool interaction logic

rooms/
  farm/                 - Main outdoor area
  farm_house/           - Interior space

datafiles/
  settings.ini          - Time speed, season length, audio

sprites/                - All visual assets
tilesets/               - Seasonal tilesets
fonts/                  - UI fonts
sounds/                 - Audio (background music)
```

## Notes

- The game uses GameMaker's built-in tilemap system for terrain
- All text is in Spanish (e.g., "Semilla de Tomate", "Regadera")
- Sprite assets created in Aseprite (source files in root directory)
- Save system stores exact room state - crops, items, tilled soil all persist
- Time progression: 1 real second = time_frames_per_minute frames = 1 game minute (default)
