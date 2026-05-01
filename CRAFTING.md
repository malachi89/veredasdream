# Crafting — Reference

## Máquinas

| Máquina | Sprite | Anim | Tiempo (frames) | Proceso |
|---|---|---|---|---|
| Curtidora | `sprite_machine_curtidora` | 3 | 600 | Pieles → Cuero |
| Telar | `sprite_machine_telar` | 7 | 600 | Estambre → Hilo → Tela |
| Mantequillera | `sprite_machine_mantequillera` | 3 | 480 | Leche → Mantequilla, Huevos → Mayonesa |
| Mermeladora | `sprite_machine_mermeladora` | 3 | 900 | Fruta → Mermelada |
| Prensa de Queso | `sprite_machine_prensa_queso` | 4 | 720 | Leche → Queso |
| Horno | `sprite_machine_horno` | 4 | 1200 | Mineral → Lingote, Madera → Carbón |
| Colmena | `sprite_machine_colmena` | 6 | 3600 (pasiva) | Produce Miel automáticamente |

---

## Crafting Chains

### Textiles (colores)

```
pelt_*       ──┐
cow_hide_*   ──┤── (curtidora) ──→  leather_*
rabbit_pelt_*──┘

yarn_*    ── (telar hilado)  ──→  thread_*
thread_*  ── (telar tejido)  ──→  cloth_*

feathers_* ─→  (end product / ingredient)
string_*   ─→  (end product / ingredient)
```

**Raw drops** (obtained by killing animals): pelt, cow_hide, rabbit_pelt, yarn, feathers, string
**Craft only** (never drop): leather, thread, cloth

### Metalurgia

```
ore_bronce       ──┐
ore_plata        ──┤
ore_oro          ──┤
ore_broncastanio ──┤── (horno) ──→  bar_*
ore_chubestanio  ──┤
ore_picastanio   ──┤
ore_hitlerstanio ──┤
ore_vitolanio    ──┘

wood ── (horno) ──→ coal
```

**Raw drops** (mine): ore_bronce, ore_plata, ore_oro, ore_broncastanio, ore_chubestanio, ore_picastanio, ore_hitlerstanio, ore_vitolanio
**Craft only** (never drop): bar_bronce, bar_plata, bar_oro, bar_broncastanio, bar_chubestanio, bar_picastanio, bar_hitlerstanio, bar_vitolanio

### Lácteos & Huevos

```
milk_reg        ── (prensa_queso) ──→  cheese
milk_large      ── (prensa_queso) ──→  cheese ×2
goat_milk_reg   ── (prensa_queso) ──→  goat_cheese
goat_milk_large ── (prensa_queso) ──→  goat_cheese ×2

milk_reg        ── (mantequillera) ──→  butter
milk_large      ── (mantequillera) ──→  butter ×2

egg_*_reg       ── (mantequillera) ──→  mayonaise
egg_*_large     ── (mantequillera) ──→  mayonaise ×2
```

**Raw drops** (from animals): milk_reg, milk_large (cow); goat_milk_reg, goat_milk_large (goat); eggs (chicken, duck, ostrich)
**Craft only** (never drop): cheese, goat_cheese, butter, mayonaise

### Mermeladas

```
cualquier fruta/verdura ── (mermeladora) ──→  jam_<crop> (Mermelada de <nombre>)
```

**Raw**: cualquier cosecha (crop_data)
**Craft only** (never drop): jam_* (37 variedades)

### Colmena (pasiva)

```
(colmena) ──→  honey (cada 3600 frames ≈ 1 minuto)
```

---

## Colors (14 total)

`red · orange · yellow · green · blue · lilac · purple · turquoise · pink · lime · amber · brown · black · white`

All 14 colors exist for every textile material. Color is random on drop.

---

## Drop Sources

### Wild Animals — 1 guaranteed drop per kill

| Animal | Material |
|---|---|
| Capibara | pelt |
| Fox | pelt |
| Frog | pelt |
| Turtle | pelt |
| Deer | string |
| Penguin | feathers |
| Rabbit | rabbit_pelt |

### Farm Animals — 50% chance drop per kill (on top of their food drop)

| Animal | Material |
|---|---|
| Goat | pelt |
| Pig | pelt |
| Chicken | feathers |
| Duck | feathers |
| Ostrich | feathers |
| Cow | cow_hide |
| Sheep | yarn |

---

## Collection Checklist (14 × 6 raw materials = 84 items)

### pelt (Piel)
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### string (Cuerda)
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### feathers (Plumas)
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### rabbit_pelt (Piel de Conejo)
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### cow_hide (Cuero de Vaca)
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### yarn (Estambre)
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

---

## Craft-Only Materials (14 × 3 = 42 items, crafted from raws)

### leather (Cuero) — from pelt, cow_hide, or rabbit_pelt
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### thread (Hilo) — from yarn
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white

### cloth (Tela) — from thread
- [ ] red · [ ] orange · [ ] yellow · [ ] green · [ ] blue · [ ] lilac
- [ ] purple · [ ] turquoise · [ ] pink · [ ] lime · [ ] amber · [ ] brown · [ ] black · [ ] white
