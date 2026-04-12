# Veredas Dream

A comprehensive farming simulation game built with **GameMaker**. This project features a robust system for farming, inventory management, seasonal progression, and character interaction.

## Project Overview

- **Engine:** GameMaker (GML)
- **Genre:** Farming Simulation / RPG
- **Key Mechanics:**
    - **Farming System:** Seeds, crops, and seasonal growth cycles. Features soil tilling and watering mechanics using tilemaps.
    - **Inventory System:** A dual-layer system with a 10-slot Hotbar and a 112-slot Backpack. Supports item stacking, swapping, and dropping.
    - **Tools & Equipment:** A variety of tools including Hoes, Watering Cans, Axes, Sickles, Pickaxes, Swords, Bows, Fishing Rods, and Bugnets.
    - **Seasonal Progression:** Dynamic seasonal changes (Spring, Summer, Fall, Winter) that swap tilesets and affect crop availability.
    - **Time & Day Cycle:** Progression of days that triggers crop growth and state changes.
    - **Quality System:** Items can have different quality levels (Normal, Silver, Gold, and the unique "Broncastanio").

## Architecture

### Core Objects
- **`obj_player`**: Manages player movement, state (Idle, Walk, Run, Acting), animations, and interaction logic via `scr_use_item`.
- **`obj_inventory`**: Handles item data, GUI rendering for the Hotbar/Backpack, and inventory logic (adding, swapping, stacking).
- **`obj_crop`**: Individual instances that manage crop growth stages based on watering and days passed.
- **`obj_controller`**: Manages global game state, including time, current day, year, and seasonal transitions.
- **`obj_camera`**: Smoothly follows the player character.
- **`obj_music_manager`**: Handles background music and transitions.

### Data & Scripts
- **`script_init.gml`**: Defines fundamental enums (`ITEM_TYPE`, `TOOL_TYPE`, `SEASON`, `QUALITY`) and global data structures for seeds, crops, and tools.
- **`script_player_actions.gml`**: Implementation of `scr_use_item` and specialized action logic for each tool.
- **`script_inventory_functions.gml`**: Helper functions for inventory operations, such as dropping items (`inventory_drop_item`).

## Building and Running

### Development Environment
- Open the project using the **Veredas Dream.yyp** file in GameMaker.
- Use **F5** to run the game in debug/play mode.
- Use **F7** to compile a build.

### In-Game Controls
- **W / A / S / D**: Movement.
- **Left Shift**: Run.
- **Left Click**: Use selected tool or interact with the world.
- **E / Tab**: (Inferred) Open/Close inventory.
- **P (Debug)**: Cycle through seasons (Spring -> Summer -> Fall -> Winter).
- **O (Debug)**: Advance to the next day (triggers crop growth).

## Development Conventions

- **State Management**: Uses enums for player states (`STATE.IDLE`, `STATE.ACTING`, etc.) and directions (`DIR.DOWN`, `DIR.UP`, etc.).
- **Global Data**: Centralized in `global.seed_data`, `global.crop_data`, and `global.tool_data` structs for easy lookup.
- **Tilemap Mechanics**:
    - **Tilling**: Sets tile to index `72` on the `Tiles_tilled_watered` layer.
    - **Watering**: Sets tile to index `168` on the `Tiles_tilled_watered` layer.
- **Naming Conventions**:
    - Objects: `obj_` prefix.
    - Sprites: `sprite_` prefix (e.g., `sprite_player_walk`, `sprite_crop_tomato`).
    - Scripts: `script_` or `scr_` prefix.
- **Farming Logic**: Crops only grow if `is_watered` is true when the day advances. Growth is calculated as a ratio of `days_passed` to `days_to_grow`.

## Assets
- **Music**: Background music is stored in the `music/` directory (e.g., `spring.mp3`).
- **Sprites**: Organized by type (crops, player actions, tools, tilesets) within the `sprites/` directory.
- **Tilesets**: Season-specific tilesets (e.g., `ts_farm_spring`, `ts_farm_summer`) are used to dynamically change the environment.
