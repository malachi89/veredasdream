# NPC Generation Plan (GameMaker Project)

## Objective

Create **20 NPCs** using modular sprite assets inside the `characters` folder, following project conventions.

---

## Folder Structure

```id="s8k2jd"
characters/
│
├── Character/
│   ├── idle/
│   │   ├── Clothes/
│   │   ├── Hairs/
│   │   ├── Skins/
│   │   └── Eyes/
│   │
│   └── walk/
│       ├── Clothes/
│       ├── Hairs/
│       ├── Skins/
│       └── Eyes/
│
└── Portrait/
    ├── Clothes/
    ├── Hairs/
    ├── Skins/
    └── Eyes/
```

---

## Sprite Specifications

### Character Sprites

* Size: **32x32**
* Layout: **single horizontal strip**

#### Idle Animation (16 frames)

* DOWN: 0–3
* UP: 4–7
* RIGHT: 8–11
* LEFT: 12–15

#### Walk Animation (24 frames)

* DOWN: 0–5
* UP: 6–11
* RIGHT: 12–17
* LEFT: 18–23

---

## Portrait Specifications (IMPORTANT)

* Frame size: **64x64**
* Layout: **3 rows × 5 columns (15 frames total)**

### Expressions by Row

* Row 0 → **Neutral**
* Row 1 → **Questioning**
* Row 2 → **Smiling**

### Frame Indexing (per row)

* Each row goes from **0–4 frames**
* Total frames:

  * Neutral: 0–4
  * Questioning: 5–9
  * Smiling: 10–14

---

## NPC Creation Rules

1. Create **20 unique NPCs**
2. Each NPC must use a **combination of:**

   * Clothes
   * Hair
   * Skin
   * Eyes
3. Combinations must be **visually distinct**
4. Use the **same combination across ALL systems:**

   * Idle animation
   * Walk animation
   * Portrait (all expressions)

---

## Portrait Rules (CRITICAL)

* Portrait uses SAME modular parts:

  * Clothes
  * Hair
  * Skin
  * Eyes
* The combination MUST match Character exactly
* ALL 3 expressions must use the same combination
* Do NOT mix parts between expressions
* Do NOT mismatch portrait vs character

---

## Naming Rules

* All NPCs must have **Mexican names**
* One NPC MUST be named: **Miraculos**

### NPC Name List

1. Miraculos
2. José
3. María
4. Juan
5. Lupita
6. Carlos
7. Fernanda
8. Diego
9. Ximena
10. Alejandro
11. Valeria
12. Ricardo
13. Daniela
14. Luis
15. Sofía
16. Miguel
17. Camila
18. Jorge
19. Andrea
20. Raúl

---

## Sprite Import Conventions

### Character

```id="n8f3ls"
spr_npc_<name>_idle
spr_npc_<name>_walk
```

### Portrait

```id="k29dle"
spr_npc_<name>_portrait
```

---

## Combination System

For each NPC:

1. Select:

   * 1 Clothes
   * 1 Hair
   * 1 Skin
   * 1 Eyes

2. Apply to:

   * Character idle
   * Character walk
   * Portrait (ALL rows)

---

## Implementation Steps

1. Loop through 20 NPCs
2. For each NPC:

   * Generate unique combination
   * Build Idle sprite
   * Build Walk sprite
   * Build Portrait:

     * Apply combination to ALL 3 rows
     * Ensure correct frame slicing (3x5 layout)
3. Import with correct naming

---

## Validation Checklist

* [ ] 20 NPCs created
* [ ] "Miraculos" exists
* [ ] All names are Mexican
* [ ] Each NPC has:

  * [ ] Idle
  * [ ] Walk
  * [ ] Portrait (3 expressions)
* [ ] Portrait uses 64x64 frames
* [ ] Portrait layout is 3x5
* [ ] Expressions mapped correctly
* [ ] No mismatched combinations
* [ ] Visual consistency across ALL assets

---

## Notes

* Do NOT change sprite sizes
* Do NOT mix combinations between systems
* Portrait expressions are NOT separate characters
* Maintain strict consistency across:

  * idle
  * walk
  * portrait (all expressions)

---
