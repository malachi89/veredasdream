# Blacksmith (Herrero — Carlos)

`obj_npc` with `npc_key = "Carlos"` in the `blacksmith` room offers tool upgrades. The shop UI uses the same workbench-style ingredient boxes (760px panel, 64px rows, sprite boxes for materials).

## Interaction

- Press **E** near Carlos to open the upgrade shop (handled in `obj_npc/Step_0.gml`)
- The NPC draw already showed `"[E] Comprar"` for any NPC with a `shop_data` entry; the Step event now handles the E key to set `shop_open` / `shop_npc_key`
- The shop closes with **ESC** (same as all shops)

## Shop Data

**File:** `scripts/script_init.gml:1089`

```gml
global.shop_data[$ "Carlos"] = {
    available: true,
    items: [
        { item_key: "pickaxe",      is_upgrade: true },
        { item_key: "axe",          is_upgrade: true },
        { item_key: "hoe",          is_upgrade: true },
        { item_key: "sickle",       is_upgrade: true },
        { item_key: "watering_can", is_upgrade: true },
        { item_key: "shovel",       is_upgrade: true },
        { item_key: "fishing_rod",  is_upgrade: true },
        { item_key: "bugnet",       is_upgrade: true },
    ]
};
```

Each entry uses the tool key as `item_key` with `is_upgrade: true`. No static `price_money` or `price_items` — all costs are computed dynamically based on the tool's current quality in the player's inventory.

## Upgrade Costs (dynamic)

**File:** `scripts/script_inventory_functions.gml:1247` — `scr_get_upgrade_requirements(_quality)`

| Target Quality | Bar (qty 10) | Stone | Coal | Money |
|---|---|---|---|---|
| BRONCE (0→1) | `bar_bronce` | 10 | 5 | $500 |
| PLATA (1→2) | `bar_plata` | 15 | 8 | $1,000 |
| ORO (2→3) | `bar_oro` | 20 | 10 | $2,000 |
| BRONCASTANIO (3→4) | `bar_broncastanio` | 25 | 12 | $4,000 |
| CHUBESTANIO (4→5) | `bar_chubestanio` | 30 | 15 | $8,000 |
| PICASTANIO (5→6) | `bar_picastanio` | 35 | 18 | $16,000 |
| HITLERSTANIO (6→7) | `bar_hitlerstanio` | 40 | 20 | $32,000 |
| VITOLANIO (7→8) | `bar_vitolanio` | 50 | 25 | $64,000 |

## Helper Functions

### `scr_get_tool_quality(tool_key, player)`

**File:** `scripts/script_inventory_functions.gml:1273`

Searches `inventory_array` then `backpack_array` for the tool. Returns its current `quality` field, defaults to `QUALITY.OXIDADO` (0) if no quality field, or `-1` if the tool is not found.

### `scr_blacksmith_upgrade(tool_key, player)`

**File:** `scripts/script_inventory_functions.gml:1289`

The full purchase flow:
1. Check the tool exists in inventory → `shop_msg: "No tienes <name>"`
2. Check not already at `QUALITY.VITOLANIO` → `shop_msg: "Ya esta al maximo!"`
3. Compute requirements via `scr_get_upgrade_requirements(quality)`
4. Check money → `shop_msg: "Fondos insuficientes"`
5. Check materials (bar, stone, coal) → `shop_msg: "Te faltan materiales"`
6. Deduct money and materials
7. Call `scr_upgrade_tool(tool_key)` — increments quality on the slot struct
8. Show `shop_msg: "Herramienta mejorada!"` + play `sound_item_pickup`

## Shop UI Changes

### Step (purchase)

**File:** `objects/obj_inventory/Step_0.gml:23,49`

- `_is_bs` check added alongside `_is_wb` (workbench) for layout (760px, 7 rows, 64px row height)
- When clicking an entry with `is_upgrade: true` in Carlos's shop, calls `scr_blacksmith_upgrade()` directly (bypasses the static affordability check)

### Draw (display)

**File:** `objects/obj_inventory/Draw_64.gml:410,566`

- Uses `_wb_or_bs` flag for panel dimensions, row height, header/footer lines, and row backgrounds
- Each upgrade row shows:
  - **Left:** Tool sprite + tool name (existing code, works since `scr_get_item_data(tool_key)` returns tool data)
  - **Below name:** Current quality → next quality (e.g. `"Bronce → Plata"`) in yellow/orange, or `"Vitolanio (MAX)"` if at max
  - **Right:** Dynamic ingredient boxes: money box (MXN$) + bar box + stone box + coal box, each with green/red border depending on affordability
- If tool not in inventory: shows `"No tienes esta herramienta"` in red
- If tool is max: shows `"MAXIMO"` in yellow
- Tooltips on ingredient boxes show quantity and item name

## Notes

- Tools without `tool_progression` data (shovel, fishing_rod, bugnet) can still be upgraded — the quality field increments and changes the sprite/tooltip, but gameplay stats remain default (no `hits_required`, `area`, etc.)
- NPC shop hint (`"[E] Comprar"`) was already shown in `obj_npc/Draw_0.gml` for any NPC with a `shop_data` entry — no change needed there
- The E-key interaction was added generically to `obj_npc/Step_0.gml` so any future NPC with `shop_data[$ key].available = true` will automatically work
