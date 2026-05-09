# Sistema de Eventos Aleatorios en la Granja

## Resumen

Sistema de eventos que ocurren durante la noche y se anuncian al amanecer. Una vez por temporada hay un 15% de probabilidad de que ocurra uno de tres eventos: ataque de osos, gran tormenta, o invasión de monstruos. El evento se programa en un día aleatorio de la temporada y se ejecuta automáticamente al inicio de ese día.

## Archivos

| Archivo | Cambio |
|---|---|
| `scripts/scr_farm_events/scr_farm_events.gml` | **NUEVO** — Toda la lógica de eventos |
| `objects/obj_controller/Create_0.gml` | Globals, bloque de eventos en `start_new_day()`, fix de orden save en `midnight_collapse()` |
| `objects/obj_controller/Step_0.gml` | Spawn de enemigos al entrar a la granja, comando `farm_event` |
| `scripts/script_inventory_functions/script_inventory_functions.gml` | `scr_notify` con timer opcional, guardar/cargar estado de eventos |

## Globals

Definidos en `obj_controller/Create_0.gml`:

| Variable | Tipo | Descripción |
|---|---|---|
| `global.pending_farm_event` | string | Evento del día actual (`""`, `"bears"`, `"storm"`, `"enemies"`) |
| `global.pending_farm_event_enemies` | array | Keys de enemigos a spawnear al entrar a la granja (evento `"enemies"`) |
| `global.farm_event_scheduled_day` | int | Día de la temporada en que ocurrirá el evento (`-1` = ninguno) |
| `global.farm_event_type` | string | Tipo del evento programado (`""`, `"bears"`, `"storm"`, `"enemies"`) |

## Probabilidad y programación

**15% por temporada** de que ocurra cualquier evento. Se programa al inicio de cada temporada nueva (`_is_season_change == true` en `start_new_day()`):

```gml
// 15% de probabilidad
if (random(1) >= 0.15) exit;

// Tipo aleatorio
var _types = ["bears", "storm", "enemies"];
global.farm_event_type = _types[irandom(2)];

// Día aleatorio entre día 3 y días_por_temporada - 2
global.farm_event_scheduled_day = irandom_range(3, max(3, global.days_per_season - 2));
```

En temporadas de 28 días, el evento puede caer entre el día 3 y el 26.

## Flujo en `start_new_day()`

Ejecutado justo después del bloque de cambio de estación, antes de `global.forest_needs_repopulate`:

1. Si es cambio de estación → `scr_schedule_season_event()` (programa el próximo evento)
2. `scr_farm_clear_event_animals()` — limpia osos/animales de refugio del día anterior
3. Si `global.day == global.farm_event_scheduled_day` → ejecuta el evento
4. Después de restaurar HP/energía del jugador → `scr_farm_event_notify()` muestra el anuncio

El evento de tormenta sobrescribe `global.weather_today = "rain"` directamente, por lo que el bloque de auto-riego que viene después lo procesa normalmente.

## Eventos

### Ataque de osos (`"bears"`)

- Destruye **~50% de los cultivos** (cada uno tiene 50% de probabilidad de sobrevivir, aleatoriamente)
- Los árboles frutales (`type == "tree"`) nunca se destruyen
- El suelo arado (`tilled_tiles`) permanece intacto
- Spawna **3–7 osos** (`obj_wild_animal` con `animal_key = "bear"`) directamente en `global.room_states[$ "farm"].wild_animals`
- Los osos se limpian automáticamente al inicio del día siguiente si no fueron cazados
- **Anuncio:** "Osos salvajes olieron que habia comida aqui y vinieron a buscarla..." + "Algunos cultivos fueron destruidos. Cuidado con los osos!"

### Gran tormenta (`"storm"`)

- Fuerza lluvia: `global.weather_today = "rain"` (overrides el roll normal)
- Destruye **~50% de los cultivos** (mismas reglas que el evento de osos)
- Spawna **5–10 árboles** extra en `common_trees[]` del farm state
- Spawna **8–15 rocas** extra en `rocks[]` del farm state
- Spawna **3–6 animales de refugio** aleatorios (`deer`, `rabbit`, `fox`, `capibara`) en `wild_animals[]`
  - Pueden ser cazados como animales normales
  - Desaparecen el día siguiente si no se cazaron
- **Anuncio:** "Hubo una gran tormenta en la noche..." + "Destruyo cultivos y trajo arboles, rocas y animales que buscan refugio."

### Invasión de monstruos (`"enemies"`)

