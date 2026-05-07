# Plan de Progresión: Restauración del Town

## Sistema de Donativos

Cada etapa requiere que el jugador done items específicos en una **caja de donativos** (`obj_donation_box`). Las donaciones deben completarse **en orden secuencial** — no se puede avanzar a la siguiente etapa hasta completar la actual.

### Mecánica de Caja de Donativo
- Objeto interactuable `obj_donation_box` en la sala town
- Al interactuar (E), abre UI que muestra:
  - Items requiridos y cantidades faltantes
  - Botón "Donar" que abre el inventario
  - Progreso visual (ej: "20/50 piedras")
- El jugador selecciona items de su inventario y los coloca en la caja
- Al completarse todos los items, la etapa se avanza automáticamente

### Convención de keys `*_any`

Las keys que terminan en `_any` representan **cualquier item cuya key empiece con ese prefijo** (acepta cualquier color o tamaño). El sistema de donativos resuelve estas keys en runtime escaneando las bases de datos correspondientes:

| Key | Resolución | Notas |
|-----|------------|-------|
| `cloth_any` | `crafting_material_data` con prefijo `cloth_` | 14 colores |
| `thread_any` | `crafting_material_data` con prefijo `thread_` | 14 colores |
| `yarn_any` | `crafting_material_data` con prefijo `yarn_` | 14 colores |
| `leather_any` | `crafting_material_data` con prefijo `leather_` | **Solo `leather_*` de colores** — NO incluye `cow_hide_*` ni `rabbit_pelt_*` |
| `pelt_any` | `crafting_material_data` con prefijos `pelt_` o `rabbit_pelt_` | Incluye pieles regulares + de conejo |
| `egg_any` | `animal_product_data` con prefijo `egg_` | Todos los huevos (gallina, pato, etc.) |
| `dye_any` | `dye_data` (todas las keys) | 14 colores |
| `gemstone_any` | `gemstone_data` (todas las keys) | 12 gemas |
| `forage_any` | `forage_data` (todas las keys) | Hongos + hierbas + flores |
| `forage_m_any` | `forage_data` con prefijo `forage_m` | Solo champiñones (78 items) |
| `forage_f_any` | `forage_data` con prefijo `forage_f` | Solo flores (22 items) |
| `forage_h_any` | `forage_data` con prefijo `forage_h` | Solo hierbas (19 items) |
| `fruit_any` | `crop_data` filtrando por `is_fruit_tree: true` | **Caso especial — no es por prefijo.** Frutas: cherry, apricot, strawberry, blueberry, banana, orange, mango, peach, watermelon, melon, pineapple, wild_berry, grapes, apple |

**Items individuales que aparecen en el plan sin sufijo `_any`:**
- `wool` — item único (no tiene 14 colores como otros materiales de costura), por eso siempre se pide directo
- `stone`, `wood`, `coal`, `honey`, `cheese`, `goat_cheese`, `butter`, lingotes específicos (`bar_*`), tintes específicos (`dye_blue`, etc.), cultivos específicos (`parsnip`, etc.) — son keys exactas

### Sistema de Construcción
- **Conteo de días:** El día de la donación cuenta como día 0. El día siguiente es el día 1 de construcción.
  - Ejemplo: Si se donate el día 5 y la construcción dura 3 días, el edificio se termina el día 8 (día 5 = día 0, día 6 = día 1, día 7 = día 2, día 8 = día 3 = listo)
- Durante la construcción se muestra `obj_construction_site` en el lugar del edificio
- El NPC correspondiente **no está disponible** hasta que termine la construcción

---

## Estado Inicial (Inicio)

El town comienza en estado destruido. Las siguientes capas deben estar **visibles**:

| Capa | Visible | Profundidad |
|------|---------|-------------|
| Instances | true | 0 |
| Instances_destroyed_buildings | true | 200 |
| Tiles_details_destroyed_1 | true | 700 |
| Tiles_floors_destroyed | true | 800 |

