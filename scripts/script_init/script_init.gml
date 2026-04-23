/*
    Veredas Dream - Script de Inicialización
    Define enums y estructuras de datos globales.
*/

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
    FLEEING
}

global.animal_data = {
    chicken: { move_speed: 1.0 },
    duck:    { move_speed: 0.9 },
    ostrich: { move_speed: 0.8 },
    goat:    { move_speed: 0.7 },
    pig:     { move_speed: 0.6 },
    sheep:   { move_speed: 0.55 },
    cow:     { move_speed: 0.5 }
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
    INSECT      // Insectos capturados con la red
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
    cherry_seeds:       { name: "Semilla de Cereza",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 0,   growth_time: 6, crop_base_name: "cherry",       base_buy_price: 30, base_sell_price: 15, is_fruit_tree: true },
    apricot_seeds:      { name: "Semilla de Chabacano",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 8,   growth_time: 6, crop_base_name: "apricot",      base_buy_price: 25, base_sell_price: 12, is_fruit_tree: true },
    strawberry_seeds:   { name: "Semilla de Fresa",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 16,  growth_time: 6, crop_base_name: "strawberry",   base_buy_price: 40, base_sell_price: 20 },
    spring_onion_seeds: { name: "Semilla de Cebolleta",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 24,  growth_time: 6, crop_base_name: "spring_onion", base_buy_price: 10, base_sell_price: 5 },
    potato_seeds:       { name: "Semilla de Papa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 32,  growth_time: 6, crop_base_name: "potato",       base_buy_price: 20, base_sell_price: 10 },
    onion_seeds:        { name: "Semilla de Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 40,  growth_time: 6, crop_base_name: "onion",        base_buy_price: 15, base_sell_price: 7 },
    carrot_seeds:       { name: "Semilla de Zanahoria",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 48,  growth_time: 6, crop_base_name: "carrot",       base_buy_price: 15, base_sell_price: 7 },
    blueberry_seeds:    { name: "Semilla de Mora Azul",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 56,  growth_time: 6, crop_base_name: "blueberry",    base_buy_price: 50, base_sell_price: 25 },
    parsnip_seeds:      { name: "Semilla de Chirivia",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 64,  growth_time: 5, crop_base_name: "parsnip",      base_buy_price: 15, base_sell_price: 7 },
    cabbage_seeds:      { name: "Semilla de Repollo",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 72,  growth_time: 7, crop_base_name: "cabbage",      base_buy_price: 20, base_sell_price: 10 },
    cauliflower_seeds:  { name: "Semilla de Coliflor",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 80,  growth_time: 6, crop_base_name: "cauliflower",  base_buy_price: 30, base_sell_price: 15 },
    rice_seeds:         { name: "Semilla de Arroz",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 88,  growth_time: 6, crop_base_name: "rice",         base_buy_price: 25, base_sell_price: 12 },
    broccoli_seeds:     { name: "Semilla de Brocoli",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 96,  growth_time: 5, crop_base_name: "broccoli",     base_buy_price: 25, base_sell_price: 12 },
    asparagus_seeds:    { name: "Semilla de Esparrago",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 104, growth_time: 5, crop_base_name: "asparagus",    base_buy_price: 35, base_sell_price: 17 },

    // --- VERANO ---
    tomato_seeds:        { name: "Semilla de Tomate",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 144, growth_time: 5, crop_base_name: "tomato",       base_buy_price: 20, base_sell_price: 10 },
    banana_seeds:       { name: "Semilla de Platano",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 112, growth_time: 7, crop_base_name: "banana",      base_buy_price: 30, base_sell_price: 15, is_fruit_tree: true },
    orange_seeds:       { name: "Semilla de Naranja",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 120, growth_time: 7, crop_base_name: "orange",      base_buy_price: 35, base_sell_price: 17, is_fruit_tree: true },
    mango_seeds:        { name: "Semilla de Mango",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 128, growth_time: 8, crop_base_name: "mango",       base_buy_price: 40, base_sell_price: 20, is_fruit_tree: true },
    peach_seeds:        { name: "Semilla de Durazno",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 136, growth_time: 7, crop_base_name: "peach",       base_buy_price: 35, base_sell_price: 17, is_fruit_tree: true },
    orange_tree_seeds:  { name: "Semilla de Naranjo",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 120, growth_time: 6, crop_base_name: "orange",      base_buy_price: 50, base_sell_price: 25, is_fruit_tree: true },
    mango_tree_seeds:   { name: "Semilla de Mango",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 128, growth_time: 6, crop_base_name: "mango",       base_buy_price: 60, base_sell_price: 30, is_fruit_tree: true },
    peach_tree_seeds:   { name: "Semilla de Durazno",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 136, growth_time: 6, crop_base_name: "peach",       base_buy_price: 50, base_sell_price: 25, is_fruit_tree: true },
    sunflower_seeds:     { name: "Semilla de Girasol",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 152, growth_time: 6, crop_base_name: "sunflower",    base_buy_price: 15, base_sell_price: 7 },
    hot_pepper_seeds:    { name: "Semilla de Chile",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 160, growth_time: 7, crop_base_name: "hot_pepper",   base_buy_price: 30, base_sell_price: 15 },
    corn_seeds:          { name: "Semilla de Maiz",        seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 168, growth_time: 8, crop_base_name: "corn",       base_buy_price: 25, base_sell_price: 12 },
    green_pepper_seeds:  { name: "Semilla de Pimiento V.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 176, growth_time: 6, crop_base_name: "green_pepper", base_buy_price: 20, base_sell_price: 10 },
    melon_seeds:         { name: "Semilla de Melon",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 200, growth_time: 6, crop_base_name: "melon",        base_buy_price: 50, base_sell_price: 25 },
    watermelon_seeds:    { name: "Semilla de Sandia",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 208, growth_time: 8, crop_base_name: "watermelon",   base_buy_price: 50, base_sell_price: 25 },
    cucumber_seeds:      { name: "Semilla de Pepino",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 216, growth_time: 6, crop_base_name: "cucumber",     base_buy_price: 20, base_sell_price: 10 },
    eggplant_seeds:      { name: "Semilla de Berenjena",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 224, growth_time: 6, crop_base_name: "eggplant",     base_buy_price: 25, base_sell_price: 12 },
    pineapple_seeds:     { name: "Semilla de Pina",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 232, growth_time: 6, crop_base_name: "pineapple",    base_buy_price: 60, base_sell_price: 30 },
    green_beans_seeds:   { name: "Semilla de Ejote",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 240, growth_time: 7, crop_base_name: "green_beans",  base_buy_price: 25, base_sell_price: 12 },
    adzuki_bean_seeds:   { name: "Semilla de Frijol A.",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 248, growth_time: 7, crop_base_name: "adzuki_bean",  base_buy_price: 30, base_sell_price: 15 },
    wild_berry_seeds:    { name: "Semilla de Mora Silv.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 256, growth_time: 7, crop_base_name: "wild_berry",   base_buy_price: 20, base_sell_price: 10 },
    wheat_seeds:         { name: "Semilla de Trigo",       seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 264, growth_time: 6, crop_base_name: "wheat",       base_buy_price: 10, base_sell_price: 5 },
    aloe_seeds:          { name: "Semilla de Aloe",        seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 272, growth_time: 6, crop_base_name: "aloe",        base_buy_price: 30, base_sell_price: 15 },

    // --- OTONO ---
    beetroot_seeds:      { name: "Semilla de Betabel",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 6, crop_base_name: "beetroot",     base_buy_price: 25, base_sell_price: 12 },
    pumpkin_seeds:       { name: "Semilla de Calabaza",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 288, growth_time: 6, crop_base_name: "pumpkin",      base_buy_price: 30, base_sell_price: 15 },
    grapes_seeds:        { name: "Semilla de Uva",         seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 296, growth_time: 6, crop_base_name: "grapes",       base_buy_price: 40, base_sell_price: 20 },
    apple_seeds:         { name: "Semilla de Manzana",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 8, crop_base_name: "apple",        base_buy_price: 30, base_sell_price: 15, is_fruit_tree: true },
    apple_tree_seeds:    { name: "Semilla de Manzano",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 6, crop_base_name: "apple",        base_buy_price: 50, base_sell_price: 25, is_fruit_tree: true }
};

global.crop_data = {
    // --- PRIMAVERA ---
    cherry:       { name: "Cereza",       seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 2,   base_buy_price: 120, base_sell_price: 90, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    apricot:      { name: "Chabacano",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 10,  base_buy_price: 100, base_sell_price: 75, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    strawberry:   { name: "Fresa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 18,  base_buy_price: 150, base_sell_price: 110 },
    spring_onion: { name: "Cebolleta",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 26,  base_buy_price: 40,  base_sell_price: 30 },
    potato:       { name: "Papa",         seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 34,  base_buy_price: 80,  base_sell_price: 60 },
    onion:        { name: "Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 42,  base_buy_price: 60,  base_sell_price: 45 },
    carrot:       { name: "Zanahoria",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 50,  base_buy_price: 60,  base_sell_price: 45 },
    blueberry:    { name: "Mora Azul",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 58,  base_buy_price: 180, base_sell_price: 135 },
    parsnip:      { name: "Chirivia",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 66,  base_buy_price: 60,  base_sell_price: 45 },
    cabbage:      { name: "Repollo",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 74,  base_buy_price: 90,  base_sell_price: 65 },
    cauliflower:  { name: "Coliflor",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 82,  base_buy_price: 120, base_sell_price: 90 },
    rice:         { name: "Arroz",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 90,  base_buy_price: 100, base_sell_price: 75 },
    broccoli:     { name: "Brocoli",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 98,  base_buy_price: 100, base_sell_price: 75 },
    asparagus:    { name: "Esparragos",   seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 106, base_buy_price: 140, base_sell_price: 105 },

    // --- VERANO ---
    tomato:        { name: "Tomate",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 146, base_buy_price: 80,  base_sell_price: 60 },
    banana:       { name: "Platano",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 114, base_buy_price: 120, base_sell_price: 90, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    orange:       { name: "Naranja",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 122, base_buy_price: 140, base_sell_price: 105, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    mango:        { name: "Mango",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 130, base_buy_price: 160, base_sell_price: 120, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    peach:        { name: "Durazno",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 139, base_buy_price: 140, base_sell_price: 105, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 },
    sunflower:     { name: "Girasol",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 154, base_buy_price: 60,  base_sell_price: 45 },
    hot_pepper:    { name: "Chile Picante",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 162, base_buy_price: 120, base_sell_price: 90 },
    corn:          { name: "Maiz",           seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 170, base_buy_price: 100, base_sell_price: 75 },
    green_pepper:  { name: "Pimiento Verde", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 178, base_buy_price: 80,  base_sell_price: 60 },
    melon:         { name: "Melon",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 202, base_buy_price: 200, base_sell_price: 150 },
    watermelon:    { name: "Sandia",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 210, base_buy_price: 200, base_sell_price: 150 },
    cucumber:      { name: "Pepino",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 218, base_buy_price: 80,  base_sell_price: 60 },
    eggplant:      { name: "Berenjena",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 226, base_buy_price: 100, base_sell_price: 75 },
    pineapple:     { name: "Pina",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 234, base_buy_price: 240, base_sell_price: 180 },
    green_beans:   { name: "Ejote",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 242, base_buy_price: 100, base_sell_price: 75 },
    adzuki_bean:   { name: "Frijol Adzuki",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 250, base_buy_price: 120, base_sell_price: 90 },
    wild_berry:    { name: "Mora Silvestre", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 258, base_buy_price: 80,  base_sell_price: 60 },
    wheat:         { name: "Trigo",          seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 266, base_buy_price: 40,  base_sell_price: 30 },
    aloe:          { name: "Aloe",           seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 274, base_buy_price: 120, base_sell_price: 90 },

    // --- OTONO ---
     beetroot:      { name: "Betabel",  seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 282, base_buy_price: 100, base_sell_price: 75 },
     pumpkin:       { name: "Calabaza", seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 290, base_buy_price: 120, base_sell_price: 90 },
     grapes:        { name: "Uva",      seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 298, base_buy_price: 150, base_sell_price: 110 },
    apple:         { name: "Manzana",  seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 282, base_buy_price: 120, base_sell_price: 90, is_fruit_tree: true, sprite_width: 32, sprite_height: 48 }
};

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
    
    sword: { 
        name: "Espada",      
        type: ITEM_TYPE.TOOL,
        tool_type: TOOL_TYPE.SWORD,         
        sprite: sprite_tools_v2, 
        subimg: 2,
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
    
    bow: { 
        name: "Arco",        
        type: ITEM_TYPE.TOOL,
        tool_type: TOOL_TYPE.BOW,         
        sprite: sprite_tools, 
        subimg: 4,
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
        subimg: 55,
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
        subimg: 46,
        sellable: false,
        droppable: false,

        quality: QUALITY.OXIDADO,
        level: QUALITY.OXIDADO + 1
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
        sellable: true,
        droppable: true,
        base_buy_price: 100,
        base_sell_price: 50
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
    }
};

// --- DATOS DE RECOLECCIÓN DEL BOSQUE ---
// Sell prices by rarity: 1=5, 2=12, 3=25, 4=60, 5=150
global.forage_data = {};
var _fd = global.forage_data;

// Mushrooms (subimg 0–77)
_fd[$ "forage_m00"] = { name: "Champiñón de Campo",      subimg: 0,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m01"] = { name: "Boleto Noble",             subimg: 1,  rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m02"] = { name: "Níscalo de Pinar",         subimg: 2,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m03"] = { name: "Amanita de los Césares",   subimg: 3,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m04"] = { name: "Rebozuelo Dorado",         subimg: 4,  rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m05"] = { name: "Trompeta de la Muerte",    subimg: 5,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m06"] = { name: "Seta de Cardo",            subimg: 6,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m07"] = { name: "Morilla de Primavera",     subimg: 7,  rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m08"] = { name: "Trufa Negra",              subimg: 8,  rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 150 };
_fd[$ "forage_m09"] = { name: "Seta de San Jorge",        subimg: 9,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m10"] = { name: "Oreja de Judas",           subimg: 10, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m11"] = { name: "Hongo Blanco",             subimg: 11, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m12"] = { name: "Seta de Pino",             subimg: 12, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m13"] = { name: "Pie Azul",                 subimg: 13, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m14"] = { name: "Lengua de Gato",           subimg: 14, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m15"] = { name: "Carbonera de Otoño",       subimg: 15, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m16"] = { name: "Parasol Gigante",          subimg: 16, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m17"] = { name: "Seta de Chopo",            subimg: 17, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m18"] = { name: "Rebozuelo Naranja",        subimg: 18, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m19"] = { name: "Boleto Bayo",              subimg: 19, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m20"] = { name: "Seta de Mayo",             subimg: 20, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m21"] = { name: "Amanita Rojiza",           subimg: 21, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m22"] = { name: "Champiñón Silvestre",      subimg: 22, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m23"] = { name: "Seta de Ostra",            subimg: 23, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m24"] = { name: "Boleto Reticulado",        subimg: 24, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m25"] = { name: "Seta Engañosa",            subimg: 25, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m26"] = { name: "Níscalo de Sangre",        subimg: 26, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m27"] = { name: "Trompeta Amarilla",        subimg: 27, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m28"] = { name: "Seta de Brezo",            subimg: 28, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m29"] = { name: "Hongo Rojo",               subimg: 29, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m30"] = { name: "Seta de Encina",           subimg: 30, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m31"] = { name: "Boleto Real",              subimg: 31, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m32"] = { name: "Seta de Musgo",            subimg: 32, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m33"] = { name: "Amanita Citrina",          subimg: 33, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m34"] = { name: "Seta de Prados",           subimg: 34, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m35"] = { name: "Bola de Nieve",            subimg: 35, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m36"] = { name: "Seta de Haya",             subimg: 36, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m37"] = { name: "Boleto de Verano",         subimg: 37, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m38"] = { name: "Seta de Roble",            subimg: 38, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m39"] = { name: "Rebozuelo de Canal",       subimg: 39, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m40"] = { name: "Seta de Abeto",            subimg: 40, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m41"] = { name: "Amanita Pantera",          subimg: 41, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m42"] = { name: "Seta de Jaral",            subimg: 42, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m43"] = { name: "Boleto de Pino",           subimg: 43, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m44"] = { name: "Seta de Castaño",          subimg: 44, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m45"] = { name: "Trompeta Gris",            subimg: 45, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m46"] = { name: "Seta de Aliso",            subimg: 46, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m47"] = { name: "Champiñón de Bosque",      subimg: 47, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m48"] = { name: "Seta de Abedul",           subimg: 48, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m49"] = { name: "Boleto Elegante",          subimg: 49, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m50"] = { name: "Seta de Sauce",            subimg: 50, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m51"] = { name: "Amanita Muscaria",         subimg: 51, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m52"] = { name: "Seta de Olmo",             subimg: 52, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m53"] = { name: "Rebozuelo Amatista",       subimg: 53, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m54"] = { name: "Seta de Enebro",           subimg: 54, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m55"] = { name: "Boleto de Cueva",          subimg: 55, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m56"] = { name: "Seta de Gruta",            subimg: 56, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m57"] = { name: "Champiñón de Arena",       subimg: 57, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m58"] = { name: "Seta de Duna",             subimg: 58, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m59"] = { name: "Boleto de Costa",          subimg: 59, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m60"] = { name: "Seta de Pantano",          subimg: 60, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m61"] = { name: "Amanita Vaginata",         subimg: 61, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m62"] = { name: "Seta de Turbera",          subimg: 62, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m63"] = { name: "Rebozuelo Velloso",        subimg: 63, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m64"] = { name: "Seta de Breñal",           subimg: 64, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m65"] = { name: "Boleto de Risco",          subimg: 65, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m66"] = { name: "Seta de Cumbre",           subimg: 66, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m67"] = { name: "Champiñón de Pasto",       subimg: 67, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_m68"] = { name: "Seta de Valle",            subimg: 68, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m69"] = { name: "Boleto de Cañada",         subimg: 69, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m70"] = { name: "Seta de Arroyo",           subimg: 70, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m71"] = { name: "Amanita de Huevo",         subimg: 71, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m72"] = { name: "Seta de Manantial",        subimg: 72, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m73"] = { name: "Rebozuelo de Fuente",      subimg: 73, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_m74"] = { name: "Seta de Cascada",          subimg: 74, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_m75"] = { name: "Boleto de Niebla",         subimg: 75, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m76"] = { name: "Seta de Bruma",            subimg: 76, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_m77"] = { name: "Champiñón Lunar",          subimg: 77, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 150 };

// Herbs (subimg 78–96)
_fd[$ "forage_h00"] = { name: "Hierbabuena",        subimg: 78, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_h01"] = { name: "Romero de Monte",    subimg: 79, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_h02"] = { name: "Tomillo de Roca",    subimg: 80, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_h03"] = { name: "Salvia del Bosque",  subimg: 81, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h04"] = { name: "Albahaca Silvestre", subimg: 82, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h05"] = { name: "Lavanda de Valle",   subimg: 83, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_h06"] = { name: "Orégano de Sierra",  subimg: 84, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h07"] = { name: "Menta de Agua",      subimg: 85, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h08"] = { name: "Poleo",              subimg: 86, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h09"] = { name: "Eneldo",             subimg: 87, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h10"] = { name: "Perejil de Selva",   subimg: 88, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h11"] = { name: "Cilantro de Loma",   subimg: 89, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h12"] = { name: "Laurel de Cañada",   subimg: 90, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_h13"] = { name: "Mejorana",           subimg: 91, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_h14"] = { name: "Estragón",           subimg: 92, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_h15"] = { name: "Anís de Estepa",     subimg: 93, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_h16"] = { name: "Hinojo",             subimg: 94, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_h17"] = { name: "Comino de Páramo",   subimg: 95, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_h18"] = { name: "Azafrán del Bosque", subimg: 96, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 150 };

// Flowers (subimg 97–118)
_fd[$ "forage_f00"] = { name: "Margarita",           subimg: 97,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_f01"] = { name: "Amapola",             subimg: 98,  rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_f02"] = { name: "Lirio de Agua",       subimg: 99,  rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f03"] = { name: "Orquídea Selvática",  subimg: 100, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_f04"] = { name: "Rosa Silvestre",      subimg: 101, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_f05"] = { name: "Girasol de Monte",    subimg: 102, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_f06"] = { name: "Tulipán de Valle",    subimg: 103, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f07"] = { name: "Violeta de Bosque",   subimg: 104, rarity: 1, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 5   };
_fd[$ "forage_f08"] = { name: "Jazmín de Noche",     subimg: 105, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_f09"] = { name: "Clavel de Aire",      subimg: 106, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f10"] = { name: "Hortensia",           subimg: 107, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f11"] = { name: "Azucena de Río",      subimg: 108, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f12"] = { name: "Narciso",             subimg: 109, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f13"] = { name: "Pensamiento",         subimg: 110, rarity: 2, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 12  };
_fd[$ "forage_f14"] = { name: "Dalia de Sierra",     subimg: 111, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f15"] = { name: "Camelia",             subimg: 112, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_f16"] = { name: "Crisantemo",          subimg: 113, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f17"] = { name: "Gladiolo",            subimg: 114, rarity: 3, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 25  };
_fd[$ "forage_f18"] = { name: "Gardenia",            subimg: 115, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_f19"] = { name: "Magnolio",            subimg: 116, rarity: 4, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 60  };
_fd[$ "forage_f20"] = { name: "Loto Azul",           subimg: 117, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 150 };
_fd[$ "forage_f21"] = { name: "Orquídea de Cristal", subimg: 118, rarity: 5, sprite: sprite_mushrooms_herbs_flowers, type: ITEM_TYPE.MATERIAL, base_sell_price: 150 };

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

// --- NPC DATA ---
global.npc_data = {
    Miraculos:  { name: "Miraculos", skin: 1, eye_type: "female", eye_color: "brown",  hair_style: "lyria",      hair_color: "black",  clothes_color: "blue",   dialog_id: -1 },
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

// --- TIENDAS ---
// price_items: array de { key, qty } requeridos ademas del dinero
global.shop_data = {};

global.shop_data[$ "Miraculos"] = {
    available: true,
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
        // OTONO
        { item_key: "beetroot_seeds",     price_money: 25, price_items: [] },
        { item_key: "pumpkin_seeds",      price_money: 30, price_items: [] },
        { item_key: "grapes_seeds",       price_money: 40, price_items: [] },
        { item_key: "apple_seeds",        price_money: 30, price_items: [] },
    ]
};

global.shop_data[$ "Carlos"] = { available: false, items: [] };
global.shop_data[$ "Pedro"]  = { available: false, items: [] };
global.shop_data[$ "Jorge"]  = { available: false, items: [] };

// --- DATOS DE PESCA ---
global.fish_data = {};
var _fish = global.fish_data;

// Peces (frames 0-44)
_fish[$ "fish_00"] = { name: "Salmón",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 0,  rarity: 20, base_sell_price: 75   };
_fish[$ "fish_01"] = { name: "Trucha Arcoíris",   type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 1,  rarity: 20, base_sell_price: 65   };
_fish[$ "fish_02"] = { name: "Pez Sol",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 2,  rarity: 50, base_sell_price: 25   };
_fish[$ "fish_03"] = { name: "Pez Gato",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 3,  rarity: 50, base_sell_price: 20   };
_fish[$ "fish_04"] = { name: "Carpa Dorada",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 4,  rarity: 50, base_sell_price: 30   };
_fish[$ "fish_05"] = { name: "Lubina",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 5,  rarity: 20, base_sell_price: 60   };
_fish[$ "fish_06"] = { name: "Perca",              type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 6,  rarity: 50, base_sell_price: 20   };
_fish[$ "fish_07"] = { name: "Esturión",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 7,  rarity: 7,  base_sell_price: 200  };
_fish[$ "fish_08"] = { name: "Anguila",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 8,  rarity: 7,  base_sell_price: 150  };
_fish[$ "fish_09"] = { name: "Pez Espada",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 9,  rarity: 7,  base_sell_price: 250  };
_fish[$ "fish_10"] = { name: "Atún",               type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 10, rarity: 20, base_sell_price: 90   };
_fish[$ "fish_11"] = { name: "Bacalao",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 11, rarity: 50, base_sell_price: 35   };
_fish[$ "fish_12"] = { name: "Sardina",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 12, rarity: 50, base_sell_price: 15   };
_fish[$ "fish_13"] = { name: "Boquerón",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 13, rarity: 50, base_sell_price: 12   };
_fish[$ "fish_14"] = { name: "Merluza",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 14, rarity: 50, base_sell_price: 28   };
_fish[$ "fish_15"] = { name: "Rodaballo",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 15, rarity: 20, base_sell_price: 80   };
_fish[$ "fish_16"] = { name: "Lenguado",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 16, rarity: 20, base_sell_price: 70   };
_fish[$ "fish_17"] = { name: "Besugo",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 17, rarity: 20, base_sell_price: 55   };
_fish[$ "fish_18"] = { name: "Mero",               type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 18, rarity: 20, base_sell_price: 85   };
_fish[$ "fish_19"] = { name: "Dorada",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 19, rarity: 20, base_sell_price: 75   };
_fish[$ "fish_20"] = { name: "Lubina de Roca",     type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 20, rarity: 20, base_sell_price: 60   };
_fish[$ "fish_21"] = { name: "Salmonete",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 21, rarity: 50, base_sell_price: 40   };
_fish[$ "fish_22"] = { name: "Caballa",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 22, rarity: 50, base_sell_price: 22   };
_fish[$ "fish_23"] = { name: "Jurel",              type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 23, rarity: 50, base_sell_price: 18   };
_fish[$ "fish_24"] = { name: "Bonito",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 24, rarity: 20, base_sell_price: 55   };
_fish[$ "fish_25"] = { name: "Pez Vela",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 25, rarity: 7,  base_sell_price: 300  };
_fish[$ "fish_26"] = { name: "Pez Martillo",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 26, rarity: 7,  base_sell_price: 350  };
_fish[$ "fish_27"] = { name: "Tiburón Blanco",     type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 27, rarity: 2,  base_sell_price: 600  };
_fish[$ "fish_28"] = { name: "Tiburón Ballena",    type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 28, rarity: 2,  base_sell_price: 800  };
_fish[$ "fish_29"] = { name: "Raya Látigo",        type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 29, rarity: 7,  base_sell_price: 220  };
_fish[$ "fish_30"] = { name: "Pez Globo",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 30, rarity: 7,  base_sell_price: 180  };
_fish[$ "fish_31"] = { name: "Pez León",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 31, rarity: 7,  base_sell_price: 190  };
_fish[$ "fish_32"] = { name: "Pez Cirujano",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 32, rarity: 20, base_sell_price: 95   };
_fish[$ "fish_33"] = { name: "Pez Ángel",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 33, rarity: 20, base_sell_price: 110  };
_fish[$ "fish_34"] = { name: "Pez Mariposa",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 34, rarity: 20, base_sell_price: 100  };
_fish[$ "fish_35"] = { name: "Pez Loro",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 35, rarity: 20, base_sell_price: 85   };
_fish[$ "fish_36"] = { name: "Pez Ballesta",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 36, rarity: 20, base_sell_price: 90   };
_fish[$ "fish_37"] = { name: "Pez Cofre",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 37, rarity: 20, base_sell_price: 80   };
_fish[$ "fish_38"] = { name: "Pez Trompeta",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 38, rarity: 7,  base_sell_price: 160  };
_fish[$ "fish_39"] = { name: "Pez Flauta",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 39, rarity: 7,  base_sell_price: 150  };
_fish[$ "fish_40"] = { name: "Pez Pipa",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 40, rarity: 7,  base_sell_price: 140  };
_fish[$ "fish_41"] = { name: "Pez Piedra",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 41, rarity: 20, base_sell_price: 70   };
_fish[$ "fish_42"] = { name: "Pez Escorpión",      type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 42, rarity: 7,  base_sell_price: 175  };
_fish[$ "fish_43"] = { name: "Pez Sapo",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 43, rarity: 20, base_sell_price: 65   };
_fish[$ "fish_44"] = { name: "Pez Diablo",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 44, rarity: 2,  base_sell_price: 500  };

// Delfines (frames 45-48)
_fish[$ "fish_45"] = { name: "Delfín Mular",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 45, rarity: 2,  base_sell_price: 1000 };
_fish[$ "fish_46"] = { name: "Delfín Oceánico",    type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 46, rarity: 2,  base_sell_price: 1200 };
_fish[$ "fish_47"] = { name: "Delfín Rosado",      type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 47, rarity: 1,  base_sell_price: 2000 };
_fish[$ "fish_48"] = { name: "Delfín de Rápida",   type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 48, rarity: 2,  base_sell_price: 1000 };

// Criaturas Marinas (frames 49-98)
_fish[$ "fish_49"] = { name: "Pulpo Gigante",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 49, rarity: 7,  base_sell_price: 250  };
_fish[$ "fish_50"] = { name: "Calamar Común",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 50, rarity: 50, base_sell_price: 30   };
_fish[$ "fish_51"] = { name: "Sepia",                  type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 51, rarity: 50, base_sell_price: 35   };
_fish[$ "fish_52"] = { name: "Nautilo",                type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 52, rarity: 2,  base_sell_price: 600  };
_fish[$ "fish_53"] = { name: "Cangrejo Real",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 53, rarity: 20, base_sell_price: 120  };
_fish[$ "fish_54"] = { name: "Langosta Espinosa",      type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 54, rarity: 7,  base_sell_price: 300  };
_fish[$ "fish_55"] = { name: "Bogavante",              type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 55, rarity: 7,  base_sell_price: 350  };
_fish[$ "fish_56"] = { name: "Cigala",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 56, rarity: 20, base_sell_price: 90   };
_fish[$ "fish_57"] = { name: "Gamba Roja",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 57, rarity: 20, base_sell_price: 80   };
_fish[$ "fish_58"] = { name: "Langostino",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 58, rarity: 50, base_sell_price: 40   };
_fish[$ "fish_59"] = { name: "Camarón",                type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 59, rarity: 50, base_sell_price: 20   };
_fish[$ "fish_60"] = { name: "Centollo",               type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 60, rarity: 20, base_sell_price: 100  };
_fish[$ "fish_61"] = { name: "Nécora",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 61, rarity: 20, base_sell_price: 85   };
_fish[$ "fish_62"] = { name: "Buey de Mar",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 62, rarity: 20, base_sell_price: 110  };
_fish[$ "fish_63"] = { name: "Percebe",                type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 63, rarity: 7,  base_sell_price: 180  };
_fish[$ "fish_64"] = { name: "Mejillón",               type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 64, rarity: 50, base_sell_price: 15   };
_fish[$ "fish_65"] = { name: "Almeja",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 65, rarity: 50, base_sell_price: 20   };
_fish[$ "fish_66"] = { name: "Berberecho",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 66, rarity: 50, base_sell_price: 12   };
_fish[$ "fish_67"] = { name: "Ostra",                  type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 67, rarity: 20, base_sell_price: 60   };
_fish[$ "fish_68"] = { name: "Vieira",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 68, rarity: 20, base_sell_price: 75   };
_fish[$ "fish_69"] = { name: "Caracol Marino",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 69, rarity: 50, base_sell_price: 25   };
_fish[$ "fish_70"] = { name: "Estrella de Mar",        type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 70, rarity: 50, base_sell_price: 30   };
_fish[$ "fish_71"] = { name: "Erizo de Mar",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 71, rarity: 20, base_sell_price: 55   };
_fish[$ "fish_72"] = { name: "Holoturia",              type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 72, rarity: 50, base_sell_price: 20   };
_fish[$ "fish_73"] = { name: "Medusa Melena de León",  type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 73, rarity: 7,  base_sell_price: 200  };
_fish[$ "fish_74"] = { name: "Carabela Portuguesa",    type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 74, rarity: 7,  base_sell_price: 250  };
_fish[$ "fish_75"] = { name: "Coral Rojo",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 75, rarity: 2,  base_sell_price: 500  };
_fish[$ "fish_76"] = { name: "Anémona de Mar",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 76, rarity: 20, base_sell_price: 70   };
_fish[$ "fish_77"] = { name: "Esponja",                type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 77, rarity: 50, base_sell_price: 15   };
_fish[$ "fish_78"] = { name: "Caballito de Mar",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 78, rarity: 7,  base_sell_price: 150  };
_fish[$ "fish_79"] = { name: "Dragón de Mar",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 79, rarity: 2,  base_sell_price: 700  };
_fish[$ "fish_80"] = { name: "Tortuga Verde",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 80, rarity: 2,  base_sell_price: 600  };
_fish[$ "fish_81"] = { name: "Tortuga Carey",          type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 81, rarity: 2,  base_sell_price: 700  };
_fish[$ "fish_82"] = { name: "Serpiente Marina",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 82, rarity: 7,  base_sell_price: 220  };
_fish[$ "fish_83"] = { name: "Manatí",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 83, rarity: 1,  base_sell_price: 2000 };
_fish[$ "fish_84"] = { name: "Dugongo",                type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 84, rarity: 1,  base_sell_price: 2000 };
_fish[$ "fish_85"] = { name: "Foca Monje",             type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 85, rarity: 1,  base_sell_price: 1500 };
_fish[$ "fish_86"] = { name: "León Marino",            type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 86, rarity: 2,  base_sell_price: 800  };
_fish[$ "fish_87"] = { name: "Morsa",                  type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 87, rarity: 2,  base_sell_price: 900  };
_fish[$ "fish_88"] = { name: "Narval",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 88, rarity: 1,  base_sell_price: 2500 };
_fish[$ "fish_89"] = { name: "Beluga",                 type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 89, rarity: 1,  base_sell_price: 2000 };
_fish[$ "fish_90"] = { name: "Orca",                   type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 90, rarity: 1,  base_sell_price: 3000 };
_fish[$ "fish_91"] = { name: "Cachalote",              type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 91, rarity: 1,  base_sell_price: 3500 };
_fish[$ "fish_92"] = { name: "Ballena Azul",           type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 92, rarity: 1,  base_sell_price: 5000 };
_fish[$ "fish_93"] = { name: "Ballena Jorobada",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 93, rarity: 1,  base_sell_price: 4000 };
_fish[$ "fish_94"] = { name: "Ballena Franca",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 94, rarity: 1,  base_sell_price: 3500 };
_fish[$ "fish_95"] = { name: "Rorcual",                type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 95, rarity: 1,  base_sell_price: 3000 };
_fish[$ "fish_96"] = { name: "Cachalote Pigmeo",       type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 96, rarity: 2,  base_sell_price: 1000 };
_fish[$ "fish_97"] = { name: "Vaquita Marina",         type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 97, rarity: 1,  base_sell_price: 5000 };
_fish[$ "fish_98"] = { name: "Pez Desconocido",        type: ITEM_TYPE.FISH, sprite: sprite_all_fishes, subimg: 98, rarity: 50, base_sell_price: 10   };

global.fish_pool = [];
var _fkeys = variable_struct_get_names(global.fish_data);
for (var _fi = 0; _fi < array_length(_fkeys); _fi++) {
    var _fd = global.fish_data[$ _fkeys[_fi]];
    repeat (_fd.rarity) { array_push(global.fish_pool, _fkeys[_fi]); }
}

// --- DATOS DE INSECTOS ---
global.insect_data = {};
var _ins = global.insect_data;

// Insectos básicos
_ins[$ "insect_ant"]           = { name: "Hormiga",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_ant,           subimg: 0, rarity: 50, base_sell_price: 10  };
_ins[$ "insect_caterpillar"]   = { name: "Oruga",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_caterpillar,   subimg: 0, rarity: 50, base_sell_price: 15  };
_ins[$ "insect_cricket"]       = { name: "Grillo",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_cricket,       subimg: 0, rarity: 50, base_sell_price: 12  };
_ins[$ "insect_cicada"]        = { name: "Cigarra",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_cicada,        subimg: 0, rarity: 20, base_sell_price: 35  };
_ins[$ "insect_beach_hopper"]  = { name: "Pulga de Mar",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_beach_hopper,  subimg: 0, rarity: 20, base_sell_price: 30  };
_ins[$ "insect_bee"]           = { name: "Abeja",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_bees,          subimg: 0, rarity: 20, base_sell_price: 40  };

// Caracoles
_ins[$ "insect_snail_black"]   = { name: "Caracol Negro",    type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_black,   subimg: 0, rarity: 50, base_sell_price: 20  };
_ins[$ "insect_snail_green"]   = { name: "Caracol Verde",    type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_green,   subimg: 0, rarity: 50, base_sell_price: 20  };
_ins[$ "insect_snail_red"]     = { name: "Caracol Rojo",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_red,     subimg: 0, rarity: 50, base_sell_price: 25  };
_ins[$ "insect_snail_blue"]    = { name: "Caracol Azul",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_blue,    subimg: 0, rarity: 20, base_sell_price: 50  };
_ins[$ "insect_snail_pink"]    = { name: "Caracol Rosa",     type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_pink,    subimg: 0, rarity: 20, base_sell_price: 55  };
_ins[$ "insect_snail_dark"]    = { name: "Caracol Oscuro",   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_dark,    subimg: 0, rarity: 20, base_sell_price: 60  };
_ins[$ "insect_snail_purple"]  = { name: "Caracol Morado",   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_purple,  subimg: 0, rarity: 7,  base_sell_price: 120 };
_ins[$ "insect_snail_golden"]  = { name: "Caracol Dorado",   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_snail_golden,  subimg: 0, rarity: 2,  base_sell_price: 400 };

// Mariposas y polillas
_ins[$ "insect_butterfly_common"]          = { name: "Mariposa Común",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_common,          subimg: 0, rarity: 50, base_sell_price: 15  };
_ins[$ "insect_butterfly_wood_white"]      = { name: "Mariposa Blanca",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_wood_white,      subimg: 0, rarity: 50, base_sell_price: 18  };
_ins[$ "insect_butterfly_cabbage_white"]   = { name: "Mariposa de la Col",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_cabbage_white,   subimg: 0, rarity: 50, base_sell_price: 15  };
_ins[$ "insect_butterfly_orange_tip"]      = { name: "Aurora",                   type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_orange_tip,      subimg: 0, rarity: 50, base_sell_price: 20  };
_ins[$ "insect_butterfly_cloudless_sulphur"] = { name: "Mariposa Azufre",        type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_cloudless_sulphur, subimg: 0, rarity: 20, base_sell_price: 45 };
_ins[$ "insect_butterfly_migrant"]         = { name: "Mariposa Migrante",        type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_migrant,         subimg: 0, rarity: 20, base_sell_price: 50  };
_ins[$ "insect_butterfly_glider"]          = { name: "Mariposa Planeadora",      type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_glider,          subimg: 0, rarity: 20, base_sell_price: 55  };
_ins[$ "insect_butterfly_hairstreak"]      = { name: "Mariposa Listada",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_hairstreak,      subimg: 0, rarity: 20, base_sell_price: 60  };
_ins[$ "insect_butterfly_peacock_pansy"]   = { name: "Mariposa Pavo Real",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_peacock_pansy,   subimg: 0, rarity: 20, base_sell_price: 65  };
_ins[$ "insect_butterfly_red_admiral"]     = { name: "Almirante Rojo",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_red_admiral,     subimg: 0, rarity: 20, base_sell_price: 70  };
_ins[$ "insect_butterfly_eggfly"]          = { name: "Mariposa Huevo",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_eggfly,          subimg: 0, rarity: 20, base_sell_price: 60  };
_ins[$ "insect_butterfly_diadem"]          = { name: "Mariposa Diadema",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_diadem,          subimg: 0, rarity: 7,  base_sell_price: 120 };
_ins[$ "insect_butterfly_azure"]           = { name: "Mariposa Azur",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_azure,           subimg: 0, rarity: 7,  base_sell_price: 130 };
_ins[$ "insect_butterfly_european_peacock"] = { name: "Pavo Real Europeo",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_european_peacock, subimg: 0, rarity: 7, base_sell_price: 140 };
_ins[$ "insect_butterfly_cinnabar_moth"]   = { name: "Polilla Cinabrio",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_cinnabar_moth,   subimg: 0, rarity: 7,  base_sell_price: 150 };
_ins[$ "insect_butterfly_io_moth"]         = { name: "Polilla Io",               type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_io_moth,         subimg: 0, rarity: 7,  base_sell_price: 160 };
_ins[$ "insect_butterfly_sheep_moth"]      = { name: "Polilla Oveja",            type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_sheep_moth,      subimg: 0, rarity: 7,  base_sell_price: 155 };
_ins[$ "insect_butterfly_luna_moth"]       = { name: "Polilla Luna",             type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_luna_moth,       subimg: 0, rarity: 7,  base_sell_price: 200 };
_ins[$ "insect_butterfly_silkmoth"]        = { name: "Polilla de Seda",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_silkmoth,        subimg: 0, rarity: 7,  base_sell_price: 180 };
_ins[$ "insect_butterfly_monarch"]         = { name: "Mariposa Monarca",         type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_monarch,         subimg: 0, rarity: 7,  base_sell_price: 175 };
_ins[$ "insect_butterfly_morpho"]          = { name: "Morpho Azul",              type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_morpho,          subimg: 0, rarity: 2,  base_sell_price: 350 };
_ins[$ "insect_butterfly_glasswing"]       = { name: "Mariposa Alas de Cristal", type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_glasswing,       subimg: 0, rarity: 2,  base_sell_price: 400 };
_ins[$ "insect_butterfly_ulysses"]         = { name: "Mariposa Ulises",          type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_ulysses,         subimg: 0, rarity: 2,  base_sell_price: 450 };
_ins[$ "insect_butterfly_emperor"]         = { name: "Mariposa Emperador",       type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_emperor,         subimg: 0, rarity: 2,  base_sell_price: 420 };
_ins[$ "insect_butterfly_periander_metalmark"] = { name: "Metalmark Periander",  type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_periander_metalmark, subimg: 0, rarity: 2, base_sell_price: 380 };
_ins[$ "insect_butterfly_birdwing"]        = { name: "Alas de Pájaro",           type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_birdwing,        subimg: 0, rarity: 1,  base_sell_price: 800 };
_ins[$ "insect_butterfly_goliath_birdwing"] = { name: "Goliat Alas de Pájaro",  type: ITEM_TYPE.INSECT, sprite: sprite_forest_animals_butterfly_goliath_birdwing, subimg: 0, rarity: 1, base_sell_price: 1000 };

global.insect_pool = [];
var _ikeys = variable_struct_get_names(global.insect_data);
for (var _ii = 0; _ii < array_length(_ikeys); _ii++) {
    var _id = global.insect_data[$ _ikeys[_ii]];
    repeat (_id.rarity) { array_push(global.insect_pool, _ikeys[_ii]); }
}