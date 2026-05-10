/*
    Veredas Dream - Script de Inicialización
    Define enums y estructuras de datos globales.
*/

randomize();

enum NET_ROLE {
    NONE   = 0,
    HOST   = 1,
    CLIENT = 2
}

enum NET_CMD {
    HANDSHAKE        = 1,
    HANDSHAKE_ACK    = 2,
    FULL_SNAPSHOT    = 3,
    PLAYER_STATE     = 16,
    ROOM_CHANGE      = 17,
    ROOM_SNAPSHOT    = 18,
    CMD_USE_ITEM     = 32,
    CMD_PICKUP       = 33,
    CMD_BUGNET       = 34,
    CMD_FISH_REEL    = 35,
    CMD_OPEN_CHEST   = 36,
    CMD_CHEST_SLOT   = 37,
    CMD_SHOP_BUY     = 38,
    CMD_BUY_BUILDING = 39,
    CMD_UPGRADE_TOOL = 40,
    CMD_DROP           = 41,
    CMD_MINE_ENTER     = 42,
    CMD_MINE_GO_DEEPER = 43,
    CMD_MINE_EXIT      = 44,
    CMD_DONATE         = 45,
    CMD_ENEMY_DAMAGE   = 46,
    CMD_ENEMY_DEATH    = 47,
    INVENTORY_UPDATE   = 48,
    MONEY_UPDATE       = 49,
    ENERGY_UPDATE      = 50,
    MINE_STATE_UPDATE  = 51,
    TOWN_STAGE_UPDATE  = 52,
    WORLD_EVENT        = 64,
    TIME_UPDATE      = 65,
    NEW_DAY          = 66,
    SLEEP_REQUEST    = 80,
    SLEEP_PROMPT     = 81,
    SLEEP_RESPONSE   = 82,
    SHIPPING_SUMMARY = 83,
    CMD_NAP          = 84,
    NOTIFY           = 96,
    DISCONNECT       = 112,
    CMD_NPC_INTERACT = 113,
    CMD_ANIMAL_EVENT = 114,
    CMD_WEATHER_SYNC = 115,
    CMD_CRAFT_START  = 116,
    CMD_CRAFT_COMPLETE = 117,
    CMD_FISH_EVENT   = 118,
    CMD_ROOM_ENEMIES = 119,
    PLAYER_DAMAGE    = 120,
    CMD_GIVE_ITEM    = 121
}

enum DIR {
    DOWN = 0,
    UP = 1,
    RIGHT = 2,
    LEFT = 3
}

enum STATE {
    IDLE,
    WALK,
    RUN,
    ACTING, // estado para usar herramientas
    FISHING
}

enum FISHING_STATE {
    CASTING,
    WAITING,
    BITE,
    REELING,
    CATCHING
}

// Estados del caballo
enum HORSE_STATE {
    IDLE,
    PACING,
    PREPARING_TO_EAT,
    EATING
}

// Direcciones del caballo
enum HORSE_DIR {
    DOWN = 0,
    UP = 1,
    RIGHT = 2,
    LEFT = 3
}

enum ANIMAL_STATE {
    IDLE,
    WANDERING,
    FLEEING,
    CHASING
}

enum TownStage {
    INITIAL                  = 0,
    STREETS_CLEARED          = 1,
    GREENS_RESTORED          = 2,
    STREETS_RESTORED         = 3,
    SHOP_CONSTRUCTION        = 4,
    SHOP_RESTORED            = 5,
    BLACKSMITH_CONSTRUCTION  = 6,
    BLACKSMITH_RESTORED      = 7,
    TREES_RESTORED           = 8,
    BUILDINGS_CONSTRUCTION   = 9,
    BUILDINGS_RESTORED       = 10,
    URBANIZATION_CONSTRUCTION = 11,
    URBANIZATION_COMPLETE    = 12
}

global.animal_data = {
    chicken: { move_speed: 1.0,  hp: 2, max_hp: 2, variants: ["black","black_white","blonde","blonde_green","brown_black","brown_white","evil","green","pink","red","universe","white"], product_drops: ["egg_chicken_brown_reg", "egg_chicken_white_reg", "chicken_leg"],  crafting_drops: ["feathers_red","feathers_orange","feathers_yellow","feathers_green","feathers_blue","feathers_lilac","feathers_purple","feathers_turquoise","feathers_pink","feathers_lime","feathers_amber","feathers_brown","feathers_black","feathers_white"] },
    cow:     { move_speed: 0.5,  hp: 5, max_hp: 5, variants: ["female_black","female_blonde","female_brown","female_pink","male_black","male_blonde","male_brown","male_pink"],         product_drops: ["milk_reg", "milk_large", "steak"],                              crafting_drops: ["cow_hide_red","cow_hide_orange","cow_hide_yellow","cow_hide_green","cow_hide_blue","cow_hide_lilac","cow_hide_purple","cow_hide_turquoise","cow_hide_pink","cow_hide_lime","cow_hide_amber","cow_hide_brown","cow_hide_black","cow_hide_white"] },
    duck:    { move_speed: 0.9,  hp: 2, max_hp: 2, variants: ["full_black","full_yellow","mallad","mallad_2","mallad_female","white","white_2"],                                       product_drops: ["egg_duck_reg", "egg_duck_large"],                               crafting_drops: ["feathers_red","feathers_orange","feathers_yellow","feathers_green","feathers_blue","feathers_lilac","feathers_purple","feathers_turquoise","feathers_pink","feathers_lime","feathers_amber","feathers_brown","feathers_black","feathers_white"] },
    goat:    { move_speed: 0.7,  hp: 3, max_hp: 3, variants: ["female_black","female_blonde","female_brown","female_pink","male_black","male_blonde","male_brown","male_pink"],         product_drops: ["goat_milk_reg", "goat_milk_large"],                          crafting_drops: ["pelt_red","pelt_orange","pelt_yellow","pelt_green","pelt_blue","pelt_lilac","pelt_purple","pelt_turquoise","pelt_pink","pelt_lime","pelt_amber","pelt_brown","pelt_black","pelt_white"] },
    ostrich: { move_speed: 0.8,  hp: 4, max_hp: 4, variants: ["black","blue","brown"],                                                                                                product_drops: ["chicken_leg", "egg_chicken_white_large", "egg_chicken_brown_large"],                    crafting_drops: ["feathers_red","feathers_orange","feathers_yellow","feathers_green","feathers_blue","feathers_lilac","feathers_purple","feathers_turquoise","feathers_pink","feathers_lime","feathers_amber","feathers_brown","feathers_black","feathers_white"] },
    pig:     { move_speed: 0.6,  hp: 3, max_hp: 3, variants: ["mud_pink","pink"],                                                                                                     product_drops: ["bacon", "steak"],                                              crafting_drops: ["pelt_red","pelt_orange","pelt_yellow","pelt_green","pelt_blue","pelt_lilac","pelt_purple","pelt_turquoise","pelt_pink","pelt_lime","pelt_amber","pelt_brown","pelt_black","pelt_white"] },
    sheep:   { move_speed: 0.55, hp: 3, max_hp: 3, variants: ["male","male_2"],                                                                                                       product_drops: ["wool"],                                                        crafting_drops: ["yarn_red","yarn_orange","yarn_yellow","yarn_green","yarn_blue","yarn_lilac","yarn_purple","yarn_turquoise","yarn_pink","yarn_lime","yarn_amber","yarn_brown","yarn_black","yarn_white"] },
};

global.wild_animal_data = {
    capibara: { name: "Capibara", sprite: sprite_forest_animals_capibara, move_speed: 0.7,  hp: 20, max_hp: 20, product_drops: ["pelt_red","pelt_orange","pelt_yellow","pelt_green","pelt_blue","pelt_lilac","pelt_purple","pelt_turquoise","pelt_pink","pelt_lime","pelt_amber","pelt_brown","pelt_black","pelt_white"] },
    deer:     { name: "Venado",   sprite: sprite_forest_animals_deer,     move_speed: 1.2,  hp: 30, max_hp: 30, product_drops: ["string_red","string_orange","string_yellow","string_green","string_blue","string_lilac","string_purple","string_turquoise","string_pink","string_lime","string_amber","string_brown","string_black","string_white"] },
    fox:      { name: "Zorro",    sprite: sprite_forest_animals_fox,      move_speed: 1.1,  hp: 15, max_hp: 15, product_drops: ["pelt_red","pelt_orange","pelt_yellow","pelt_green","pelt_blue","pelt_lilac","pelt_purple","pelt_turquoise","pelt_pink","pelt_lime","pelt_amber","pelt_brown","pelt_black","pelt_white"] },
    frog:     { name: "Rana",     sprite: sprite_forest_animals_frog,     move_speed: 0.8,  hp: 4, max_hp: 4, product_drops: ["pelt_red","pelt_orange","pelt_yellow","pelt_green","pelt_blue","pelt_lilac","pelt_purple","pelt_turquoise","pelt_pink","pelt_lime","pelt_amber","pelt_brown","pelt_black","pelt_white"] },
    penguin:  { name: "Pinguino", sprite: sprite_forest_animals_penguin,  move_speed: 0.6,  hp: 4, max_hp: 4, product_drops: ["feathers_red","feathers_orange","feathers_yellow","feathers_green","feathers_blue","feathers_lilac","feathers_purple","feathers_turquoise","feathers_pink","feathers_lime","feathers_amber","feathers_brown","feathers_black","feathers_white"] },
    rabbit:   { name: "Conejo",   sprite: sprite_forest_animals_rabbit,   move_speed: 1.0,  hp: 8, max_hp: 8, product_drops: ["rabbit_pelt_red","rabbit_pelt_orange","rabbit_pelt_yellow","rabbit_pelt_green","rabbit_pelt_blue","rabbit_pelt_lilac","rabbit_pelt_purple","rabbit_pelt_turquoise","rabbit_pelt_pink","rabbit_pelt_lime","rabbit_pelt_amber","rabbit_pelt_brown","rabbit_pelt_black","rabbit_pelt_white"] },
    turtle:   { name: "Tortuga",  sprite: sprite_forest_animals_turtle,   move_speed: 0.3,  hp: 45, max_hp: 45, product_drops: ["pelt_red","pelt_orange","pelt_yellow","pelt_green","pelt_blue","pelt_lilac","pelt_purple","pelt_turquoise","pelt_pink","pelt_lime","pelt_amber","pelt_brown","pelt_black","pelt_white"] },
    bear:     { name: "Oso",      sprite: sprite_player_bear_walk_bear_brown, move_speed: 0.8,  hp: 80, max_hp: 80, product_drops: ["honey","honey","honey","honey","honey","honey","honey","honey","honey","pelt_brown","pelt_black","pelt_white"], frame_order: [0, 1, 2, 3], weapon_drop_chance: 0.15 },
};

global.enemy_data = {
    slime_black: {
        name: "Slime Negro",
        object: obj_enemy_slime,
        sprite: sprite_enemy_slime_black,
        move_speed: 0.8,
        chase_speed_mult: 1.5,
        hp: 25,
        max_hp: 25,
        chase_timer: 600,
        attack_damage: 3,
        attack_cooldown: 60,
        attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["string_black"],
        dye_drops: ["dye_black","dye_white"],
        weapon_drop_chance: 0.03,
        snd_hurt: sound_slime_damage, snd_death: sound_slime_death, snd_move: sound_slime_moving_attacking
    },
    slime_blue: {
        name: "Slime Azul",
        object: obj_enemy_slime_blue,
        sprite: sprite_enemy_slime_blue,
        move_speed: 1.0,
        chase_speed_mult: 1.8,
        hp: 10,
        max_hp: 10,
        chase_timer: 480,
        attack_damage: 2,
        attack_cooldown: 45,
        attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["string_blue","feathers_blue"],
        dye_drops: ["dye_blue","dye_turquoise"],
        weapon_drop_chance: 0.03,
        snd_hurt: sound_slime_damage, snd_death: sound_slime_death, snd_move: sound_slime_moving_attacking
    },
    slime_golden: {
        name: "Slime Dorado",
        object: obj_enemy_slime_golden,
        sprite: sprite_enemy_slime_golden,
        move_speed: 0.6,
        chase_speed_mult: 1.2,
        hp: 80,
        max_hp: 80,
        chase_timer: 900,
        attack_damage: 6,
        attack_cooldown: 90,
        attack_range: 28,
        death_anim_frames: 48,
        product_drops: ["yarn_amber","string_amber"],
        dye_drops: ["dye_amber","dye_yellow"],
        weapon_drop_chance: 0.05,
        snd_hurt: sound_slime_damage, snd_death: sound_slime_death, snd_move: sound_slime_moving_attacking
    },
    slime_green: {
        name: "Slime Verde",
        object: obj_enemy_slime_green,
        sprite: sprite_enemy_slime_green,
        move_speed: 0.8,
        chase_speed_mult: 1.5,
        hp: 25,
        max_hp: 25,
        chase_timer: 600,
        attack_damage: 3,
        attack_cooldown: 60,
        attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["string_green","feathers_green"],
        dye_drops: ["dye_green","dye_lime"],
        weapon_drop_chance: 0.03,
        snd_hurt: sound_slime_damage, snd_death: sound_slime_death, snd_move: sound_slime_moving_attacking
    },
    slime_pink: {
        name: "Slime Rosa",
        object: obj_enemy_slime_pink,
        sprite: sprite_enemy_slime_pink,
        move_speed: 0.7,
        chase_speed_mult: 1.3,
        hp: 45,
        max_hp: 45,
        chase_timer: 750,
        attack_damage: 4,
        attack_cooldown: 40,
        attack_range: 30,
        death_anim_frames: 48,
        product_drops: ["yarn_pink","string_pink"],
        dye_drops: ["dye_pink","dye_red"],
        weapon_drop_chance: 0.05,
        snd_hurt: sound_slime_damage, snd_death: sound_slime_death, snd_move: sound_slime_moving_attacking
    },
    slime_purple: {
        name: "Slime Morado",
        object: obj_enemy_slime_purple,
        sprite: sprite_enemy_slime_purple,
        move_speed: 0.5,
        chase_speed_mult: 1.2,
        hp: 100,
        max_hp: 100,
        chase_timer: 900,
        attack_damage: 7,
        attack_cooldown: 100,
        attack_range: 28,
        death_anim_frames: 48,
        product_drops: ["yarn_purple","string_purple"],
        dye_drops: ["dye_purple","dye_lilac"],
        weapon_drop_chance: 0.07,
        snd_hurt: sound_slime_damage, snd_death: sound_slime_death, snd_move: sound_slime_moving_attacking
    },
    myconid_blue: {
        name: "Micónido Azul",
        object: obj_enemy_myconid_blue,
        sprite_idle: sprite_enemy_myconid_blue_idle,
        sprite_walk: sprite_enemy_myconid_blue_walk,
        sprite_attack: sprite_enemy_myconid_blue_attack,
        sprite_damage: sprite_enemy_myconid_blue_damage,
        sprite_dead: sprite_enemy_myconid_blue_dead,
        move_speed: 0.7,
        chase_speed_mult: 1.4,
        hp: 25,
        max_hp: 25,
        chase_timer: 600,
        attack_damage: 3,
        attack_cooldown: 60,
        attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["pelt_blue","string_blue","thread_blue"],
        dye_drops: ["dye_blue"],
        weapon_drop_chance: 0.05,
        snd_hurt: sound_myconid_damage, snd_death: sound_myconid_death, snd_attack: sound_myconid_attack
    },
    myconid_green: {
        name: "Micónido Verde",
        object: obj_enemy_myconid_green,
        sprite_idle: sprite_enemy_myconid_green_idle,
        sprite_walk: sprite_enemy_myconid_green_walk,
        sprite_attack: sprite_enemy_myconid_green_attack,
        sprite_damage: sprite_enemy_myconid_green_damage,
        sprite_dead: sprite_enemy_myconid_green_dead,
        move_speed: 0.9,
        chase_speed_mult: 1.6,
        hp: 10,
        max_hp: 10,
        chase_timer: 480,
        attack_damage: 2,
        attack_cooldown: 45,
        attack_range: 34,
        death_anim_frames: 48,
        product_drops: ["pelt_green","string_green","thread_green"],
        dye_drops: ["dye_green"],
        weapon_drop_chance: 0.05,
        snd_hurt: sound_myconid_damage, snd_death: sound_myconid_death, snd_attack: sound_myconid_attack
    },
    myconid_pink: {
        name: "Micónido Rosa",
        object: obj_enemy_myconid_pink,
        sprite_idle: sprite_enemy_myconid_pink_idle,
        sprite_walk: sprite_enemy_myconid_pink_walk,
        sprite_attack: sprite_enemy_myconid_pink_attack,
        sprite_damage: sprite_enemy_myconid_pink_damage,
        sprite_dead: sprite_enemy_myconid_pink_dead,
        move_speed: 0.6,
        chase_speed_mult: 1.3,
        hp: 60,
        max_hp: 60,
        chase_timer: 750,
        attack_damage: 5,
        attack_cooldown: 80,
        attack_range: 28,
        death_anim_frames: 48,
        product_drops: ["pelt_pink","string_pink","thread_pink"],
        dye_drops: ["dye_pink"],
        weapon_drop_chance: 0.07,
        snd_hurt: sound_myconid_damage, snd_death: sound_myconid_death, snd_attack: sound_myconid_attack
    },
    goblin: {
        name: "Goblin",
        object: obj_enemy_goblin,
        sprite_idle: sprite_enemy_goblin_idle,
        sprite_walk: sprite_enemy_goblin_walk,
        sprite_run: sprite_enemy_goblin_run,
        sprite_attack: sprite_enemy_goblin_attack,
        sprite_damage: sprite_enemy_goblin_damage,
        sprite_dead: sprite_enemy_goblin_dead,
        move_speed: 1.0,
        chase_speed_mult: 2.0,
        hp: 45,
        max_hp: 45,
        chase_timer: 600,
        attack_damage: 4,
        attack_cooldown: 45,
        attack_range: 30,
        death_anim_frames: 48,
        product_drops: ["leather_brown","string_brown","pelt_brown"],
        dye_drops: ["dye_brown","dye_orange"],
        weapon_drop_chance: 0.15,
        snd_hurt: sound_goblin_damage, snd_death: sound_goblin_death, snd_attack: sound_goblin_attack, snd_idle: sound_goblin_idling
    },
    skeleton: {
        name: "Esqueleto",
        object: obj_enemy_skeleton,
        sprite_idle:   sprite_skeleton_idle,
        sprite_walk:   sprite_skeleton_walk,
        sprite_attack: sprite_skeleton_attack,
        sprite_damage: sprite_skeleton_damage,
        sprite_dead:   sprite_skeleton_dead,
        move_speed: 0.84,
        chase_speed_mult: 1.4,
        hp: 140,
        max_hp: 140,
        chase_timer: 720,
        attack_damage: 9,
        attack_cooldown: 40,
        attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["gemstone_ruby","gemstone_sapphire","gemstone_emerald"],
        snd_death: sound_skeleton_dead,
        snd_move:  sound_skeleton_walk,
        snd_idle:  sound_skeleton_general,
        snd_hurt:  sound_skeleton_general,
    },
    sprout_slime_blue: {
        name: "Sprout Slime Azul",
        object: obj_enemy_sprout_slime_blue,
        sprite_idle:   sprite_sprout_slime_blue_idle,
        sprite_walk:   sprite_sprout_slime_blue_walk,
        sprite_damage: sprite_sprout_slime_blue_damage,
        sprite_dead:   sprite_sprout_slime_blue_dead,
        move_speed: 0.9,
        chase_speed_mult: 1.8,
        hp: 18, max_hp: 18,
        chase_timer: 480,
        attack_damage: 3, attack_cooldown: 45, attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["coal", "forage_h04"],
        dye_drops: ["dye_lilac"],
        weapon_drop_chance: 0.03,
    },
    sprout_slime_pink: {
        name: "Sprout Slime Rosa",
        object: obj_enemy_sprout_slime_pink,
        sprite_idle:   sprite_sprout_slime_pink_idle,
        sprite_walk:   sprite_sprout_slime_pink_walk,
        sprite_damage: sprite_sprout_slime_pink_damage,
        sprite_dead:   sprite_sprout_slime_pink_dead,
        move_speed: 0.75,
        chase_speed_mult: 1.6,
        hp: 35, max_hp: 35,
        chase_timer: 540,
        attack_damage: 4, attack_cooldown: 40, attack_range: 32,
        death_anim_frames: 48,
        product_drops: ["ore_bronce", "forage_h13"],
        dye_drops: ["dye_orange"],
        weapon_drop_chance: 0.04,
    },
    venom_bloom: {
        name: "Venom Bloom",
        object: obj_enemy_venom_bloom,
        sprite_idle: sprite_venom_bloom_idle,
        hp: 22, max_hp: 22,
        attack_damage: 6, attack_cooldown: 80, attack_range: 56,
        death_anim_frames: 48,
        product_drops: ["forage_f12", "ore_plata"],
        dye_drops: ["dye_lilac"],
    },
};