**Capas ocultas inicialmente:**
- Instances_restored_buildings (depth 100)
- Tiles_floors_restored (depth 500)
- Tiles_road_restored (depth 600)
- Tiles_trees (depth 500)
- Tiles_urban_road (depth 650)

---

## Etapa 1: Limpiar las Calles

**Acción requerida:** El jugador debe donate materials para limpiar los escombros.

**Días de construcción:** 1 día (inmediato, solo limpieza)

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `stone` | 500 | Piedra para escombros |
| `wood` | 300 | Madera para estructuras |
| `coal` | 25 | Carbón |
| `bar_plata` | 15 | Lingote de Plata |
| `bar_bronce` | 15 | Lingote de Bronce |
| `dye_blue` | 3 | Tinte Azul |
| `dye_red` | 3 | Tinte Rojo |
| `honey` | 5 | Miel |

**Efecto en el mapa al completar:**
- Se **oculta** `Tiles_details_destroyed_1` (depth 700)
- Caja de donativo se actualiza para etapa 2

**Capas visibles:**
- Instances
- Instances_destroyed_buildings
- Tiles_floors_destroyed

**Progreso de UI:** "Limpiando las calles del town..."

---

## Etapa 2: Restaurar Áreas Verdes

**Acción requerida:** El jugador debe donate frutos y materiales de plantas.

**Días de construcción:** 1 día (inmediato, solo vegetación)

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `parsnip` | 50 | Chirivia (fruto tier1 Miraculos) |
| `carrot` | 25 | Zanahoria (fruto tier1 Miraculos) |
| `onion` | 25 | Cebolla (fruto tier1 Miraculos) |
| `forage_any` | 35 | Cualquier hierba/flor/champiñón |
| `bar_oro` | 10 | Lingote de Oro |

**Efecto en el mapa al completar:**
- Se **muestra** `Tiles_floors_restored` (depth 500)
- Las áreas del town se ven más "vivas"

**Capas visibles:**
- Instances
- Instances_destroyed_buildings
- Tiles_floors_destroyed
- Tiles_floors_restored (nueva)

**Progreso de UI:** "Restaurando los jardines del town..."

---

## Etapa 3: Calles Restauradas

**Acción requerida:** El jugador debe donate materiales de construcción pesados.

**Días de construcción:** 2 días

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `stone` | 600 | Piedra (cimiento) |
| `wood` | 400 | Madera (vigas) |
| `bar_broncastanio` | 10 | Lingote de Broncastanio |
| `cloth_any` | 30 | Cualquier tela de color (`cloth_*`) |
| `leather_any` | 15 | Cualquier cuero de color (`leather_*` solamente, no incluye `cow_hide_*` ni `rabbit_pelt_*`) |
| `thread_any` | 10 | Cualquier hilo (`thread_*`) |
| `wool` | 5 | Lana (item único, sin variantes) |
| `dye_yellow` | 3 | Tinte Amarillo |

**Efecto en el mapa al completar:**
- Se **muestra** `Tiles_road_restored` (depth 600)
- Se **muestra** `Instances_restored_buildings` (depth 100)
- Se **oculta** `Tiles_floors_destroyed` (depth 800)
- Se **oculta** `Tiles_details_destroyed_1` (depth 700)
- Destruidas las instancias destroyed buildings base

**Capas visibles:**
- Instances
- Instances_restored_buildings (edificios base visibles)
- Tiles_floors_restored
- Tiles_road_restored

**Progreso de UI:** "Reconstruyendo las calles principales..."

---

## Etapa 4: Arreglar Tienda de Miraculos

**Acción requerida:** El jugador debe donate items valiosos y productos artesanales.

