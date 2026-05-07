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
10. [Colisiones del town](#colisiones-del-town)
11. [Depth sorting de edificios](#depth-sorting-de-edificios)
12. [Transiciones a tiendas interiores](#transiciones-a-tiendas-interiores)
13. [NPCs en interiores](#npcs-en-interiores)
14. [Buses (autobuses con movimiento)](#buses-autobuses-con-movimiento)
15. [Tiendas NPC sincronizadas](#tiendas-npc-sincronizadas)
16. [Cap de upgrades de herramienta](#cap-de-upgrades-de-herramienta)
17. [Comandos debug](#comandos-debug)
18. [Save / Load](#save--load)
19. [Sincronización multiplayer](#sincronización-multiplayer)
20. [Archivos modificados/creados](#archivos-modificadoscreados)
21. [Pendiente / mejoras futuras](#pendiente--mejoras-futuras)

---

## Arquitectura

El sistema vive principalmente en un script único:

- **`scripts/script_town_progression/script_town_progression.gml`** — todas las funciones del sistema.

Se integra con:

- **`obj_controller`** — inicializa globals, dispara `scr_restore_town_stage()` al entrar al town y al entrar a `general_shop`/`blacksmith`, expone comando debug `set_town_stage`.
- **`obj_donation_table`** — interactuable que dispara donaciones. Se oculta al alcanzar `URBANIZATION_COMPLETE`.
- **`obj_construction_site`** — sprite estático que se spawnea/destruye dinámicamente. Crea su propio companion `obj_collision` en Create y lo destruye en CleanUp.
- **`obj_bus_down`, `obj_bus_up`** — autobuses con movimiento autónomo. Incluidos en el `move_and_collide` del player.
- **`obj_shop`, `obj_shop_destroyed`, `obj_apartments_tower`, `obj_kid_park`, `obj_bus_stop_1`, `obj_bus_stop_2`** — edificios del town, todos con `depth = -bbox_bottom` en Create para depth sorting correcto.
- **`scr_upgrade_tool`** — lee `global.town_stage` para gating de upgrades.
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
| 3 | STREETS_RESTORED | Stage 3 completado (calles + road) |
| 4 | SHOP_CONSTRUCTION | Tienda Miraculos en construcción (3 días) |
| 5 | SHOP_RESTORED | Tienda Miraculos restaurada |
| 6 | BLACKSMITH_CONSTRUCTION | Herrería en construcción (3 días) |
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
3. **Caso especial `fruit_any`**: busca en `global.crop_data` y verifica `is_fruit_tree: true`.
4. **Caso especial `pelt_any`**: incluye prefijo `pelt_` Y `rabbit_pelt_` (no incluye `cow_hide_*`).
5. Resto: prefijo = `_req_key` sin los últimos 4 chars (`_any`). Match si `string_pos(prefijo, _item_key) == 1`.

### `scr_resolve_donation_target(_item_key, _stage)`

Para un item del inventario, devuelve la requirement key contra la cual debe contar (o `undefined` si no aplica). Itera primero match exactos, luego `_any` matches.

---

## Flujo de donación

Al pulsar **E** cerca de `obj_donation_table`:

1. **Step event** del table verifica:
   - Distancia al jugador < 48 px
   - No hay otras UIs abiertas
   - Cooldown de interacción terminó (20 frames)
2. Si `town_stage >= URBANIZATION_COMPLETE` → notifica "Town restaurado" y salir.
3. Si hay construcción en progreso → notifica días restantes y salir.
4. **Abre el panel de donativos** (`_lp.donation_box_open = true`).

### Panel de donativos (UI)

Dibujado en `obj_inventory/Draw_64.gml` cuando `_p.donation_box_open == true`. Layout 720×600 px centrado.

### Interacción

- **Click sobre una fila no completa** → llama a `scr_donate_specific_target(_target_key, _player)`.
- **ESC** → cierra el panel.
- **Si la donación completa toda la etapa** → mensaje + cierre automático + `scr_complete_donation_stage`.

---

## Sistema de construcción (días absolutos)

### `scr_complete_donation_stage(_current_stage)`

Decide al completar las donaciones si la siguiente etapa requiere días de construcción o es instantánea.

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

### Días absolutos

`global.day` resetea cada estación; `scr_total_days()` calcula el día absoluto para que las construcciones funcionen entre estaciones.

### Detección de etapa de construcción

`scr_is_construction_stage(_stage)` — devuelve `true` para los 4 estados de construcción. Usado en `scr_restore_town_stage` para spawnear construction sites (no depende de `town_construction_duration`, por eso el comando debug `set_town_stage` funciona correctamente).

### Auto-avance al re-entrar al town

En `obj_controller/Step_0.gml`, bloque de transición de room:

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

---

## Restauración visual

`scr_restore_town_stage()` aplica visibilidad del town según `global.town_stage`. Solo corre si `room_get_name(room) == "town"`. Llama secuencialmente a:

1. **Capas de tiles** (visibilidad por layer):
   ```gml
   destroyed_details   = (_stage < TownStage.STREETS_CLEARED);
   destroyed_floors    = (_stage < TownStage.STREETS_RESTORED);
   restored_floors     = (_stage >= TownStage.GREENS_RESTORED);
   restored_road       = (_stage >= TownStage.STREETS_RESTORED);
   trees               = (_stage >= TownStage.TREES_RESTORED);
   urban_road          = (_stage >= TownStage.URBANIZATION_COMPLETE);
   ```
   **Nota:** `scr_setup_forest_trees()` se excluye del town en `obj_controller/Step_0.gml` (`if (_room_name != "town")`) para evitar que cree una capa dinámica `Tiles_trees_top` que ignoraría la visibilidad controlada.

2. **Capas de instancias** siempre visibles: `Instances_destroyed_buildings` y `Instances_restored_buildings`.
3. **`scr_set_town_instance_visibility()`** — visibilidad individual.
4. **`scr_clear_construction_sites()`** + spawn si etapa de construcción activa.
5. **`scr_setup_buses(_stage)`** — spawnea/destruye buses.
6. **`scr_manage_shop_town_transition(_stage)`** — transición a `general_shop`.
7. **`scr_manage_blacksmith_town_transition(_stage)`** — transición a `blacksmith`.
8. **`scr_rebuild_town_collisions(_stage)`** — colisiones dinámicas y control de colisiones manuales.

---

## Visibilidad por instancia

`scr_set_town_instance_visibility()` identifica edificios por posición Y (el runtime no expone editor names):

### Tabla de visibilidad

| Objeto | Condición | Visible cuando |
|--------|-----------|----------------|
| `obj_shop_destroyed` (Miraculos, y≈412) | `_stage <= STREETS_RESTORED` (3) | Fases 0–3 |
| `obj_shop_destroyed` (Blacksmith, y≈82) | `_stage <= SHOP_RESTORED` (5) | Fases 0–5 |
| `obj_shop` (Miraculos, y≈343) | `_stage >= SHOP_RESTORED` (5) | Fase 5+ |
| `obj_shop` (Blacksmith, y≈25) | `_stage >= BLACKSMITH_RESTORED` (7) | Fase 7+ |
| `obj_apartments_tower` | `_stage >= BUILDINGS_RESTORED` (10) | Fase 10+ |
| `obj_kid_park` | `_stage >= BUILDINGS_RESTORED` (10) | Fase 10+ |
| `obj_bus_stop_1` | `_stage >= URBANIZATION_COMPLETE` (12) | Fase 12 |
| `obj_bus_stop_2` | `_stage >= URBANIZATION_COMPLETE` (12) | Fase 12 |
| `obj_npc` Miraculos (town) | `_stage < SHOP_CONSTRUCTION` (4) | Fases 0–3 |
| `obj_npc` Carlos (town) | `_stage < BLACKSMITH_CONSTRUCTION` (6) | Fases 0–5 |
| `obj_donation_table` | `_stage < URBANIZATION_COMPLETE` (12) | Fases 0–11 |

---

## Construction sites dinámicos

`scr_spawn_construction_sites_for_stage(_stage)` crea instancias de `obj_construction_site`:

| Estado | Posiciones (x, y) |
|--------|-------------------|
| `SHOP_CONSTRUCTION` | (871, 340) |
| `BLACKSMITH_CONSTRUCTION` | (865, 55) |
| `BUILDINGS_CONSTRUCTION` | (385, 180) apartments + (385, 242) kid_park |
| `URBANIZATION_CONSTRUCTION` | (758, 247) bus_stop_1 + (543, 734) bus_stop_2 |

`obj_construction_site` tiene un **companion `obj_collision`** (96×80px) creado en su Create event y destruido en su CleanUp event, para que el jugador no pueda atravesar los sitios de obra.

---

## Colisiones del town

El sistema combina colisiones manuales colocadas en el room editor con colisiones dinámicas generadas por `scr_rebuild_town_collisions(_stage)`.

### Colisiones manuales (room editor)

Colocadas en la layer `Instances_collision` con nombres de instancia accesibles en runtime. Se activan/desactivan moviendo la instancia a (-9999, -9999) cuando inactiva:

| Instancia | Activa desde | Posición original |
|-----------|-------------|-------------------|
| `inst_miraculos_store1` | `SHOP_RESTORED` (5) | (892, 396) |
| `inst_miraculos_store2` | `SHOP_RESTORED` (5) | (856, 396) |
| `inst_blacksmith1` | `BLACKSMITH_RESTORED` (7) | (892, 68.5) |
| `inst_blacksmith2` | `BLACKSMITH_RESTORED` (7) | (850, 68.5) |

### Colisiones dinámicas (`scr_spawn_town_collision`)

Spawneadas por `scr_rebuild_town_collisions` con `is_town_building_collision = true`. Se destruyen y recrean en cada llamada:

| Objeto | Activa desde | Posición (x, y) | Scale (sx, sy) |
|--------|-------------|-----------------|----------------|
| Donation table | siempre (< URBANIZATION_COMPLETE) | (1216, 832) | 3×2 |
| Apartments tower base | `BUILDINGS_RESTORED` (10) | (100, 349) | 7×2 |
| Kid park base | `BUILDINGS_RESTORED` (10) | (385, 354) | 11×2 |
| Bus stop 1 | `URBANIZATION_COMPLETE` (12) | (788, 247) | 6×3 |
| Bus stop 2 | `URBANIZATION_COMPLETE` (12) | (573, 734) | 6×3 |

### Buses y construction sites

- **Buses** (`obj_bus_down`, `obj_bus_up`): añadidos directamente al `move_and_collide` del player — colisión basada en su sprite (48×112px) y posición actual.
- **Construction sites**: companion `obj_collision` (96×80px) en Create/CleanUp.

---

## Depth sorting de edificios

Los edificios del town no tenían eventos y su depth era estático (fijo en room editor), causando que el player siempre se dibujara encima. Se añadió `Create_0.gml` con `depth = -bbox_bottom;` a:

- `obj_shop`, `obj_shop_destroyed`
- `obj_apartments_tower`, `obj_kid_park`
- `obj_bus_stop_1`, `obj_bus_stop_2`

El player ya usaba `depth = -bbox_bottom` en su Step. Con esto el sorting es correcto: el jugador aparece detrás del edificio cuando está por encima de su base, y delante cuando está por debajo.

---

## Transiciones a tiendas interiores

Al completarse la construcción de cada tienda, se spawnea dinámicamente un `obj_transition` en el town que lleva al interior. Se gestiona en `scr_restore_town_stage`.

### Tienda Miraculos (`general_shop`)

| | Town (entrada) | general_shop (salida) |
|---|---|---|
| `obj_transition` en town | (863, 425) | — |
| Target en general_shop | — | player spawn: (60, 160) |
| Salida de general_shop | — | town (863, 455) |

- Activa desde: `SHOP_RESTORED` (5)
- Función: `scr_manage_shop_town_transition(_stage)`

### Herrería Carlos (`blacksmith`)

| | Town (entrada) | blacksmith (salida) |
|---|---|---|
| `obj_transition` en town | (863, 80) | — |
| Target en blacksmith | — | player spawn: (60, 160) |
| Salida de blacksmith | — | town (863, 110) |

- Activa desde: `BLACKSMITH_RESTORED` (7)
- Función: `scr_manage_blacksmith_town_transition(_stage)`

Las transiciones previas se destruyen antes de crear nuevas (buscan `target_room == general_shop` o `target_room == blacksmith` en el town).

---

## NPCs en interiores

Al entrar a `general_shop` o `blacksmith`, `obj_controller/Step_0.gml` llama las funciones de setup del room:

```gml
if (_room_name == "general_shop") scr_setup_general_shop();
if (_room_name == "blacksmith")   scr_setup_blacksmith();
```

Estas funciones spawnean el NPC en el interior si el stage es suficiente:

| Función | NPC | Room | Posición | Activo desde |
|---------|-----|------|----------|-------------|
| `scr_setup_general_shop()` | Miraculos | `general_shop` | (60, 90) | `SHOP_RESTORED` (5) |
| `scr_setup_blacksmith()` | Carlos | `blacksmith` | (60, 90) | `BLACKSMITH_RESTORED` (7) |

El NPC se crea con `instance_create_layer(x, y, layer, obj_npc, { npc_key: "Miraculos" })` — el struct como 5° argumento setea `npc_key` antes del Create event. Como los NPCs no son capturados por `scr_capture_current_room_state`, no hay duplicados al re-entrar.

---

## Buses (autobuses con movimiento)

### `scr_setup_buses(_stage)`

Spawnea/destruye buses al stage 12. Spawn positions: `obj_bus_down` en (670, -100), `obj_bus_up` en (720, 1000).

### Ciclo de movimiento

Cada bus recorre ~1100px a 50 px/s. Al llegar al extremo opuesto, espera `loop_pause_frames = 3900` (~65 seg) antes de volver. Ciclo total: **~90 segundos por bus** (1.5 minutos).

| Variable | bus_down | bus_up |
|----------|----------|--------|
| start_y | -100 | 1000 |
| end_y | 1000 | -100 |
| pause_y (parada) | 740 | 250 |
| pause_frames | 180 (3 seg) | 180 (3 seg) |
| loop_pause_frames | 3900 (~65 seg) | 3900 (~65 seg) |
| x | 670 | 720 |

---

## Tiendas NPC sincronizadas

`global.shop_data["Miraculos"]` y `["Carlos"]` arrancan con `available: true` — ambos vendedores están disponibles desde la fase 0 para comprar. `scr_update_shop_availability` tiene el cuerpo vacío (ya no gestiona disponibilidad).

---

## Cap de upgrades de herramienta

`scr_upgrade_tool` en `script_player_actions.gml`:

```gml
if (_cur >= QUALITY.VITOLANIO) {
    scr_notify(_tool_key + " ya esta al maximo");
    return;
}
if (_cur >= QUALITY.BRONCASTANIO && global.town_stage < TownStage.BLACKSMITH_RESTORED) {
    scr_notify("La herreria del town no esta lista para upgrades mayores.");
    return;
}
_slot.quality = _cur + 1;
```

Por debajo de `BLACKSMITH_RESTORED` (estado 7), el cap es **BRONCASTANIO (4)**. A partir del estado 7, el cap real es **VITOLANIO (8)**.

---

## Comandos debug

### `set_town_stage <n>`

```
set_town_stage 0   → INITIAL
set_town_stage 5   → SHOP_RESTORED
set_town_stage 12  → URBANIZATION_COMPLETE (todo restaurado, buses corriendo)
```

Resetea donaciones y construcción, y llama `scr_restore_town_stage()` que aplica todos los visuales, colisiones y transiciones correctamente para el stage dado.

### Debug overlay coordenadas

`obj_controller/Draw_64.gml` dibuja las coordenadas X,Y del jugador en tiempo real (esquina superior izquierda, debajo de los corazones). Útil para posicionar transitions y colisiones. Quitar cuando ya no se necesite.

---

## Save / Load

### Serialización

`scr_save_game()` guarda: `town_stage`, `town_donations`, `town_construction_day`, `town_construction_duration`.

### Deserialización

`scr_apply_loaded_game()` restaura el estado con migración para saves viejos (cargan en `INITIAL`).

---

## Sincronización multiplayer

El estado del town se sincroniza vía dos mecanismos:

### FULL_SNAPSHOT (conexión inicial)

`net_send_full_snapshot()` incluye `town_stage`, `town_donations`, `town_construction_day` y `town_construction_duration`. El cliente los aplica en `net_handle_full_snapshot()` antes de llamar `room_goto`, de modo que `scr_restore_town_stage()` ya tiene el stage correcto al entrar al town.

### NET_CMD.TOWN_STAGE_UPDATE (cambios en tiempo real)

`net_send_town_stage_update()` serializa el estado completo (stage + donations + construction). Se envía desde:

- **`scr_advance_town_stage()`** — automáticamente cuando el HOST avanza de etapa (donación completa o construcción terminada).
- **`net_handle_donate()`** — para actualizaciones parciales de donación (items donados pero etapa no completada aún).
- **`set_town_stage <n>` debug command** — cuando lo ejecuta el HOST.

`net_handle_town_stage_update()` en el cliente aplica los globals y llama `scr_restore_town_stage()` si está en el town.

### NET_CMD.CMD_DONATE (donaciones del cliente)

`scr_donate_specific_target()` detecta `NET_ROLE.CLIENT` y en lugar de modificar globals localmente, envía `net_send_donate(_target_key)`. El HOST recibe el paquete en `net_handle_donate()`, ejecuta la lógica de donación contra el ghost del cliente, y:

1. Envía `INVENTORY_UPDATE` para cada slot del ghost que cambió.
2. Si la etapa avanzó: `scr_advance_town_stage` broadcast `TOWN_STAGE_UPDATE` automáticamente.
3. Si fue donación parcial: `net_handle_donate` envía `TOWN_STAGE_UPDATE` con el progreso actualizado.

### Guard de auto-avance por construcción

En `obj_controller/Step_0.gml`, el bloque de `scr_check_town_construction_completed()` está guardado con `global.net_role != NET_ROLE.CLIENT` para que solo el HOST detecte y avance la etapa cuando termina la construcción.

### Debug command `set_town_stage`

Bloqueado en CLIENT. En HOST: setea globals, llama `scr_restore_town_stage()` y broadcast `net_send_town_stage_update()`.

---

## Archivos modificados/creados

### Nuevos
- `scripts/script_town_progression/script_town_progression.gml`
- `objects/obj_donation_table/Create_0.gml`, `Step_0.gml`, `Draw_0.gml`
- `objects/obj_construction_site/Create_0.gml`, `Step_0.gml`, `CleanUp_0.gml`
- `objects/obj_bus_down/Create_0.gml`, `Step_0.gml`
- `objects/obj_bus_up/Create_0.gml`, `Step_0.gml`
- `objects/obj_shop/Create_0.gml`
- `objects/obj_shop_destroyed/Create_0.gml`
- `objects/obj_apartments_tower/Create_0.gml`
- `objects/obj_kid_park/Create_0.gml`
- `objects/obj_bus_stop_1/Create_0.gml`
- `objects/obj_bus_stop_2/Create_0.gml`

### Modificados
- `scripts/script_init/script_init.gml` — enum TownStage, Miraculos/Carlos `available: true`, `NET_CMD.CMD_DONATE` (45) y `NET_CMD.TOWN_STAGE_UPDATE` (52)
- `scripts/script_net/script_net.gml` — FULL_SNAPSHOT incluye town state; nuevas funciones `net_send_town_stage_update`, `net_handle_town_stage_update`, `net_send_donate`, `net_handle_donate`; dispatch de CMD_DONATE y TOWN_STAGE_UPDATE
- `scripts/script_town_progression/script_town_progression.gml` — `scr_donate_specific_target` enruta al host en CLIENT; `scr_advance_town_stage` broadcast en HOST
- `scripts/script_inventory_functions/script_inventory_functions.gml` — save/load del estado town
- `scripts/script_player_actions/script_player_actions.gml` — cap BRONCASTANIO en `scr_upgrade_tool`
- `objects/obj_controller/Create_0.gml` — globals
- `objects/obj_controller/Step_0.gml` — room-change handlers (town, general_shop, blacksmith), excluye town de `scr_setup_forest_trees`, guard `net_role != CLIENT` en auto-avance de construcción, `set_town_stage` debug bloqueado en CLIENT + broadcast en HOST
- `objects/obj_controller/Draw_64.gml` — debug overlay coordenadas
- `objects/obj_player/Step_0.gml` — buses añadidos a `move_and_collide`
- `objects/obj_construction_site/obj_construction_site.yy` — evento CleanUp añadido
- `objects/obj_shop/obj_shop.yy`, `obj_shop_destroyed.yy`, `obj_apartments_tower.yy`, `obj_kid_park.yy`, `obj_bus_stop_1.yy`, `obj_bus_stop_2.yy` — evento Create añadido
- `rooms/general_shop/general_shop.yy` — exit transition → town (863, 455)
- `rooms/blacksmith/blacksmith.yy` — exit transition → town (863, 110)
- `rooms/town/town.yy` — instancias manuales de colisión (inst_miraculos_store1/2, inst_blacksmith1/2)

---

## Pendiente / mejoras futuras

1. **Debug overlay coordenadas** — quitar `Draw_64.gml` block cuando ya no se necesite para posicionamiento.

2. **Mensajes específicos por etapa** — el plan menciona strings como "Restaurando los jardines del town...", "La tienda estará lista en X días...". Actualmente se usan los nombres genéricos de `scr_get_town_stage_name`.

3. **NPCs vecinos en stage 7** — el plan dice "NPCs de vecinos aparecen en el town" pero no especifica qué objetos. Requeriría crear nuevos `obj_npc` instances o un sistema de vecinos.

4. **Scroll en panel de donativos** — actualmente las 9 filas máximas caben sin scroll. Si una etapa futura tuviera más de 9 requirements habría que añadir scroll vertical.

5. **Colisiones de bancas/farolas** — si en el futuro se agregan objetos de mobiliario urbano como objetos GML (no tiles), necesitarán colisiones propias o ser añadidos a `scr_rebuild_town_collisions`.

6. **Multiplayer: estado entre sesiones del cliente** — el ghost arranca con inventario fijo de ítems iniciales; si el cliente tuviera un save propio habría que serializar su inventario en el save del host.
