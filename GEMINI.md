# Veredas Dream - Project Overview

Veredas Dream is a farming simulation game developed in **GameMaker Studio 2**. It features a state-driven player character, a seasonal time system, and a persistent world with farming mechanics, inventory management, and exploration.

## Technical Stack
- **Engine:** GameMaker Studio 2
- **Language:** GML (GameMaker Language)
- **Data Formats:** JSON (for saves), INI (for settings)

## Core Systems

### 1. Time & Seasons (`obj_controller`)
- **Calendar:** 28 days per season. Seasons cycle through Spring, Summer, Fall, and Winter.
- **Clock:** Tracks minutes, hours, days, and years. Starting time is 6:00 AM.
- **Multiplier:** Time speed can be adjusted via `settings.ini`.
- **Daily Reset:** Advancing to the next day triggers crop growth, dries watered soil, and updates tilesets to reflect the current season.

### 2. Farming Mechanics (`obj_crop`, `script_init`)
- **Crops:** Defined by `global.seed_data` and `global.crop_data`. Each crop has specific growth times, seasons, and visual stages.
- **Soil:** Tilled soil can be watered using the Watering Can. Crops grow only when watered.
- **Persistence:** Room states (crops, tilled tiles) are saved and restored when moving between rooms.

### 3. Inventory & Tools (`obj_inventory`, `script_init`)
- **Slots:** 10 Hotbar slots and a larger Backpack.
- **Item Types:** `MATERIAL`, `TOOL`, `SEED`, `FOOD`, `WEAPON`, `CROP`, `FISH`.
- **Tools:** Includes Hoe (tilling), Watering Can (watering), Axe (chopping), Pickaxe (mining), Sword/Bow (combat), and Fishing Rod.
- **UI:** Supports dragging items, swapping slots, and dropping items into the world.

### 4. Player Character (`obj_player`)
- **States:** `IDLE`, `WALK`, `RUN`, `ACTING`.
- **Animations:** Directional sprites for all states, including specialized animations for using tools and riding horses.
- **Movement:** Grid-based interaction (16x16) but free-form movement with collision detection.

### 5. Horse Riding
- Players can mount and dismount horses (`obj_horse1`). Riding increases movement speed and uses specialized animation layers (horse body, saddle, player clothes/hair/eyes).

## Building and Running
1.  Open `Veredas Dream.yyp` in **GameMaker Studio 2**.
2.  Ensure the target platform is set (Windows/Mac/Linux).
3.  Press **F5** to run the game in debug mode.
4.  Press **F7** to build an executable.

## Development Conventions
- **Global Data:** Centralized in `script_init.gml` using structs and enums.
- **State Management:** Objects (Player, Horse) use enums for state machines.
- **Layer Naming:** Consistent use of layers like `Tiles_background`, `Tiles_details`, `Tiles_tilled_watered`, and `Instances`.
- **Debug Keys:**
    - `P`: Cycle Seasons
    - `O`: Advance Day
    - `U`: Spawn Test Seeds (Tomato)

## Key Files
- `Veredas Dream.yyp`: Main project file.
- `scripts/script_init/script_init.gml`: Core enums and data definitions.
- `objects/obj_controller/`: Game logic, time, and UI controller.
- `objects/obj_player/`: Player movement, interaction, and rendering logic.
- `objects/obj_inventory/`: Inventory system logic.
- `KEYBINDINGS.md`: Detailed list of player controls.