**Días de construcción:** 3 días

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `cheese` | 20 | Queso |
| `goat_cheese` | 15 | Queso de cabra |
| `butter` | 20 | Mantequilla |
| `honey` | 5 | Miel |
| `thread_any` | 15 | Cualquier hilo (`thread_*`) |
| `egg_any` | 15 | Cualquier huevo (`egg_*` en `animal_product_data`) |
| `dye_any` | 3 | Cualquier tinte (`dye_*`) |
| `fruit_any` | 50 | Cualquier fruta (caso especial: entradas de `crop_data` con `is_fruit_tree: true` — cherry, apricot, banana, orange, mango, peach, apple) |
| `forage_any` | 15 | Cualquier forage (`forage_m*`, `forage_h*`, `forage_f*`) |

**Efectos en el mapa al completar:**
- Durante construcción: mostrar `obj_construction_site` en lugar de la tienda
- Al completar construcción: ocultar `inst_miraculos_shop_destroyed`
- Mostrar `inst_shop_restored` (capa Instances_restored_buildings)
- Tienda visible y operativa en el town

**Efectos en NPC:**
- Durante construcción: Miraculos **no disponible**
- Al completar construcción: crear NPC "Miraculos" en room `general_shop` coordenadas x:60, y:90
- NPC activa su diálogo de tienda restaurada
- Tienda vuelve a comprar/vender items

**Progreso de UI:** "Restaurando la Tienda de Miráculos..."
**Notificación de construcción:** "La tienda estará lista en X días..."

---

## Etapa 5: Arreglar Herrero (Blacksmith)

**Acción requerida:** El jugador debe donate materiales de herrería.

**Días de construcción:** 3 días

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `bar_chubestanio` | 10 | Lingote de Chubestanio |
| `leather_any` | 40 | Cualquier cuero de color (`leather_*` solamente) |
| `pelt_any` | 20 | Cualquier piel (`pelt_*` y `rabbit_pelt_*`) |
| `yarn_any` | 20 | Cualquier estambre (`yarn_*`) |
| `gemstone_any` | 10 | Cualquier gema (`gemstone_*` en `gemstone_data`) |
| `stone` | 200 | Piedra (banco de trabajo) |

**Efectos en el mapa al completar:**
- Durante construcción: mostrar `obj_construction_site` en lugar de la herrería
- Al completar construcción: ocultar `inst_blacksmith_shop_destroyed`
- Mostrar `inst_blacksmith_restored` (capa Instances_restored_buildings)
- Herrería visible y operativa

**Efectos en NPC:**
- Durante construcción: Carlos **no disponible**
- Al completar construcción: crear NPC "Carlos" en room `blacksmith` coordenadas x:60, y:90
- Herrero activa servicio de upgrades de herramientas
- Carlos comienza a comentar sobre el herreraje restaurado

**Progreso de UI:** "Restaurando la herrería del town..."
**Notificación de construcción:** "La herrería estará lista en X días..."

**Restricción de Herramientas:**
- Antes de etapa 5: herramientas pueden mejorarse hasta **nivel 6** (CHUBESTANIO) máximo
- Al completar etapa 5: herramientas pueden mejorarse hasta **nivel 9** (VITOLANIO) máximo
- Intentar upgradear más allá de nivel 6 antes de etapa 5 → Carlos rechaza (diálogo: "La herrería no está lista...")

**Consecuencias finales:** Una vez completadas todas las 5 etapas:
- Town completamente restaurado (BLACKSMITH_RESTORED = 5)
- Ambas tiendas funcionan (Miraculos y Carlos)
- Jugador puede upgradear herramientas hasta nivel 9 (máximo global)
- Diálogos de NPCs cambian (mencionan la restauración)

---

## Etapa 6: Árboles del Town

**Acción requerida:** El jugador debe donate materiales incluyendo metales raros (disponibles tras restaurar la herrería).

