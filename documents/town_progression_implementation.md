# Town Progression — Implementation Details

Implementación técnica del sistema de restauración del town. Para el diseño y requisitos por etapa ver [`plans/TOWN_PROGRESSION.md`](plans/TOWN_PROGRESSION.md).

---

## Índice

1. [Arquitectura](#arquitectura)
2. [Estado global y persistencia](#estado-global-y-persistencia)
3. [Enum TownStage](#enum-townstage)
4. [Resolución de keys `*_any`](#resolución-de-keys-_any)
5. [Flujo de donación](#flujo-de-donación)
6. [Sistema de construcción (días absolutos)](#sistema-de-construcción-días-absolutos)
7. [Restauración visual](#restauración-visual)
8. [Visibilidad por instancia](#visibilidad-por-instancia)
9. [Construction sites dinámicos](#construction-sites-dinámicos)
10. [Buses (autobuses con movimiento)](#buses-autobuses-con-movimiento)
11. [Tiendas NPC sincronizadas](#tiendas-npc-sincronizadas)
12. [Cap de upgrades de herramienta](#cap-de-upgrades-de-herramienta)
13. [Comandos debug](#comandos-debug)
14. [Save / Load](#save--load)
15. [Archivos modificados/creados](#archivos-modificadoscreados)
16. [Pendiente / mejoras futuras](#pendiente--mejoras-futuras)

---

## Arquitectura

El sistema vive principalmente en un script único:

- **`scripts/script_town_progression/script_town_progression.gml`** — todas las funciones del sistema (~340 líneas).

Se integra con:

- **`obj_controller`** — inicializa globals, dispara `scr_restore_town_stage()` al entrar al town, expone comando debug `set_town_stage`.
- **`obj_donation_table`** — interactuable que dispara donaciones (sprite ya existente, instancia ya colocada en el town room).
- **`obj_construction_site`** — sprite estático que se spawnea/destruye dinámicamente.
- **`obj_bus_down`, `obj_bus_up`** — autobuses con movimiento autónomo.
- **`scr_upgrade_tool`** — leído `global.town_stage` para gating de upgrades.
- **`scr_save_game` / `scr_apply_loaded_game`** — persistencia del estado.

---

## Estado global y persistencia

Globals inicializados en `obj_controller/Create_0.gml`:

```gml
global.town_stage = TownStage.INITIAL;
global.town_donations = {};            // {req_key: donated_qty, ...}
global.town_construction_day = 0;      // dia absoluto cuando empezo construccion
global.town_construction_duration = 0; // duracion en dias (0 = sin construccion)
scr_update_shop_availability();
```

`global.town_donations` es un struct dinámico cuyas keys son los requirement keys (ej. `stone`, `forage_any`) y valores son cantidades acumuladas. Se limpia en cada `scr_advance_town_stage()`.

---

## Enum TownStage

13 estados (definidos en `script_init.gml`):

| # | Nombre | Notas |
|---|--------|-------|
| 0 | INITIAL | Estado destruido inicial |
| 1 | STREETS_CLEARED | Stage 1 completado (calles limpias) |
| 2 | GREENS_RESTORED | Stage 2 completado (jardines) |
| 3 | STREETS_RESTORED | Stage 3 completado (calles) |
| 4 | SHOP_CONSTRUCTION | Stage 4 en construcción (3 días) |
| 5 | SHOP_RESTORED | Tienda Miraculos restaurada |
| 6 | BLACKSMITH_CONSTRUCTION | Stage 5 en construcción (3 días) |
| 7 | BLACKSMITH_RESTORED | Herrería + Carlos disponibles |
| 8 | TREES_RESTORED | Stage 6 completado (árboles) |
| 9 | BUILDINGS_CONSTRUCTION | Stage 7 en construcción (4 días) |
| 10 | BUILDINGS_RESTORED | Torre + parque |
| 11 | URBANIZATION_CONSTRUCTION | Stage 8 en construcción (3 días) |
| 12 | URBANIZATION_COMPLETE | Urban road + buses moviéndose |

**Convención:** las donaciones de la "etapa N" se piden cuando el estado es la etapa anterior. Ej: para completar la etapa 1, el estado debe ser `INITIAL` (0); al completar avanza a `STREETS_CLEARED` (1).

`scr_get_town_stage_name(_stage)` devuelve el nombre legible en español de cada estado para UI/notificaciones.

---

## Resolución de keys `*_any`

Las keys que terminan en `_any` se resuelven por **prefijo string** sobre el item key del slot, con dos casos especiales.

### `scr_match_donation_key(_req_key, _item_key)`

Lógica:

1. Match exacto: `_req_key == _item_key` → true.
2. Si no termina en `_any` → false.
3. **Caso especial `fruit_any`**: busca en `global.crop_data` y verifica `is_fruit_tree: true`. Frutas válidas: cherry, apricot, strawberry, blueberry, banana, orange, mango, peach, watermelon, melon, pineapple, wild_berry, grapes, apple.
4. **Caso especial `pelt_any`**: incluye prefijo `pelt_` Y `rabbit_pelt_` (no incluye `cow_hide_*`).
5. Resto: prefijo = `_req_key` sin los últimos 4 chars (`_any`). Match si `string_pos(prefijo, _item_key) == 1`.

### Tabla de resolución

| Key del plan | Prefijo efectivo | Bases de datos cubiertas |
|--------------|------------------|---------------------------|
| `cloth_any` | `cloth_` | `crafting_material_data` |
| `thread_any` | `thread_` | `crafting_material_data` |
| `yarn_any` | `yarn_` | `crafting_material_data` |
| `leather_any` | `leather_` | `crafting_material_data` (solo `leather_*`, NO cow_hide ni rabbit_pelt) |
| `pelt_any` | (especial) | `pelt_*` + `rabbit_pelt_*` |
| `egg_any` | `egg_` | `animal_product_data` (egg_chicken_*, egg_duck_*) |
| `dye_any` | `dye_` | `dye_data` (14 colores) |
| `gemstone_any` | `gemstone_` | `gemstone_data` (12 gemas) |
| `forage_any` | `forage_` | `forage_data` (mushrooms + herbs + flowers) |
| `forage_m_any` | `forage_m` | Solo champiñones (78) |
| `forage_f_any` | `forage_f` | Solo flores (22) |
| `forage_h_any` | `forage_h` | Solo hierbas (19) |
| `fruit_any` | (especial) | `crop_data[is_fruit_tree=true]` |

### `scr_resolve_donation_target(_item_key, _stage)`

Para un item del inventario, devuelve la requirement key contra la cual debe contar (o `undefined` si no aplica). Itera primero match exactos, luego `_any` matches.

---

## Flujo de donación

Al pulsar **E** cerca de `obj_donation_table`:

1. **Step event** del table verifica:
   - Distancia al jugador < 48 px
   - No hay otras UIs abiertas (shop, dialog, backpack, donation, etc.)
   - Cooldown de interacción terminó (20 frames)
2. Si `town_stage >= URBANIZATION_COMPLETE` → notifica "Town restaurado" y salir.
3. Si hay construcción en progreso → notifica días restantes y salir.
4. **Abre el panel de donativos** (`_lp.donation_box_open = true`).

### Panel de donativos (UI)

Dibujado en `obj_inventory/Draw_64.gml` cuando `_p.donation_box_open == true`. Layout 720×600 px centrado:

- **Header:** `"Donativos: <nombre etapa>"` + hint `[ESC] Cerrar`
- **Filas** (una por requirement, ~56 px alto):
  - **Checkbox** a la izquierda: rectángulo vacío con borde plateado si pendiente, borde verde lima con palomita pintada por `draw_line_width` si completo
  - **Icono** del item (sprite del primer item matching para `_any` keys)
  - **Nombre legible**: para `_any` usa nombres como "Tela (cualquier color)"; para items específicos usa `name` de la base de datos
  - **Progreso** `X / Y` a la derecha (verde lima si completo)
  - **Hover hint** abajo: `[Click] Donar (N disp.)` cuando el cursor está sobre la fila y el req no está completo, o `Sin items` si el jugador no tiene
- **Footer:** mensaje temporal (90 frames) tras donar

### Interacción

- **Click sobre una fila no completa** → llama a `scr_donate_specific_target(_target_key, _player)`. Dona del inventario los items que cumplan ese requirement específico, hasta cubrir lo faltante. Restantes en otros requirements no se tocan.
- **Click sobre fila completa** → ignorado (no hace nada).
- **ESC** → cierra el panel.
- **Si la donación completa toda la etapa** → mensaje "Etapa completada!" + cierre automático del panel + `scr_complete_donation_stage` (instant advance o construction start).

### Helpers

#### `scr_donate_to_town(_player)` (auto-donate, fallback)

Itera inventario completo y dona TODO lo aplicable de una vez. **Ya no se usa desde el flujo normal**, pero se mantiene como utilidad o para uso futuro (ej: comando debug "donar todo").

#### `scr_donate_specific_target(_target_key, _player)`

```gml
// 1. Calcula faltante: needed - donated
// 2. Itera inventory + backpack
// 3. Solo considera slots cuyo key matchee _target_key (vía scr_match_donation_key)
// 4. Toma min(slot.quantity, needed) hasta cubrir
// 5. Si la etapa se completa: llama scr_complete_donation_stage
```

Devuelve `{ donated, items_donated, completed }`.

#### `scr_get_donation_target_display(_target_key)`

Devuelve `{ sprite, subimg, name, is_group }` para renderizar el ícono y nombre del requirement. Para `_any` keys mapea a un nombre amigable (`"Tela (cualquier color)"`) y busca un item representativo de la categoría para usar su sprite. Fallback `sprite: -1` si no encuentra.

---

## Sistema de construcción (días absolutos)

### `scr_complete_donation_stage(_current_stage)`

Decide al completar las donaciones:

```gml
var _construction_days = scr_get_stage_construction_duration(_current_stage);
var _next_stage = _current_stage + 1;

if (_construction_days > 0) {
    scr_advance_town_stage(_next_stage);          // -> CONSTRUCTION state
    scr_start_town_construction(_construction_days);
} else {
    scr_advance_town_stage(_next_stage);          // instantáneo
}
```

### Duraciones por etapa

| Etapa donada | Estado siguiente | Días |
|--------------|------------------|------|
| INITIAL | STREETS_CLEARED | 0 (instant) |
| STREETS_CLEARED | GREENS_RESTORED | 0 |
| GREENS_RESTORED | STREETS_RESTORED | 0 |
| **STREETS_RESTORED** | **SHOP_CONSTRUCTION** | **3** |
| **SHOP_RESTORED** | **BLACKSMITH_CONSTRUCTION** | **3** |
| BLACKSMITH_RESTORED | TREES_RESTORED | 0 |
| **TREES_RESTORED** | **BUILDINGS_CONSTRUCTION** | **4** |
| **BUILDINGS_RESTORED** | **URBANIZATION_CONSTRUCTION** | **3** |

### Días absolutos (bug fix)

`global.day` resetea cada estación, lo que rompía `_days_passed` entre estaciones.

```gml
function scr_total_days() {
    return ((global.year - 1) * 4 * global.days_per_season)
         + (global.season_index * global.days_per_season)
         + global.day;
}
```

Tanto `scr_start_town_construction` como `scr_check_town_construction_completed` usan `scr_total_days()` para contar correctamente atravesando estaciones.

### Auto-avance al re-entrar al town

En `obj_controller/Step_0.gml`, en el bloque de transición de room:

```gml
if (_room_name == "town") {
    if (scr_check_town_construction_completed()) {
        scr_advance_town_stage(global.town_stage + 1);
        scr_notify("Construccion terminada: " + scr_get_town_stage_name(global.town_stage));
    } else {
        scr_restore_town_stage();
    }
}
```

La construcción "se materializa" cuando el jugador re-entra al town, no cuando duerme. Esto evita procesar transiciones cuando el jugador no está mirando.

---

## Restauración visual

`scr_restore_town_stage()` aplica visibilidad del town según `global.town_stage`. Solo corre si `room_get_name(room) == "town"`. Llama secuencialmente a:

1. **Capas de tiles** (visibilidad por layer):
   ```gml
   destroyed_details   = (_stage < TownStage.STREETS_CLEARED);     // hide a partir de stage 1
   destroyed_floors    = (_stage < TownStage.STREETS_RESTORED);    // hide a partir de stage 3
   restored_floors     = (_stage >= TownStage.GREENS_RESTORED);    // show desde stage 2
   restored_road       = (_stage >= TownStage.STREETS_RESTORED);   // show desde stage 3
   trees               = (_stage >= TownStage.TREES_RESTORED);     // show desde stage 6 (8)
   urban_road          = (_stage >= TownStage.URBANIZATION_COMPLETE);
   ```
2. **Capas de instancias** siempre visibles (control por instancia):
   - `Instances_destroyed_buildings` y `Instances_restored_buildings` quedan `visible: true` siempre.
3. **`scr_set_town_instance_visibility()`** — visibilidad individual.
4. **`scr_clear_construction_sites()`** — destruye sitios de obra previos.
5. Si construcción activa: **`scr_spawn_construction_sites_for_stage(_stage)`**.
6. **`scr_setup_buses(_stage)`** — spawnea/destruye buses.

---

## Visibilidad por instancia

Como múltiples edificios viven en la misma layer `Instances_restored_buildings`, no se puede usar visibilidad de layer. `scr_set_town_instance_visibility()` identifica edificios por **posición Y** (la layer no expone editor names en runtime):

```gml
with (obj_shop_destroyed) {
    if (room_get_name(room) != "town") {
        // skip
    } else if (abs(y - 412) < 80) {  // Miraculos shop destroyed
        visible = (_stage <= TownStage.STREETS_RESTORED);
    } else if (abs(y - 82) < 80) {   // Blacksmith destroyed
        visible = (_stage <= TownStage.SHOP_RESTORED);
    }
}
// ... mismo patrón para obj_shop, obj_apartments_tower, etc.
```

### Tabla de visibilidad

| Objeto | Posición | Visible cuando |
|--------|----------|----------------|
| `obj_shop_destroyed` (Miraculos) | y≈412 | `_stage <= STREETS_RESTORED` (3) |
| `obj_shop_destroyed` (Blacksmith) | y≈82 | `_stage <= SHOP_RESTORED` (5) |
| `obj_shop` (Miraculos restored) | y≈343 | `_stage >= SHOP_RESTORED` (5) |
| `obj_shop` (Blacksmith restored) | y≈25 | `_stage >= BLACKSMITH_RESTORED` (7) |
| `obj_apartments_tower` | — | `_stage >= BUILDINGS_RESTORED` (10) |
| `obj_kid_park` | — | `_stage >= BUILDINGS_RESTORED` (10) |
| `obj_bus_stop_1` | — | `_stage >= URBANIZATION_COMPLETE` (12) |
| `obj_bus_stop_2` | — | `_stage >= URBANIZATION_COMPLETE` (12) |
| `obj_npc` con `npc_key="Carlos"` | — | `_stage >= BLACKSMITH_RESTORED` (7) |

**Nota:** los edificios no tienen colisión propia (no heredan de `obj_collision`), así que invisibles no bloquean movimiento. La colisión real está en la layer `Instances_collision`.

---

## Construction sites dinámicos

`scr_spawn_construction_sites_for_stage(_stage)` crea instancias de `obj_construction_site` en posiciones extraídas de `rooms/town/town.yy`:

| Estado | Posiciones |
|--------|------------|
| `SHOP_CONSTRUCTION` | (871, 412) — Miraculos shop |
| `BLACKSMITH_CONSTRUCTION` | (865, 82) — Blacksmith |
| `BUILDINGS_CONSTRUCTION` | (100, 93) apartments + (385, 242) kid_park |
| `URBANIZATION_CONSTRUCTION` | (788, 247) bus_stop_1 + (573, 734) bus_stop_2 |

Se crean en la layer `Instances_restored_buildings` (fallback `Instances`).

`scr_clear_construction_sites()` ejecuta `with (obj_construction_site) instance_destroy()` antes de crear nuevos para evitar duplicados.

`obj_construction_site` Create event: `image_speed = 0; depth = -bbox_bottom;`. Step event refresca depth para sorting correcto.

---

## Buses (autobuses con movimiento)

### `scr_setup_buses(_stage)`

```gml
if (_stage >= TownStage.URBANIZATION_COMPLETE) {
    if (!instance_exists(obj_bus_down)) instance_create_layer(700, -100, _layer, obj_bus_down);
    if (!instance_exists(obj_bus_up))   instance_create_layer(750, 1000, _layer, obj_bus_up);
} else {
    with (obj_bus_down) instance_destroy();
    with (obj_bus_up) instance_destroy();
}
```

### `obj_bus_down`

- **Spawn:** (700, -100). Se mueve hacia abajo a 50 px/s (`bus_speed = 50 / room_speed`).
- **Pausa:** 3 segundos (180 frames) en `y = 740` (parada de bus_stop_2).
- **Loop:** al cruzar `y = 1000`, vuelve a `y = -100` y resetea `paused_at_y = false`.
- **State machine:** 0 = moviendo, 1 = pausado.

### `obj_bus_up`

- **Spawn:** (750, 1000). Se mueve hacia arriba.
- **Pausa:** 3 segundos en `y = 250` (parada de bus_stop_1).
- **Loop:** al cruzar `y = -100`, vuelve a `y = 1000`.

Ambos refrescan `depth = -bbox_bottom;` cada step para sorting correcto.

---

## Tiendas NPC sincronizadas

`global.shop_data["Miraculos"]` y `["Carlos"]` arrancan ahora con `available: false` en `script_init.gml`. La sincronización ocurre vía:

```gml
function scr_update_shop_availability() {
    if (variable_struct_exists(global.shop_data, "Miraculos")) {
        global.shop_data[$ "Miraculos"].available = (global.town_stage >= TownStage.SHOP_RESTORED);
    }
    if (variable_struct_exists(global.shop_data, "Carlos")) {
        global.shop_data[$ "Carlos"].available = (global.town_stage >= TownStage.BLACKSMITH_RESTORED);
    }
}
```

Llamada desde:
- `obj_controller/Create_0.gml` — al iniciar fresh game
- `scr_apply_loaded_game()` — al cargar partida (sincroniza con town_stage del save)
- `scr_advance_town_stage()` — en cada avance de etapa
- `set_town_stage` debug command

`obj_npc/Step_0.gml` ya verifica `_shop_data.available` antes de abrir la UI de tienda al pulsar E, así que un NPC visible pero con shop "no disponible" no abre nada al interactuar.

---

## Cap de upgrades de herramienta

`scr_upgrade_tool` en `script_player_actions.gml`:

```gml
if (_cur >= QUALITY.VITOLANIO) {
    scr_notify(_tool_key + " ya esta al maximo");
    return;
}
if (_cur >= QUALITY.CHUBESTANIO && global.town_stage < TownStage.BLACKSMITH_RESTORED) {
    scr_notify("La herreria del town no esta lista para upgrades mayores.");
    return;
}
_slot.quality = _cur + 1;
```

Por debajo de `BLACKSMITH_RESTORED` (estado 7), el cap es **CHUBESTANIO (5)** — al intentar upgradear desde nivel 5 a 6 (PICASTANIO) se rechaza. A partir del estado 7, el cap real es **VITOLANIO (8)**.

Nota sobre la enum: la quality enum es 0-indexed (OXIDADO=0, BRONCE=1, ..., CHUBESTANIO=5, ..., VITOLANIO=8). El plan original mencionaba "nivel 6" para CHUBESTANIO usando 1-indexing.

---

## Comandos debug

### `set_town_stage <n>`

```
set_town_stage 0   → INITIAL
set_town_stage 5   → SHOP_RESTORED (incluye Miraculos shop disponible)
set_town_stage 12  → URBANIZATION_COMPLETE (todo restaurado, buses corriendo)
```

Implementación en `obj_controller/Step_0.gml`:

```gml
} else if (_cmd == "set_town_stage" && array_length(_parts) >= 2) {
    var _ts = clamp(real(_parts[1]), 0, TownStage.URBANIZATION_COMPLETE);
    global.town_stage = _ts;
    global.town_donations = {};
    global.town_construction_day = 0;
    global.town_construction_duration = 0;
    scr_update_shop_availability();
    scr_restore_town_stage();
    scr_notify("Town stage: " + string(_ts) + " (" + scr_get_town_stage_name(_ts) + ")");
}
```

Resetea donaciones y construcción, sincroniza tiendas, y aplica visuales.

### `command_list`

Imprime los 26 comandos disponibles al GMS debug console y como una notificación multi-línea de 10 segundos en pantalla.

---

## Save / Load

### Serialización

`scr_save_game()` añade al struct guardado:

```gml
town_stage: global.town_stage,
town_donations: global.town_donations,
town_construction_day: global.town_construction_day,
town_construction_duration: global.town_construction_duration
```

### Deserialización

`scr_apply_loaded_game()` con migración para saves viejos:

```gml
if (variable_struct_exists(_save_data, "town_stage")) {
    global.town_stage = _save_data.town_stage;
    global.town_donations = variable_struct_exists(_save_data, "town_donations") ? _save_data.town_donations : {};
    global.town_construction_day = ... ?: 0;
    global.town_construction_duration = ... ?: 0;
} else {
    // Save pre-town-progression: defaults
    global.town_stage = TownStage.INITIAL;
    global.town_donations = {};
    global.town_construction_day = 0;
    global.town_construction_duration = 0;
}
scr_update_shop_availability();
```

Saves viejos cargan en `INITIAL` con shops cerrados — el usuario puede usar `set_town_stage 12` para saltar al estado final si quiere preservar acceso.

---

## Archivos modificados/creados

### Nuevos
- `scripts/script_town_progression/script_town_progression.gml` (~340 líneas)
- `scripts/script_town_progression/script_town_progression.yy`
- `objects/obj_donation_table/Create_0.gml`
- `objects/obj_donation_table/Step_0.gml`
- `objects/obj_donation_table/Draw_0.gml`
- `objects/obj_construction_site/Create_0.gml`
- `objects/obj_construction_site/Step_0.gml`
- `objects/obj_bus_down/Create_0.gml`
- `objects/obj_bus_down/Step_0.gml`
- `objects/obj_bus_up/Create_0.gml`
- `objects/obj_bus_up/Step_0.gml`

### Modificados
- `Veredas Dream.yyp` — registro del nuevo script
- `scripts/script_init/script_init.gml` — enum `TownStage`, Miraculos/Carlos arrancan con `available: false`
- `scripts/script_inventory_functions/script_inventory_functions.gml` — save/load del estado town
- `scripts/script_player_actions/script_player_actions.gml` — cap de upgrades en `scr_upgrade_tool`
- `objects/obj_controller/Create_0.gml` — globals + `scr_update_shop_availability()`
- `objects/obj_controller/Step_0.gml` — auto-avance al re-entrar town, comandos `set_town_stage` y `command_list`
- `objects/obj_donation_table/obj_donation_table.yy` — eventList con Create/Step/Draw
- `objects/obj_construction_site/obj_construction_site.yy` — eventList con Create/Step
- `objects/obj_bus_down/obj_bus_down.yy` — eventList con Create/Step
- `objects/obj_bus_up/obj_bus_up.yy` — eventList con Create/Step
- `documents/plans/TOWN_PROGRESSION.md` — refinamientos del plan (items que existen, prefijos `*_any`, etc.)

---

## Pendiente / mejoras futuras

Funcionalidad que NO afecta el sistema base pero está mencionada en el plan:

1. **Mensajes específicos por etapa** — el plan menciona strings como "Restaurando los jardines del town...", "La tienda estará lista en X días...". Actualmente se usan los nombres genéricos de `scr_get_town_stage_name`.

2. **NPCs vecinos en stage 7** — el plan dice "NPCs de vecinos aparecen en el town" pero no especifica qué objetos. No existen objetos de vecinos genéricos. Requeriría crear nuevos `obj_npc` instances o un sistema de vecinos.

3. **Donación slot-por-slot** — el panel actual dona TODO lo aplicable de una key con un click. Una mejora más granular sería permitir donar slot-por-slot del inventario (ej: el jugador tiene 50 stones en inventario y 80 en backpack, y elige cuál stack donar primero). Para esto se requeriría un modo "donation pick" del inventario.

4. **Sin colisión durante construcción** — si un edificio ahora invisible tuviera colisión, el jugador no podría caminar por donde antes había escombros. Actualmente los edificios del town no heredan de `obj_collision` así que esto no es problema, pero a tomar en cuenta si se agregan colisiones por sprite.

5. **Multiplayer sync** — `global.town_stage` no se sincroniza vía `script_net.gml`. Si el host avanza una etapa, el client no se entera hasta cargar partida. Habría que añadir un `NET_CMD.TOWN_STAGE_UPDATE`.

6. **Scroll en panel de donativos** — actualmente las 9 filas máximas caben sin scroll en el panel 720×600. Si una etapa futura tuviera más de 9 requirements habría que añadir scroll vertical.
