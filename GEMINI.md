# Veredas Dream

A comprehensive farming simulation game built with **GameMaker**. This project features a robust system for farming, inventory management, seasonal progression, and character interaction.

## Project Overview

- **Engine:** GameMaker (GML)
- **Genre:** Farming Simulation / RPG
- **Key Mechanics:**
    - **Farming System:** Seeds, crops, and seasonal growth cycles. Features soil tilling, watering, and **harvesting** mechanics.
    - **Inventory System:** A dual-layer system with a 10-slot Hotbar and a 112-slot Backpack. Supports item stacking (up to 999), swapping (drag and drop), and physical item dropping.
    - **Tools & Equipment:** A variety of tools including Hoes, Watering Cans, Axes, Sickles, Pickaxes, Swords, Bows, Fishing Rods, Bugnets, and Shovels.
    - **Horse System:** Ability to mount and ride different horses, affecting movement speed and animations.
    - **Seasonal Progression:** Dynamic seasonal changes (Spring, Summer, Fall, Winter) that swap tilesets and affect crop availability.
    - **Time & Day Cycle:** Detailed progression of minutes, hours, days, and years. Advance to the next day to trigger crop growth and seasonal transitions.
    - **Quality System:** Items can have different quality levels (Normal, Silver, Gold, and the unique "Broncastanio").

## Architecture

### Core Objects
- **`obj_player`**: Manages movement, states (Idle, Walk, Run, Acting), riding status, and interaction logic via `scr_use_item`.
- **`obj_inventory`**: Handles item data, GUI rendering, and inventory logic (adding, swapping, stacking). Manages both Hotbar and Backpack.
- **`obj_crop`**: Individual instances managing growth stages based on watering and days passed.
- **`obj_controller`**: Manages global game state, including time (minutes, hours, days, years), money, and seasonal transitions. Handles UI notifications.
- **`obj_camera`**: Smoothly follows the player character.
- **`obj_horse_parent`**: Parent object for rideable horses (`obj_horse1`, `obj_horse2`).
- **`obj_item_parent`**: Physical representation of items dropped in the world.
- **`obj_music_manager`**: Handles background music and transitions.

### Data & Scripts
- **`script_init.gml`**: Defines fundamental enums (`ITEM_TYPE`, `TOOL_TYPE`, `SEASON`, `QUALITY`) and global data structures for seeds, crops, and tools.
- **`script_player_actions.gml`**: Implementation of `scr_use_item` (tools, seeds, harvesting) and specialized action logic.
- **`script_inventory_functions.gml`**: Helper functions for inventory operations (`inventory_drop_item`) and UI feedback (`scr_notify`).

## Building and Running

### Development Environment
- Open the project using the **Veredas Dream.yyp** file in GameMaker.
- Use **F5** to run the game in debug/play mode.
- Use **F7** to compile a build.

### In-Game Controls
- **W / A / S / D**: Movement.
- **Left Shift**: Run (swaps to Walk when riding).
- **Left Click**: Use selected tool, plant seeds, or harvest mature crops (hand or sickle).
- **M**: Toggle riding (if near/interacting with a horse).
- **E / Tab**: Open/Close backpack.
- **P (Debug)**: Cycle through seasons.
- **O (Debug)**: Advance to the next day.

## Development Conventions

- **State Management**: Uses enums for player states (`STATE.IDLE`, `STATE.WALK`, `STATE.RUN`, `STATE.ACTING`) and directions (`DIR.DOWN`, `DIR.UP`, `DIR.LEFT`, `DIR.RIGHT`).
- **Animation Frames**:
    - **On Foot**: Idle (4), Walk (6), Run (8).
    - **Riding**: Idle (2), Walk (4), Run (6).
- **Global Data**: Centralized in `global.seed_data`, `global.crop_data`, and `global.tool_data` structs.
- **Tilemap Mechanics**:
    - **Tilling**: Sets tile to index `72` on the `Tiles_tilled_watered` layer.
    - **Watering**: Sets tile to index `168` on the `Tiles_tilled_watered` layer.
- **Farming Logic**: Crops only grow if `is_watered` is true when the day advances. Growth is calculated as a ratio of `days_passed` to `days_to_grow`.
- **Naming Conventions**:
    - Objects: `obj_` prefix.
    - Sprites: `sprite_` prefix.
    - Scripts: `script_` or `scr_` prefix.