**Días de construcción:** 1 día (inmediato, solo visibilidad de árboles)

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `bar_vitolanio` | 5 | Lingote de Vitolanio (metal raro, disponible tras etapa 5) |
| `bar_chubestanio` | 20 | Lingote de Chubestanio |
| `gemstone_any` | 15 | Cualquier gema (`gemstone_*`) |
| `forage_f_any` | 30 | Cualquier flor (`forage_f*`, 22 items) |
| `forage_m_any` | 20 | Cualquier champiñón (`forage_m*`, 78 items) |
| `wood` | 500 | Madera |
| `stone` | 300 | Piedra |

**Efecto en el mapa al completar:**
- Se **muestra** `Tiles_trees` (depth 500, antes oculto)
- Los árboles del town se hacen visibles

**Capas visibles:**
- Instances
- Instances_restored_buildings
- Tiles_floors_restored
- Tiles_road_restored
- Tiles_trees (nueva)

**Progreso de UI:** "Plantando árboles en el town..."

**Nota de metales raros:** Esta es la primera etapa que requiere `bar_vitolanio`, un metal only obtainable after the blacksmith upgrade. Esto incentiva al jugador a completar la etapa 5 primero.

---

## Etapa 7: Torre de Vecinos y Parque Infantil

**Acción requerida:** El jugador debe donate materiales de construcción para edificios residenciales y de ocio.

**Días de construcción:** 4 días (para ambos edificios)

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `stone` | 800 | Piedra (cimiento) |
| `wood` | 600 | Madera (estructura) |
| `bar_vitolanio` | 10 | Lingote de Vitolanio |
| `cloth_any` | 40 | Cualquier tela de color (`cloth_*`) |
| `leather_any` | 25 | Cualquier cuero de color (`leather_*` solamente) |
| `yarn_any` | 30 | Cualquier estambre (`yarn_*`) |
| `dye_green` | 5 | Tinte Verde |
| `dye_orange` | 5 | Tinte Naranja |

**Efectos en el mapa al completar:**
- Durante construcción: mostrar `obj_construction_site` en las ubicaciones de ambos edificios
- Al completar construcción: ocultar `obj_construction_site` y mostrar:
  - `inst_72DD1105` (`obj_apartments_tower`)
  - `inst_36DA4A58` (`obj_kid_park`)
- Ambos edificios visibles en la capa Instances_restored_buildings

**Efectos en NPCs:**
- Durante construcción: Los vecinos **no están disponibles**
- Al completar construcción: NPCs de vecinos aparecen en el town
- Los NPCs mencionan la nueva torre y el parque

**Progreso de UI:** "Construyendo torre de vecinos y parque infantil..."
**Notificación de construcción:** "Los edificios estarán listos en X días..."

---

## Etapa 8: Urbanización Final (Autobuses)

**Acción requerida:** El jugador debe donate materiales para infraestructura urbana final (bancas, luces, autobuses).

**Días de construcción:** 3 días

**Items requeridos para donate:**
| Item | Cantidad | Notas |
|------|----------|-------|
| `stone` | 400 | Piedra (bancas y fundamentos) |
| `bar_chubestanio` | 30 | Lingote de Chubestanio (postes de luz) |
| `coal` | 15 | Carbón (combustible autobús) |
| `cloth_any` | 20 | Cualquier tela de color (`cloth_*`) (asientos autobús) |
| `leather_any` | 15 | Cualquier cuero de color (`leather_*`) (asientos) |

**Efectos en el mapa al completar:**
- Se **muestra** `Tiles_urban_road` (nueva capa para carretera urbana)
- Se **muestra** `obj_bus_stop_1` (parada de autobús 1)
- Se **muestra** `obj_bus_stop_2` (parada de autobús 2)
- Se **crean** 2 instancias de autobús en movimiento:
  - `obj_bus_down`: viajan de norte a sur
    - Posición inicial: x=700, y=-100 (fuera del mapa, parte superior)
    - Posición final: x=700, y=1000 (fuera del mapa, parte inferior)
    - **Parada:** 3 segundos en posición y=740
    - Velocidad: ~50 pixels/segundo
  - `obj_bus_up`: viajan de sur a norte
    - Posición inicial: x=750, y=1000 (fuera del mapa, parte inferior)
    - Posición final: x=750, y=-100 (fuera del mapa, parte superior)
    - **Parada:** 3 segundos en posición y=250
    - Velocidad: ~50 pixels/segundo

