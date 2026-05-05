# Sistema de Clima — Lluvia

## Resumen

Sistema meteorológico diario con probabilidad de lluvia. Cuando llueve:
- Partículas azules caen del cielo en zonas exteriores
- Los tiles arados (tile 72) se autorriegan (tile 168) al comenzar el día
- Los cultivos crecen como si hubieran sido regados
- Ocasionalmente hay truenos (flash visual y hook de sonido)

## Archivos modificados

| Archivo | Cambio |
|---|---|
| `objects/obj_rain/Create_0.gml` | **NUEVO** — Sistema de partículas de lluvia |
| `objects/obj_rain/Step_0.gml` | **NUEVO** — Emisión de gotas siguiendo la cámara |
| `objects/obj_rain/Draw_0.gml` | **NUEVO** — Flash de relámpago |
| `objects/obj_rain/CleanUp_0.gml` | **NUEVO** — Limpieza de partículas |
| `objects/obj_controller/Create_0.gml` | Globals de clima, weather roll en `start_new_day()`, auto-watering por lluvia |
| `objects/obj_controller/Step_0.gml` | Timer de truenos, ciclo de vida de `obj_rain`, tecla R, comando `set_weather` |
| `objects/obj_controller/Draw_0.gml` | Overlay nublado (oscurecimiento 12%) |
| `scripts/script_init/script_init.gml` | Función `scr_is_outdoor_room()` |
| `scripts/script_inventory_functions/script_inventory_functions.gml` | Auto-watering en `scr_advance_stored_room_states()`, guardar/cargar estado del clima |

## Globals

Definidos en `obj_controller/Create_0.gml`:

- `global.weather_today` — `"sunny"` o `"rain"`
- `global.force_rain_tomorrow` — bool; si es true, el próximo `start_new_day()` forza lluvia
- `global.thunder_timer` — frames hasta el próximo trueno (-1 = inactivo)
- `global.lightning_flash` — frames restantes del flash visual

## Probabilidad de lluvia

20% fijo todos los días, independientemente de la estación.

```gml
global.weather_today = (irandom(99) < 20) ? "rain" : "sunny";
```

## Auto-watering

Cuando `global.weather_today == "rain"`:

1. **En `start_new_day()`** (room actual): todos los tile 72 → 168 en `Tiles_tilled_watered`, y `obj_crop.is_watered = true` en todas las instancias. Esto se ejecuta ANTES del loop de crecimiento de cultivos, para que crezcan ese día.

2. **En `scr_advance_stored_room_states()`** (rooms fuera de pantalla): todos los `_c_data.is_watered = true` y tile 72 → 168 en los datos persistidos.

## Partículas de lluvia (`obj_rain`)

- Shape: `pt_shape_rectangle` con scale vertical (0.08×1.0) = línea delgada
- Color: `$99CCFF` → `$5599DD` (azul cielo a azul medio)
- Velocidad: 4-8 px/frame, dirección 260-280° (ligera inclinación), gravedad hacia abajo
- Alpha: 0.7 → 0.5 → 0.0 (fade out)
- Vida: 60-120 frames
- Emisión: 3 gotas/frame en el ancho de la cámara
- Se crea/destruye automáticamente al cambiar de sala (solo en exteriores)

## Truenos

- Timer aleatorio entre 1800-7200 frames (30-120 segundos reales)
- Solo cuando llueve y el jugador está en exterior
- Activa `global.lightning_flash = 4` (4 frames de pantalla blanca)
- Hook de sonido: buscar `REPLACE_ME: audio_play_sound` en Step_0.gml para conectar `sound_thunder`

## Salas exteriores

Definido en `scr_is_outdoor_room()` en `script_init.gml`:

- `farm`
- `forest`
- `town`
- `road_to_cave`

## Debug

| Tecla/Comando | Descripción |
|---|---|
| `R` | Alterna `force_rain_tomorrow` — fuerza lluvia al próximo día |
| `set_weather rain` | Cambia el clima inmediatamente a lluvia |
| `set_weather sunny` | Cambia el clima inmediatamente a soleado |

## Sonido

Dos pistas suenan simultáneamente durante la lluvia, ambas al 70% de volumen:

| Pista | Rol | Gestionado por |
|---|---|---|
| `sound_music_when_rains` | Música de fondo de lluvia (reemplaza la música de estación) | `obj_music_manager` Step |
| `sound_rain_and_thunder` | Efectos ambientales (lluvia + truenos) en loop | `obj_rain` Create/CleanUp |

- `sound_music_when_rains` se reproduce en lugar de la música de estación/sala cuando `global.weather_today == "rain"` y el jugador está en exterior. Su volumen final es `global.music_volume * 0.7`.
- `sound_rain_and_thunder` se reproduce en loop mientras `obj_rain` exista, con gain fijo de 0.7.
- Al cambiar a interior o al dejar de llover, `obj_rain` se destruye y el sonido se detiene.

## Próximos pasos (pendientes)

1. Sincronizar clima en multijugador (enviar `NET_CMD.WEATHER_UPDATE` del host al cliente)
