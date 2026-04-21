# Plan: Fishing System Implementation

This document outlines the strategy for implementing the fishing system. The system uses a multi-phase state machine to handle casting, waiting, biting, and catching.

> **Scope note:** Water tile detection is **deferred**. For now the rod works from any tile. Once the map is complete, Phase A will be updated to check for a water tile in front of the player.

---

## 1. Sprite Analysis & Animation Logic

All fishing sprites (cast, wait, bite, reel, catch) contain **60 frames** split by direction:

| Direction | Frames |
|-----------|--------|
| Down      | 0 – 14  |
| Up        | 15 – 29 |
| Right     | 30 – 44 |
| Left      | 45 – 59 |

When in `STATE.FISHING`, `image_index` is always calculated as:
```gml
image_index = (dir * 15) + floor(frame_anim);
```

### Confirmed sprite assets (per sub-state)

| Sub-state | skin          | hair                    | clothes                  | eyes                       | tool (weapon)                    |
|-----------|---------------|-------------------------|--------------------------|----------------------------|----------------------------------|
| cast      | `..._cast_skins_2` | `..._cast_hairs_fawn_black` | `..._cast_clothes_purple` | `..._cast_eyes_female_brown` | `..._cast_weapon` |
| wait      | `..._wait_skins_2` | `..._wait_hairs_fawn_black` | `..._wait_clothes_purple` | `..._wait_eyes_female_brown` | `..._wait_weapon` |
| bite      | `..._bite_skins_2` | `..._bite_hairs_fawn_black` | `..._bite_clothes_purple` | `..._bite_eyes_female_brown` | `..._bite_weapon` |
| reel      | `..._reel_skins_2` | `..._reel_hairs_fawn_black` | `..._reel_clothes_purple` | **missing** — pass `-1`    | `..._reel_weapon` |
| catch     | `..._catch_skins_2` | `..._catch_hairs_fawn_black` | `..._catch_clothes_purple` | `..._catch_eyes_female_brown` | `..._catch_weapon` |

All sprite names share the prefix `sprite_player_fishing_`. During `reel`, pass `-1` for `action_sprite_eyes`; the draw event will fall back to the idle eyes sprite automatically via `get_sprite_set`.

---

## 2. Data Structures

### 2a. Add `ITEM_TYPE.FISH`

In `scripts/script_init/script_init.gml`, extend the `ITEM_TYPE` enum:
```gml
enum ITEM_TYPE {
    MATERIAL,
    SEED,
    CROP,
    TOOL,
    PLACEABLE,
    FORAGE,
    FISH    // new
}
```

### 2b. `global.fish_data` (99 entries)

Define a new struct in `scripts/script_init/script_init.gml`. Keys use the format `fish_XX` (zero-padded two digits). Each entry:
```gml
fish_XX: {
    name: "...",
    type: ITEM_TYPE.FISH,
    sprite: sprite_all_fishes,
    subimg: <frame index>,
    rarity: <weight>,      // higher = more common
    base_sell_price: <gold>
}
```

**Rarity weights:**

| Tier       | Weight |
|------------|--------|
| common     | 50     |
| uncommon   | 20     |
| rare       | 7      |
| very_rare  | 2      |
| legendary  | 1      |

**Full fish table (frames 0–44 — Fish):**