**Capas visibles:**
- Instances
- Instances_restored_buildings (con buses y paradas)
- Tiles_floors_restored
- Tiles_road_restored
- Tiles_trees
- Tiles_urban_road (nueva)

**Efectos en NPCs:**
- Los NPCs de las paradas de autobús están disponibles
- Los vecinos pueden usar los autobuses (diálogos sobre transporte)

**Progreso de UI:** "Completando infraestructura urbana..."
**Notificación de construcción:** "La urb. estará lista en X días..."

---

## Estados de Progresión

```gml
enum TownStage {
    INITIAL = 0,           // Estado destruido inicial
    STREETS_CLEARED = 1,  // Calles limpiadas
    GREENS_RESTORED = 2,  // Áreas verdes restauradas
    COMPLETE = 3,         // Calles restauradas
    SHOP_CONSTRUCTION = 4,   // Tienda en construcción
    SHOP_RESTORED = 5,    // Tienda de Miraculos arreglada
    BLACKSMITH_CONSTRUCTION = 6, // Herrero en construcción
    BLACKSMITH_RESTORED = 7, // Herrero arreglado
    TREES_CONSTRUCTION = 8, // Árboles en proceso (sin tiempo real)
    TREES_RESTORED = 9, // Árboles visibles
    BUILDINGS_CONSTRUCTION = 10, // Torre y parque en construcción
    BUILDINGS_RESTORED = 11, // Torre y parque completados
    URBANIZATION_CONSTRUCTION = 12, // Urbanización final en construcción
    URBANIZATION_COMPLETE = 13 // Urbanización completada (autobuses)
}
```

**Notas del enum:**
- `SHOP_CONSTRUCTION`, `BLACKSMITH_CONSTRUCTION` y `BUILDINGS_CONSTRUCTION` son estados transient durante la construcción
- `TREES_CONSTRUCTION` es instantáneo (0 días), pero sirve como estado de transición
- La UI debe mostrar progreso de construcción (días restantes)
- Los NPCs no están disponibles en estados de construcción

---

## Variables Globales Sugeridas

```gml
global.town_stage = TownStage.INITIAL;  // Controla la etapa actual
global.town_construction_day = 0;      // Día en que empezó la construcción actual
global.town_construction_duration = 0;  // Días que dura la construcción actual
```

---

## Integración con Sistema Existente

### Almacenamiento de Estado
- `global.town_stage`, `global.town_construction_day`, `global.town_construction_duration` se guardan en `scr_save_game()` (JSON)
- Se cargan en `scr_apply_loaded_game()` al iniciar partida
- Room state de town incluye visibilidad de instancias destroyed/restored
- **Verificar construcción al cargar:** Si hay una construcción en progreso, calcular días restantes y completar si corresponde

### Objeto de Gestión
- **`obj_town_progression`** — singleton que:
  - Inicia con `global.town_stage = TownStage.INITIAL`
  - Contiene array `donation_requirements[stage]` con items/cantidades por etapa
  - Gestiona transiciones al detectar donaciones completadas
  - Ejecuta cambios visuales (capas, instancias, NPCs) al avanzar etapa
  - Maneja el conteo de días de construcción

### Objeto de Caja de Donativo
- **`obj_donation_box`** — instancia interactuable en town:
  - Create: lee `global.town_stage` y muestra items requeridos para etapa actual
  - Draw: muestra UI con progreso de donaciones
  - Key Press E: abre menú de donación (desde inventario)
  - Al completarse: inicia construcción o llama a `scr_advance_town_stage()` según corresponda
  - Si `global.town_stage == TownStage.BLACKSMITH_RESTORED`: desaparece o muestra "¡Completado!"

