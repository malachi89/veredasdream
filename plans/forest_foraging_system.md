# Plan: Implementation of Forest Foraging System

This plan outlines the steps to implement a script that populates the "forest" room with mushrooms, herbs, and flowers from the `sprite_mushrooms_herbs_flowers` sprite each in-game day.

## 1. Data Definition
Create a new data structure in `scripts/script_init/script_init.gml` called `global.forage_data`. Given the volume, a separate struct is cleaner than expanding `global.material_data`.

Each entry uses a plain ASCII string key (e.g., `"forage_001"`) to avoid encoding issues. The display name is stored as a field inside the struct.

### Data struct fields per item
```
global.forage_data[$ "forage_001"] = {
    name: "Champiñón de Campo",
    subimg: 0,           // 0-based GML image_index
    rarity: 1,           // 1 (common) – 5 (rarest)
    base_sell_price: 10, // required by scr_process_shipping()
    item_type: ITEM_TYPE.MATERIAL
};
```

### Note on subimage indexing
GML `image_index` is **0-based**. The item tables below use 0-based indices throughout. The sprite has 119 frames: mushrooms 0–77, herbs 78–96, flowers 97–118.

### Mushroom Data (Subimg 0–77)
Examples:
- Subimg 0: "Champiñón de Campo" (Rarity 1)
- Subimg 77: "Champiñón Lunar" (Rarity 5)

### Herb Data (Subimg 78–96)
- Subimg 78: "Hierbabuena" (Rarity 1)
- Subimg 96: "Azafrán del Bosque" (Rarity 5)

### Flower Data (Subimg 97–118)
- Subimg 97: "Margarita" (Rarity 1)
- Subimg 118: "Orquídea de Cristal" (Rarity 5)

### Detailed Item List

Below are the invented Spanish names and rarities (1-5, where 5 is rarest) for all 119 items.

#### Mushrooms (Subimg 0 – 77)
| Subimg | Name | Rarity | | Subimg | Name | Rarity |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 0 | Champiñón de Campo | 1 | | 39 | Rebozuelo de Canal | 3 |
| 1 | Boleto Noble | 2 | | 40 | Seta de Abeto | 2 |
| 2 | Níscalo de Pinar | 1 | | 41 | Amanita Pantera | 4 |
| 3 | Amanita de los Césares | 3 | | 42 | Seta de Jaral | 2 |
| 4 | Rebozuelo Dorado | 2 | | 43 | Boleto de Pino | 3 |
| 5 | Trompeta de la Muerte | 3 | | 44 | Seta de Castaño | 2 |
| 6 | Seta de Cardo | 1 | | 45 | Trompeta Gris | 3 |
| 7 | Morilla de Primavera | 4 | | 46 | Seta de Aliso | 2 |
| 8 | Trufa Negra | 5 | | 47 | Champiñón de Bosque | 1 |
| 9 | Seta de San Jorge | 3 | | 48 | Seta de Abedul | 2 |
| 10 | Oreja de Judas | 2 | | 49 | Boleto Elegante | 3 |
| 11 | Hongo Blanco | 1 | | 50 | Seta de Sauce | 2 |
| 12 | Seta de Pino | 2 | | 51 | Amanita Muscaria | 4 |
| 13 | Pie Azul | 3 | | 52 | Seta de Olmo | 2 |
| 14 | Lengua de Gato | 2 | | 53 | Rebozuelo Amatista | 3 |
| 15 | Carbonera de Otoño | 2 | | 54 | Seta de Enebro | 2 |
| 16 | Parasol Gigante | 2 | | 55 | Boleto de Cueva | 4 |
| 17 | Seta de Chopo | 1 | | 56 | Seta de Gruta | 3 |
| 18 | Rebozuelo Naranja | 2 | | 57 | Champiñón de Arena | 2 |
| 19 | Boleto Bayo | 3 | | 58 | Seta de Duna | 2 |
| 20 | Seta de Mayo | 2 | | 59 | Boleto de Costa | 3 |
| 21 | Amanita Rojiza | 3 | | 60 | Seta de Pantano | 3 |
| 22 | Champiñón Silvestre | 1 | | 61 | Amanita Vaginata | 2 |
| 23 | Seta de Ostra | 2 | | 62 | Seta de Turbera | 3 |
| 24 | Boleto Reticulado | 3 | | 63 | Rebozuelo Velloso | 3 |
| 25 | Seta Engañosa | 2 | | 64 | Seta de Breñal | 2 |
| 26 | Níscalo de Sangre | 3 | | 65 | Boleto de Risco | 4 |
| 27 | Trompeta Amarilla | 2 | | 66 | Seta de Cumbre | 4 |
| 28 | Seta de Brezo | 2 | | 67 | Champiñón de Pasto | 1 |
| 29 | Hongo Rojo | 3 | | 68 | Seta de Valle | 2 |
| 30 | Seta de Encina | 2 | | 69 | Boleto de Cañada | 3 |
| 31 | Boleto Real | 4 | | 70 | Seta de Arroyo | 2 |
| 32 | Seta de Musgo | 2 | | 71 | Amanita de Huevo | 4 |
| 33 | Amanita Citrina | 3 | | 72 | Seta de Manantial | 3 |
| 34 | Seta de Prados | 1 | | 73 | Rebozuelo de Fuente | 2 |
| 35 | Bola de Nieve | 3 | | 74 | Seta de Cascada | 4 |
| 36 | Seta de Haya | 2 | | 75 | Boleto de Niebla | 3 |
| 37 | Boleto de Verano | 2 | | 76 | Seta de Bruma | 3 |
| 38 | Seta de Roble | 2 | | 77 | Champiñón Lunar | 5 |

