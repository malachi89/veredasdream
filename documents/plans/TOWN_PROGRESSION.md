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
| `cloth_any` | 30 | Cualquier tela |
| `leather_any` | 15 | Cualquier cuero |
| `thread_any` | 10 | Cualquier hilo |
| `wool_any` | 10 | Cualquier lana |
| `dye_yellow` | 3 | Tinte Amarillo |

**Efecto en el mapa al completar:**
- Se **muestra** `Tiles_road_restored` (depth 600)
- Se **oculta** `Tiles_floors_destroyed` (depth 800)
- Se **oculta** `Tiles_details_destroyed_1` (depth 700)
- Destruidas las instancias destroyed buildings base

**Capas visibles:**
- Instances
- Instances_restored_buildings (edificios base ahora visibles)
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
| `thread_any` | 15 | Cualquier hilo |
| `egg_any` | 15 | Cualquier huevo |
| `dye_any` | 3 | Cualquier tinte |
| `fruit_any` | 50 | Cualquier fruta |
| `forage_any` | 15 | Cualquier hierba/flor |

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
| `leather_any` | 40 | Cualquier cuero |
| `pelt_any` | 20 | Cualquier piel |
| `yarn_any` | 20 | Cualquier estambre |
| `gemstone_any` | 10 | Cualquier gema |
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
    BLACKSMITH_RESTORED = 7 // Herrero arreglado
}
```

**Notas del enum:**
- `SHOP_CONSTRUCTION` y `BLACKSMITH_CONSTRUCTION` son estados transient durante la construcción
- La UI debe mostrar progreso de construcción (días restantes)
- Los NPCs no están disponibles en estos estados

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

### Verificación de Construcción al Iniciar/Cargar
```gml
// En scr_apply_loaded_game() o al entrar al town
if (global.town_stage == TownStage.SHOP_CONSTRUCTION || 
    global.town_stage == TownStage.BLACKSMITH_CONSTRUCTION) {
    
    var _days_passed = global.day - global.town_construction_day;
    
    if (_days_passed >= global.town_construction_duration) {
        // Construcción completada mientras el jugador no estaba
        scr_advance_town_stage(global.town_stage + 1);
    }
}
```