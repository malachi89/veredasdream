# Implementación de la Pala (Shovel)

## Archivos modificados

### `scripts/script_init/script_init.gml`
- Agregada progresión `_tp[$ "shovel"]` con 9 tiers de calidad (OXIDADO a VITOLANIO)
- Stats por tier: `area_width`, `area_height` (1×1 → 4×4), `dig_chance` (0.15 → 0.55), `treasure_chance` (0.01 → 0.10), `no_energy_chance` (0 → 0.40)

### `scripts/script_player_actions/script_player_actions.gml`
- Agregado `dig_chance: 0` al fallback default de tier_stats (línea 17)
- Reemplazado stub de pala con lógica completa (líneas 389-453):
  - Solo funciona en salas `"farm"`, `"forest"`, y `"cave_*"`
  - Itera área efectiva centrada en el tile objetivo
  - Verifica `Tiles_details` == 0 (suelo válido) y no agua
  - Crea `obj_shoveled` en capa `"Instances"` si no existe ya en esa posición
  - **Loot** (cuando `dig_chance` acierta y no es gema):
    - 30% Piedra (`stone`) — 1-3 + bono
    - 25% Carbón (`coal`) — 1-2 + bono
    - 15% Mineral aleatorio (`ore_*`) — 1
    - 15% Semilla aleatoria — 1-2 + bono
    - 15% Insecto aleatorio — 1
  - **Gema**: cuando `treasure_chance` acierta, una gema aleatoria de `global.gemstone_pool`
- Azada ahora destruye `obj_shoveled` al arar (línea 172-173)

## Archivos nuevos

### `objects/obj_shoveled/`
- `obj_shoveled.yy` — Objeto con sprite `sprite_shoveled`, depth = 100
- `Create_0.gml` — `depth = 100;` (dibuja encima del tilemap, debajo de ítems)

## Persistencia

### `scripts/script_inventory_functions/script_inventory_functions.gml`
- **Captura** (líneas 336-341): guarda array `{x, y}` de todos los `obj_shoveled` en `_state.shoveled_tiles`
- **Restaura** (líneas 656-665): destruye todos los `obj_shoveled` existentes y recrea desde el estado guardado
- Los hoyos cavados persisten en room state y se guardan en `savegame.json`

## Progresión por calidad

| Calidad | Área | dig_chance | treasure_chance | no_energy_chance |
|---|---|---|---|---|
| OXIDADO | 1×1 | 15% | 1% | 0% |
| BRONCE | 1×1 | 20% | 2% | 0% |
| PLATA | 1×1 | 25% | 3% | 5% |
| ORO | 2×1 | 30% | 4% | 10% |
| BRONCASTANIO | 2×2 | 35% | 5% | 15% |
| CHUBESTANIO | 3×2 | 40% | 6% | 20% |
| PICASTANIO | 3×3 | 45% | 7% | 25% |
| HITLERSTANIO | 4×3 | 50% | 8% | 30% |
| VITOLANIO | 4×4 | 55% | 10% | 40% |
