# La Señora Rata — Documentación

NPC contratable que ofrece servicios de granja y guardaespaldas. Sprite: `sprite_sra_rata` (48×32, 12 frames: DOWN=0-2, LEFT=3-5, RIGHT=6-8, UP=9-11). Se dibuja escalado al 67% (~32×21 px) con `image_xscale = image_yscale = 0.67`.

## Archivos del objeto

| Archivo | Propósito |
|---------|-----------|
| `objects/obj_sra_rata/obj_sra_rata.yy` | Definición del objeto en el IDE |
| `objects/obj_sra_rata/Create_0.gml` | Init de variables de instancia |
| `objects/obj_sra_rata/Step_0.gml` | Lógica completa: movimiento, trabajo, guardaespaldas, wander |
| `objects/obj_sra_rata/Draw_0.gml` | Render del sprite escalado + barra de progreso |

## Ubicación

- **Bosque** (room `forest`) en (165, 40), junto al `obj_forest_sign`. Solo aparece si `contract_type == "none"`.
- **Granja** (room `farm`) en (650, 200). Solo aparece si está contratada (daily activo o lifetime) y no descansando.
- **Cualquier sala** (bodyguard activo) — spawn cerca del jugador en cada sala.

## Spawning (obj_controller/Step_0.gml)

Al cambiar de sala se destruye cualquier `obj_sra_rata` existente y se crea uno nuevo según el estado:

| Condición | Spawn |
|-----------|-------|
| bodyguard activo + jugador existe | `(player.x - 40, player.y)` en TODA sala |
| Sala `forest` + no contratada | `(165, 40)` |
| Sala `farm` + contratada + descansando | `(670, 120)` |
| Sala `farm` + contratada + trabajando | `(650, 200)` |

## Interacción E (obj_player/Step_0.gml)

| Prioridad | Condición | Stage | Propósito |
|-----------|-----------|-------|-----------|
| 1ª | `contract_type == "lifetime"` | 30 | Diálogo unificado (descansar/trabajar/seguir) |
| 2ª | `bodyguard == true` | 20 | Diálogo de despedir guardaespaldas |
| 3ª | Sala `forest` + no contratada | 0 | Oferta de contrato inicial |
| 4ª | Sala `farm` + contratada | 10 | Diálogo diario (descansar/seguir trabajando) |

La interacción setea `sra_dialog_open = true` y `sra_dialog_stage` en `obj_player`. El manejador de teclas (1/2/3/Esc) y el dibujado del diálogo están en `obj_inventory` (`Step_0.gml` y `Draw_64.gml`).

## Estado global

`global.sra_rata_state` (definido en `script_init.gml:1245`):

| Campo | Tipo | Default | Descripción |
|-------|------|---------|-------------|
| `contract_type` | string | `"none"` | `"none"`, `"daily"`, `"lifetime"` |
| `hired_on_day` | int | `-1` | Día en que se contrató (daily) |
| `bodyguard` | bool | `false` | Modo guardaespaldas activo |
| `bodyguard_hired_on_day` | int | `-1` | Día en que se contrató guardaespaldas |
| `is_resting` | bool | `false` | Si true, descansa en la granja sin trabajar |

Variable global transitoria (no se guarda):
- `global.sra_rata_bodyguard_target` — instancia del enemigo a atacar (seteada por hooks de daño).

## Contratos

### Diario — Granja (1,500G)
- `contract_type = "daily"`, `hired_on_day = global.day`, `bodyguard = false`
- Expira al llegar la medianoche: en `start_new_day()` se compara `global.day > hired_on_day`
- Al expirar: `contract_type = "none"`, `bodyguard = false`, se destruye la instancia

### Diario — Guardaespaldas (3,000G)
- `contract_type = "daily"`, `hired_on_day = global.day`, `bodyguard = true`
- Misma expiración que el diario de granja

### Vitalicio (25,000G)
- `contract_type = "lifetime"`, `bodyguard = false`
- Nunca expira
- Desde la granja se puede alternar el modo guardaespaldas sin costo

## Diálogos

### Bosque — Oferta inicial

| Stage | Contenido | Acción |
|-------|-----------|--------|
| 0 | Saludo: "¡Oh! ¡Hola!..." | E → stage 1 |
| 1 | Oferta con 3 opciones | 1→daily, 2→lifetime, 3→bodyguard, Esc→decline |
| 2 | Contratado diario | E/Esc → cerrar |
| 3 | Rechazado | E/Esc → cerrar |
| 4 | Ya contratado | E/Esc → cerrar |
| 5 | Sin dinero | E/Esc → cerrar |
| 6 | Contratado vitalicio | E/Esc → cerrar |

