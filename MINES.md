# Mining System — Archivo Técnico

## Resumen

8 puertas en `cave_entrance` (x=120,152,184,216,248,280,312,344), cada una lleva a una mina con un tipo de mineral específico. Cada mina tiene 10 pisos que reutilizan aleatoriamente los 6 layouts de cueva (`cave_1`–`cave_6`). El progreso por mina se guarda (pisos alcanzados) y al reingresar se continúa desde el piso más profundo alcanzado.

## Puertas (Levels 1–8)

| Door index | x     | Mineral   |
|------------|-------|-----------|
| 0          | 120   | Bronce    |
| 1          | 152   | Plata     |
| 2          | 184   | Oro       |
| 3          | 216   | Broncastanio |
| 4          | 248   | Chubestanio |
| 5          | 280   | Picastanio  |
| 6          | 312   | Hitlerstanio |
| 7          | 344   | Vitolanio   |

Solo la puerta 0 está abierta inicialmente. Completar el piso 10 de una mina desbloquea la siguiente puerta.

## Archivos creados

| Archivo | Propósito |
|---------|-----------|
| `scripts/scr_enter_cave_mine/` | Entrar a una mina desde cave_entrance |
| `scripts/scr_go_deeper/` | Bajar al siguiente piso vía ladder_down |
| `scripts/scr_exit_mine/` | Salir de la mina vía ladder_exit |

## Archivos modificados

| Archivo | Cambio |
|---------|--------|
| `script_init.gml` | `ITEM_TYPE.ORE`, `global.ore_data` (8 minerales), `global.ore_rock_sprites`, `global.mine_state`, `global.mine_unlocks`, `global.mine_progress`, `global.gemstone_data`, `global.gemstone_pool`, `coal` en `material_data` |
| `obj_rock/Create_0.gml` | Variables: `is_ore_rock`, `is_coal_rock`, `is_gemstone_rock`, `ore_type_index`, `ore_item_key`, `hit_counter`, `max_hits` |
| `obj_rock/Draw_64.gml` | Health bar usa `max_hits` en vez de hardcoded 10 |
| `scr_populate_cave.gml` | Acepta `_ore_type` y `_floor`; genera rocas de mineral, carbón y gemas según porcentajes |
| `script_player_actions.gml` (scr_use_item) | Lógica de minado por tiers, drops condicionales, spawn de ladder_down 3% |
| `obj_player/Create_0.gml` | `prev_on_door`; `ore_data` y `gemstone_data` en `add_item` |
| `obj_player/Step_0.gml` | Auto-entry por colisión con puerta; ladder usa prompt con SI/NO |
| `obj_controller/Create_0.gml` | `mine_prompt_open`, `mine_prompt_type`, `mine_prompt_selection` |
| `obj_controller/Step_0.gml` | Input handling del prompt; `cave_repopulate` con soporte mine mode |
| `obj_controller/Draw_64.gml` | Dibuja el prompt; dibuja "Mina de X - Nivel Y" abajo del reloj |
| `script_inventory_functions.gml` | `ore_data` + `gemstone_data` en `scr_get_item_data`; room state captura/restaura `max_hits`, `is_coal_rock`, `is_gemstone_rock`; save/load de `mine_unlocks` y `mine_progress` |
| `obj_item_parent/Step_0.gml` | Resolución de sprite y nombre para `ore_data` y `gemstone_data` |
| `cave_entrance.yy` | `clearViewBackground: true`; se eliminó la 9na puerta (x=376) |
| `obj_cave_door_open/Create_0.gml` | `door_index = (x - 120) div 32` |
| `obj_cave_door_closed/Create_0.gml` | `door_index = (x - 120) div 32` |
| `obj_cave_door_closed/Step_0.gml` | Cambia sprite a open cuando `global.mine_unlocks[door_index]` es true |
| `obj_camera/Step_0.gml` | Salas más chicas que la cámara se posicionan en (0,0) en vez de coordenadas negativas |
| `obj_transition.yy` | `visible: false` |

## Globals

### `global.mine_state`
```gml
{
    active: false,      // true mientras el jugador está dentro de una mina
    door_index: -1,     // 0-7, qué puerta se usó para entrar
    ore_type: -1,       // 0-7, mismo valor que door_index
    floor: 1,           // 1-10, piso actual
    entry_door_x: 0,    // para posicionar al jugador al salir
    entry_door_y: 0
}
```

### `global.mine_unlocks`
Array de 8 bools. Index 0 empieza en `true` (puerta 1 = Bronce siempre abierta).

### `global.mine_progress`
Array de 8 ints. Progreso máximo por puerta. 0 = no visitado. Se actualiza al bajar de piso (`scr_go_deeper`) y al salir (`scr_exit_mine`).

### `global.ore_data`
8 minerales principales: `ore_bronce`, `ore_plata`, ... `ore_vitolanio`. Sprite: `sprite_metals` frames 0-7. Sell price 10-1280.

### `global.gemstone_data`
12 gemas: ruby → alexandrite. Sprite: `sprite_gemstones` frames 0-11. Weighted pool en `global.gemstone_pool`.

## Distribución de rocas por piso (mine mode)

| Tipo | Porcentaje |
|------|-----------|
| Gema  | 1% |
| Carbón | 4% |
| Mineral | `5 + piso * 3` (8% → 35%) |
| Normal | Resto |

## Mecánica de minado por tiers

`diff = ore_tier - pickaxe_tier`

| diff | Efecto |
|------|--------|
| ≤ 1 | Daño normal |
| 2 | Golpe por medio (hit_counter toggle) |
| ≥ 3 | Imposible: "Necesitas un pico mas fuerte" |

`ore_tier = ore_type_index + 1` (Bronce=1, ..., Vitolanio=8)
`pickaxe_tier = calidad del pico en el inventario` (OXIDADO=0, ..., VITOLANIO=8)

## Ladder Down

- 3% de probabilidad por roca destruida (solo pisos 1-9)
- Si se destruye la última roca sin que aparezca una escalera, se genera una automáticamente al lado del jugador
- Al presionar E cerca: prompt "Bajar al siguiente nivel?" con SI/NO

## Ladder Exit

- Siempre presente en cada sala de cueva (parte del layout)
- Al presionar E cerca: prompt "Salir de la mina?" con SI/NO
- Al confirmar: teletransporta a `cave_entrance` frente a la puerta correspondiente

## Progresión

1. Puerta 1 (Bronce) siempre abierta
2. Al alcanzar piso 10 de una mina, se desbloquea la siguiente puerta
3. El progreso por mina se guarda en `global.mine_progress[]`
4. Al reingresar a una mina, se comienza desde `max(1, mine_progress[d])`
5. Los datos de progreso y desbloqueos se guardan en `savegame.json` (version 3)

## Comandos debug

- `unlock <0-7>` — Desbloquea una puerta específica
- `add_item ore_bronce 5` — Agrega mineral al inventario
