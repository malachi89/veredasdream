
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
    STORAGE     // Cofres, barriles, etc.
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
    NORMAL,
    PLATA,
    ORO,
    BRONCASTANIO // Metal fantastico unico para Veredas Dream
}

global.seed_data = {
    // --- PRIMAVERA ---
    cherry_seeds:       { name: "Semilla de Cereza",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 0,   growth_time: 6, crop_base_name: "cherry",       base_buy_price: 30, base_sell_price: 15 },
    apricot_seeds:      { name: "Semilla de Chabacano",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 8,   growth_time: 6, crop_base_name: "apricot",      base_buy_price: 25, base_sell_price: 12 },
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
    grapes_seeds:        { name: "Semilla de Uva",         seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 296, growth_time: 6, crop_base_name: "grapes",       base_buy_price: 40, base_sell_price: 20 }
};

global.crop_data = {
    // --- PRIMAVERA ---
    cherry:       { name: "Cereza",       seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 2,   base_buy_price: 120, base_sell_price: 90 },
    apricot:      { name: "Chabacano",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 10,  base_buy_price: 100, base_sell_price: 75 },
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
     grapes:        { name: "Uva",      seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 298, base_buy_price: 150, base_sell_price: 110 }
};

// --- BASE DE DATOS DE HERRAMIENTAS Y ARMAS (CORREGIDA) ---
global.tool_data = {
    
    watering_can: { 
        name: "Regadera",    
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.WATERING_CAN, 
        sprite: sprite_tools, 
        subimg: 0, // Frame 1
        sellable: false,
        droppable: false
    },
    
    pickaxe: { 
        name: "Pico",        
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.PICKAXE,      
        sprite: sprite_tools, 
        subimg: 1, // Frame 2
        sellable: false,
        droppable: false
    },
    
    sword: { 
        name: "Espada",      
        type: ITEM_TYPE.TOOL,   // Cambiado a TOOL
        tool_type: TOOL_TYPE.SWORD,         
        sprite: sprite_tools, 
        subimg: 2, // Frame 3
        sellable: false,
        droppable: false
    },
    
    axe: { 
        name: "Hacha",       
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.AXE,          
        sprite: sprite_tools, 
        subimg: 3, // Frame 4
        sellable: false,
        droppable: false
    },
    
    bow: { 
        name: "Arco",        
        type: ITEM_TYPE.TOOL,   // Cambiado a TOOL
        tool_type: TOOL_TYPE.BOW,         
        sprite: sprite_tools, 
        subimg: 4, // Frame 5
        sellable: false,
        droppable: false
    },
    
    hoe: { 
        name: "Azada", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.HOE, 
        sprite: sprite_tools, 
        subimg: 6, // Frame 7 (El 6 era la flecha, saltamos al 7)
        sellable: false,
        droppable: false
    },

    shovel: { 
        name: "Pala", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SHOVEL, 
        sprite: sprite_tools, 
        subimg: 7, // Frame 8
        sellable: false,
        droppable: false
    },
    
    sickle: { 
        name: "Hoz", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SICKLE, 
        sprite: sprite_tools, 
        subimg: 8, // Frame 9
        sellable: false,
        droppable: false
    },

    fishing_rod: {
        name: "Cana de pescar",
        type: ITEM_TYPE.TOOL,
        tool_type: TOOL_TYPE.FISHING_ROD,
        sprite: sprite_tools,
        subimg: 22, // Frame 23
        sellable: false,
        droppable: false
    },

    bugnet: { 
        name: "Red de bichos", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.BUGNET,
        sprite: sprite_bugnet,    
        subimg: 0,
        sellable: false,
        droppable: false
    }
};

global.storage_data = {
    chest: {
        name: "Cofre",
        type: ITEM_TYPE.STORAGE,
        sprite: sprite_farm_chests,
        subimg: 0,
        offset_x: 8,
        sellable: true,
        droppable: true,
        base_buy_price: 100,
        base_sell_price: 50
    }
};