### Granja — Diario (stage 10-14)

| Stage | Contenido | Acción |
|-------|-----------|--------|
| 10 | "¿Necesitas algo?" con opciones | 1→descansar, 2→seguir, Esc→cerrar |
| 11 | "Muy bien, descansaré por hoy." | E/Esc → cerrar |
| 12 | "Noooooo pos ta caray, pinchi negrero" | E/Esc → cerrar |
| 13 | "¡A protegerte!" (bodyguard ON) | E/Esc → cerrar |
| 14 | "Bien, vuelvo a mis quehaceres." (bodyguard OFF) | E/Esc → cerrar |

### Bodyguard activo — Cualquier sala (stage 20-21)

| Stage | Contenido | Acción |
|-------|-----------|--------|
| 20 | "¿Necesitas algo más?" | 1→despedir, Esc→cerrar |
| 21 | "Muy bien, ahí estaré en el bosque si me necesitas." | E/Esc → cerrar |

### Vitalicio — Unificado, cualquier sala (stage 30-33)

| Stage | Contenido | Acción |
|-------|-----------|--------|
| 30 | "¿Necesitas algo?" con 3 opciones | 1→descansar, 2→trabajar, 3→seguirme, Esc→cerrar |
| 31 | "Muy bien, descansaré por hoy." | E/Esc → cerrar |
| 32 | "¡Enseguida, jefe!" (a trabajar) | E/Esc → cerrar |
| 33 | "¡A protegerte! ...aunque prefiero la granja." (seguir) | E/Esc → cerrar |

## Sistema de Trabajo (solo en sala `farm`)

La rata escanea periódicamente (cada 15 frames) en busca de trabajo dentro de 320px (20 tiles). Usa `collision_line` para verificar que haya un camino despejado (sin obstáculos) antes de seleccionar un objetivo. Si ningún objetivo es alcanzable, deambula y espera el próximo escaneo.

### Prioridad de búsqueda
1. **Crops sin regar** (más cercano con línea de visión clara)
2. **Rocas** (más cercana con línea de visión clara)
3. **Maleza** (más cercana con línea de visión clara)
4. **Árboles comunes** (más cercano con línea de visión clara)

### Distancia de interacción
- Se mueve hacia el objetivo si `point_distance > 32`px
- Al estar a ≤32px, comienza a trabajar (incrementa `work_progress`)
- Si choca con un obstáculo por más de 60 frames (~1s), aborta y pone el objetivo en lista negra por 300 frames (~5s)

### Duración por tarea (60 FPS)

| Tarea | Segundos | Frames |
|-------|----------|--------|
| Regar crop | 3s | 180 |
| Romper piedra | 15s | 900 |
| Quitar maleza | 15s | 900 |
| Talar árbol | 30s | 1800 |

### Comportamiento al completar

| work_type | Acción |
|-----------|--------|
| `"water"` | Setea `is_watered = true` en el crop, actualiza tile a ID 168 (tilled+watered) |
| `"rock"` | Dropea 1-3 `stone`, destruye la roca |
| `"weed"` | Destruye la maleza |
| `"tree"` | Dropea 3-5 `wood`, destruye el árbol |

### Barra de progreso (Draw_0.gml)

Se dibuja centrada sobre la rata SOLO cuando `work_progress > 0` (es decir, ya está en rango y trabajando):
- Dimensiones: 24×3 px, fondo negro, borde blanco, relleno verde
- Posición: `(centro_x - 12, y - 12)`

### Lista negra temporal
Cuando la rata no puede alcanzar un objetivo por obstáculos, lo guarda en `work_fail_target` con un timer de 300 frames (~5s). Durante ese tiempo no volverá a seleccionar ese mismo objetivo.

## Sistema de Wander (sin trabajo)

Cuando no hay trabajo disponible o la rata está descansando:
- Timer aleatorio entre moverse y quedarse quieta (pausas de 40-120 frames, movimientos de 60-180 frames)
- 8 direcciones cardinales (ángulos de 45°)
- Si choca con `obj_collision`, reinicia el timer de wander
- Velocidad: `wander_speed = 0.5`

## Walk-to-farm (transición bosque → granja)

Cuando se contrata a la rata en el bosque, `walk_to_farm = true`. Camina hacia `(-50, 105)` (offscreen izquierda de la granja). Al llegar, se destruye — el sistema de spawn en `obj_controller` la recrea en la posición correcta de la granja.

## Go-to-rest (dentro de la granja)

Cuando el jugador elige "Descansar por hoy", `go_to_rest = true`. La rata camina hacia `(670, 120)` y al llegar setea `is_resting = true`, `go_to_rest = false`.