enum ITEM_TYPE {
    MATERIAL,   // Madera, piedra, basura
    TOOL,       // Hacha, pico, regadera
    SEED,       // Semillas para plantar
    FOOD,       // Cosas que se comen
    WEAPON,     // Espadas, arcos
    CROP,       // El fruto ya cosechado (el tomate, el trigo)
    FISH,       // Peces capturados
    PLACEABLE,  // Objetos que se pueden colocar: cofres, decoracion, etc.
    INSECT,      // Insectos capturados con la red
    ORE,        // Minerales de la mina
    BAR,        // Lingotes de metal
    JAM,        // Mermelada
    DYE,        // Tinte
    POTION,      // Pocimas consumibles
    ARMOR       // Piezas de armadura (casco, peto, etc.)
}

enum TOOL_TYPE {
    NONE,
    PICKAXE,
    AXE,
    SICKLE,
    HOE,
    WATERING_CAN,
    FISHING_ROD,
    SHOVEL,
    BUGNET,
    SWORD,
    BOW
}

enum SEASON {
    SPRING,
    SUMMER,
    FALL,
    WINTER,
    ALL
} 
    
// --- ENUMS DE APOYO ---
enum QUALITY {
    OXIDADO,
    BRONCE,
    PLATA,
    ORO,
    BRONCASTANIO,
    CHUBESTANIO ,
    PICASTANIO,
    HITLERSTANIO,
    VITOLANIO 
}

global.quality_names = ["Oxidado", "Bronce", "Plata", "Oro", "Broncastanio", "Chubestanio", "Picastanio", "Hitlerstanio", "Vitolanio"];

