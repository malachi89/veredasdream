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
    ACTING // Nuevo estado para usar herramientas
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

enum ITEM_TYPE {
    MATERIAL,   // Madera, piedra, basura
    TOOL,       // Hacha, pico, regadera
    SEED,       // Semillas para plantar
    FOOD,       // Cosas que se comen
    WEAPON,     // Espadas, arcos
    CROP,       // El fruto ya cosechado (el tomate, el trigo)
    FISH,       // Peces capturados
    PLACEABLE   // Objetos que se pueden colocar: cofres, decoracion, etc.
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