## Variables de instancia (Create_0.gml)

| Variable | Default | Descripción |
|----------|---------|-------------|
| `dir` | `DIR.DOWN` | Dirección actual del sprite |
| `frame_anim` | 0 | Frame de animación (0-3) |
| `frames_walk` | 3 | Total de frames por dirección |
| `is_resting` | `global.sra_rata_state.is_resting` | Si true, no hace quehaceres |
| `wander_speed` | 0.5 | Velocidad de movimiento |
| `wander_timer` | 0 | Timer para cambio de dirección wander |
| `wander_dx` / `wander_dy` | 0 | Vector de movimiento wander |
| `wander_resting` | false | Si true, está en pausa de wander |
| `is_working` | false | Si true, está activa en un objetivo |
| `work_target` | noone | Instancia objetivo (crop/rock/weed/tree) |
| `work_type` | `""` | `"water"`, `"rock"`, `"weed"`, `"tree"` |
| `work_progress` | 0.0 | Progreso 0.0 → 1.0 |
| `work_duration` | 0 | Frames totales para completar |
| `work_scan_timer` | 0 | Contador para escaneo (cada 15 frames) |
| `work_stuck_time` | 0 | Frames consecutivos sin poder moverse |
| `work_fail_target` | noone | Objetivo en lista negra |
| `work_fail_timer` | 0 | Frames restantes de lista negra |
| `walk_to_farm` | false | Si true, camina offscreen a la granja |
| `go_to_rest` | false | Si true, camina a su posición de descanso |
| `bodyguard_attack_timer` | 0 | Cooldown entre ataques (30 frames ~0.5s) |

## Sistema de Guardaespaldas

Cuando `global.sra_rata_state.bodyguard == true`, la rata **sigue al jugador** a velocidad proporcional (87% de la velocidad del jugador, incluyendo montura y sprint) por todas las salas. En el Step se ejecuta antes que la lógica de trabajo/wander y hace `exit` para no ejecutar el resto.

### Ataque
No busca enemigos por su cuenta. Cuando el jugador **golpea con espada** o **acierta una flecha** a un enemigo, se setea `global.sra_rata_bodyguard_target` a esa instancia. La rata se mueve hacia él y al estar a ≤30px inflige **9 de daño** (equivale a Espada Nv.3) cada 30 frames (~0.5s). Cuando el enemigo muere, la rata vuelve a seguir al jugador.

### Hook de daño (bodyguard target assignment)
- `scripts/script_player_actions/script_player_actions.gml:586` — golpe de espada
- `objects/obj_arrow/Step_0.gml:23` — impacto de flecha

## Expiración de contratos (obj_controller/Create_0.gml)

En `start_new_day()`:
```
if (global.sra_rata_state.contract_type == "daily" && global.day > global.sra_rata_state.hired_on_day) {
    global.sra_rata_state.contract_type = "none";
    global.sra_rata_state.bodyguard = false;
}
```

## Persistencia

`global.sra_rata_state` se guarda y carga como parte del savegame JSON a través de `scr_save_game()` / `scr_apply_loaded_game()`. La rata misma no se persiste (se destruye al cambiar de sala y se recrea según el estado).

## Archivos modificados (todos los que tocan sra_rata)

| Archivo | Cambio |
|---------|--------|
| `objects/obj_sra_rata/obj_sra_rata.yy` | Definición del objeto |
| `objects/obj_sra_rata/Create_0.gml` | Init de vars |
| `objects/obj_sra_rata/Step_0.gml` | Lógica completa |
| `objects/obj_sra_rata/Draw_0.gml` | Sprite escalado + barra de progreso |
| `Veredas Dream.yyp` | Registro del objeto |
| `scripts/script_init/script_init.gml` | `global.sra_rata_state`, `global.sra_rata_dialogs`, `global.sra_rata_bodyguard_target` |
| `objects/obj_player/Create_0.gml` | `sra_dialog_open`, `sra_dialog_stage` |
| `objects/obj_player/Step_0.gml` | Interacción E (bosque→contrato, granja→descanso/bodyguard) |
| `objects/obj_inventory/Step_0.gml` | Manejo de teclas 1/2/3/Esc en diálogos + toggle bodyguard |
| `objects/obj_inventory/Draw_64.gml` | UI de todos los stages del diálogo |
| `objects/obj_controller/Create_0.gml` | Expiración de contrato diario + bodyguard en `start_new_day` |
| `objects/obj_controller/Step_0.gml` | Spawn en entrada de sala |
| `scripts/script_player_actions/script_player_actions.gml` | Hook de espada → bodyguard target |
| `objects/obj_arrow/Step_0.gml` | Hook de flecha → bodyguard target |