| Key      | Frame | Name              | Rarity    | Weight | Sell Price |
|----------|-------|-------------------|-----------|--------|------------|
| fish_00  | 0     | Salmón            | uncommon  | 20     | 75         |
| fish_01  | 1     | Trucha Arcoíris   | uncommon  | 20     | 65         |
| fish_02  | 2     | Pez Sol           | common    | 50     | 25         |
| fish_03  | 3     | Pez Gato          | common    | 50     | 20         |
| fish_04  | 4     | Carpa Dorada      | common    | 50     | 30         |
| fish_05  | 5     | Lubina            | uncommon  | 20     | 60         |
| fish_06  | 6     | Perca             | common    | 50     | 20         |
| fish_07  | 7     | Esturión          | rare      | 7      | 200        |
| fish_08  | 8     | Anguila           | rare      | 7      | 150        |
| fish_09  | 9     | Pez Espada        | rare      | 7      | 250        |
| fish_10  | 10    | Atún              | uncommon  | 20     | 90         |
| fish_11  | 11    | Bacalao           | common    | 50     | 35         |
| fish_12  | 12    | Sardina           | common    | 50     | 15         |
| fish_13  | 13    | Boquerón          | common    | 50     | 12         |
| fish_14  | 14    | Merluza           | common    | 50     | 28         |
| fish_15  | 15    | Rodaballo         | uncommon  | 20     | 80         |
| fish_16  | 16    | Lenguado          | uncommon  | 20     | 70         |
| fish_17  | 17    | Besugo            | uncommon  | 20     | 55         |
| fish_18  | 18    | Mero              | uncommon  | 20     | 85         |
| fish_19  | 19    | Dorada            | uncommon  | 20     | 75         |
| fish_20  | 20    | Lubina de Roca    | uncommon  | 20     | 60         |
| fish_21  | 21    | Salmonete         | common    | 50     | 40         |
| fish_22  | 22    | Caballa           | common    | 50     | 22         |
| fish_23  | 23    | Jurel             | common    | 50     | 18         |
| fish_24  | 24    | Bonito            | uncommon  | 20     | 55         |
| fish_25  | 25    | Pez Vela          | rare      | 7      | 300        |
| fish_26  | 26    | Pez Martillo      | rare      | 7      | 350        |
| fish_27  | 27    | Tiburón Blanco    | very_rare | 2      | 600        |
| fish_28  | 28    | Tiburón Ballena   | very_rare | 2      | 800        |
| fish_29  | 29    | Raya Látigo       | rare      | 7      | 220        |
| fish_30  | 30    | Pez Globo         | rare      | 7      | 180        |
| fish_31  | 31    | Pez León          | rare      | 7      | 190        |
| fish_32  | 32    | Pez Cirujano      | uncommon  | 20     | 95         |
| fish_33  | 33    | Pez Ángel         | uncommon  | 20     | 110        |
| fish_34  | 34    | Pez Mariposa      | uncommon  | 20     | 100        |
| fish_35  | 35    | Pez Loro          | uncommon  | 20     | 85         |
| fish_36  | 36    | Pez Ballesta      | uncommon  | 20     | 90         |
| fish_37  | 37    | Pez Cofre         | uncommon  | 20     | 80         |
| fish_38  | 38    | Pez Trompeta      | rare      | 7      | 160        |
| fish_39  | 39    | Pez Flauta        | rare      | 7      | 150        |
| fish_40  | 40    | Pez Pipa          | rare      | 7      | 140        |
| fish_41  | 41    | Pez Piedra        | uncommon  | 20     | 70         |
| fish_42  | 42    | Pez Escorpión     | rare      | 7      | 175        |
| fish_43  | 43    | Pez Sapo          | uncommon  | 20     | 65         |
| fish_44  | 44    | Pez Diablo        | very_rare | 2      | 500        |

**Dolphins (frames 45–48):**

| Key      | Frame | Name               | Rarity    | Weight | Sell Price |
|----------|-------|--------------------|-----------|--------|------------|
| fish_45  | 45    | Delfín Mular       | very_rare | 2      | 1000       |
| fish_46  | 46    | Delfín Oceánico    | very_rare | 2      | 1200       |
| fish_47  | 47    | Delfín Rosado      | legendary | 1      | 2000       |
| fish_48  | 48    | Delfín de Rápida   | very_rare | 2      | 1000       |

**Sea Creatures (frames 49–98):**

