# La Señora Rata — Documentación

NPC contratable que ofrece servicios de granja. Sprite: `sprite_sra_rata` (48×32, 12 frames: DOWN=0-2, LEFT=3-5, RIGHT=6-8, UP=9-11). Se dibuja escalado al 67% (~32×21 px) con `image_xscale = image_yscale = 0.67`.

## Ubicación

- **Bosque** (room `forest`) en (165, 40), junto al `obj_forest_sign`. Solo aparece si `contract_type == "none"`.
- **Granja** (room `farm`) en (650, 200). Solo aparece si está contratada (daily activo o lifetime).

## Spawning (obj_controller/Step_0.gml:113-128)

Al cambiar de sala se destruye cualquier `obj_sra_rata` existente y se crea uno nuevo según el estado:

```
bodyguard activo          → spawn en (player.x - 40, player.y) en TODA sala
```
bodyguard activo          → spawn en (player.x - 40, player.y) en TODA sala
forest + no contratada    → spawn en (165, 40)
farm + contratada activa  → spawn en (650, 200) si trabajando, (670, 120) si descansando
```

## Interacción E (obj_player/Step_0.gml)

| Prioridad | Condición | Stage |
|-----------|-----------|-------|
| 1ª | `contract_type == "lifetime"` | 30 (unificado) |
| 2ª | `bodyguard == true` | 20 (despedir) |
| 3ª | Sala `forest` + no contratada | 0 (oferta) |
| 4ª | Sala `farm` + contratada | 10 (trabajo diario) |

## Contratos

Estado global en `global.sra_rata_state`:

| Campo | Tipo | Descripción |
|---|---|---|
| `contract_type` | string | `"none"`, `"daily"`, `"lifetime"` |
| `hired_on_day` | int | Día en que se contrató |
| `bodyguard` | bool | Modo guardaespaldas activo |
| `bodyguard_hired_on_day` | int | Día en que se contrató guardaespaldas |
| `is_resting` | bool | Si true, descansa en la granja sin trabajar |

Variable global transitoria (no se guarda): `global.sra_rata_bodyguard_target` — instancia del enemigo a atacar.

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

## Diálogo (Bosque)

Flujo de stages controlado por `sra_dialog_stage` en `obj_player`:

| Stage | Contenido | Acción |
|---|---|---|
| 0 | Saludo: "¡Oh! ¡Hola!..." | E → stage 1 |
| 1 | Oferta con opciones | 1 → daily, 2 → lifetime, 3 → bodyguard, Esc → decline |
| 2 | Contratado diario | E/Esc → cerrar |
| 3 | Rechazado | E/Esc → cerrar |
| 4 | Ya contratado | E/Esc → cerrar |
| 5 | Sin dinero | E/Esc → cerrar |
| 6 | Contratado vitalicio | E/Esc → cerrar |
| (nuevo) | Stage 2 se usa para daily de granja y bodyguard | |

### Diálogo (Granja)

| Stage | Contenido | Acción |
|---|---|---|
| 10 | "¿Necesitas algo?" (daily farm) | 1 → descansar, 2 → seguir, Esc → cerrar |
| 11 | "Muy bien, descansaré por hoy." | E/Esc → cerrar |
| 12 | "Noooooo pos ta caray, pinchi negrero" (daily) | E/Esc → cerrar |
| 13 | "¡A protegerte! ...aunque prefiero la granja." (bodyguard ON, legacy) | E/Esc → cerrar |
| 14 | "Bien, vuelvo a mis quehaceres." (bodyguard OFF, legacy) | E/Esc → cerrar |

### Diálogo (Bodyguard activo, daily, cualquier sala)

| Stage | Contenido | Acción |
|---|---|---|
| 20 | "¿Necesitas algo más?" con opción | 1 → despedir, Esc → cerrar |
| 21 | "Muy bien, ahí estaré en el bosque si me necesitas." | E/Esc → cerrar |

### Diálogo unificado (Vitalicio, cualquier sala)

| Stage | Contenido | Acción |
|---|---|---|
| 30 | "¿Necesitas algo?" con 3 opciones | 1 → descansar, 2 → trabajar, 3 → seguirme, Esc → cerrar |
| 31 | "Muy bien, descansaré por hoy." | E/Esc → cerrar |
| 32 | "¡Enseguida, jefe!" | E/Esc → cerrar |
| 33 | "¡A protegerte! ...aunque prefiero la granja." | E/Esc → cerrar |

## Sistema de Trabajo

La rata camina hacia el trabajo más cercano dentro de 320px (20 tiles). Al llegar a 24px del objetivo, muestra una barra de progreso y completa la tarea al llenarse.

### Prioridad de búsqueda
1. **Crops sin regar** (más cercano)
2. **Rocas** (más cercana)
3. **Maleza** (más cercana)
4. **Árboles comunes** (más cercano)

### Duración por tarea (60 FPS)

| Tarea | Segundos | Frames |
|---|---|---|
| Regar crop | 3s | 180 |
| Romper piedra | 15s | 900 |
| Quitar maleza | 15s | 900 |
| Talar árbol | 30s | 1800 |

### Barra de progreso (Draw_0.gml:4-18)
Se dibuja centrada sobre la rata cuando `is_working && instance_exists(work_target)`. Borde negro, fondo blanco, relleno verde según `work_progress`.

### Atascos
Si la rata no puede moverse hacia el objetivo por más de 1 segundo (60 frames detectando collision), aborta el objetivo y escanea inmediatamente en busca de algo más cercano.

## Variables de instancia (Create_0.gml)

| Variable | Default | Descripción |
|---|---|---|
| `is_resting` | false | Si true, no hace quehaceres |
| `is_working` | false | Si true, está caminando/trabajando en un objetivo |
| `work_target` | noone | Instancia objetivo |
| `work_type` | "" | `"water"`, `"rock"`, `"weed"`, `"tree"` |
| `work_progress` | 0 | 0.0 → 1.0 |
| `work_duration` | 0 | Frames totales para completar |
| `work_scan_timer` | 0 | Contador para escaneo periódico (cada 15 frames) |
| `work_stuck_time` | 0 | Frames atascado sin poder moverse |
| `bodyguard_attack_timer` | 0 | Cooldown entre ataques (30 frames ~0.5s) |

## Sistema de Guardaespaldas

Cuando `global.sra_rata_state.bodyguard == true`, la rata **sigue al jugador** a velocidad 1.7 (caminar=1.3, correr=1.95) por todas las salas.

### Ataque

No busca enemigos por su cuenta. Cuando el jugador **golpea con espada** o **acierta una flecha** a un enemigo, se setea `global.sra_rata_bodyguard_target` a esa instancia. La rata se mueve hacia él y al estar a ≤30px inflige **9 de daño** (equivale a Espada Nv.3) cada 30 frames (~0.5s).

Cuando el enemigo muere, la rata vuelve a seguir al jugador.

### Hook de daño

Se agregó en dos puntos:
- `scripts/script_player_actions/script_player_actions.gml:586` — golpe de espada
- `objects/obj_arrow/Step_0.gml:23` — impacto de flecha

## Archivos modificados

| Archivo | Cambio |
|---|---|
| `objects/obj_sra_rata/obj_sra_rata.yy` | Definición del objeto |
| `objects/obj_sra_rata/Create_0.gml` | Init de vars |
| `objects/obj_sra_rata/Step_0.gml` | Lógica de wander + trabajo + barra + modo guardaespaldas |
| `objects/obj_sra_rata/Draw_0.gml` | Sprite escalado + barra de progreso |
| `Veredas Dream.yyp` | Registro del objeto |
| `scripts/script_init/script_init.gml` | `global.sra_rata_state` (bodyguard fields) + `global.sra_rata_dialogs` + `global.sra_rata_bodyguard_target` |
| `objects/obj_player/Create_0.gml` | `sra_dialog_open`, `sra_dialog_stage` |
| `objects/obj_player/Step_0.gml` | Interacción E (bosque→contrato, granja→descanso/bodyguard) |
| `objects/obj_inventory/Step_0.gml` | Manejo de teclas 1/2/3/Esc en diálogos + toggle bodyguard |
| `objects/obj_inventory/Draw_64.gml` | UI de todos los stages del diálogo + opción 3 bodyguard |
| `objects/obj_controller/Create_0.gml` | Expiración de contrato diario + bodyguard en `start_new_day` |
| `objects/obj_controller/Step_0.gml` | Spawn en entrada de sala (bodyguard en toda sala) |
| `scripts/script_player_actions/script_player_actions.gml` | Hook post-daño espada → `global.sra_rata_bodyguard_target` |
| `objects/obj_arrow/Step_0.gml` | Hook post-daño flecha → `global.sra_rata_bodyguard_target` |