#### Herbs (Subimg 78 – 96)
| Subimg | Name | Rarity | | Subimg | Name | Rarity |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 78 | Hierbabuena | 1 | | 88 | Perejil de Selva | 2 |
| 79 | Romero de Monte | 1 | | 89 | Cilantro de Loma | 2 |
| 80 | Tomillo de Roca | 1 | | 90 | Laurel de Cañada | 3 |
| 81 | Salvia del Bosque | 2 | | 91 | Mejorana | 2 |
| 82 | Albahaca Silvestre | 2 | | 92 | Estragón | 3 |
| 83 | Lavanda de Valle | 3 | | 93 | Anís de Estepa | 3 |
| 84 | Orégano de Sierra | 2 | | 94 | Hinojo | 1 |
| 85 | Menta de Agua | 2 | | 95 | Comino de Páramo | 3 |
| 86 | Poleo | 2 | | 96 | Azafrán del Bosque | 5 |
| 87 | Eneldo | 2 | | | | |

#### Flowers (Subimg 97 – 118)
| Subimg | Name | Rarity | | Subimg | Name | Rarity |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 97 | Margarita | 1 | | 108 | Azucena de Río | 3 |
| 98 | Amapola | 1 | | 109 | Narciso | 3 |
| 99 | Lirio de Agua | 3 | | 110 | Pensamiento | 2 |
| 100 | Orquídea Selvática | 4 | | 111 | Dalia de Sierra | 3 |
| 101 | Rosa Silvestre | 2 | | 112 | Camelia | 4 |
| 102 | Girasol de Monte | 2 | | 113 | Crisantemo | 3 |
| 103 | Tulipán de Valle | 3 | | 114 | Gladiolo | 3 |
| 104 | Violeta de Bosque | 1 | | 115 | Gardenia | 4 |
| 105 | Jazmín de Noche | 4 | | 116 | Magnolio | 4 |
| 106 | Clavel de Aire | 3 | | 117 | Loto Azul | 5 |
| 107 | Hortensia | 3 | | 118 | Orquídea de Cristal | 5 |

## 2. Script: `scr_populate_forest`
Create a new script `scripts/scr_populate_forest.gml` with the following logic:

- **Clear old forageables** — remove all existing forest forage drops from `global.room_drops[$ "forest"]` whose `item_key` starts with `"forage_"`, then destroy any live `obj_item_parent` instances in the forest room if the forest is currently active.
- **Define spawn boundaries** for the `forest` room.
- **Loop** to attempt spawning N items (e.g., 5–15 per day).
- **Selection algorithm:**
  - Build a weighted pool from `global.forage_data`: weight = `(6 - rarity)`.
  - Pick a random entry from the pool.
- **Placement:**
  - Pick a random (x, y) within bounds.
  - Check for collisions with `obj_collision`, `obj_tree`, or existing `obj_item_parent` using `place_meeting`.
  - Retry up to a max attempt count if blocked.
- **Instance creation:**
  - `var _inst = instance_create_layer(x, y, "Instances_Items", obj_item_parent);`
  - Set `_inst.item_key` to the chosen forage key.
  - Call `scr_register_room_drop(_inst, "forest")` immediately so the drop persists across room changes and is included in the save file.

## 3. Integration with Game Controller
**Do not** call `scr_populate_forest()` directly inside `start_new_day()` — that function runs regardless of current room, so `place_meeting` would check the wrong room's collision objects.

Instead, use a deferred flag pattern (same as `global.farm_populated` in `Step_0.gml`):

### In `start_new_day()` (`objects/obj_controller/Create_0.gml`):
```gml
global.forest_needs_repopulate = true;
```

### In `Step_0.gml` (alongside the existing farm populate block):
```gml
if (global.forest_needs_repopulate && room_get_name(room) == "forest"
        && instance_exists(obj_player) && instance_exists(obj_inventory)) {
    global.forest_needs_repopulate = false;
    scr_populate_forest();
    scr_capture_current_room_state();
}
```

Also initialize `global.forest_needs_repopulate = false;` in `Create_0.gml` alongside the other globals.

## 4. Update `scr_get_item_data()`
Add `global.forage_data` to the lookup chain in `scripts/script_inventory_functions/script_inventory_functions.gml`. Without this, picked-up forageables will have no data and break the inventory display and shipping.

```gml
function scr_get_item_data(_key) {
    if (variable_struct_exists(global.seed_data,      _key)) return global.seed_data[$      _key];
    if (variable_struct_exists(global.crop_data,      _key)) return global.crop_data[$      _key];
    if (variable_struct_exists(global.tool_data,      _key)) return global.tool_data[$      _key];
    if (variable_struct_exists(global.placeable_data, _key)) return global.placeable_data[$ _key];
    if (variable_struct_exists(global.material_data,  _key)) return global.material_data[$  _key];
    if (variable_struct_exists(global.forage_data,    _key)) return global.forage_data[$    _key];
    return undefined;
}
```

## 5. Verification
- Use the "Advance Day" keybind (**O**) to set the repopulate flag.
- Teleport to the forest room and verify items spawn on entry.
- Advance another day while inside the forest to verify old items are cleared and new ones appear.
- Verify items can be picked up and added to the inventory.
- Verify picked-up forageables display correctly in the inventory (name, icon, sell price).
- Save and reload; verify forest forage drops are restored correctly.

## Summary Table
| Category | Subimg Range (0-based) | Total | Naming Style |
| :--- | :--- | :--- | :--- |
| Mushrooms | 0 – 77 | 78 | Spanish (e.g., Boleto, Níscalo) |
| Herbs | 78 – 96 | 19 | Spanish (e.g., Tomillo, Romero) |
| Flowers | 97 – 118 | 22 | Spanish (e.g., Azucena, Orquídea) |

Rarity logic: `weighted_chance = (6 - rarity)`. Higher rarity = lower weight.
