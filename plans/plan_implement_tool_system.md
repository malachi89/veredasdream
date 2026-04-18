# Tool Progression System (GameMaker)

## Goal

Implement a **linear upgrade system** for tools where:

* Each tier improves efficiency
* Higher tiers add **stacking special effects**
* No branching paths
* Clean, data-driven implementation

---

## Tools

```
PICKAXE
AXE
SICKLE
HOE
WATERING_CAN
```

---

## Tiers (ordered)

```
OXIDADO
BRONCE
PLATA
ORO
BRONCASTANIO
CHUBESTANIO
PICASTANIO
HITLERSTANIO
VITOLANIO
```

---

## Global Rules

* Each tier reduces required actions OR increases area
* Special effects are **additive (stacking)**
* No tier removes previous bonuses
* System must be **data-driven**

---

## Core Stats

```
hits_required
area_width
area_height
double_drop_chance
rare_drop_chance
treasure_chance
triple_drop_chance
no_energy_chance
```

---

# RESOURCE DURABILITY

## Base Durability

* Rocks require **10 hits** with PICKAXE to break
* Trees require **10 hits** with AXE to break

## Rule

* `hits_required` reduces the number of hits needed
* Final hits = base_hits - reduction
* Clamp minimum to 1

## Example

```
rock_base_hits = 10

OXIDADO → 10 hits
BRONCE → 9 hits
PLATA → 8 hits
ORO → 7 hits
BRONCASTANIO → 6 hits
```

---

# PICKAXE

## Efficiency

* Reduces hits progressively from base (10)

## Special Effects

CHUBESTANIO:

* double_drop_chance

PICASTANIO:

* rare_drop_chance (gems)

HITLERSTANIO:

* treasure_chance

VITOLANIO:

* no_energy_chance

---

# AXE

## Efficiency

* Same system as PICKAXE (trees = base 10 hits)

## Special Effects

CHUBESTANIO:

* double_drop_chance

PICASTANIO:

* rare_drop_chance (fruits / seeds)

HITLERSTANIO:

* treasure_chance

VITOLANIO:

* no_energy_chance

---

# SICKLE

## Area

OXIDADO: 1x1
BRONCE: 2x2
PLATA: 3x3
ORO: 4x4
BRONCASTANIO: 5x5

## Special Effects

CHUBESTANIO:

* double_drop_chance

PICASTANIO:

* rare_drop_chance (money)

HITLERSTANIO:

* triple_drop_chance

VITOLANIO:

* no_energy_chance = 1

---

# HOE

## Area

OXIDADO: 1x1
BRONCE: 2x1
PLATA: 3x1
ORO: 3x2
BRONCASTANIO: 3x3
CHUBESTANIO: 3x6
PICASTANIO: 6x6
HITLERSTANIO: 9x9
VITOLANIO: 9x9

## Special Effects

VITOLANIO:

* no_energy_chance = 1

---

# WATERING_CAN

## Area

Same as HOE

## Special Effects

VITOLANIO:

* no_energy_chance = 1
* water_persists_next_day = true

---

# Implementation

## Data Structure

```
tool_data[tool_type][tier] = {
    hits_required,
    area_width,
    area_height,
    double_drop_chance,
    rare_drop_chance,
    treasure_chance,
    triple_drop_chance,
    no_energy_chance
}
```

---

## Behavior

### Breaking Resources

* Use base_hits (10)
* Apply hits_required reduction
* Destroy when reaches 0

### Drops

* Roll double_drop_chance
* Roll rare_drop_chance
* Roll treasure_chance
* Roll triple_drop_chance (sickle)

### Energy

* Roll no_energy_chance before consuming energy

---

## Constraints

* No hardcoded logic per tier
* Everything driven by data
* Keep code simple and reusable

---

## Output

* GameMaker-style structs/enums
* Minimal, clean logic
* No overengineering
