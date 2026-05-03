# Planes Pendientes — Veredas Dream

## 1. Misiones de Construcción: Bombay y Farmacia Simi

### Resumen

El jugador encuentra cofres fijos en la ciudad (`town`) que aceptan entregas de ítems específicos. Al completar ciertos lotes de entrega, se construyen dos edificios que mejoran la calidad de vida de Veredas.

### Cofres de entrega

Dos cofres ubicados en la ciudad (`town`), en lugares visibles (ej. cerca de la plaza central):

- **Cofre del Bombay** — etiquetado "Construcción Bombay"
- **Cofre de la Farmacia Simi** — etiquetado "Construcción Farmacia Simi"

### Mecánica

1. El jugador se para cerca del cofre y presiona **E** (como con cofres/maquinas).
2. Se abre un UI que muestra:
   - Lista de materiales requeridos (total y cuánto llevas entregado).
   - Inventario del jugador para seleccionar ítems.
3. Al depositar un ítem, se descuenta del inventario y se registra en `global.bombay_progress` o `global.simi_progress`.
4. Cuando todos los materiales están completos, se marca el edificio como construido.
5. Aparece el edificio en la ciudad (o cambia un placeholder a la versión construida).

### Materiales necesarios

#### Bombay (Centro Recreativo)

| Ítem | Cantidad | Categoría |
|---|---|---|
| `wood` | 200 | Material |
| `stone` | 150 | Material |
| `coal` | 50 | Material |
| `bar_bronce` | 30 | Barra |
| `bar_plata` | 20 | Barra |
| `cloth_blue` | 10 | Tela |
| `cloth_red` | 10 | Tela |
| `thread_white` | 15 | Hilo |
| `leather_brown` | 20 | Cuero |
| `pelt_brown` | 15 | Piel |

**Beneficio al construir:**
- Aumenta la felicidad de la gente (nuevo diálogo NPC).
- Se desbloquean recetas en `obj_workbench` para muebles decorativos.
- Efecto visual: el edificio aparece en la ciudad.

#### Farmacia Simi

| Ítem | Cantidad | Categoría |
|---|---|---|
| `wood` | 100 | Material |
| `stone` | 80 | Material |
| `coal` | 30 | Material |
| `bar_plata` | 15 | Barra |
| `bar_oro` | 5 | Barra |
| `cloth_white` | 8 | Tela |
| `yarn_white` | 10 | Estambre |
| `forage_h01` (menta) | 10 | Hierba |
| `forage_h02` (manzanilla) | 10 | Hierba |
| `honey` | 5 | Miel |
| `goat_cheese` | 3 | Queso de cabra |

**Beneficio al construir:**
- La farmacia vende pociones/hierbas (nuevo shop "Simi").
- Los NPCs mencionan que ahora tienen medicinas.
- Cada día genera 1-3 `forage_h*` gratis en el cofre de la farmacia como "recompensa".

### Implementación técnica

**Archivos a crear/modificar:**

| Archivo | Cambio |
|---|---|
| `objects/obj_delivery_chest/Create_0.gml` | **NUEVO**. Variables: `building_type` ("bombay" o "simi"), referencia a `global.bombay_progress` / `global.simi_progress`. |
| `objects/obj_delivery_chest/Step_0.gml` | **NUEVO**. Detectar jugador cerca + E, abrir UI. |
| `objects/obj_delivery_chest/Draw_0.gml` | **NUEVO**. UI de entrega (lista de materiales, slots del jugador). |
| `objects/obj_delivery_chest/CleanUp_0.gml` | **NUEVO**. Cleanup si aplica. |
| `objects/obj_bombay/Create_0.gml` | **NUEVO** (o placeholder → real). Edificio construido. |
| `objects/obj_farmacia_simi/Create_0.gml` | **NUEVO** (o placeholder → real). Edificio construido. |
| `objects/obj_controller/Create_0.gml` | Inicializar `global.bombay_progress`, `global.simi_progress`, `global.bombay_built`, `global.simi_built`. |
| `scripts/script_init/script_init.gml` | Agregar datos de materiales requeridos (structs). |
| `scripts/script_inventory_functions.gml` | Guardar/cargar progreso de construcción. |
| `town` room | Colocar `obj_delivery_chest` instances. Colocar `obj_bombay`/`obj_farmacia_simi` como buildings. |

### Progreso

Cada entrega se almacena como struct:
```
global.bombay_progress = {
    completed: false,
    items: { wood: 0, stone: 0, ... }
}
```

Persistencia en save: agregar al `_save_data` struct.

---

## 2. Clima — Multijugador

Falta sincronizar el clima en LAN multiplayer. Cuando el host hace `start_new_day()`, debe enviar `global.weather_today` al cliente vía un nuevo `NET_CMD.WEATHER_UPDATE`.

- Agregar `NET_CMD.WEATHER_UPDATE` al enum en `script_init.gml`.
- En `start_new_day()` del host, enviar el comando con el valor de `global.weather_today`.
- En `script_net.gml`, manejar el comando: el cliente actualiza `global.weather_today`.
- El cliente también necesita que `obj_rain` se cree/destruya al recibir el update.

---

## 3. Clima — Sonido de trueno SFX (opcional)

Actualmente los truenos son solo flash visual + el sonido ambiente incluido en `sound_rain_and_thunder`. Si se desea un sonido de trueno puntual más fuerte, agregar un SFX separado (`sound_thunder`) y reproducirlo en el bloque de trueno en `obj_controller/Step_0.gml`.

---

## 4. Menú de pausa — Indicador de clima

Mostrar el clima actual ("Soleado" / "Lluvioso") en el menú de pausa o en el HUD.

---

## 5. Efecto de lluvia — Salpicaduras en el suelo

Opcional: agregar un segundo tipo de partícula (círculos pequeños, alpha bajo) que aparezca al contacto con el suelo para simular salpicaduras.

---

## 6. Temporizador de truenos — Ajuste

Actualmente el timer de trueno (1800-7200 frames) se reinicia si el jugador cambia de sala. Podría mantener su valor actual entre transiciones para evitar que los truenos se sientan erráticos.