| Key      | Frame | Name                   | Rarity    | Weight | Sell Price |
|----------|-------|------------------------|-----------|--------|------------|
| fish_49  | 49    | Pulpo Gigante          | rare      | 7      | 250        |
| fish_50  | 50    | Calamar Común          | common    | 50     | 30         |
| fish_51  | 51    | Sepia                  | common    | 50     | 35         |
| fish_52  | 52    | Nautilo                | very_rare | 2      | 600        |
| fish_53  | 53    | Cangrejo Real          | uncommon  | 20     | 120        |
| fish_54  | 54    | Langosta Espinosa      | rare      | 7      | 300        |
| fish_55  | 55    | Bogavante              | rare      | 7      | 350        |
| fish_56  | 56    | Cigala                 | uncommon  | 20     | 90         |
| fish_57  | 57    | Gamba Roja             | uncommon  | 20     | 80         |
| fish_58  | 58    | Langostino             | common    | 50     | 40         |
| fish_59  | 59    | Camarón                | common    | 50     | 20         |
| fish_60  | 60    | Centollo               | uncommon  | 20     | 100        |
| fish_61  | 61    | Nécora                 | uncommon  | 20     | 85         |
| fish_62  | 62    | Buey de Mar            | uncommon  | 20     | 110        |
| fish_63  | 63    | Percebe                | rare      | 7      | 180        |
| fish_64  | 64    | Mejillón               | common    | 50     | 15         |
| fish_65  | 65    | Almeja                 | common    | 50     | 20         |
| fish_66  | 66    | Berberecho             | common    | 50     | 12         |
| fish_67  | 67    | Ostra                  | uncommon  | 20     | 60         |
| fish_68  | 68    | Vieira                 | uncommon  | 20     | 75         |
| fish_69  | 69    | Caracol Marino         | common    | 50     | 25         |
| fish_70  | 70    | Estrella de Mar        | common    | 50     | 30         |
| fish_71  | 71    | Erizo de Mar           | uncommon  | 20     | 55         |
| fish_72  | 72    | Holoturia              | common    | 50     | 20         |
| fish_73  | 73    | Medusa Melena de León  | rare      | 7      | 200        |
| fish_74  | 74    | Carabela Portuguesa    | rare      | 7      | 250        |
| fish_75  | 75    | Coral Rojo             | very_rare | 2      | 500        |
| fish_76  | 76    | Anémona de Mar         | uncommon  | 20     | 70         |
| fish_77  | 77    | Esponja                | common    | 50     | 15         |
| fish_78  | 78    | Caballito de Mar       | rare      | 7      | 150        |
| fish_79  | 79    | Dragón de Mar          | very_rare | 2      | 700        |
| fish_80  | 80    | Tortuga Verde          | very_rare | 2      | 600        |
| fish_81  | 81    | Tortuga Carey          | very_rare | 2      | 700        |
| fish_82  | 82    | Serpiente Marina       | rare      | 7      | 220        |
| fish_83  | 83    | Manatí                 | legendary | 1      | 2000       |
| fish_84  | 84    | Dugongo                | legendary | 1      | 2000       |
| fish_85  | 85    | Foca Monje             | legendary | 1      | 1500       |
| fish_86  | 86    | León Marino            | very_rare | 2      | 800        |
| fish_87  | 87    | Morsa                  | very_rare | 2      | 900        |
| fish_88  | 88    | Narval                 | legendary | 1      | 2500       |
| fish_89  | 89    | Beluga                 | legendary | 1      | 2000       |
| fish_90  | 90    | Orca                   | legendary | 1      | 3000       |
| fish_91  | 91    | Cachalote              | legendary | 1      | 3500       |
| fish_92  | 92    | Ballena Azul           | legendary | 1      | 5000       |
| fish_93  | 93    | Ballena Jorobada       | legendary | 1      | 4000       |
| fish_94  | 94    | Ballena Franca         | legendary | 1      | 3500       |
| fish_95  | 95    | Rorcual                | legendary | 1      | 3000       |
| fish_96  | 96    | Cachalote Pigmeo       | very_rare | 2      | 1000       |
| fish_97  | 97    | Vaquita Marina         | legendary | 1      | 5000       |
| fish_98  | 98    | *(placeholder)*        | common    | 50     | 10         |

> **Note:** The original name list had 49 sea creatures for 50 slots (frames 49–98). Frame 98 is left as a placeholder until the missing name is defined.

### 2c. `global.fish_pool` (weighted selection array)

