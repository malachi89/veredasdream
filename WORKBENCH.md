# Workbench (Mesa de Trabajo)

`obj_workbench` is a placeable crafting station. The player presses **E** near it to open the crafting menu. It is picked up with the **axe** (cannot pick up while menu is open).

## Data

- Item key: `"workbench"` — in `global.placeable_data` with `is_workbench: true`
- `global.shop_data[$ "workbench"]` holds all recipes in the standard shop format
- `global.npc_data` has a `workbench` entry (`name: "Mesa de Trabajo"`) so the shop UI shows the correct title

## Recipes

| Output | Ingredients |
|---|---|
| Mesa de Trabajo | 30 madera + 20 piedra |
| Cofre | 50 madera |
| Curtidora | 50 madera + 10 piedra + 3 lingote plata + 10 Cuero/Piel |
| Telar | 15 madera + 5 carbón + 3 lingote bronce + 10 Estambre |
| Mantequillera | 50 madera + 50 piedra + 3 lingote bronce + 10 Leche |
| Mermeladora | 30 madera + 3 lingote plata + 10 Fruta/Verdura |
| Prensa de Queso | 60 madera + 30 piedra + 3 lingote oro + 10 Leche |
| Horno | 80 piedra + 10 carbón |
| Colmena | 20 madera + 3 miel + 5 lingote broncastanio |

## Item Groups

`global.item_groups` defines ingredient groups for recipes that accept any item of a type. Used via `group_keys` field on a `price_items` entry.

| Key | Accepts |
|---|---|
| `milk_any` | `milk_reg`, `milk_large`, `goat_milk_reg`, `goat_milk_large` |
| `leather_any` | `pelt_*`, `cow_hide_*`, `rabbit_pelt_*` (all 14 colors each) |
| `yarn_any` | `yarn_*` (all 14 colors) |
| `crop_any` | All 37 crop types from `global.crop_data` |

### Recipe ingredient struct format

```gml
// specific item
{ key: "wood", qty: 50 }

// group ingredient
{ key: "milk_any", qty: 10, name: "Leche", group_keys: global.item_groups.milk_any }
```

The `name` field is used for display when `scr_get_item_data(key)` returns `undefined`. The sprite shown in the UI is taken from `group_keys[0]`.

## Helper Functions (`script_inventory_functions.gml`)

- `scr_count_item_group(_group_keys, _player)` — sum of all items in the group across hotbar + backpack
- `scr_remove_items_from_group(_group_keys, _qty, _player)` — removes `_qty` total from group keys in order

## Shop UI — Workbench vs NPC

The shop UI in `obj_inventory/Draw_64.gml` and `obj_inventory/Step_0.gml` both branch on `shop_npc_key == "workbench"`:

| Property | NPC shop | Workbench |
|---|---|---|
| Panel width | 520 | 760 |
| Panel height | 460 | 580 |
| Row height | 44 | 64 |
| Visible rows | 8 | 7 |
| Header line y | `py1 + 46` | `py1 + 66` |
| List start y | `py1 + 52` | `py1 + 74` |
| Footer line y | `py2 - 38` | `py2 - 50` |
| Price display | Text string | Sprite boxes (96×48 px each) |

Each ingredient is shown as a sprite box: sprite on the left, quantity number on the right. Border is **green** if the player has enough, **red** if not. Hovering a box shows a tooltip: `"50 piezas de Madera"` or `"10 Leche (cualquier tipo o color)"`.

**Important:** `_visible` and panel dimensions must be kept in sync between Draw_64.gml and Step_0.gml. Mismatches cause click rows to be offset from the visual rows.

## Placement Notes

- `placeable_data` entries can have `tile_w` / `tile_h` integer fields to override the auto-calculated tile size (`ceil(sprite_width / 16)`). The chest uses `tile_w: 1, tile_h: 1` because `sprite_farm_chests` is 32 px wide per frame.
- The same override is checked in `obj_controller/Step_0.gml` (selector) and `script_player_actions.gml` (collision check).

## Machine Pickup Change

Machines are no longer picked up with right-click. They are picked up with the **axe** (same as workbench). Cannot pick up if `state == 1` (processing) or `state == 2` (item ready). Logic lives in the `case "axe"` block of `scr_use_item()`.

## Bear Honey Drop

`global.wild_animal_data.bear.product_drops` includes `"honey"` 5 times alongside 14 pelt colors, giving ~26% drop chance. Honey is required to craft the Colmena at the workbench.
