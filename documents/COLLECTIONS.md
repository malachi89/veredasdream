# Catálogo de Colección

## Resumen
Sistema que rastrea automáticamente todos los items que el jugador ha obtenido alguna vez y los muestra en un menú visual (tecla **M**). Los items no coleccionados aparecen como siluetas negras con "???".

## Archivos involucrados

### Nuevos
- `scripts/scr_collection_catalog/scr_collection_catalog.gml` — Funciones helper para el catálogo

### Modificados
- `scripts/script_init.gml` — Inicialización de `global.collected_items`
- `objects/obj_player/Create_0.gml` — Hook en `add_item()` para marcar items como coleccionados
- `scripts/script_inventory_functions.gml` — Persistencia save/load + migración de saves antiguos
- `objects/obj_controller/Create_0.gml` — Variables de estado del menú
- `objects/obj_controller/Step_0.gml` — Tecla M, navegación, bloqueo de input
- `objects/obj_controller/Draw_64.gml` — Renderizado del catálogo
- `objects/obj_inventory/Step_0.gml` — Bloqueo de input cuando el catálogo está abierto
- `Veredas Dream.yyp` — Registro del nuevo script en el proyecto

## Tracking (`global.collected_items`)
- Estructura tipo mapa: `{ "tomato_seeds": true, "fish_03": true, ... }`
- Se actualiza automáticamente en `obj_player.add_item()` — cubre pesca, caza con red, cosecha, compras, crafteo, recoger items del suelo, productos de animales/máquinas
- También se actualiza al matar enemigos (`obj_enemy`), animales salvajes (`obj_wild_animal`), y animales de granja (`obj_farm_animal`)
- Se persiste en el savegame (`savegame.json` → clave `collected_items`)
- Saves sin el campo se migran automáticamente marcando todo el inventario actual como coleccionado

## Categorías (14 total)

| # | Categoría | Items | Fuente de datos |
|---|-----------|-------|-----------------|
| 0 | Semillas | 43 | `global.seed_data` |
| 1 | Cultivos | 37 | `global.crop_data` |
| 2 | Pescados | 99 | `global.fish_data` |
| 3 | Insectos | 30 | `global.insect_data` |
| 4 | Forraje | 119 | `global.forage_data` |
| 5 | Productos | 20 | `global.animal_product_data` |
| 6 | Materiales | 126 | `global.crafting_material_data` |
| 7 | Minerales | 8 | `global.ore_data` |
| 8 | Lingotes | 8 | `global.bar_data` |
| 9 | Gemas | 12 | `global.gemstone_data` |
| 10 | Tintes | 14 | `global.dye_data` |
| 11 | Mermeladas | 37 | `global.jam_data` |
| 12 | Enemigos | 10 | `global.enemy_collection_data` |
| 13 | Fauna | 8 | `global.wild_animal_collection_data` |
| 14 | Granja | 7 | `global.farm_animal_collection_data` |

**Total: 578 items + 25 criaturas = 603 entradas catalogables.**

## UI del Catálogo
- **Abrir/Cerrar**: Tecla **M** (solo cuando ninguna otra interfaz está abierta)
- **Panel**: 760×540px centrado en pantalla, fondo oscuro overlay
- **Sidebar izquierdo**: Lista de categorías con contador (coleccionados/total) y resaltado de categoría activa
- **Área derecha**: Grid de 7 columnas × 4 filas (28 items por página)
- **Items coleccionados**: Sprite a color + nombre del item
- **Items no coleccionados**: Sprite en negro al 35% opacidad + "???" como nombre
- **Paginación**: Flechas ARRIBA/ABAJO (W/S), rueda del ratón, o botones "ANTERIOR/SIGUIENTE"
- **Navegación rápida**: Flechas IZQUIERDA/DERECHA (A/D) para cambiar de categoría
- **Clic**: Click en categorías del sidebar para cambiar, click en botones de página

## Funciones helper (`scr_collection_catalog.gml`)
- `scr_get_collection_categories()` — Devuelve array con las 11 categorías (nombre + referencia a DB)
- `scr_get_collection_keys(db)` — Devuelve keys de una DB ordenadas alfabéticamente
- `scr_count_collected_in_category(db)` — Cuenta cuántos items de una categoría han sido coleccionados

## Notas
- La tecla **M** también cierra el catálogo si está abierto
- El catálogo bloquea todo input del juego mientras está abierto (movimiento, inventario, etc.)
- Las armas, herramientas y placeables NO están incluidos en el catálogo por ser funcionales
- Compatible con multiplayer (el tracking es local por cliente)
