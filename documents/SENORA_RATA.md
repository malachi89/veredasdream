# La Señora Rata — Documentación

NPC contratable que ofrece servicios de granja. Sprite: `sprite_sra_rata` (48×32, 12 frames: DOWN=0-2, LEFT=3-5, RIGHT=6-8, UP=9-11). Se dibuja escalado al 67% (~32×21 px) con `image_xscale = image_yscale = 0.67`.

## Ubicación

- **Bosque** (room `forest`) en (165, 40), junto al `obj_forest_sign`. Solo aparece si `contract_type == "none"`.
- **Granja** (room `farm`) en (650, 200). Solo aparece si está contratada (daily activo o lifetime).

## Spawning (obj_controller/Step_0.gml:113-123)

Al cambiar de sala se destruye cualquier `obj_sra_rata` existente y se crea uno nuevo según el estado:

```
forest + no contratada → spawn en (165, 40)
farm + contratada      → spawn en (650, 200)
```

## Contratos

Estado global en `global.sra_rata_state`:

| Campo | Tipo | Descripción |
|---|---|---|
| `contract_type` | string | `"none"`, `"daily"`, `"lifetime"` |
| `hired_on_day` | int | Día en que se contrató |

### Diario (800G)
- `contract_type = "daily"`, `hired_on_day = global.day`
- Expira al llegar la medianoche: en `start_new_day()` se compara `global.day > hired_on_day`
- Al expirar: `contract_type = "none"`, se destruye la instancia

### Vitalicio (25,000G)
- `contract_type = "lifetime"`
- Nunca expira

## Diálogo (Bosque)

Flujo de stages controlado por `sra_dialog_stage` en `obj_player`:

| Stage | Contenido | Acción |
|---|---|---|
| 0 | Saludo: "¡Oh! ¡Hola!..." | E → stage 1 |
| 1 | Oferta con opciones | 1 → daily, 2 → lifetime, Esc → decline |
| 2 | Contratado diario | E/Esc → cerrar |
| 3 | Rechazado | E/Esc → cerrar |
| 4 | Ya contratado | E/Esc → cerrar |
| 5 | Sin dinero | E/Esc → cerrar |
| 6 | Contratado vitalicio | E/Esc → cerrar |

### Diálogo (Granja)

| Stage | Contenido | Acción |
|---|---|---|
| 10 | "¿Necesitas algo?" | 1 → descansar, 2 → seguir, Esc → cerrar |
| 11 | "Muy bien, descansaré por hoy." | E/Esc → cerrar |
| 12 | "Noooooo pos ta caray, pinchi negrero" | E/Esc → cerrar |

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

## Archivos modificados

| Archivo | Cambio |
|---|---|
| `objects/obj_sra_rata/obj_sra_rata.yy` | Definición del objeto |
| `objects/obj_sra_rata/Create_0.gml` | Init de vars |
| `objects/obj_sra_rata/Step_0.gml` | Lógica de wander + trabajo + barra |
| `objects/obj_sra_rata/Draw_0.gml` | Sprite escalado + barra de progreso |
| `Veredas Dream.yyp` | Registro del objeto |
| `scripts/script_init/script_init.gml` | `global.sra_rata_state` + `global.sra_rata_dialogs` |
| `objects/obj_player/Create_0.gml` | `sra_dialog_open`, `sra_dialog_stage` |
| `objects/obj_player/Step_0.gml` | Interacción E (bosque→contrato, granja→descanso) |
| `objects/obj_inventory/Step_0.gml` | Manejo de teclas 1/2/Esc en diálogos |
| `objects/obj_inventory/Draw_64.gml` | UI de todos los stages del diálogo |
| `objects/obj_controller/Create_0.gml` | Expiración de contrato diario en `start_new_day` |
| `objects/obj_controller/Step_0.gml` | Spawn en entrada de sala |
| `scripts/script_inventory_functions/script_inventory_functions.gml` | Save/load de `sra_rata_state` |
