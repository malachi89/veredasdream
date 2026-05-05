# Veredas Dream - Keybindings

This document lists all the keyboard and mouse controls implemented in the project, including gameplay and development/debug keys.

## Gameplay Controls

### Movement
- **W**: Move Up
- **A**: Move Left
- **S**: Move Down
- **D**: Move Right
- **Left Shift**: Run

### Interaction
- **E**: Interact with objects (chests, workbench, machines, NPCs, shipping bin).
- **F**: Mount/dismount horse.
- **Left Click**: Use selected tool, plant seeds, or interact with the world (harvest, etc.).
- **Q**: Drop the entire stack of the currently selected item in the Hotbar.

### Inventory Management
- **I**: Open/Close Backpack (Inventory).
- **Escape**: Close Backpack (if open).
- **1 - 9**: Select Hotbar slots 1 to 9.
- **0**: Select Hotbar slot 10.
- **Mouse Wheel Up/Down**: Cycle through Hotbar slots (when Backpack is closed).
- **Left Click (Dragging)**:
    - Click an item to "hold" it.
    - Click an empty slot or another item to swap/place it.
    - Click **outside** the UI areas while the Backpack is open to drop the held item to the ground.

### Other Menus
- **M**: Open/Close Collection Catalog.
- **Enter**: Confirm dialogs / Sleep.
- **Tab**: Chat (multiplayer).

---

## Debug Console Commands (Enter para abrir)

| Comando | Descripción |
|---------|-------------|
| `add_item <key> <qty>` | Añadir items al inventario |
| `add_animal <id>` | Spawnear animal (chicken, cow, duck, goat, ostrich, pig, sheep) |
| `upgrade_tool <key>` | Mejorar herramienta un tier |
| `buy_building <name>` | Construir edificio (chicken_coop, barn, stable, mill, greenhouse) |
| `set_money <amount>` | Establecer dinero |
| `set_energy <amount>` | Establecer energía |
| `heal` | Restaurar energía y HP al máximo |
| `set_day <n>` | Establecer día (1-28) |
| `set_hour <h>` | Establecer hora (0-23) |
| `set_season <name>` | Cambiar estación (spring, summer, fall, winter) |
| `set_weather <tipo>` | Clima (rain, sunny) |
| `unlock <0-7>` | Desbloquear puerta de mina |
| `next_day` | Avanzar un día |
| `next_season` | Cambiar estación |
| `next_hour` | Avanzar una hora |
| `toggle_rain` | Alternar lluvia forzada para mañana |
| `minigame` | Abrir minijuego de captura de insectos |
| `spawn_seeds <qty>` | Spawnear semillas de tomate |

---

*Last updated: May 5, 2026*