Build this immediately after `global.fish_data` in `script_init.gml`:
```gml
global.fish_pool = [];
var _keys = variable_struct_get_names(global.fish_data);
for (var _i = 0; _i < array_length(_keys); _i++) {
    var _d = global.fish_data[$ _keys[_i]];
    repeat (_d.rarity) { array_push(global.fish_pool, _keys[_i]); }
}
```
Catching a fish: `var _key = global.fish_pool[irandom(array_length(global.fish_pool) - 1)];`

### 2d. Update `scr_get_item_data`

In `scripts/script_inventory_functions/script_inventory_functions.gml` (line 638), add before `return undefined`:
```gml
if (variable_struct_exists(global.fish_data, _key)) return global.fish_data[$ _key];
```

---

## 3. Player State Extension

In `script_init.gml`, add `FISHING` to the `STATE` enum:
```gml
enum STATE {
    IDLE,
    WALK,
    RUN,
    ACTING,
    FISHING   // new
}
```

Add new enum for fishing sub-states:
```gml
enum FISHING_STATE {
    CASTING,
    WAITING,
    BITE,
    REELING,
    CATCHING
}
```

In `obj_player` Create event, initialize the fishing sub-state variable:
```gml
fishing_substate = FISHING_STATE.CASTING;
fishing_bite_timer = 0;
fishing_wait_timer = 0;
```

---

## 4. Implementation Steps

### Phase A: Initiation (`scr_use_item`)

Add a new case to the tool switch in `scripts/script_player_actions/script_player_actions.gml`:
```gml
case TOOL_TYPE.FISHING_ROD:
    other.state = STATE.FISHING;
    other.fishing_substate = FISHING_STATE.CASTING;
    other.frame_anim = 0;
    other.fishing_wait_timer = 0;
    other.fishing_bite_timer = 0;
    other.action_sprite_tool = sprite_player_fishing_cast_weapon;
    scr_set_player_action_sprites(
        sprite_player_fishing_cast_skins_2,
        sprite_player_fishing_cast_hairs_fawn_black,
        sprite_player_fishing_cast_clothes_purple,
        sprite_player_fishing_cast_eyes_female_brown
    );
break;
```

No water tile check at this stage — deferred until map is complete.

### Phase B: Fishing Logic (`obj_player` Step Event)

Add a new block after the `STATE.ACTING` block:

```gml
if (state == STATE.FISHING) {
    frame_anim += 0.2;

    switch (fishing_substate) {

        case FISHING_STATE.CASTING:
            if (frame_anim >= 15) {
                fishing_substate = FISHING_STATE.WAITING;
                frame_anim = 0;
                fishing_wait_timer = irandom_range(180, 480); // 3–8 seconds at 60fps
                action_sprite_tool = sprite_player_fishing_wait_weapon;
                scr_set_player_action_sprites(
                    sprite_player_fishing_wait_skins_2,
                    sprite_player_fishing_wait_hairs_fawn_black,
                    sprite_player_fishing_wait_clothes_purple,
                    sprite_player_fishing_wait_eyes_female_brown
                );
            }
        break;

        case FISHING_STATE.WAITING:
            if (frame_anim >= 15) frame_anim = 0; // loop
            fishing_wait_timer--;
            if (fishing_wait_timer <= 0) {
                fishing_substate = FISHING_STATE.BITE;
                frame_anim = 0;
                fishing_bite_timer = 120; // 2 seconds to react
                action_sprite_tool = sprite_player_fishing_bite_weapon;
                scr_set_player_action_sprites(
                    sprite_player_fishing_bite_skins_2,
                    sprite_player_fishing_bite_hairs_fawn_black,
                    sprite_player_fishing_bite_clothes_purple,
                    sprite_player_fishing_bite_eyes_female_brown
                );
            }
        break;

        case FISHING_STATE.BITE:
            if (frame_anim >= 15) frame_anim = 0; // loop
            fishing_bite_timer--;
            if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) {
                fishing_substate = FISHING_STATE.REELING;
                frame_anim = 0;
                action_sprite_tool = sprite_player_fishing_reel_weapon;
                scr_set_player_action_sprites(
                    sprite_player_fishing_reel_skins_2,
                    sprite_player_fishing_reel_hairs_fawn_black,
                    sprite_player_fishing_reel_clothes_purple,
                    -1 // no eyes sprite for reel
                );
            } else if (fishing_bite_timer <= 0) {
                // missed — go back to idle
                state = STATE.IDLE;
                frame_anim = 0;
                scr_notify("¡Se escapó!");
            }
        break;

        case FISHING_STATE.REELING:
            if (frame_anim >= 15) {
                fishing_substate = FISHING_STATE.CATCHING;
                frame_anim = 0;
                action_sprite_tool = sprite_player_fishing_catch_weapon;
                scr_set_player_action_sprites(
                    sprite_player_fishing_catch_skins_2,
                    sprite_player_fishing_catch_hairs_fawn_black,
                    sprite_player_fishing_catch_clothes_purple,
                    sprite_player_fishing_catch_eyes_female_brown
                );
            }
        break;

        case FISHING_STATE.CATCHING:
            if (frame_anim >= 15) {
                // select fish, add to inventory, deduct energy
                var _fish_key = global.fish_pool[irandom(array_length(global.fish_pool) - 1)];
                var _fish = global.fish_data[$ _fish_key];
                obj_inventory.add_item(_fish_key, 1);
                energy -= 10;
                scr_notify("¡Atrapaste un " + _fish.name + "!");
                state = STATE.IDLE;
                frame_anim = 0;
            }
        break;
    }
}
```