### Funciones Nuevas
```gml
// Devuelve struct con requirements: {key: cantidad, key2: cantidad, ...}
scr_get_town_stage_donations(_stage)

// Verifica si jugador tiene todos los items de la etapa
scr_check_donations_complete(_stage)

// Transfiere items del inventario a un struct temporal
scr_submit_donations(_items_array)

// Inicia construcción (para etapas 4-5)
// _duration: días de construcción
scr_start_town_construction(_duration)

// Verifica si la construcción terminó
// Llamar en start_new_day()
scr_check_town_construction_completed()

// Ejecuta cambios visuales/NPCs al avanzar etapa
scr_advance_town_stage(_new_stage)

// Restaura estado visual del town según stage guardado
scr_restore_town_stage()
```

### UI de Donativo
- Panel centrado con:
  - Título: "Donativos para [nombre etapa]"
  - Lista de items: `[X/Y] <icon> <nombre> (cantidad requerida)`
  - Progreso visual (barra o porcentaje)
  - Botón "Donar" → abre inventario modo selección
  - Botón "Cerrar"

### UI de Construcción (para etapas 4-5)
- Panel centrado con:
  - Título: "Construcción en progreso..."
  - Nombre del edificio: "Tienda de Miraculos" o "Herrería"
  - Días restantes: "Listo en X días"
  - Visual del `obj_construction_site`

### Persistencia de NPCs
- En `scr_advance_town_stage()`:
  - Si etapa = SHOP_RESTORED: crear instancia Miraculos en room general_shop (60, 90)
  - Si etapa = BLACKSMITH_RESTORED: crear instancia Carlos en room blacksmith (60, 90)
  - Instancias existentes se destruyen antes de crear nuevas

### Límite de Upgrades de Herramientas
- En `scr_upgrade_tool(_tool_key)`:
  - Obtener calidad actual de la herramienta
  - **Si `global.town_stage < TownStage.BLACKSMITH_RESTORED`:**
    - Si calidad actual ≥ 6 (CHUBESTANIO): rechazar upgrade
    - Mostrar notificación: `scr_notify("La herrería del town no está lista para upgrades mayores.")`
    - Return sin hacer upgrade
  - **Si `global.town_stage >= TownStage.BLACKSMITH_RESTORED`:**
    - Permitir upgrade hasta nivel 9 (VITOLANIO, el máximo)
    
- La validación ocurre **antes** de intentar hacer el upgrade (no consume items)

### Comandos de Debug

Agregar al sistema de debug console (presionar Enter para abrir) el siguiente comando para testear la progresión sin tener que donar items reales:

| Comando | Descripción |
|---------|-------------|
| `set_town_stage <n>` | Establece `global.town_stage` directamente al valor `n` (0-13, ver enum `TownStage`). Aplica todos los cambios visuales (capas, instancias, NPCs) llamando a `scr_restore_town_stage()` |

**Implementación:** Agregar la branch correspondiente en el parser del comando de debug (mismo lugar donde se procesan `add_item`, `set_day`, `buy_building`, etc.). Debe llamar a `scr_restore_town_stage()` y mostrar feedback con `scr_notify()`.

---

### Verificación de Construcción al Iniciar/Cargar
```gml
// En scr_apply_loaded_game() o al entrar al town
if (global.town_stage == TownStage.SHOP_CONSTRUCTION ||
    global.town_stage == TownStage.BLACKSMITH_CONSTRUCTION ||
    global.town_stage == TownStage.BUILDINGS_CONSTRUCTION ||
    global.town_stage == TownStage.URBANIZATION_CONSTRUCTION) {

    var _days_passed = global.day - global.town_construction_day;

    if (_days_passed >= global.town_construction_duration) {
        // Construcción completada mientras el jugador no estaba
        scr_advance_town_stage(global.town_stage + 1);
    }
}
```