# Plan de Progresión: Restauración del Town

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

**Acción requerida:** El jugador debe limpiar los escombros de las calles.

**Efecto en el mapa:**
- Se **oculta** `Tiles_details_destroyed_1` (depth 700)

**Capas visibles al completar etapa 1:**
- Instances
- Instances_destroyed_buildings
- Tiles_floors_destroyed

---

## Etapa 2: Restaurar Áreas Verdes

**Acción requerida:** El jugador debe restaurar las áreas verdes/jardines.

**Efecto en el mapa:**
- Se **muestra** `Tiles_floors_restored` (depth 500)
- No se oculta nada existente

**Capas visibles al completar etapa 2:**
- Instances
- Instances_destroyed_buildings
- Tiles_floors_destroyed
- Tiles_floors_restored (nueva)

---

## Etapa 3: Calles Restauradas

**Acción requerida:** El jugador debe completar la restauración de las calles.

**Efecto en el mapa:**
- Se **muestra** `Tiles_road_restored` (depth 600)
- Se **oculta** `Tiles_floors_destroyed` (depth 800)
- Se **oculta** `Tiles_details_destroyed_1` (depth 700)

**Capas visibles al completar:**
- Instances
- Instances_restored_buildings (para mostrar edificios reconstruidos)
- Tiles_floors_restored
- Tiles_road_restored

---

## Etapa 4: Arreglar Tienda de Miraculos

**Acción requerida:** El jugador debe reconstruir la tienda de Miraculos.

**Efectos en el mapa:**
- Ocultar `inst_miraculos_shop_destroyed` (capa Instances_destroyed_buildings)
- Mostrar `inst_shop_restored` (capa Instances_restored_buildings) — esta instancia está oculta por defecto

**Efecto en NPC:**
- Mover NPC "Miraculos" al room `general_shop` coordenadas x:60, y:90

---

## Etapa 5: Arreglar Herrero (Blacksmith)

**Acción requerida:** El jugador debe reconstruir la herrería.

**Efectos en el mapa:**
- Ocultar `inst_blacksmith_shop_destroyed` (capa Instances_destroyed_buildings)
- Mostrar `inst_blacksmith_restored` (capa Instances_restored_buildings) — esta instancia está oculta por defecto

**Efecto en NPC:**
- Mover NPC "Carlos" al room `blacksmith` coordenadas x:60, y:90

---

## Estados de Progresión

```gml
enum TownStage {
    INITIAL = 0,          // Estado destruido inicial
    STREETS_CLEARED = 1, // Calles limpiadas
    GREENS_RESTORED = 2, // Áreas verdes restauradas
    COMPLETE = 3,        // Calles restauradas
    SHOP_RESTORED = 4,   // Tienda de Miraculos arreglada
    BLACKSMITH_RESTORED = 5 // Herrero arreglado
}
```

---

## Variables Globales Sugeridas

```gml
global.town_stage = TownStage.INITIAL;  // Controla la etapa actual
```

---

## Integración con Sistema Existente

- El sistema de guardado ya usa `scr_restore_room_state()` - se puede extender para incluir el estado de progresión del town.
- Se puede añadir un objeto `obj_town_progression` que gestione las transiciones entre etapas.
- La UI debe mostrar la tarea actual (limpiar calles → restaurar áreas → completar calles → arreglar tienda → arreglar herrero).