- No destruye cultivos
- Spawna **6–12 enemigos** al entrar a la granja (no a través de room_states)
- Pool de enemigos: `slime_blue`, `slime_green`, `slime_black`, `slime_pink`, `myconid_blue`, `myconid_green`, `goblin`, `sprout_slime_blue`, `sprout_slime_pink`, `venom_bloom`
- Los enemigos desaparecen si el jugador sale y regresa a la granja (no persisten en room_states)
- **Anuncio:** "Monstruos invaden tu granja!" + "Defiendela antes de que lleguen mas!"

## Spawn de enemigos (detalle técnico)

Los enemigos no se guardan en `global.room_states`, por lo que se spawnean en el Step de `obj_controller` cuando se detecta el cambio de cuarto a `"farm"`:

```gml
if (_room_name == "farm" && array_length(global.pending_farm_event_enemies) > 0) {
    // Spawna todos los enemigos del array y lo vacía
    // El Create event de cada enemigo inicializa sus stats desde global.enemy_data
}
```

## Limpieza de animales de evento

`scr_farm_clear_event_animals()` se llama cada mañana en `start_new_day()`. Elimina de `farm.wild_animals[]` todas las entradas donde `is_farm_animal == false` (osos y animales de tormenta). Los animales de granja comprados por el jugador tienen `is_farm_animal = true` y no se ven afectados.

Si el jugador estuviese en la granja cuando se llama (edge case), también destruye las instancias vivas.

## Structs de animales en room_state

Los osos y animales de refugio se insertan directamente en `global.room_states[$ "farm"].wild_animals` con el mismo formato que `scr_capture_current_room_state`:

```gml
{
    x, y,
    animal_key: "bear",         // o "deer", "rabbit", etc.
    is_farm_animal: false,
    is_test_animal: false,
    sprite_index: "sprite_...", // nombre del sprite como string
    move_speed: 0.8,
    hp: 25, max_hp: 25,
    dir: 0                      // DIR enum value
}
```

## Notificaciones

Se usa `scr_notify(_text, _duration)` con `_duration = 300` (~5 segundos). Se muestra después de que el jugador recupera HP/energía, antes de `scr_capture_current_room_state()`.

`scr_notify` fue extendido para aceptar un segundo parámetro opcional (por defecto `120` frames):

```gml
function scr_notify(_text, _duration = 120) { ... }
```

Todas las llamadas existentes sin segundo argumento siguen funcionando igual.

## Save / Load

Los cuatro globals de eventos se guardan en el JSON del save:

```
pending_farm_event, pending_farm_event_enemies,
farm_event_scheduled_day, farm_event_type
```

Al cargar saves anteriores que no tengan estos campos, se aplican defaults seguros (`""`, `[]`, `-1`, `""`).

## Fix: orden save/new_day en `midnight_collapse`

El path sin shipping de `midnight_collapse()` fue corregido para guardar DESPUÉS de `start_new_day()` (antes lo hacía al revés, perdiendo el estado del nuevo evento en el save):

```gml
// ANTES
scr_save_game();
start_new_day();

// AHORA
start_new_day();
if (global.net_role != NET_ROLE.CLIENT) scr_save_game();
```

## Debug

| Comando | Descripción |
|---|---|
| `farm_event` | Programa un evento aleatorio para mañana |
| `farm_event bears` | Programa ataque de osos para mañana |
| `farm_event storm` | Programa tormenta para mañana |
| `farm_event enemies` | Programa invasión de monstruos para mañana |

El evento se ejecuta al dormir y despertar al día siguiente. El día programado se guarda en el save.

## Funciones en `scr_farm_events.gml`

| Función | Descripción |
|---|---|
| `scr_schedule_season_event()` | Roll de 15%; si dispara, asigna tipo y día aleatorio |
| `scr_apply_farm_event(_type)` | Dispatcher que llama al handler del evento |
| `scr_apply_bear_attack()` | Destruye crops, inserta osos en room_state |
| `scr_apply_great_storm()` | Fuerza lluvia, destruye crops, spawna recursos y animales |
| `scr_apply_enemy_invasion()` | Llena `global.pending_farm_event_enemies` |
| `scr_farm_destroy_crops(_state)` | Elimina ~50% de crops del array; árboles siempre sobreviven |
| `scr_farm_storm_spawn_resources(_state)` | Inserta árboles y rocas extra en room_state |
| `scr_farm_event_notify(_type)` | Muestra las notificaciones del evento al amanecer |
| `scr_farm_clear_event_animals()` | Limpia animales de evento del farm room_state |
| `scr_farm_occupied_positions(_state)` | Devuelve struct `{}` con posiciones ocupadas |
| `scr_farm_find_free_pos(_occ)` | Encuentra posición libre en la granja (grid 16px, 50 intentos) |