### Phase C: Drawing Integration (`obj_player` Draw Event)

The draw event uses `get_sprite_set(_idle, _walk, _run, _action)`. Add a `STATE.FISHING` branch that treats the state like `ACTING` — always using the action sprites — and draw the fishing rod weapon layer:

```gml
// In the draw event, where STATE.ACTING sets image_index:
if (state == STATE.ACTING || state == STATE.FISHING) {
    image_index = (dir * 15) + floor(frame_anim);
    // draw skin, hair, clothes, eyes layers using action sprites
    // ...existing ACTING draw code...
    draw_sprite(action_sprite_tool, image_index, x, y);
}
```

The key change is ensuring:
1. `action_sprite_eyes` of `-1` is handled safely by `get_sprite_set` (falls back to idle sprite).
2. `action_sprite_tool` is drawn during `STATE.FISHING` (the existing check `if (state == STATE.ACTING)` must include `|| state == STATE.FISHING`).

### Phase D: Energy Cost

- Deduct **10 energy** on a successful catch (inside `FISHING_STATE.CATCHING`, as shown above).
- No energy cost on a missed bite — the fish escaped, that's punishment enough.
- If energy is 0 or below before casting, optionally block fishing with a notification (can be added later alongside other tool energy gates).

---

## 5. Deferred: Water Tile Detection

When the map is complete, update Phase A's `case TOOL_TYPE.FISHING_ROD:` block to first check:
```gml
var _wx = x + lengthdir_x(16, dir * 90);
var _wy = y + lengthdir_y(16, dir * 90);
var _water_layer = layer_get_id("Tiles_water"); // confirm layer name from map
var _tilemap = layer_tilemap_get_id(_water_layer);
var _tile = tilemap_get_at_pixel(_tilemap, _wx, _wy);
if (_tile == 0) {
    scr_notify("No hay agua aquí.");
    exit;
}
```
Water tile ID and layer name must be confirmed from the actual map data.

---

## 6. Verification Tasks

- [ ] Fishing rod triggers from any tile (no water check yet).
- [ ] CASTING animation plays once (15 frames) then transitions to WAITING.
- [ ] WAITING animation loops until the bite timer fires.
- [ ] BITE shows a "!" cue; pressing Space/LMB within 2 seconds transitions to REELING.
- [ ] Missing a BITE returns to IDLE with "¡Se escapó!" notification.
- [ ] REELING plays once then transitions to CATCHING.
- [ ] CATCHING adds a valid fish key to inventory and notifies the player with the fish name.
- [ ] All 4 directions display the correct animation frames.
- [ ] Energy decreases by 10 on a successful catch.
- [ ] `scr_get_item_data("fish_00")` (and others) returns the correct struct.
- [ ] Fish items appear correctly in inventory with the `sprite_all_fishes` icon.