global.seed_data = {
    // --- PRIMAVERA ---
    cherry_seeds:       { name: "Semilla de Cereza",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 0,   growth_time: 6, crop_base_name: "cherry",       base_buy_price: 30, base_sell_price: 5, is_fruit_tree: true },
    apricot_seeds:      { name: "Semilla de Chabacano",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 8,   growth_time: 6, crop_base_name: "apricot",      base_buy_price: 25, base_sell_price: 4, is_fruit_tree: true },
    strawberry_seeds:   { name: "Semilla de Fresa",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 16,  growth_time: 6, crop_base_name: "strawberry",   base_buy_price: 35, base_sell_price: 7 },
    spring_onion_seeds: { name: "Semilla de Cebolleta",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 24,  growth_time: 6, crop_base_name: "spring_onion", base_buy_price: 10, base_sell_price: 2 },
    potato_seeds:       { name: "Semilla de Papa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 32,  growth_time: 6, crop_base_name: "potato",       base_buy_price: 18, base_sell_price: 3 },
    onion_seeds:        { name: "Semilla de Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 40,  growth_time: 6, crop_base_name: "onion",        base_buy_price: 14, base_sell_price: 2 },
    carrot_seeds:       { name: "Semilla de Zanahoria",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 48,  growth_time: 6, crop_base_name: "carrot",       base_buy_price: 14, base_sell_price: 2 },
    blueberry_seeds:    { name: "Semilla de Mora Azul",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 56,  growth_time: 7, crop_base_name: "blackberry",    base_buy_price: 40, base_sell_price: 8 },
    parsnip_seeds:      { name: "Semilla de Chirivia",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 64,  growth_time: 5, crop_base_name: "parsnip",      base_buy_price: 12, base_sell_price: 2 },
    cabbage_seeds:      { name: "Semilla de Repollo",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 72,  growth_time: 7, crop_base_name: "cabbage",      base_buy_price: 18, base_sell_price: 3 },
    cauliflower_seeds:  { name: "Semilla de Coliflor",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 80,  growth_time: 7, crop_base_name: "cauliflower",  base_buy_price: 28, base_sell_price: 5 },
    rice_seeds:         { name: "Semilla de Arroz",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 88,  growth_time: 6, crop_base_name: "rice",         base_buy_price: 22, base_sell_price: 4 },
    broccoli_seeds:     { name: "Semilla de Brocoli",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 96,  growth_time: 5, crop_base_name: "broccoli",     base_buy_price: 22, base_sell_price: 4 },
    asparagus_seeds:    { name: "Semilla de Esparrago",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 104, growth_time: 5, crop_base_name: "asparagus",    base_buy_price: 28, base_sell_price: 6 },

    // --- VERANO ---
    tomato_seeds:        { name: "Semilla de Tomate",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 144, growth_time: 6, crop_base_name: "tomato",       base_buy_price: 20, base_sell_price: 3 },
    banana_seeds:       { name: "Semilla de Platano",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 112, growth_time: 7, crop_base_name: "banana",      base_buy_price: 30, base_sell_price: 5, is_fruit_tree: true },
    orange_seeds:       { name: "Semilla de Naranja",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 120, growth_time: 7, crop_base_name: "orange",      base_buy_price: 35, base_sell_price: 6, is_fruit_tree: true },
    mango_seeds:        { name: "Semilla de Mango",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 128, growth_time: 8, crop_base_name: "mango",       base_buy_price: 40, base_sell_price: 7, is_fruit_tree: true },
    peach_seeds:        { name: "Semilla de Durazno",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 136, growth_time: 7, crop_base_name: "peach",       base_buy_price: 35, base_sell_price: 6, is_fruit_tree: true },
    orange_tree_seeds:  { name: "Semilla de Naranjo",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 120, growth_time: 6, crop_base_name: "orange",      base_buy_price: 50, base_sell_price: 8, is_fruit_tree: true },
    mango_tree_seeds:   { name: "Semilla de Mango",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 128, growth_time: 6, crop_base_name: "mango",       base_buy_price: 60, base_sell_price: 10, is_fruit_tree: true },
    peach_tree_seeds:   { name: "Semilla de Durazno",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 136, growth_time: 6, crop_base_name: "peach",       base_buy_price: 50, base_sell_price: 8, is_fruit_tree: true },
    sunflower_seeds:     { name: "Semilla de Girasol",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 152, growth_time: 6, crop_base_name: "sunflower",    base_buy_price: 15, base_sell_price: 2 },
    hot_pepper_seeds:    { name: "Semilla de Chile",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 160, growth_time: 7, crop_base_name: "hot_pepper",   base_buy_price: 30, base_sell_price: 5 },
    corn_seeds:          { name: "Semilla de Maiz",        seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 168, growth_time: 8, crop_base_name: "corn",       base_buy_price: 25, base_sell_price: 4 },
    green_pepper_seeds:  { name: "Semilla de Pimiento V.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 176, growth_time: 8, crop_base_name: "bell_pepper", base_buy_price: 20, base_sell_price: 3 },
    melon_seeds:         { name: "Semilla de Melon",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 200, growth_time: 6, crop_base_name: "melon",        base_buy_price: 50, base_sell_price: 8 },
    watermelon_seeds:    { name: "Semilla de Sandia",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 208, growth_time: 8, crop_base_name: "watermelon",   base_buy_price: 50, base_sell_price: 8 },
    cucumber_seeds:      { name: "Semilla de Pepino",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 216, growth_time: 6, crop_base_name: "cucumber",     base_buy_price: 20, base_sell_price: 3 },
    eggplant_seeds:      { name: "Semilla de Berenjena",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 224, growth_time: 6, crop_base_name: "eggplant",     base_buy_price: 25, base_sell_price: 4 },
    pineapple_seeds:     { name: "Semilla de Pina",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 232, growth_time: 6, crop_base_name: "pineapple",    base_buy_price: 60, base_sell_price: 10 },
    green_beans_seeds:   { name: "Semilla de Ejote",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 240, growth_time: 7, crop_base_name: "green_beans",  base_buy_price: 25, base_sell_price: 4 },
    adzuki_bean_seeds:   { name: "Semilla de Frijol A.",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 248, growth_time: 7, crop_base_name: "adzuki_bean",  base_buy_price: 30, base_sell_price: 5 },
    wild_berry_seeds:    { name: "Semilla de Mora Silv.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 256, growth_time: 7, crop_base_name: "blackberry",   base_buy_price: 20, base_sell_price: 3 },
    wheat_seeds:         { name: "Semilla de Trigo",       seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 264, growth_time: 6, crop_base_name: "wheat",       base_buy_price: 10, base_sell_price: 2 },
    aloe_seeds:          { name: "Semilla de Aloe",        seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 272, growth_time: 6, crop_base_name: "aloe",        base_buy_price: 30, base_sell_price: 5 },

    // --- OTONO ---
    beetroot_seeds:      { name: "Semilla de Betabel",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 6, crop_base_name: "beetroot",     base_buy_price: 25, base_sell_price: 4 },
    pumpkin_seeds:       { name: "Semilla de Calabaza",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 288, growth_time: 6, crop_base_name: "pumpkin",      base_buy_price: 30, base_sell_price: 5 },
    grapes_seeds:        { name: "Semilla de Uva",         seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 296, growth_time: 6, crop_base_name: "grapes",       base_buy_price: 40, base_sell_price: 7 },
    apple_seeds:         { name: "Semilla de Manzana",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 8, crop_base_name: "apple",        base_buy_price: 30, base_sell_price: 5, is_fruit_tree: true },
    apple_tree_seeds:    { name: "Semilla de Manzano",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 6, crop_base_name: "apple",        base_buy_price: 50, base_sell_price: 8, is_fruit_tree: true }
};

global.crop_data = {
    // --- PRIMAVERA ---
    cherry:       { name: "Cereza",       seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 2,   base_buy_price: 120, base_sell_price: 42, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    apricot:      { name: "Chabacano",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 10,  base_buy_price: 100, base_sell_price: 35, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    strawberry:   { name: "Fresa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 18,  base_buy_price: 150, base_sell_price: 56 },
    spring_onion: { name: "Cebolleta",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 26,  base_buy_price: 40,  base_sell_price: 16 },
    potato:       { name: "Papa",         seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 34,  base_buy_price: 80,  base_sell_price: 32 },
    onion:        { name: "Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 42,  base_buy_price: 60,  base_sell_price: 24 },
    carrot:       { name: "Zanahoria",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 50,  base_buy_price: 60,  base_sell_price: 24 },
    blueberry:    { name: "Mora Azul",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 58,  base_buy_price: 180, base_sell_price: 72 },
    parsnip:      { name: "Chirivia",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 66,  base_buy_price: 60,  base_sell_price: 22 },
    cabbage:      { name: "Repollo",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 74,  base_buy_price: 90,  base_sell_price: 32 },
    cauliflower:  { name: "Coliflor",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 82,  base_buy_price: 120, base_sell_price: 46 },
    rice:         { name: "Arroz",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 90,  base_buy_price: 100, base_sell_price: 40 },
    broccoli:     { name: "Brocoli",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 98,  base_buy_price: 100, base_sell_price: 40 },
    asparagus:    { name: "Esparragos",   seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 106, base_buy_price: 140, base_sell_price: 50 },

    // --- VERANO ---
    tomato:        { name: "Tomate",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 146, base_buy_price: 80,  base_sell_price: 28 },
    banana:       { name: "Platano",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 114, base_buy_price: 120, base_sell_price: 42, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    orange:       { name: "Naranja",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 122, base_buy_price: 140, base_sell_price: 49, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    mango:        { name: "Mango",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 130, base_buy_price: 160, base_sell_price: 56, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    peach:        { name: "Durazno",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 139, base_buy_price: 140, base_sell_price: 49, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    sunflower:     { name: "Girasol",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 154, base_buy_price: 60,  base_sell_price: 21 },
    hot_pepper:    { name: "Chile Picante",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 162, base_buy_price: 120, base_sell_price: 42 },
    corn:          { name: "Maiz",           seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 170, base_buy_price: 100, base_sell_price: 35 },
    green_pepper:  { name: "Pimiento Verde", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 178, base_buy_price: 80,  base_sell_price: 28 },
    melon:         { name: "Melon",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 202, base_buy_price: 200, base_sell_price: 70 },
    watermelon:    { name: "Sandia",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 210, base_buy_price: 200, base_sell_price: 70 },
    cucumber:      { name: "Pepino",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 218, base_buy_price: 80,  base_sell_price: 28 },
    eggplant:      { name: "Berenjena",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 226, base_buy_price: 100, base_sell_price: 35 },
    pineapple:     { name: "Pina",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 234, base_buy_price: 240, base_sell_price: 84 },
    green_beans:   { name: "Ejote",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 242, base_buy_price: 100, base_sell_price: 35 },
    adzuki_bean:   { name: "Frijol Adzuki",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 250, base_buy_price: 120, base_sell_price: 42 },
    wild_berry:    { name: "Mora Silvestre", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 258, base_buy_price: 80,  base_sell_price: 28 },
    wheat:         { name: "Trigo",          seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 266, base_buy_price: 40,  base_sell_price: 14 },
    aloe:          { name: "Aloe",           seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 274, base_buy_price: 120, base_sell_price: 42 },

    // --- OTONO ---
     beetroot:      { name: "Betabel",  seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 282, base_buy_price: 100, base_sell_price: 35 },
     pumpkin:       { name: "Calabaza", seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 290, base_buy_price: 120, base_sell_price: 42 },
     grapes:        { name: "Uva",      seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 298, base_buy_price: 150, base_sell_price: 56 },
    apple:         { name: "Manzana",  seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 282, base_buy_price: 120, base_sell_price: 42, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 }
};

// --- MERMELADAS ---
global.jam_data = {};
var _jd = global.jam_data;
var _jam_crops = ["cherry","apricot","strawberry","spring_onion","potato","onion","carrot","blueberry","parsnip","cabbage","cauliflower","rice","broccoli","asparagus","tomato","banana","orange","mango","peach","sunflower","hot_pepper","corn","green_pepper","melon","watermelon","cucumber","eggplant","pineapple","green_beans","adzuki_bean","wild_berry","wheat","aloe","beetroot","pumpkin","grapes","apple"];
for (var _ji = 0; _ji < array_length(_jam_crops); _ji++) {
    var _jc = _jam_crops[_ji];
    var _crop_data = global.crop_data[$ _jc];
    if (_crop_data != undefined) {
        _jd[$ "jam_" + _jc] = {
            name: "Mermelada de " + _crop_data.name,
            type: ITEM_TYPE.JAM,
            sprite: sprite_jam,
            subimg: 0,
            base_sell_price: round(_crop_data.base_sell_price * 2.5)
        };
    }
}

// --- BASE DE DATOS DE HERRAMIENTAS Y ARMAS
global.tool_data = {
    
    watering_can: { 
        name: "Regadera",    
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.WATERING_CAN, 
        sprite: sprite_tools_v2, 
        subimg: 18,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },
    
    pickaxe: { 
        name: "Pico",        
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.PICKAXE,      
        sprite: sprite_tools_v2, 
        subimg: 27,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },
    
    axe: { 
        name: "Hacha",       
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.AXE,          
        sprite: sprite_tools_v2, 
        subimg: 36,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },
    
    hoe: { 
        name: "Azada", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.HOE, 
        sprite: sprite_tools_v2, 
        subimg: 0,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },

    shovel: { 
        name: "Pala", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SHOVEL, 
        sprite: sprite_tools_v2, 
        subimg: 9,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },
    
    sickle: { 
        name: "Hoz", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SICKLE, 
        sprite: sprite_tools_v2, 
        subimg: 63,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },

    fishing_rod: {
        name: "Cana de pescar",
        type: ITEM_TYPE.TOOL,
        tool_type: TOOL_TYPE.FISHING_ROD,
        sprite: sprite_tools_v2,
        subimg: 54,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    },

    bugnet: { 
        name: "Red de bichos", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.BUGNET,
        sprite: sprite_tools_v2,    
        subimg: 45,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
    }
};

// --- BASE DE DATOS DE ARMAS (encontradas en el mundo, 10 niveles) ---
global.weapon_data = {};
var _wd = global.weapon_data;
_wd[$ "sword_1"]  = { name: "Espada Nv.1",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 10, level:  1, damage:  2, sellable: false, droppable: false };
_wd[$ "sword_2"]  = { name: "Espada Nv.2",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 11, level:  2, damage:  5, sellable: false, droppable: false };
_wd[$ "sword_3"]  = { name: "Espada Nv.3",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 12, level:  3, damage:  9, sellable: false, droppable: false };
_wd[$ "sword_4"]  = { name: "Espada Nv.4",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 13, level:  4, damage: 14, sellable: false, droppable: false };
_wd[$ "sword_5"]  = { name: "Espada Nv.5",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 14, level:  5, damage: 20, sellable: false, droppable: false };
_wd[$ "sword_6"]  = { name: "Espada Nv.6",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 15, level:  6, damage: 27, sellable: false, droppable: false };
_wd[$ "sword_7"]  = { name: "Espada Nv.7",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 16, level:  7, damage: 35, sellable: false, droppable: false };
_wd[$ "sword_8"]  = { name: "Espada Nv.8",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 17, level:  8, damage: 40, sellable: false, droppable: false };
_wd[$ "sword_9"]  = { name: "Espada Nv.9",  type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 18, level:  9, damage: 45, sellable: false, droppable: false };
_wd[$ "sword_10"] = { name: "Espada Nv.10", type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.SWORD, sprite: sprite_weapons, subimg: 19, level: 10, damage: 50, sellable: false, droppable: false };
_wd[$ "bow_1"]    = { name: "Arco Nv.1",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 0, level:  1, damage:  1, sellable: false, droppable: false };
_wd[$ "bow_2"]    = { name: "Arco Nv.2",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 1, level:  2, damage:  3, sellable: false, droppable: false };
_wd[$ "bow_3"]    = { name: "Arco Nv.3",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 2, level:  3, damage:  6, sellable: false, droppable: false };
_wd[$ "bow_4"]    = { name: "Arco Nv.4",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 3, level:  4, damage: 10, sellable: false, droppable: false };
_wd[$ "bow_5"]    = { name: "Arco Nv.5",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 4, level:  5, damage: 15, sellable: false, droppable: false };
_wd[$ "bow_6"]    = { name: "Arco Nv.6",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 5, level:  6, damage: 21, sellable: false, droppable: false };
_wd[$ "bow_7"]    = { name: "Arco Nv.7",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 6, level:  7, damage: 28, sellable: false, droppable: false };
_wd[$ "bow_8"]    = { name: "Arco Nv.8",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 7, level:  8, damage: 34, sellable: false, droppable: false };
_wd[$ "bow_9"]    = { name: "Arco Nv.9",    type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 8, level:  9, damage: 40, sellable: false, droppable: false };
_wd[$ "bow_10"]   = { name: "Arco Nv.10",   type: ITEM_TYPE.WEAPON, tool_type: TOOL_TYPE.BOW,   sprite: sprite_weapons, subimg: 9, level: 10, damage: 45, sellable: false, droppable: false };

global.armor_data = {
    armor_casco: {
        name: "Casco",
        type: ITEM_TYPE.ARMOR,
        sprite: sprite_armor,
        subimg: 0,
        defense: 0.12,
        sellable: true,
        droppable: false,
        base_sell_price: 50
    },
    armor_peto: {
        name: "Peto",
        type: ITEM_TYPE.ARMOR,
        sprite: sprite_armor,
        subimg: 1,
        defense: 0.24,
        sellable: true,
        droppable: false,
        base_sell_price: 100
    },
    armor_perneras: {
        name: "Pernerass",
        type: ITEM_TYPE.ARMOR,
        sprite: sprite_armor,
        subimg: 2,
        defense: 0.14,
        sellable: true,
        droppable: false,
        base_sell_price: 75
    },
    armor_botas: {
        name: "Botas",
        type: ITEM_TYPE.ARMOR,
        sprite: sprite_armor,
        subimg: 3,
        defense: 0.10,
        sellable: true,
        droppable: false,
        base_sell_price: 40
    }
};

global.placeable_data = {
    chest: {
        name: "Cofre",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_farm_chests,
        subimg: 0,
        offset_x: 8,
        place_offset_x: 0,
        tile_w: 1,
        tile_h: 1,
        sellable: true,
        droppable: true,
        base_buy_price: 100,
        base_sell_price: 17
    },
    machine_curtidora: {
        name: "Curtidora",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_curtidora,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 200,
        base_sell_price: 34,
        machine_type: "curtidora"
    },
    machine_telar: {
        name: "Telar",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_telar,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 300,
        base_sell_price: 51,
        machine_type: "telar"
    },
    machine_mantequillera: {
        name: "Mantequillera",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_mantequillera,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 250,
        base_sell_price: 42,
        machine_type: "mantequillera"
    },
    machine_mermeladora: {
        name: "Mermeladora",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_mermeladora,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 400,
        base_sell_price: 68,
        machine_type: "mermeladora"
    },
    machine_prensa_queso: {
        name: "Prensa de Queso",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_prensa_queso,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 250,
        base_sell_price: 42,
        machine_type: "prensa_queso"
    },
    machine_horno: {
        name: "Horno",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_horno,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 350,
        base_sell_price: 60,
        machine_type: "horno"
    },
    machine_colmena: {
        name: "Colmena",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_colmena,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_buy_price: 500,
        base_sell_price: 85,
        machine_type: "colmena"
    },
    workbench: {
        name: "Mesa de Trabajo",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_workbench,
        subimg: 0,
        sellable: false,
        droppable: true,
        base_sell_price: 0,
        is_workbench: true
    },
    machine_alchemy: {
        name: "Tabla de Alquimia",
        type: ITEM_TYPE.PLACEABLE,
        sprite: sprite_machine_alchemy,
        subimg: 0,
        sellable: true,
        droppable: true,
        base_sell_price: 90,
        is_alchemy: true
    }
};

global.material_data = {
    wood: {
        name: "Madera",
        type: ITEM_TYPE.MATERIAL,
        sprite: sprite_material_wood,
        subimg: 0
    },
    stone: {
        name: "Piedra",
        type: ITEM_TYPE.MATERIAL,
        sprite: sprite_material_stone,
        subimg: 0
    },
    weed: {
        name: "Hierba",
        type: ITEM_TYPE.MATERIAL,
        sprite: sprite_weed,
        subimg: 0
    },
    coal: {
        name: "Carbon",
        type: ITEM_TYPE.MATERIAL,
        sprite: sprite_coal,
        subimg: 0,
        base_sell_price: 2
    }
};

// --- DATOS DE MINERALES (MINA) ---
global.ore_names = ["bronce", "plata", "oro", "broncastanio", "chubestanio", "picastanio", "hitlerstanio", "vitolanio"];
global.ore_data = {};
var _od = global.ore_data;
var _ore_sell = [3, 7, 14, 27, 54, 109, 218, 435];
for (var _oi = 0; _oi < 8; _oi++) {
    var _on = global.ore_names[_oi];
    _od[$ "ore_" + _on] = {
        name: string_upper(string_char_at(_on, 1)) + string_copy(_on, 2, string_length(_on) - 1),
        type: ITEM_TYPE.ORE,
        sprite: sprite_metals,
        subimg: _oi,
        base_sell_price: _ore_sell[_oi]
    };
}

global.ore_rock_sprites = [
    sprite_rock_ore_bronce,
    sprite_rock_ore_plata,
    sprite_rock_ore_oro,
    sprite_rock_ore_broncastanio,
    sprite_rock_ore_chubestanio,
    sprite_rock_ore_picastanio,
    sprite_rock_ore_hitlerstanio,
    sprite_rock_ore_vitolanio
];

global.bar_data = {};
var _bd = global.bar_data;
var _bar_sell = [7, 14, 27, 54, 109, 218, 435, 870];
for (var _bi = 0; _bi < 8; _bi++) {
    var _bn = global.ore_names[_bi];
    _bd[$ "bar_" + _bn] = {
        name: "Lingote de " + (string_upper(string_char_at(_bn, 1)) + string_copy(_bn, 2, string_length(_bn) - 1)),
        type: ITEM_TYPE.BAR,
        sprite: sprite_metals,
        subimg: _bi + 8,
        base_sell_price: _bar_sell[_bi]
    };
}

global.mine_state = {
    active: false,
    door_index: -1,
    ore_type: -1,
    floor: 1,
    entry_door_x: 0,
    entry_door_y: 0
};

global.mine_unlocks = [true, false, false, false, false, false, false, false];
global.mine_progress = [0, 0, 0, 0, 0, 0, 0, 0];
global.mine_floor_room_assigned = {};

global.gemstone_data = {};
var _gd = global.gemstone_data;
_gd[$ "gemstone_ruby"]          = { name: "Rubi",          type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 0,  rarity: 30, base_sell_price: 26   };
_gd[$ "gemstone_sapphire"]      = { name: "Zafiro",        type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 1,  rarity: 25, base_sell_price: 34  };
_gd[$ "gemstone_emerald"]       = { name: "Esmeralda",     type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 2,  rarity: 20, base_sell_price: 51  };
_gd[$ "gemstone_topaz"]         = { name: "Topacio",       type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 3,  rarity: 18, base_sell_price: 68  };
_gd[$ "gemstone_pink_sapphire"] = { name: "Zafiro Rosa",   type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 4,  rarity: 15, base_sell_price: 102  };
_gd[$ "gemstone_turquoise"]     = { name: "Turquesa",      type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 5,  rarity: 12, base_sell_price: 136  };
_gd[$ "gemstone_aquamarine"]    = { name: "Aguamarina",    type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 6,  rarity: 10, base_sell_price: 170  };
_gd[$ "gemstone_amethyst"]      = { name: "Amatista",      type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 7,  rarity: 8,  base_sell_price: 221  };
_gd[$ "gemstone_pearl"]         = { name: "Perla",         type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 8,  rarity: 6,  base_sell_price: 272  };
_gd[$ "gemstone_diamond"]       = { name: "Diamante",      type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 9,  rarity: 4,  base_sell_price: 340 };
_gd[$ "gemstone_pink_diamond"]  = { name: "Diamante Rosa", type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 10, rarity: 2,  base_sell_price: 510 };
_gd[$ "gemstone_alexandrite"]   = { name: "Alejandrita",   type: ITEM_TYPE.ORE, sprite: sprite_gemstones, subimg: 11, rarity: 1,  base_sell_price: 850 };

global.gemstone_pool = [];
var _gkeys = variable_struct_get_names(global.gemstone_data);
for (var _gi = 0; _gi < array_length(_gkeys); _gi++) {
    var _gd_entry = global.gemstone_data[$ _gkeys[_gi]];
    repeat (_gd_entry.rarity) { array_push(global.gemstone_pool, _gkeys[_gi]); }
}

// --- DATOS DE RECOLECCIÓN DEL BOSQUE ---
// Sell prices by rarity: 1=5, 2=12, 3=25, 4=60, 5=150
global.forage_data = {};
var _fd = global.forage_data;

// Mushrooms (subimg 0–77)
_fd[$ "forage_m00"] = { name: "Champiñón de Campo",      subimg: 0,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m01"] = { name: "Boleto Noble",             subimg: 1,  rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m02"] = { name: "Níscalo de Pinar",         subimg: 2,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m03"] = { name: "Amanita de los Césares",   subimg: 3,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m04"] = { name: "Rebozuelo Dorado",         subimg: 4,  rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m05"] = { name: "Trompeta de la Muerte",    subimg: 5,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m06"] = { name: "Seta de Cardo",            subimg: 6,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m07"] = { name: "Morilla de Primavera",     subimg: 7,  rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m08"] = { name: "Trufa Negra",              subimg: 8,  rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 51 };
_fd[$ "forage_m09"] = { name: "Seta de San Jorge",        subimg: 9,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m10"] = { name: "Oreja de Judas",           subimg: 10, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m11"] = { name: "Hongo Blanco",             subimg: 11, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m12"] = { name: "Seta de Pino",             subimg: 12, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m13"] = { name: "Pie Azul",                 subimg: 13, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m14"] = { name: "Lengua de Gato",           subimg: 14, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m15"] = { name: "Carbonera de Otoño",       subimg: 15, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m16"] = { name: "Parasol Gigante",          subimg: 16, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m17"] = { name: "Seta de Chopo",            subimg: 17, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m18"] = { name: "Rebozuelo Naranja",        subimg: 18, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m19"] = { name: "Boleto Bayo",              subimg: 19, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m20"] = { name: "Seta de Mayo",             subimg: 20, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m21"] = { name: "Amanita Rojiza",           subimg: 21, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m22"] = { name: "Champiñón Silvestre",      subimg: 22, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m23"] = { name: "Seta de Ostra",            subimg: 23, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m24"] = { name: "Boleto Reticulado",        subimg: 24, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m25"] = { name: "Seta Engañosa",            subimg: 25, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m26"] = { name: "Níscalo de Sangre",        subimg: 26, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m27"] = { name: "Trompeta Amarilla",        subimg: 27, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m28"] = { name: "Seta de Brezo",            subimg: 28, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m29"] = { name: "Hongo Rojo",               subimg: 29, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m30"] = { name: "Seta de Encina",           subimg: 30, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m31"] = { name: "Boleto Real",              subimg: 31, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m32"] = { name: "Seta de Musgo",            subimg: 32, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m33"] = { name: "Amanita Citrina",          subimg: 33, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m34"] = { name: "Seta de Prados",           subimg: 34, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m35"] = { name: "Bola de Nieve",            subimg: 35, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m36"] = { name: "Seta de Haya",             subimg: 36, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m37"] = { name: "Boleto de Verano",         subimg: 37, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m38"] = { name: "Seta de Roble",            subimg: 38, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m39"] = { name: "Rebozuelo de Canal",       subimg: 39, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m40"] = { name: "Seta de Abeto",            subimg: 40, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m41"] = { name: "Amanita Pantera",          subimg: 41, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m42"] = { name: "Seta de Jaral",            subimg: 42, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m43"] = { name: "Boleto de Pino",           subimg: 43, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m44"] = { name: "Seta de Castaño",          subimg: 44, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m45"] = { name: "Trompeta Gris",            subimg: 45, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m46"] = { name: "Seta de Aliso",            subimg: 46, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m47"] = { name: "Champiñón de Bosque",      subimg: 47, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m48"] = { name: "Seta de Abedul",           subimg: 48, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m49"] = { name: "Boleto Elegante",          subimg: 49, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m50"] = { name: "Seta de Sauce",            subimg: 50, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m51"] = { name: "Amanita Muscaria",         subimg: 51, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m52"] = { name: "Seta de Olmo",             subimg: 52, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m53"] = { name: "Rebozuelo Amatista",       subimg: 53, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m54"] = { name: "Seta de Enebro",           subimg: 54, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m55"] = { name: "Boleto de Cueva",          subimg: 55, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m56"] = { name: "Seta de Gruta",            subimg: 56, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m57"] = { name: "Champiñón de Arena",       subimg: 57, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m58"] = { name: "Seta de Duna",             subimg: 58, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m59"] = { name: "Boleto de Costa",          subimg: 59, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m60"] = { name: "Seta de Pantano",          subimg: 60, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m61"] = { name: "Amanita Vaginata",         subimg: 61, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m62"] = { name: "Seta de Turbera",          subimg: 62, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m63"] = { name: "Rebozuelo Velloso",        subimg: 63, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m64"] = { name: "Seta de Breñal",           subimg: 64, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m65"] = { name: "Boleto de Risco",          subimg: 65, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m66"] = { name: "Seta de Cumbre",           subimg: 66, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m67"] = { name: "Champiñón de Pasto",       subimg: 67, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_m68"] = { name: "Seta de Valle",            subimg: 68, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m69"] = { name: "Boleto de Cañada",         subimg: 69, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m70"] = { name: "Seta de Arroyo",           subimg: 70, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m71"] = { name: "Amanita de Huevo",         subimg: 71, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m72"] = { name: "Seta de Manantial",        subimg: 72, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m73"] = { name: "Rebozuelo de Fuente",      subimg: 73, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_m74"] = { name: "Seta de Cascada",          subimg: 74, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_m75"] = { name: "Boleto de Niebla",         subimg: 75, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m76"] = { name: "Seta de Bruma",            subimg: 76, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_m77"] = { name: "Champiñón Lunar",          subimg: 77, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 51 };

// Herbs (subimg 78–96)
_fd[$ "forage_h00"] = { name: "Hierbabuena",        subimg: 78, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_h01"] = { name: "Romero de Monte",    subimg: 79, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_h02"] = { name: "Tomillo de Roca",    subimg: 80, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_h03"] = { name: "Salvia del Bosque",  subimg: 81, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h04"] = { name: "Albahaca Silvestre", subimg: 82, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h05"] = { name: "Lavanda de Valle",   subimg: 83, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_h06"] = { name: "Orégano de Sierra",  subimg: 84, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h07"] = { name: "Menta de Agua",      subimg: 85, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h08"] = { name: "Poleo",              subimg: 86, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h09"] = { name: "Eneldo",             subimg: 87, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h10"] = { name: "Perejil de Selva",   subimg: 88, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h11"] = { name: "Cilantro de Loma",   subimg: 89, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h12"] = { name: "Laurel de Cañada",   subimg: 90, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_h13"] = { name: "Mejorana",           subimg: 91, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_h14"] = { name: "Estragón",           subimg: 92, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_h15"] = { name: "Anís de Estepa",     subimg: 93, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_h16"] = { name: "Hinojo",             subimg: 94, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_h17"] = { name: "Comino de Páramo",   subimg: 95, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_h18"] = { name: "Azafrán del Bosque", subimg: 96, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 51 };

// Flowers (subimg 97–118)
_fd[$ "forage_f00"] = { name: "Margarita",           subimg: 97,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_f01"] = { name: "Amapola",             subimg: 98,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_f02"] = { name: "Lirio de Agua",       subimg: 99,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f03"] = { name: "Orquídea Selvática",  subimg: 100, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_f04"] = { name: "Rosa Silvestre",      subimg: 101, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_f05"] = { name: "Girasol de Monte",    subimg: 102, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_f06"] = { name: "Tulipán de Valle",    subimg: 103, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f07"] = { name: "Violeta de Bosque",   subimg: 104, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 2   };
_fd[$ "forage_f08"] = { name: "Jazmín de Noche",     subimg: 105, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_f09"] = { name: "Clavel de Aire",      subimg: 106, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f10"] = { name: "Hortensia",           subimg: 107, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f11"] = { name: "Azucena de Río",      subimg: 108, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f12"] = { name: "Narciso",             subimg: 109, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f13"] = { name: "Pensamiento",         subimg: 110, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 4  };
_fd[$ "forage_f14"] = { name: "Dalia de Sierra",     subimg: 111, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f15"] = { name: "Camelia",             subimg: 112, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_f16"] = { name: "Crisantemo",          subimg: 113, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f17"] = { name: "Gladiolo",            subimg: 114, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 8  };
_fd[$ "forage_f18"] = { name: "Gardenia",            subimg: 115, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_f19"] = { name: "Magnolio",            subimg: 116, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 20  };
_fd[$ "forage_f20"] = { name: "Loto Azul",           subimg: 117, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 51 };
_fd[$ "forage_f21"] = { name: "Orquídea de Cristal", subimg: 118, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 51 };

// Berries (own sprites)
_fd[$ "forage_b00"] = { name: "Arándano Azul",  subimg: 0, rarity: 2, sprite: sprite_blueberry,  type: ITEM_TYPE.MATERIAL, base_sell_price: 6  };
_fd[$ "forage_b01"] = { name: "Arándano Rojo",  subimg: 0, rarity: 3, sprite: sprite_cranberry, type: ITEM_TYPE.MATERIAL, base_sell_price: 12 };

// --- SISTEMA DE PROGRESIÓN DE HERRAMIENTAS ---
// global.tool_progression[$ "key"][QUALITY_tier] = { stats }
// hits_required: daño por golpe = 1 + hits_required (recursos tienen 10 HP base)
// area_width/height: área de efecto en tiles
// double_drop_chance/triple_drop_chance/treasure_chance: 0.0-1.0
// no_energy_chance: 1.0 = siempre sin gasto de energía
// water_persists_next_day: el riego persiste al día siguiente
global.tool_progression = {};
var _tp = global.tool_progression;

// --- PICO ---
_tp[$ "pickaxe"] = [
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
    { hits_required: 1, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
    { hits_required: 2, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
    { hits_required: 3, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // ORO
    { hits_required: 4, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
    { hits_required: 5, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
    { hits_required: 6, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
    { hits_required: 7, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0.05, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
    { hits_required: 8, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0.05, triple_drop_chance: 0, no_energy_chance: 1.0, water_persists_next_day: false }  // VITOLANIO
];

// --- HACHA ---
_tp[$ "axe"] = [
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
    { hits_required: 1, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
    { hits_required: 2, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
    { hits_required: 3, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // ORO
    { hits_required: 4, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
    { hits_required: 5, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
    { hits_required: 6, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0,    triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
    { hits_required: 7, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0.05, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
    { hits_required: 8, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0.05, triple_drop_chance: 0, no_energy_chance: 1.0, water_persists_next_day: false }  // VITOLANIO
];

// --- HOZ ---
_tp[$ "sickle"] = [
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
    { hits_required: 0, area_width: 2, area_height: 2, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
    { hits_required: 0, area_width: 3, area_height: 3, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
    { hits_required: 0, area_width: 4, area_height: 4, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // ORO
    { hits_required: 0, area_width: 5, area_height: 5, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
    { hits_required: 0, area_width: 5, area_height: 5, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
    { hits_required: 0, area_width: 5, area_height: 5, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0,   no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
    { hits_required: 0, area_width: 5, area_height: 5, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0.3, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
    { hits_required: 0, area_width: 5, area_height: 5, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0.3, no_energy_chance: 1.0, water_persists_next_day: false }  // VITOLANIO
];

// --- AZADA ---
_tp[$ "hoe"] = [
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
    { hits_required: 0, area_width: 2, area_height: 1, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
    { hits_required: 0, area_width: 3, area_height: 1, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
    { hits_required: 0, area_width: 3, area_height: 2, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // ORO
    { hits_required: 0, area_width: 3, area_height: 3, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
    { hits_required: 0, area_width: 3, area_height: 6, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
    { hits_required: 0, area_width: 6, area_height: 6, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
    { hits_required: 0, area_width: 9, area_height: 9, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
    { hits_required: 0, area_width: 9, area_height: 9, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 1.0, water_persists_next_day: false }  // VITOLANIO
];

// --- REGADERA ---
_tp[$ "watering_can"] = [
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
    { hits_required: 0, area_width: 2, area_height: 1, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
    { hits_required: 0, area_width: 3, area_height: 1, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
    { hits_required: 0, area_width: 3, area_height: 2, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // ORO
    { hits_required: 0, area_width: 3, area_height: 3, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
    { hits_required: 0, area_width: 3, area_height: 6, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
    { hits_required: 0, area_width: 6, area_height: 6, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
    { hits_required: 0, area_width: 9, area_height: 9, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
    { hits_required: 0, area_width: 9, area_height: 9, double_drop_chance: 0, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 1.0, water_persists_next_day: true  }  // VITOLANIO
];

    _tp[$ "bugnet"] = [
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.1, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.1, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // ORO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.3, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.3, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.5, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 1,   water_persists_next_day: false }, // VITOLANIO
    ];

    _tp[$ "fishing_rod"] = [
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // OXIDADO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCE
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PLATA
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.1, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // ORO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.1, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // BRONCASTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // CHUBESTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.2, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // PICASTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.3, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false }, // HITLERSTANIO
        { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0.5, treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 1,   water_persists_next_day: false }, // VITOLANIO
    ];

// --- PALA ---
_tp[$ "shovel"] = [
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0.01, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false, dig_chance: 0.15 }, // OXIDADO
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0.02, triple_drop_chance: 0, no_energy_chance: 0,   water_persists_next_day: false, dig_chance: 0.20 }, // BRONCE
    { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,   treasure_chance: 0.03, triple_drop_chance: 0, no_energy_chance: 0.05, water_persists_next_day: false, dig_chance: 0.25 }, // PLATA
    { hits_required: 0, area_width: 2, area_height: 1, double_drop_chance: 0,   treasure_chance: 0.04, triple_drop_chance: 0, no_energy_chance: 0.10, water_persists_next_day: false, dig_chance: 0.30 }, // ORO
    { hits_required: 0, area_width: 2, area_height: 2, double_drop_chance: 0,   treasure_chance: 0.05, triple_drop_chance: 0, no_energy_chance: 0.15, water_persists_next_day: false, dig_chance: 0.35 }, // BRONCASTANIO
    { hits_required: 0, area_width: 3, area_height: 2, double_drop_chance: 0,   treasure_chance: 0.06, triple_drop_chance: 0, no_energy_chance: 0.20, water_persists_next_day: false, dig_chance: 0.40 }, // CHUBESTANIO
    { hits_required: 0, area_width: 3, area_height: 3, double_drop_chance: 0,   treasure_chance: 0.07, triple_drop_chance: 0, no_energy_chance: 0.25, water_persists_next_day: false, dig_chance: 0.45 }, // PICASTANIO
    { hits_required: 0, area_width: 4, area_height: 3, double_drop_chance: 0,   treasure_chance: 0.08, triple_drop_chance: 0, no_energy_chance: 0.30, water_persists_next_day: false, dig_chance: 0.50 }, // HITLERSTANIO
    { hits_required: 0, area_width: 4, area_height: 4, double_drop_chance: 0,   treasure_chance: 0.10, triple_drop_chance: 0, no_energy_chance: 0.40, water_persists_next_day: false, dig_chance: 0.55 }  // VITOLANIO
];

// --- NPC DATA ---
global.npc_data = {
    workbench:       { name: "Mesa de Trabajo" },
    machine_alchemy: { name: "Tabla de Alquimia" },
    Miraculos:  { name: "Miraculos", skin: 4, eye_type: "female", eye_color: "brown",  hair_style: "none",       hair_color: "black",  clothes_color: "blue",   dialog_id: -1 },
    Jose:       { name: "José",      skin: 2, eye_type: "male",   eye_color: "brown",  hair_style: "standard",   hair_color: "black",  clothes_color: "green",  dialog_id: -1 },
    Maria:      { name: "María",     skin: 3, eye_type: "female", eye_color: "black",  hair_style: "iridessa",   hair_color: "brown",  clothes_color: "pink",   dialog_id: -1 },
    Juan:       { name: "Juan",      skin: 1, eye_type: "male",   eye_color: "black",  hair_style: "josh",       hair_color: "brown",  clothes_color: "blue",   dialog_id: -1 },
    Lupita:     { name: "Lupita",    skin: 4, eye_type: "female", eye_color: "green",  hair_style: "fawn",       hair_color: "black",  clothes_color: "purple", dialog_id: -1 },
    Carlos:     { name: "Carlos",    skin: 2, eye_type: "male",   eye_color: "blue",   hair_style: "sebastian",  hair_color: "brown",  clothes_color: "red",    dialog_id: -1 },
    Ana:        { name: "Ana",       skin: 1, eye_type: "female", eye_color: "blue",   hair_style: "silvermist", hair_color: "blonde", clothes_color: "green",  dialog_id: -1 },
    Pedro:      { name: "Pedro",     skin: 3, eye_type: "male",   eye_color: "brown",  hair_style: "standard",   hair_color: "ginger", clothes_color: "blue",   dialog_id: -1 },
    Sofia:      { name: "Sofía",     skin: 2, eye_type: "female", eye_color: "brown",  hair_style: "lyria",      hair_color: "blonde", clothes_color: "pink",   dialog_id: -1 },
    Diego:      { name: "Diego",     skin: 4, eye_type: "male",   eye_color: "black",  hair_style: "josh",       hair_color: "black",  clothes_color: "green",  dialog_id: -1 },
    Carmen:     { name: "Carmen",    skin: 1, eye_type: "female", eye_color: "brown",  hair_style: "fawn",       hair_color: "brown",  clothes_color: "red",    dialog_id: -1 },
    Luis:       { name: "Luis",      skin: 3, eye_type: "male",   eye_color: "green",  hair_style: "sebastian",  hair_color: "black",  clothes_color: "purple", dialog_id: -1 },
    Fernanda:   { name: "Fernanda",  skin: 2, eye_type: "female", eye_color: "blue",   hair_style: "iridessa",   hair_color: "ginger", clothes_color: "blue",   dialog_id: -1 },
    Jorge:      { name: "Jorge",     skin: 4, eye_type: "male",   eye_color: "brown",  hair_style: "standard",   hair_color: "blonde", clothes_color: "green",  dialog_id: -1 },
    Elena:      { name: "Elena",     skin: 1, eye_type: "female", eye_color: "green",  hair_style: "silvermist", hair_color: "brown",  clothes_color: "pink",   dialog_id: -1 },
    Raul:       { name: "Raúl",      skin: 3, eye_type: "male",   eye_color: "blue",   hair_style: "josh",       hair_color: "ginger", clothes_color: "red",    dialog_id: -1 },
    Patricia:   { name: "Patricia",  skin: 2, eye_type: "female", eye_color: "black",  hair_style: "lyria",      hair_color: "ginger", clothes_color: "purple", dialog_id: -1 },
    Miguel:     { name: "Miguel",    skin: 4, eye_type: "male",   eye_color: "brown",  hair_style: "fawn",       hair_color: "blonde", clothes_color: "blue",   dialog_id: -1 },
    Rosa:       { name: "Rosa",      skin: 1, eye_type: "female", eye_color: "brown",  hair_style: "iridessa",   hair_color: "black",  clothes_color: "green",  dialog_id: -1 },
    Andres:     { name: "Andrés",    skin: 3, eye_type: "male",   eye_color: "black",  hair_style: "sebastian",  hair_color: "ginger", clothes_color: "red",    dialog_id: -1 },
};

global.sra_rata_state = {
    contract_type: "none",
    hired_on_day: -1
};

global.sra_rata_dialogs = {
    greeting: "¡Oh! ¡Hola! Soy La Señora Rata, encantada de conocerte.\nMe encanta la vida de granja.",
    offer: "Si necesitas ayuda en tu granja,\npuedo regar cultivos, quitar piedras y maleza, y talar árboles.\n¿Qué te parece?",
    daily_option: "[1] Contrato por un día  |  1,500G",
    lifetime_option: "[2] Contrato vitalicio  |  25,000G",
    hired_daily: "¡Trato hecho! Hoy mismo empiezo a trabajar.",
    hired_lifetime: "¡Maravilloso! Esta granja será mi hogar.",
    no_money: "No tienes suficiente dinero. ¡Vuelve cuando tengas!",
    already_hired: "Ya estoy trabajando para ti, ¿recuerdas?",
    decline: "Como quieras. Estaré aquí si cambias de opinión.",
    farm_ask: "¿Necesitas algo?",
    farm_rest_option: "[1] Descansar por hoy",
    farm_work_option: "[2] Seguir trabajando",
    farm_rest: "Muy bien, descansaré por hoy.",
    farm_work: "Noooooo pos ta caray, pinchi negrero"
};

// --- DIALOGOS NPC ---
// Organizados por fase del town (ver script_town_progression)
global.npc_dialogues = [
    // === FASE 0: LIMPIAR LAS CALLES ===
    "Aguanta el polvo, que ni a barrer se dignan. Esto esta peor que cuando llego el cataclismo.",
    "Limpien eso de una vez, no pense que ivan a tardar tanto en recoger la basura.",
    "Los tarahumaras no movieron ni una piedra. Ahi nomas viendo mientras uno parte el lomo.",
    "Ya deberiamos estar construyendo algo, no perdiendo el tiempo con escombros.",
    "Calor y polvo, mi unica compania. Ni para conseguir una escoba alcanza.",
    "Si no lo hacemos nosotros, no lo hace nadie. Como siempre, el pueblo somos nosotros.",

    // === FASE 1-2: RESTAURAR AREAS VERDES ===
    "Ya por fin hay areas verdes, pero los riegos ni funcionan. A ver si alguien les da mantenimiento.",
    "Los huertos sobrevivieron al cataclismo pero ahora les dan mas trabajo a uno que sembrar.",
    "Unas areas verdes con yerba seca no es area verde, es desierto con pintitas.",
    "Mi abuela sembraba mejor que todos estos 'jardineros' juntos. Verguenza ajena.",
    "Quedo todo bien culero parece que lo hicieron tarahumaras.",
    "Unos arbolitos aqui y alla, pero mientras no haya agua de verdad esto no prospera.",

    // === FASE 3-4: TIENDA DE MIRACULOS ===
    "La tienda de Miraculos esta bien culera. Pura semilla vende. Segun iba a vender cosas utiles, a ver si es verdad.",
    "Miraculos vale para pura verga. Siempre andara de metiche.",
    "Miraculos de mierda cobra comision por pagar con tarjeta.",
    "Si Miraculos vende semillas de mala calidad.",
    "La tienda lleva anos en construccion. En Veredas del Sur todo tarda el doble.",
    "Ya abrio la tienda, pero todavia le falta mucho. Presupuesto jodido como el mismo Miraculos.",

    // === FASE 5: HERRERIA ===
    "Una herreria! Aunque segun Carlos el carbon que hay no sirve pa'nada.",
    "Carlos es bueno en lo que hace, pero cobra un ojo de la cara por cualquier cosa.",
    "Con una herreria deberiamos hacer herramientas pa'todo, pero pinchi viejo carero lo hace imposible.",
    "Mano de obra mala que hace el herrero y bien carero. Ni pone el material, lo tengo que llevar yo.",
    "Quiero culearme al herrero.",
    "El herrero es un viejo mamon cara de culo, quiero matarlo a chingazos.",

    // === FASE 6-7: ARBOLES DEL TOWN ===
    "Los arboles ya crecieron, pero no daran sombra hasta dentro de unos anos. Mientras, prepara tu ano para el cancer.",
    "Arboles culeros, la neta.",
    "Plantar esperanza no llena la panza. Mientras haya hambre, los arboles son puro adorno.",
    "Tengo mucho coraje.",
    "Al menos esto no lo hizo un tarahumara todo a medias.",
    "Con sombra y aire puro se ve bonito, pero no se come nada de eso.",

    // === FASE 8-9: TORRE Y PARQUE ===
    "Una torre y un parque! Aunque los juegos ya tienen oxido y nadie les ha dado mantenimiento.",
    "Los ninos ya tienen donde jugar, pero no hay quien los supervise. Peligro a la orden del dia.",
    "Mi abuelo decia que en Veredas habia una cancha de futbol. Aqui pura tierra.",
    "La torre se ve bonita pero por dentro esta vacia. Pura fachada como siempre.",
    "Un parque sin bancos nomas sirve pa'estar parado. Parada traigo la verga mas bien.",
    "Por fin tenemos un lugar de reunion, aunque la mayoria del tiempo nadie viene.",

    // === FASE 10-12: URBANIZACION FINAL ===
    "Increible quanto hemos construido, pero a los politicos ni les importa. Solamente el pueblo.",
    "Las paradas de autobus estan bien, pero los autobuses nunca llegan. Pura simulacion.",
    "Despues del cataclismo pense que no sobrevivia. Y ahorita que sobrevivi, todavia mejoro nada.",
    "Mira todo lo que hemos logrado, pero todavia falta mucho pa' lo que Chihuahua fue.",
    "El Cochabebes puede dormir tranquilo. Aqui no hay nada que valga la pena robar.",
    "Veredas del Sur es exemplo de que la comunidad tiene que hacer todo sola. Gracias, poco agradecimiento.",
    "Por fin el pueblo se ve bien, pero aun asi nadie quiere vivir aqui. Solo nosotros. Lo bueno.",

    // === MISCELANEOS (cataclismo, chismes, quejumbrosos) ===
    "Desde el cataclismo que destruyo Chihuahua, todos vivimos en Veredas del Sur. Y aun asi no aprendemos.",
    "Los tarahumaras sobrevivieron al cataclismo pero ahora puro flojos. Uno aqui partiendonos de ellos.",
    "Veredas del Sur se levanto del cataclismo, pero con puras manos vazias y nada de ayuda.",
    "Antes vivia en el Sanfra. Ahora esto. No hay derecho.",
    "Los tarahumaras no les gusta trabajar. Como todos en este pais.",
    "Veredas del Sur era solo una colonia. Ahora es lo unico que nos queda, y ni modo de quejarse.",
    "El cataclismo no dejo piedra sobre piedra. Y nosotros tampoco recibimos ayuda de nadie.",
    "Los de la sierra nomas vienen a vender artesanias y a pedir. Despues se van a su mundo.",
    "Chihuahua era grande. Ahora es pura area verde y piedras. Que caida mas penosa.",
    "Veredas del Sur es pura buena gente, pero la ayuda mutua solo existe en el papel.",
    "Despues del cataclismo reconstruimos entre todos. Aunque algunos nomas posteen y no trabajan.",
    "Los tarahumaras le tienen fe a sus costumbres. Bueno para ellos, pesimo para nosotros.",
    "Todo Chihuahua quedo bajo el polvo. Y aca en Veredas del Sur puras promesas rotas.",
    "Los tarahumaras nomas bajan a vender y se van. Cuando hay trabajo pesado, nadie aparece.",
    "Mi abuelo contaba Chihuahua antes del cataclismo. Siempre suena mejor en los recuerdos.",
    "Veredas del Sur es pequena pero aqui todos se quejan. Y pocos hacen algo.",
    "El cataclismo ensena a valorar lo poco que hay. Que poco es poco, eso si.",
    "Cada dia hay mas gente de la sierra queriendose mudar. Y luego no hay trabajo pa'tantos.",
    "Yo no tengo nada contra nadie, pero aqui siempre hay alguien que se sale con la suya.",
    "La Sierra Tarahumara es mas tranquila. Aunque alla tampoco hay empleo ni nada.",
    "Dicen que en otros lugares ya tienen internet. Aqui ni senal pa'llamar por telefono.",
    "La buldak carbonara esta cara, pero al menos te olvidas de la vida por unos minutos.",
    "Una buldak 2x te pone a volar, pero a la hora de trabajar no puedes ni pararte.",
    "Extrano cuando habia Netflix y no habia cataclismo. Ahora nada mas cataclismo sin Netflix.",
    "Cuando vivia en Chihuahua veia Netflix todo el dia. Ahora veo piedras y mas piedras.",
    "Antes me entretenia con Netflix, ahora nomas miro a Miraculos mirando a la gente.",
    "A veces siento que soy un NPC mal programado, nomas camino y camino sin sentido.",
    "Estoy harto de caminar de aqui pa'lla sin proposito. Aunque uno en la vida real igual.",
    "Los desarrolladores nos dejaron con pura IA generica. Ni soar podemos enserio.",
    "A veces pienso que soy un NPC. Y si lo soy? Al menos no pago renta.",
    "Me late la buldak negro, aunque te chamusca hasta las pestanas.",
    "Ojala Netflix llegara a Veredas del Sur, sin internet ni nada.",
    "Toda la vida caminando en circulos. Si esto no es un juego, esta muy biecho pa'serlo.",
    "¿Te acuerdas del Cochabebes? Ese wey tenia a todo Chihuahua con miedo en los 2020s.",
    "Dicen que el Cochabebes nunca lo agarraron. Segun sigue suelto por ahi, esperando.",
    "El Cochabebes azotaba bien feo en Chihuahua. Aqui en Veredas al menos estamos mas seguros.",
    "Mi primo jura que vio al Cochabebes en la colonia Rosario. Salio corriendo y no volta a ver.",
    "Cuando vivia en la Dale, mi mama no me dejaba salir solito. Y con razon.",
    "Ojala hubieran agarrado al Cochabebes antes del cataclismo. Aunque talvez nada habria cambiado.",
];

// price_items: array de { key, qty } requeridos ademas del dinero
global.shop_data = {};

global.shop_data[$ "Miraculos"] = {
    available: true,
    daily_specials: [],
    specials_day: -1,
    items: [
        // PRIMAVERA
        { item_key: "cherry_seeds",       price_money: 30, price_items: [] },
        { item_key: "apricot_seeds",      price_money: 25, price_items: [] },
        { item_key: "strawberry_seeds",   price_money: 40, price_items: [] },
        { item_key: "spring_onion_seeds", price_money: 10, price_items: [] },
        { item_key: "potato_seeds",       price_money: 20, price_items: [] },
        { item_key: "onion_seeds",        price_money: 15, price_items: [] },
        { item_key: "carrot_seeds",       price_money: 15, price_items: [] },
        { item_key: "blueberry_seeds",    price_money: 50, price_items: [] },
        { item_key: "parsnip_seeds",      price_money: 15, price_items: [] },
        { item_key: "cabbage_seeds",      price_money: 20, price_items: [] },
        { item_key: "cauliflower_seeds",  price_money: 30, price_items: [] },
        { item_key: "rice_seeds",         price_money: 25, price_items: [] },
        { item_key: "broccoli_seeds",     price_money: 25, price_items: [] },
        { item_key: "asparagus_seeds",    price_money: 35, price_items: [] },
        // VERANO
        { item_key: "tomato_seeds",       price_money: 20, price_items: [] },
        { item_key: "banana_seeds",       price_money: 30, price_items: [] },
        { item_key: "orange_seeds",       price_money: 35, price_items: [] },
        { item_key: "mango_seeds",        price_money: 40, price_items: [] },
        { item_key: "peach_seeds",        price_money: 35, price_items: [] },
        { item_key: "sunflower_seeds",    price_money: 15, price_items: [] },
        { item_key: "hot_pepper_seeds",   price_money: 30, price_items: [] },
        { item_key: "corn_seeds",         price_money: 25, price_items: [] },
        { item_key: "green_pepper_seeds", price_money: 20, price_items: [] },
        { item_key: "melon_seeds",        price_money: 50, price_items: [] },
        { item_key: "watermelon_seeds",   price_money: 50, price_items: [] },
        { item_key: "cucumber_seeds",     price_money: 20, price_items: [] },
        { item_key: "eggplant_seeds",     price_money: 25, price_items: [] },
        { item_key: "pineapple_seeds",    price_money: 60, price_items: [] },
        { item_key: "green_beans_seeds",  price_money: 25, price_items: [] },
        { item_key: "adzuki_bean_seeds",  price_money: 30, price_items: [] },
        { item_key: "wild_berry_seeds",   price_money: 20, price_items: [] },
        { item_key: "wheat_seeds",        price_money: 10, price_items: [] },
        { item_key: "aloe_seeds",         price_money: 30, price_items: [] },
        { item_key: "orange_tree_seeds",  price_money: 50, price_items: [] },
        { item_key: "mango_tree_seeds",   price_money: 60, price_items: [] },
        { item_key: "peach_tree_seeds",   price_money: 50, price_items: [] },
        // OTONO
        { item_key: "beetroot_seeds",     price_money: 25, price_items: [] },
        { item_key: "pumpkin_seeds",      price_money: 30, price_items: [] },
        { item_key: "grapes_seeds",       price_money: 40, price_items: [] },
        { item_key: "apple_seeds",        price_money: 30, price_items: [] },
        { item_key: "apple_tree_seeds",   price_money: 50, price_items: [] },
    ]
};

// --- SISTEMA DE DESBLOQUEO GRADUAL DE SEMILLAS ---
global.shipped_quantities = {};

global.seed_unlock_tiers = array_create(5, undefined);
global.seed_unlock_tiers[SEASON.SPRING] = [
    ["potato_seeds", "onion_seeds", "parsnip_seeds"],
    ["spring_onion_seeds", "carrot_seeds", "cabbage_seeds"],
    ["cauliflower_seeds", "rice_seeds", "broccoli_seeds"],
    ["asparagus_seeds", "strawberry_seeds", "blueberry_seeds"],
    ["cherry_seeds", "apricot_seeds"]
];
global.seed_unlock_tiers[SEASON.SUMMER] = [
    ["tomato_seeds", "sunflower_seeds", "wheat_seeds"],
    ["green_pepper_seeds", "cucumber_seeds", "wild_berry_seeds"],
    ["corn_seeds", "eggplant_seeds", "green_beans_seeds"],
    ["hot_pepper_seeds", "adzuki_bean_seeds", "aloe_seeds"],
    ["melon_seeds", "watermelon_seeds", "pineapple_seeds"],
    ["banana_seeds", "orange_seeds", "mango_seeds", "peach_seeds"]
];
global.seed_unlock_tiers[SEASON.FALL] = [
    ["beetroot_seeds", "pumpkin_seeds"],
    ["grapes_seeds"],
    ["apple_seeds"]
];

// --- GRUPOS DE ITEMS PARA RECETAS ---
var _colors = ["red","orange","yellow","green","blue","lilac","purple","turquoise","pink","lime","amber","brown","black","white"];
var _milk_keys    = ["milk_reg","milk_large","goat_milk_reg","goat_milk_large"];
var _leather_keys = [];
var _yarn_keys    = [];
var _crop_keys    = ["cherry","apricot","strawberry","spring_onion","potato","onion","carrot","blueberry","parsnip","cabbage","cauliflower","rice","broccoli","asparagus","tomato","banana","orange","mango","peach","sunflower","hot_pepper","corn","green_pepper","melon","watermelon","cucumber","eggplant","pineapple","green_beans","adzuki_bean","wild_berry","wheat","aloe","beetroot","pumpkin","grapes","apple"];
for (var _ci = 0; _ci < array_length(_colors); _ci++) {
    array_push(_leather_keys, "pelt_" + _colors[_ci], "cow_hide_" + _colors[_ci], "rabbit_pelt_" + _colors[_ci]);
    array_push(_yarn_keys, "yarn_" + _colors[_ci]);
}
var _herb_keys     = [];
var _mushroom_keys = [];
var _fish_keys     = [];
for (var _i = 0; _i <= 18; _i++) array_push(_herb_keys,     "forage_h" + (_i < 10 ? "0" : "") + string(_i));
for (var _i = 0; _i <= 77; _i++) array_push(_mushroom_keys, "forage_m" + (_i < 10 ? "0" : "") + string(_i));
for (var _i = 0; _i <= 98; _i++) array_push(_fish_keys,     "fish_"    + (_i < 10 ? "0" : "") + string(_i));
global.item_groups = {
    milk_any:     _milk_keys,
    leather_any:  _leather_keys,
    yarn_any:     _yarn_keys,
    crop_any:     _crop_keys,
    egg_any:      ["egg_chicken_white_reg","egg_chicken_brown_reg","egg_chicken_white_large",
                   "egg_chicken_brown_large","egg_chicken_large_generic","egg_duck_reg","egg_duck_large"],
    herb_any:     _herb_keys,
    mushroom_any: _mushroom_keys,
    fish_any:     _fish_keys
};

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
global.shop_data[$ "Pedro"]  = { available: false, items: [] };
global.shop_data[$ "Jorge"]  = { available: false, items: [] };

global.shop_data[$ "workbench"] = {
    available: true,
    items: [
        { item_key: "workbench",
          price_money: 0, price_items: [
            { key: "wood",  qty: 30 },
            { key: "stone", qty: 20 }
          ]},
        { item_key: "chest",
          price_money: 0, price_items: [
            { key: "wood",  qty: 50 }
          ]},
        { item_key: "machine_curtidora",
          price_money: 0, price_items: [
            { key: "wood",      qty: 50 },
            { key: "stone",     qty: 10 },
            { key: "bar_plata", qty: 3  },
            { key: "leather_any", qty: 10, name: "Cuero/Piel", group_keys: global.item_groups.leather_any }
          ], collection_req: { cat: 6, min: 20 }},
        { item_key: "machine_telar",
          price_money: 0, price_items: [
            { key: "wood",       qty: 15 },
            { key: "coal",       qty: 5  },
            { key: "bar_bronce", qty: 3  },
            { key: "yarn_any",   qty: 10, name: "Estambre", group_keys: global.item_groups.yarn_any }
          ], collection_req: { cat: 6, min: 15 }},
        { item_key: "machine_mantequillera",
          price_money: 0, price_items: [
            { key: "wood",       qty: 50 },
            { key: "stone",      qty: 50 },
            { key: "bar_bronce", qty: 3  },
            { key: "milk_any",   qty: 10, name: "Leche", group_keys: global.item_groups.milk_any }
          ], collection_req: { cat: 5, min: 8 }},
        { item_key: "machine_mermeladora",
          price_money: 0, price_items: [
            { key: "wood",      qty: 30 },
            { key: "bar_plata", qty: 3  },
            { key: "crop_any",  qty: 10, name: "Fruta/Verdura", group_keys: global.item_groups.crop_any }
          ], collection_req: { cat: 1, min: 25 }},
        { item_key: "machine_prensa_queso",
          price_money: 0, price_items: [
            { key: "wood",    qty: 60 },
            { key: "stone",   qty: 30 },
            { key: "bar_oro", qty: 3  },
            { key: "milk_any", qty: 10, name: "Leche", group_keys: global.item_groups.milk_any }
          ], collection_req: { cat: 5, min: 12 }},
        { item_key: "machine_horno",
          price_money: 0, price_items: [
            { key: "stone", qty: 80 },
            { key: "coal",  qty: 10 }
          ]},
        { item_key: "machine_colmena",
          price_money: 0, price_items: [
            { key: "wood",             qty: 20 },
            { key: "honey",            qty: 3  },
            { key: "bar_broncastanio", qty: 5  }
          ], collection_req: { cat: 4, min: 50 }},
        { item_key: "machine_alchemy",
          price_money: 0, price_items: [
            { key: "wood",  qty: 60 },
            { key: "stone", qty: 40 },
            { key: "honey", qty: 5  }
          ]},
    ]
};

global.shop_data[$ "machine_alchemy"] = {
    available: true,
    items: [
        { item_key: "potion_energy",
          price_money: 0, price_items: [
            { key: "crop_any", qty: 10, name: "Cultivo",  group_keys: global.item_groups.crop_any  },
            { key: "herb_any", qty: 10, name: "Hierba",   group_keys: global.item_groups.herb_any  },
            { key: "honey",    qty: 1 }
          ]},
        { item_key: "potion_health",
          price_money: 0, price_items: [
            { key: "crop_any", qty: 10, name: "Cultivo",  group_keys: global.item_groups.crop_any  },
            { key: "herb_any", qty: 10, name: "Hierba",   group_keys: global.item_groups.herb_any  },
            { key: "goat_milk_reg", qty: 1 }
          ]},
        { item_key: "potion_animals",
          price_money: 0, price_items: [
            { key: "egg_any",      qty: 3,  name: "Huevo",   group_keys: global.item_groups.egg_any      },
            { key: "mushroom_any", qty: 10, name: "Hongo",   group_keys: global.item_groups.mushroom_any },
            { key: "fish_any",     qty: 5,  name: "Pescado", group_keys: global.item_groups.fish_any     }
          ]},
        { item_key: "potion_strength",
          price_money: 0, price_items: [
            { key: "crop_any",     qty: 10, name: "Cultivo", group_keys: global.item_groups.crop_any     },
            { key: "mushroom_any", qty: 10, name: "Hongo",   group_keys: global.item_groups.mushroom_any },
            { key: "steak",        qty: 1 }
          ]},
    ]
};

global.potion_data = {
    potion_energy:   { name: "Poción de Energía",  type: ITEM_TYPE.POTION, sprite: sprite_potions, subimg: 0, sellable: true, droppable: true, base_sell_price: 80  },
    potion_health:   { name: "Poción de Salud",    type: ITEM_TYPE.POTION, sprite: sprite_potions, subimg: 1, sellable: true, droppable: true, base_sell_price: 100 },
    potion_animals:  { name: "Poción de Animales", type: ITEM_TYPE.POTION, sprite: sprite_potions, subimg: 2, sellable: true, droppable: true, base_sell_price: 120 },
    potion_strength: { name: "Poción de Fuerza",   type: ITEM_TYPE.POTION, sprite: sprite_potions, subimg: 3, sellable: true, droppable: true, base_sell_price: 150 },
};

// --- DATOS DE PESCA ---
global.fish_data = {};
var _fish = global.fish_data;

// Peces (frames 0-44) — base_sell_price es precio POR KG; weight_min/max en kg
_fish[$ "fish_00"] = { name: "Salmón",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 0,  rarity: 20, base_sell_price: 9,   weight_min: 1.5,   weight_max: 4.0    };
_fish[$ "fish_01"] = { name: "Trucha Arcoíris",   seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 1,  rarity: 20, base_sell_price: 12,   weight_min: 0.8,   weight_max: 3.0    };
_fish[$ "fish_02"] = { name: "Pez Sol",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 2,  rarity: 50, base_sell_price: 17,   weight_min: 0.2,   weight_max: 0.8    };
_fish[$ "fish_03"] = { name: "Pez Gato",           seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 3,  rarity: 50, base_sell_price: 9,   weight_min: 0.3,   weight_max: 1.2    };
_fish[$ "fish_04"] = { name: "Carpa Dorada",       seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 4,  rarity: 50, base_sell_price: 5,   weight_min: 0.8,   weight_max: 3.0    };
_fish[$ "fish_05"] = { name: "Lubina",             seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 5,  rarity: 20, base_sell_price: 8,   weight_min: 1.0,   weight_max: 4.0    };
_fish[$ "fish_06"] = { name: "Perca",              seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 6,  rarity: 50, base_sell_price: 11,   weight_min: 0.2,   weight_max: 1.0    };
_fish[$ "fish_07"] = { name: "Esturión",           seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 7,  rarity: 7,  base_sell_price: 7,    weight_min: 3.0,   weight_max: 12.0  };
_fish[$ "fish_08"] = { name: "Anguila",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 8,  rarity: 7,  base_sell_price: 29,   weight_min: 0.5,   weight_max: 3.0    };
_fish[$ "fish_09"] = { name: "Pez Espada",         seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 9,  rarity: 7,  base_sell_price: 5,    weight_min: 5.0,   weight_max: 20.0   };
_fish[$ "fish_10"] = { name: "Atún",               seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 10, rarity: 20, base_sell_price: 7,    weight_min: 3.0,   weight_max: 12.0   };
_fish[$ "fish_11"] = { name: "Bacalao",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 11, rarity: 50, base_sell_price: 7,   weight_min: 0.8,   weight_max: 2.5    };
_fish[$ "fish_12"] = { name: "Sardina",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 12, rarity: 50, base_sell_price: 25,  weight_min: 0.05,  weight_max: 0.15   };
_fish[$ "fish_13"] = { name: "Boquerón",           seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 13, rarity: 50, base_sell_price: 20,  weight_min: 0.04,  weight_max: 0.12   };
_fish[$ "fish_14"] = { name: "Merluza",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 14, rarity: 50, base_sell_price: 6,   weight_min: 0.5,   weight_max: 2.5    };
_fish[$ "fish_15"] = { name: "Rodaballo",          seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 15, rarity: 20, base_sell_price: 9,   weight_min: 1.0,   weight_max: 5.0    };
_fish[$ "fish_16"] = { name: "Lenguado",           seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 16, rarity: 20, base_sell_price: 27,   weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_17"] = { name: "Besugo",             seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 17, rarity: 20, base_sell_price: 15,   weight_min: 0.5,   weight_max: 2.0    };
_fish[$ "fish_18"] = { name: "Mero",               seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 18, rarity: 20, base_sell_price: 6,   weight_min: 2.0,   weight_max: 8.0    };
_fish[$ "fish_19"] = { name: "Dorada",             seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 19, rarity: 20, base_sell_price: 15,   weight_min: 0.5,   weight_max: 3.0    };
_fish[$ "fish_20"] = { name: "Lubina de Roca",     seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 20, rarity: 20, base_sell_price: 11,   weight_min: 0.8,   weight_max: 3.0    };
_fish[$ "fish_21"] = { name: "Salmonete",          seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 21, rarity: 50, base_sell_price: 27,   weight_min: 0.2,   weight_max: 0.8    };
_fish[$ "fish_22"] = { name: "Caballa",            seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 22, rarity: 50, base_sell_price: 15,   weight_min: 0.2,   weight_max: 0.8    };
_fish[$ "fish_23"] = { name: "Jurel",              seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 23, rarity: 50, base_sell_price: 15,   weight_min: 0.2,   weight_max: 0.6    };
_fish[$ "fish_24"] = { name: "Bonito",             seasons: [SEASON.SPRING], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 24, rarity: 20, base_sell_price: 4,   weight_min: 2.0,   weight_max: 8.0    };
_fish[$ "fish_25"] = { name: "Pez Vela",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 25, rarity: 7,  base_sell_price: 8,    weight_min: 4.0,   weight_max: 15.0   };
_fish[$ "fish_26"] = { name: "Pez Martillo",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 26, rarity: 7,  base_sell_price: 6,    weight_min: 6.0,   weight_max: 25.0   };
_fish[$ "fish_27"] = { name: "Tiburón Blanco",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 27, rarity: 2,  base_sell_price: 7,    weight_min: 8.0,   weight_max: 30.0   };
_fish[$ "fish_28"] = { name: "Tiburón Ballena",    seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 28, rarity: 2,  base_sell_price: 10,   weight_min: 10.0,  weight_max: 40.0   };
_fish[$ "fish_29"] = { name: "Raya Látigo",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 29, rarity: 7,  base_sell_price: 6,   weight_min: 5.0,   weight_max: 20.0   };
_fish[$ "fish_30"] = { name: "Pez Globo",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 30, rarity: 7,  base_sell_price: 51,  weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_31"] = { name: "Pez León",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 31, rarity: 7,  base_sell_price: 54,  weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_32"] = { name: "Pez Cirujano",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 32, rarity: 20, base_sell_price: 40,  weight_min: 0.2,   weight_max: 1.0    };
_fish[$ "fish_33"] = { name: "Pez Ángel",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 33, rarity: 20, base_sell_price: 30,  weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_34"] = { name: "Pez Mariposa",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 34, rarity: 20, base_sell_price: 84,  weight_min: 0.1,   weight_max: 0.5    };
_fish[$ "fish_35"] = { name: "Pez Loro",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 35, rarity: 20, base_sell_price: 23,   weight_min: 0.5,   weight_max: 2.0    };
_fish[$ "fish_36"] = { name: "Pez Ballesta",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 36, rarity: 20, base_sell_price: 34,  weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_37"] = { name: "Pez Cofre",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 37, rarity: 20, base_sell_price: 68,  weight_min: 0.1,   weight_max: 0.5    };
_fish[$ "fish_38"] = { name: "Pez Trompeta",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 38, rarity: 7,  base_sell_price: 33,  weight_min: 0.5,   weight_max: 2.0    };
_fish[$ "fish_39"] = { name: "Pez Flauta",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 39, rarity: 7,  base_sell_price: 42,  weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_40"] = { name: "Pez Pipa",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 40, rarity: 7,  base_sell_price: 118,  weight_min: 0.1,   weight_max: 0.5    };
_fish[$ "fish_41"] = { name: "Pez Piedra",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 41, rarity: 20, base_sell_price: 19,   weight_min: 0.5,   weight_max: 2.0    };
_fish[$ "fish_42"] = { name: "Pez Escorpión",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 42, rarity: 7,  base_sell_price: 50,  weight_min: 0.3,   weight_max: 1.5    };
_fish[$ "fish_43"] = { name: "Pez Sapo",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 43, rarity: 20, base_sell_price: 15,   weight_min: 0.5,   weight_max: 2.5    };
_fish[$ "fish_44"] = { name: "Pez Diablo",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 44, rarity: 2,  base_sell_price: 12,   weight_min: 5.0,   weight_max: 20.0   };

// Delfines (frames 45-48)
_fish[$ "fish_45"] = { name: "Delfín Mular",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 45, rarity: 2,  base_sell_price: 9,    weight_min: 6.0,   weight_max: 25.0   };
_fish[$ "fish_46"] = { name: "Delfín Oceánico",    seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 46, rarity: 2,  base_sell_price: 16,   weight_min: 6.0,   weight_max: 25.0   };
_fish[$ "fish_47"] = { name: "Delfín Rosado",      seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 47, rarity: 1,  base_sell_price: 30,   weight_min: 5.0,   weight_max: 20.0   };
_fish[$ "fish_48"] = { name: "Delfín de Rápida",   seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 48, rarity: 2,  base_sell_price: 15,   weight_min: 5.0,   weight_max: 20.0   };

// Criaturas Marinas (frames 49-98)
_fish[$ "fish_49"] = { name: "Pulpo Gigante",          seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 49, rarity: 7,  base_sell_price: 15,  weight_min: 2.0,   weight_max: 10.0   };
_fish[$ "fish_50"] = { name: "Calamar Común",          seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 50, rarity: 50, base_sell_price: 34,  weight_min: 0.1,   weight_max: 0.5    };
_fish[$ "fish_51"] = { name: "Sepia",                  seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 51, rarity: 50, base_sell_price: 24,   weight_min: 0.2,   weight_max: 0.8    };
_fish[$ "fish_52"] = { name: "Nautilo",                seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 52, rarity: 2,  base_sell_price: 313,  weight_min: 0.3,   weight_max: 1.0    };
_fish[$ "fish_53"] = { name: "Cangrejo Real",          seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 53, rarity: 20, base_sell_price: 13,   weight_min: 1.5,   weight_max: 5.0    };
_fish[$ "fish_54"] = { name: "Langosta Espinosa",      seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 54, rarity: 7,  base_sell_price: 62,  weight_min: 0.5,   weight_max: 2.0    };
_fish[$ "fish_55"] = { name: "Bogavante",              seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 55, rarity: 7,  base_sell_price: 51,  weight_min: 0.5,   weight_max: 3.0    };
_fish[$ "fish_56"] = { name: "Cigala",                 seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 56, rarity: 20, base_sell_price: 92,  weight_min: 0.1,   weight_max: 0.4    };
_fish[$ "fish_57"] = { name: "Gamba Roja",             seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 57, rarity: 20, base_sell_price: 163,  weight_min: 0.05,  weight_max: 0.2    };
_fish[$ "fish_58"] = { name: "Langostino",             seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 58, rarity: 50, base_sell_price: 54,  weight_min: 0.1,   weight_max: 0.4    };
_fish[$ "fish_59"] = { name: "Camarón",                seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 59, rarity: 50, base_sell_price: 226,  weight_min: 0.01,  weight_max: 0.05   };
_fish[$ "fish_60"] = { name: "Centollo",               seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 60, rarity: 20, base_sell_price: 27,   weight_min: 0.5,   weight_max: 2.0    };
_fish[$ "fish_61"] = { name: "Nécora",                 seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 61, rarity: 20, base_sell_price: 87,  weight_min: 0.1,   weight_max: 0.4    };
_fish[$ "fish_62"] = { name: "Buey de Mar",            seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 62, rarity: 20, base_sell_price: 20,   weight_min: 0.8,   weight_max: 3.0    };
_fish[$ "fish_63"] = { name: "Percebe",                seasons: [SEASON.FALL], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 63, rarity: 7,  base_sell_price: 574, weight_min: 0.04,  weight_max: 0.12   };
_fish[$ "fish_64"] = { name: "Mejillón",               seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 64, rarity: 50, base_sell_price: 51,  weight_min: 0.05,  weight_max: 0.15   };
_fish[$ "fish_65"] = { name: "Almeja",                 seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 65, rarity: 50, base_sell_price: 68,  weight_min: 0.05,  weight_max: 0.15   };
_fish[$ "fish_66"] = { name: "Berberecho",             seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 66, rarity: 50, base_sell_price: 82,  weight_min: 0.02,  weight_max: 0.08   };
_fish[$ "fish_67"] = { name: "Ostra",                  seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 67, rarity: 20, base_sell_price: 102,  weight_min: 0.1,   weight_max: 0.3    };
_fish[$ "fish_68"] = { name: "Vieira",                 seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 68, rarity: 20, base_sell_price: 102,  weight_min: 0.1,   weight_max: 0.4    };
_fish[$ "fish_69"] = { name: "Caracol Marino",         seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 69, rarity: 50, base_sell_price: 56,  weight_min: 0.05,  weight_max: 0.25   };
_fish[$ "fish_70"] = { name: "Estrella de Mar",        seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 70, rarity: 50, base_sell_price: 58,  weight_min: 0.05,  weight_max: 0.3    };
_fish[$ "fish_71"] = { name: "Erizo de Mar",           seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 71, rarity: 20, base_sell_price: 63,  weight_min: 0.1,   weight_max: 0.5    };
_fish[$ "fish_72"] = { name: "Holoturia",              seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 72, rarity: 50, base_sell_price: 39,  weight_min: 0.05,  weight_max: 0.3    };
_fish[$ "fish_73"] = { name: "Medusa Melena de León",  seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 73, rarity: 7,  base_sell_price: 7,   weight_min: 3.0,   weight_max: 15.0   };
_fish[$ "fish_74"] = { name: "Carabela Portuguesa",    seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 74, rarity: 7,  base_sell_price: 49,  weight_min: 0.5,   weight_max: 3.0    };
_fish[$ "fish_75"] = { name: "Coral Rojo",             seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 75, rarity: 2,  base_sell_price: 148,  weight_min: 0.3,   weight_max: 2.0    };
_fish[$ "fish_76"] = { name: "Anémona de Mar",         seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 76, rarity: 20, base_sell_price: 80,  weight_min: 0.1,   weight_max: 0.5    };
_fish[$ "fish_77"] = { name: "Esponja",                seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 77, rarity: 50, base_sell_price: 29,   weight_min: 0.05,  weight_max: 0.3    };
_fish[$ "fish_78"] = { name: "Caballito de Mar",       seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 78, rarity: 7,  base_sell_price: 500, weight_min: 0.02,  weight_max: 0.06   };
_fish[$ "fish_79"] = { name: "Dragón de Mar",          seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 79, rarity: 7,  base_sell_price: 600, weight_min: 0.05,  weight_max: 0.2    };
_fish[$ "fish_80"] = { name: "Tortuga Verde",          seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 80, rarity: 2,  base_sell_price: 12,   weight_min: 5.0,   weight_max: 20.0   };
_fish[$ "fish_81"] = { name: "Tortuga Carey",          seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 81, rarity: 2,  base_sell_price: 18,   weight_min: 3.0,   weight_max: 15.0   };
_fish[$ "fish_82"] = { name: "Serpiente Marina",       seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 82, rarity: 7,  base_sell_price: 15,   weight_min: 2.0,   weight_max: 8.0    };
_fish[$ "fish_83"] = { name: "Manatí",                 seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 83, rarity: 1,  base_sell_price: 20,   weight_min: 8.0,   weight_max: 30.0   };
_fish[$ "fish_84"] = { name: "Dugongo",                seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 84, rarity: 1,  base_sell_price: 25,   weight_min: 8.0,   weight_max: 25.0   };
_fish[$ "fish_85"] = { name: "Foca Monje",             seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 85, rarity: 1,  base_sell_price: 20,   weight_min: 8.0,   weight_max: 25.0   };
_fish[$ "fish_86"] = { name: "León Marino",            seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 86, rarity: 2,  base_sell_price: 15,   weight_min: 6.0,   weight_max: 20.0   };
_fish[$ "fish_87"] = { name: "Morsa",                  seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 87, rarity: 2,  base_sell_price: 6,    weight_min: 10.0,  weight_max: 40.0   };
_fish[$ "fish_88"] = { name: "Narval",                 seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 88, rarity: 1,  base_sell_price: 20,   weight_min: 10.0,  weight_max: 40.0   };
_fish[$ "fish_89"] = { name: "Beluga",                 seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 89, rarity: 1,  base_sell_price: 15,   weight_min: 10.0,  weight_max: 35.0   };
_fish[$ "fish_90"] = { name: "Orca",                   seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 90, rarity: 1,  base_sell_price: 12,   weight_min: 15.0,  weight_max: 60.0   };
_fish[$ "fish_91"] = { name: "Cachalote",              seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 91, rarity: 1,  base_sell_price: 18,   weight_min: 20.0,  weight_max: 80.0   };
_fish[$ "fish_92"] = { name: "Ballena Azul",           seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 92, rarity: 1,  base_sell_price: 25,   weight_min: 25.0,  weight_max: 100.0  };
_fish[$ "fish_93"] = { name: "Ballena Jorobada",       seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 93, rarity: 1,  base_sell_price: 18,   weight_min: 20.0,  weight_max: 80.0   };
_fish[$ "fish_94"] = { name: "Ballena Franca",         seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 94, rarity: 1,  base_sell_price: 18,   weight_min: 20.0,  weight_max: 80.0   };
_fish[$ "fish_95"] = { name: "Rorcual",                seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 95, rarity: 1,  base_sell_price: 12,   weight_min: 15.0,  weight_max: 60.0   };
_fish[$ "fish_96"] = { name: "Cachalote Pigmeo",       seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 96, rarity: 2,  base_sell_price: 12,   weight_min: 8.0,   weight_max: 30.0   };
_fish[$ "fish_97"] = { name: "Vaquita Marina",         seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 97, rarity: 1,  base_sell_price: 150,  weight_min: 3.0,   weight_max: 10.0   };
_fish[$ "fish_98"] = { name: "Pez Desconocido",        seasons: [SEASON.WINTER], type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 98, rarity: 50, base_sell_price: 34,  weight_min: 0.05,  weight_max: 0.15   };

var _fk = variable_struct_get_names(global.fish_data);
for (var _fi2 = 0; _fi2 < array_length(_fk); _fi2++) {
    global.fish_data[$ _fk[_fi2]].base_sell_price = round(global.fish_data[$ _fk[_fi2]].base_sell_price * 0.9);
}

global.fish_pool = [];
global.fish_pool[SEASON.SPRING] = [];
global.fish_pool[SEASON.SUMMER] = [];
global.fish_pool[SEASON.FALL]   = [];
global.fish_pool[SEASON.WINTER] = [];
var _fkeys = variable_struct_get_names(global.fish_data);
for (var _fi = 0; _fi < array_length(_fkeys); _fi++) {
    var _fd = global.fish_data[$ _fkeys[_fi]];
    for (var _si = 0; _si < array_length(_fd.seasons); _si++) {
        var _s = _fd.seasons[_si];
        if (_s >= SEASON.SPRING && _s <= SEASON.WINTER) {
            repeat (_fd.rarity) { array_push(global.fish_pool[_s], _fkeys[_fi]); }
        }
    }
}

// --- DATOS DE INSECTOS ---
global.insect_data = {};
var _ins = global.insect_data;

// Insectos básicos
_ins[$ "insect_ant"]           = { name: "Hormiga",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_ant,           subimg: 0, rarity: 50, base_sell_price: 2  };
_ins[$ "insect_caterpillar"]   = { name: "Oruga",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_caterpillar,   subimg: 0, rarity: 50, base_sell_price: 3  };
_ins[$ "insect_cricket"]       = { name: "Grillo",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_cricket,       subimg: 0, rarity: 50, base_sell_price: 2  };
_ins[$ "insect_cicada"]        = { name: "Cigarra",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_cicada,        subimg: 0, rarity: 20, base_sell_price: 6  };
_ins[$ "insect_beach_hopper"]  = { name: "Pulga de Mar",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_beach_hopper,  subimg: 0, rarity: 20, base_sell_price: 5  };
_ins[$ "insect_bee"]           = { name: "Abeja",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_bees,          subimg: 0, rarity: 20, base_sell_price: 7  };

// Caracoles
_ins[$ "insect_snail_black"]   = { name: "Caracol Negro",    type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_black,   subimg: 0, rarity: 50, base_sell_price: 3  };
_ins[$ "insect_snail_green"]   = { name: "Caracol Verde",    type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_green,   subimg: 0, rarity: 50, base_sell_price: 3  };
_ins[$ "insect_snail_red"]     = { name: "Caracol Rojo",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_red,     subimg: 0, rarity: 50, base_sell_price: 4  };
_ins[$ "insect_snail_blue"]    = { name: "Caracol Azul",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_blue,    subimg: 0, rarity: 20, base_sell_price: 8  };
_ins[$ "insect_snail_pink"]    = { name: "Caracol Rosa",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_pink,    subimg: 0, rarity: 20, base_sell_price: 9  };
_ins[$ "insect_snail_dark"]    = { name: "Caracol Oscuro",   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_dark,    subimg: 0, rarity: 20, base_sell_price: 10 };
_ins[$ "insect_snail_purple"]  = { name: "Caracol Morado",   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_purple,  subimg: 0, rarity: 7,  base_sell_price: 15 };
_ins[$ "insect_snail_golden"]  = { name: "Caracol Dorado",   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_golden,  subimg: 0, rarity: 2,  base_sell_price: 40 };

// Mariposas y polillas
_ins[$ "insect_butterfly_common"]          = { name: "Mariposa Común",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_common,          subimg: 0, rarity: 50, base_sell_price: 3  };
_ins[$ "insect_butterfly_wood_white"]      = { name: "Mariposa Blanca",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_wood_white,      subimg: 0, rarity: 50, base_sell_price: 3  };
_ins[$ "insect_butterfly_cabbage_white"]   = { name: "Mariposa de la Col",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_cabbage_white,   subimg: 0, rarity: 50, base_sell_price: 3  };
_ins[$ "insect_butterfly_orange_tip"]      = { name: "Aurora",                   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_orange_tip,      subimg: 0, rarity: 50, base_sell_price: 4  };
_ins[$ "insect_butterfly_cloudless_sulphur"] = { name: "Mariposa Azufre",        type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_cloudless_sulphur, subimg: 0, rarity: 20, base_sell_price: 8 };
_ins[$ "insect_butterfly_migrant"]         = { name: "Mariposa Migrante",        type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_migrant,         subimg: 0, rarity: 20, base_sell_price: 9  };
_ins[$ "insect_butterfly_glider"]          = { name: "Mariposa Planeadora",      type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_glider,          subimg: 0, rarity: 20, base_sell_price: 10  };
_ins[$ "insect_butterfly_hairstreak"]      = { name: "Mariposa Listada",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_hairstreak,      subimg: 0, rarity: 20, base_sell_price: 10  };
_ins[$ "insect_butterfly_peacock_pansy"]   = { name: "Mariposa Pavo Real",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_peacock_pansy,   subimg: 0, rarity: 20, base_sell_price: 11  };
_ins[$ "insect_butterfly_red_admiral"]     = { name: "Almirante Rojo",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_red_admiral,     subimg: 0, rarity: 20, base_sell_price: 12  };
_ins[$ "insect_butterfly_eggfly"]          = { name: "Mariposa Huevo",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_eggfly,          subimg: 0, rarity: 20, base_sell_price: 10  };
_ins[$ "insect_butterfly_diadem"]          = { name: "Mariposa Diadema",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_diadem,          subimg: 0, rarity: 7,  base_sell_price: 18 };
_ins[$ "insect_butterfly_azure"]           = { name: "Mariposa Azur",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_azure,           subimg: 0, rarity: 7,  base_sell_price: 20 };
_ins[$ "insect_butterfly_european_peacock"] = { name: "Pavo Real Europeo",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_european_peacock, subimg: 0, rarity: 7, base_sell_price: 20 };
_ins[$ "insect_butterfly_cinnabar_moth"]   = { name: "Polilla Cinabrio",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_cinnabar_moth,   subimg: 0, rarity: 7,  base_sell_price: 20 };
_ins[$ "insect_butterfly_io_moth"]         = { name: "Polilla Io",               type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_io_moth,         subimg: 0, rarity: 7,  base_sell_price: 22 };
_ins[$ "insect_butterfly_sheep_moth"]      = { name: "Polilla Oveja",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_sheep_moth,      subimg: 0, rarity: 7,  base_sell_price: 20 };
_ins[$ "insect_butterfly_luna_moth"]       = { name: "Polilla Luna",             type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_luna_moth,       subimg: 0, rarity: 7,  base_sell_price: 25 };
_ins[$ "insect_butterfly_silkmoth"]        = { name: "Polilla de Seda",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_silkmoth,        subimg: 0, rarity: 7,  base_sell_price: 22 };
_ins[$ "insect_butterfly_monarch"]         = { name: "Mariposa Monarca",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_monarch,         subimg: 0, rarity: 7,  base_sell_price: 22 };
_ins[$ "insect_butterfly_morpho"]          = { name: "Morpho Azul",              type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_morpho,          subimg: 0, rarity: 2,  base_sell_price: 35 };
_ins[$ "insect_butterfly_glasswing"]       = { name: "Mariposa Alas de Cristal", type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_glasswing,       subimg: 0, rarity: 2,  base_sell_price: 40 };
_ins[$ "insect_butterfly_ulysses"]         = { name: "Mariposa Ulises",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_ulysses,         subimg: 0, rarity: 2,  base_sell_price: 45 };
_ins[$ "insect_butterfly_emperor"]         = { name: "Mariposa Emperador",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_emperor,         subimg: 0, rarity: 2,  base_sell_price: 40 };
_ins[$ "insect_butterfly_periander_metalmark"] = { name: "Metalmark Periander",  type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_periander_metalmark, subimg: 0, rarity: 2, base_sell_price: 35 };
_ins[$ "insect_butterfly_birdwing"]        = { name: "Alas de Pájaro",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_birdwing,        subimg: 0, rarity: 1,  base_sell_price: 65 };
_ins[$ "insect_butterfly_goliath_birdwing"] = { name: "Goliat Alas de Pájaro",  type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_goliath_birdwing, subimg: 0, rarity: 1, base_sell_price: 80 };

var _ik = variable_struct_get_names(global.insect_data);
for (var _ii2 = 0; _ii2 < array_length(_ik); _ii2++) {
    global.insect_data[$ _ik[_ii2]].base_sell_price = round(global.insect_data[$ _ik[_ii2]].base_sell_price * 0.9);
}

global.insect_pool = [];
var _ikeys = variable_struct_get_names(global.insect_data);
for (var _ii = 0; _ii < array_length(_ikeys); _ii++) {
    var _id = global.insect_data[$ _ikeys[_ii]];
    repeat (_id.rarity) { array_push(global.insect_pool, _ikeys[_ii]); }
}
// --- DATOS DE PRODUCTOS ANIMALES ---
global.animal_product_data = {};
var _ap = global.animal_product_data;

_ap[$ "honey"]                      = { name: "Miel",                      type: ITEM_TYPE.MATERIAL, sprite: sprite_animal_products, subimg: 0,  base_sell_price: 34 };
_ap[$ "cheese"]                     = { name: "Queso",                     type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 1,  base_sell_price: 54 };
_ap[$ "butter"]                     = { name: "Mantequilla",               type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 2,  base_sell_price: 37 };
_ap[$ "mayonaise"]                  = { name: "Mayonesa",                  type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 3,  base_sell_price: 65 };
_ap[$ "egg_chicken_white_large"]    = { name: "Huevo Blanco Grande",       type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 4,  base_sell_price: 17  };
_ap[$ "egg_chicken_brown_large"]    = { name: "Huevo Colorado Grande",      type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 5,  base_sell_price: 17  };
_ap[$ "egg_chicken_white_reg"]      = { name: "Huevo Blanco",              type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 6,  base_sell_price: 8  };
_ap[$ "egg_chicken_brown_reg"]      = { name: "Huevo Colorado",             type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 7,  base_sell_price: 8  };
_ap[$ "egg_duck_large"]             = { name: "Huevo de Pato Grande",      type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 8,  base_sell_price: 26  };
_ap[$ "egg_duck_reg"]               = { name: "Huevo de Pato",             type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 9,  base_sell_price: 14  };
_ap[$ "milk_reg"]                   = { name: "Leche",                     type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 10, base_sell_price: 20  };
_ap[$ "milk_large"]                 = { name: "Leche Grande",              type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 11, base_sell_price: 37 };
_ap[$ "goat_milk_reg"]              = { name: "Leche de Cabra",            type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 12, base_sell_price: 27  };
_ap[$ "goat_milk_large"]             = { name: "Leche de Cabra Grande",     type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 13, base_sell_price: 51 };
_ap[$ "chicken_leg"]                = { name: "Muslo de Pollo",            type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 14, base_sell_price: 14  };
_ap[$ "egg_chicken_large_generic"]  = { name: "Huevo de Gallina Grande",   type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 15, base_sell_price: 17  };
_ap[$ "wool"]                       = { name: "Lana",                      type: ITEM_TYPE.MATERIAL, sprite: sprite_animal_products, subimg: 16, base_sell_price: 41 };
_ap[$ "goat_cheese"]                = { name: "Queso de Cabra",            type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 17, base_sell_price: 68 };
_ap[$ "steak"]                      = { name: "Filete",                    type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 18, base_sell_price: 51 };
_ap[$ "bacon"]                      = { name: "Tocino",                    type: ITEM_TYPE.FOOD,     sprite: sprite_animal_products, subimg: 19, base_sell_price: 41 };

// --- DATOS DE MATERIALES DE COSTURA ---
// sprite_crafting_material: 9 tipos × 14 colores = 126 frames
// Orden de colores (subimg dentro del tipo): 0=Rojo 1=Naranja 2=Amarillo 3=Verde 4=Azul
//   5=Lila 6=Morado 7=Turquesa 8=Rosa 9=Lima 10=Ámbar 11=Café 12=Negro 13=Blanco
global.crafting_material_data = {};
var _cm = global.crafting_material_data;

var _cm_colors = [
    ["red",       "Rojo"],
    ["orange",    "Naranja"],
    ["yellow",    "Amarillo"],
    ["green",     "Verde"],
    ["blue",      "Azul"],
    ["lilac",     "Lila"],
    ["purple",    "Morado"],
    ["turquoise", "Turquesa"],
    ["pink",      "Rosa"],
    ["lime",      "Lima"],
    ["amber",     "Ámbar"],
    ["brown",     "Café"],
    ["black",     "Negro"],
    ["white",     "Blanco"],
];

var _cm_types = [
    // [key_prefix, nombre_es, sell_price]
    ["thread",      "Hilo",           5],
    ["cloth",       "Tela",           10],
    ["string",      "Cuerda",         3],
    ["leather",     "Cuero",          15],
    ["pelt",        "Piel",           14],
    ["feathers",    "Plumas",         9],
    ["rabbit_pelt", "Piel de Conejo", 12],
    ["yarn",        "Estambre",       9],
    ["cow_hide",    "Cuero de Vaca",  17],
];

var _num_colors = array_length(_cm_colors);
for (var _mi = 0; _mi < array_length(_cm_types); _mi++) {
    var _mtype = _cm_types[_mi];
    for (var _ci = 0; _ci < _num_colors; _ci++) {
        var _ccolor = _cm_colors[_ci];
        _cm[$ _mtype[0] + "_" + _ccolor[0]] = {
            name:            _mtype[1] + " " + _ccolor[1],
            type:            ITEM_TYPE.MATERIAL,
            sprite:          sprite_crafting_material,
            subimg:          _mi * _num_colors + _ci,
            base_sell_price: _mtype[2]
        };
    }
}

// --- TINTES ---
global.dye_data = {};
var _dd = global.dye_data;
for (var _di = 0; _di < _num_colors; _di++) {
    var _dc = _cm_colors[_di];
    _dd[$ "dye_" + _dc[0]] = {
        name: "Tinte " + _dc[1],
        type: ITEM_TYPE.DYE,
        sprite: sprite_dyes,
        subimg: _di,
        base_sell_price: 25
    };
}

// --- DATOS DE COLECCION DE ENEMIGOS ---
global.enemy_collection_data = {};
var __ecd = global.enemy_collection_data;
var __enemy_keys = variable_struct_get_names(global.enemy_data);
for (var __eki = 0; __eki < array_length(__enemy_keys); __eki++) {
    var __ek = __enemy_keys[__eki];
    var __ed = global.enemy_data[$ __ek];
    var __espr = variable_struct_exists(__ed, "sprite") ? __ed.sprite : __ed.sprite_idle;
    __ecd[$ __ek] = {
        name: __ed.name,
        sprite: __espr,
        subimg: 0,
        base_sell_price: 0
    };
}

// --- DATOS DE COLECCION DE ANIMALES SALVAJES ---
global.wild_animal_collection_data = {};
var __wacd = global.wild_animal_collection_data;
var __wa_keys = variable_struct_get_names(global.wild_animal_data);
for (var __wki = 0; __wki < array_length(__wa_keys); __wki++) {
    var __wk = __wa_keys[__wki];
    var __wd = global.wild_animal_data[$ __wk];
    __wacd[$ __wk] = {
        name: __wd.name,
        sprite: __wd.sprite,
        subimg: 0,
        base_sell_price: 0
    };
}

// --- DATOS DE COLECCION DE ANIMALES DE GRANJA ---
global.farm_animal_collection_data = {};
var __facd = global.farm_animal_collection_data;
var __fa_keys = variable_struct_get_names(global.animal_data);
var __fa_names = {
    chicken: "Gallina",
    cow: "Vaca",
    duck: "Pato",
    goat: "Cabra",
    ostrich: "Avestruz",
    pig: "Cerdo",
    sheep: "Oveja"
};
for (var __fki = 0; __fki < array_length(__fa_keys); __fki++) {
    var __fk = __fa_keys[__fki];
    var __fad = global.animal_data[$ __fk];
    var __fspr = asset_get_index("sprite_" + __fk + "_" + __fad.variants[0]);
    if (__fspr == -1) __fspr = sprite_chicken_white;
    __facd[$ "farm_" + __fk] = {
        name: __fa_names[$ __fk],
        sprite: __fspr,
        subimg: 0,
        base_sell_price: 0
    };
}

global.cave_repopulate = {
    cave_1: true,
    cave_2: true,
    cave_3: true,
    cave_4: true,
    cave_5: true,
    cave_6: true,
};

global.collected_items = {};
global.bears_killed = 0;
global.bear_unlocked = false;

// --- DATOS DE MÁQUINAS ---
global.machine_data = {
    curtidora: {
        name: "Curtidora",
        sprite: sprite_machine_curtidora,
        anim_frames: 3,
        process_time: 600,
        preserve_color: true,
        color_inputs: ["pelt", "cow_hide", "rabbit_pelt"],
        color_output: "leather"
    },
    telar: {
        name: "Telar",
        sprite: sprite_machine_telar,
        anim_frames: 7,
        process_time: 600,
        preserve_color: true,
        color_inputs: ["yarn", "thread"],
        color_outputs: ["thread", "cloth"]
    },
    mantequillera: {
        name: "Mantequillera",
        sprite: sprite_machine_mantequillera,
        anim_frames: 3,
        process_time: 480,
        preserve_color: false,
        recipes: [
            { input: "milk_reg", output: "butter", qty: 1 },
            { input: "milk_large", output: "butter", qty: 2 },
            { input: "egg_chicken_white_reg", output: "mayonaise", qty: 1 },
            { input: "egg_chicken_brown_reg", output: "mayonaise", qty: 1 },
            { input: "egg_chicken_white_large", output: "mayonaise", qty: 2 },
            { input: "egg_chicken_brown_large", output: "mayonaise", qty: 2 },
            { input: "egg_duck_reg", output: "mayonaise", qty: 1 },
            { input: "egg_duck_large", output: "mayonaise", qty: 2 },
            { input: "egg_chicken_large_generic", output: "mayonaise", qty: 2 }
        ]
    },
    mermeladora: {
        name: "Mermeladora",
        sprite: sprite_machine_mermeladora,
        anim_frames: 3,
        process_time: 900,
        preserve_color: false,
        recipe_type: "fruit_to_jam"
    },
    prensa_queso: {
        name: "Prensa de Queso",
        sprite: sprite_machine_prensa_queso,
        anim_frames: 4,
        process_time: 720,
        preserve_color: false,
        recipes: [
            { input: "milk_reg",        output: "cheese",      qty: 1, weight_min: 0.3, weight_max: 0.5 },
            { input: "milk_large",      output: "cheese",      qty: 1, weight_min: 0.5, weight_max: 1.0 },
            { input: "goat_milk_reg",   output: "goat_cheese", qty: 1, weight_min: 0.3, weight_max: 0.5 },
            { input: "goat_milk_large", output: "goat_cheese", qty: 1, weight_min: 0.5, weight_max: 1.0 }
        ]
    },
    horno: {
        name: "Horno",
        sprite: sprite_machine_horno,
        anim_frames: 4,
        process_time: 1200,
        preserve_color: false,
        recipes: [
            { input: "wood", output: "coal", qty: 1 },
            { input: "ore_bronce", output: "bar_bronce", qty: 1 },
            { input: "ore_plata", output: "bar_plata", qty: 1 },
            { input: "ore_oro", output: "bar_oro", qty: 1 },
            { input: "ore_broncastanio", output: "bar_broncastanio", qty: 1 },
            { input: "ore_chubestanio", output: "bar_chubestanio", qty: 1 },
            { input: "ore_picastanio", output: "bar_picastanio", qty: 1 },
            { input: "ore_hitlerstanio", output: "bar_hitlerstanio", qty: 1 },
            { input: "ore_vitolanio", output: "bar_vitolanio", qty: 1 }
        ]
    },
    colmena: {
        name: "Colmena",
        sprite: sprite_machine_colmena,
        anim_frames: 6,
        process_time: 3600,
        preserve_color: false,
        passive: true,
        output: "honey",
        output_qty: 1
    }
};

function scr_match_machine_recipe(_machine_type, _item_key) {
    var _md = global.machine_data[$ _machine_type];
    if (_md == undefined) return undefined;

    if (_md.preserve_color) {
        for (var _pi = 0; _pi < array_length(_md.color_inputs); _pi++) {
            var _prefix = _md.color_inputs[_pi] + "_";
            if (string_starts_with(_item_key, _prefix)) {
                var _suffix = string_copy(_item_key, string_length(_prefix) + 1, string_length(_item_key));
                var _out_prefix = variable_struct_exists(_md, "color_outputs") ? _md.color_outputs[_pi] : _md.color_output;
                return { output: _out_prefix + "_" + _suffix, qty: 1 };
            }
        }
        return undefined;
    }

    if (variable_struct_exists(_md, "recipe_type") && _md.recipe_type == "fruit_to_jam") {
        if (variable_struct_exists(global.crop_data, _item_key)) {
            var _jam_key = "jam_" + _item_key;
            if (variable_struct_exists(global.jam_data, _jam_key)) {
                return { output: _jam_key, qty: 1 };
            }
        }
        return undefined;
    }

    if (variable_struct_exists(_md, "recipes")) {
        for (var _ri = 0; _ri < array_length(_md.recipes); _ri++) {
            var _r = _md.recipes[_ri];
            if (_r.input == _item_key) {
                return { output: _r.output, qty: _r.qty };
            }
        }
    }

    return undefined;
}

function scr_is_outdoor_room() {
    var _rn = room_get_name(room);
    return (_rn == "farm" || _rn == "forest" || _rn == "town" || _rn == "road_to_cave");
}
