

enum ITEM_TYPE {
    MATERIAL,   // Madera, piedra, basura
    TOOL,       // Hacha, pico, regadera
    SEED,       // Semillas para plantar
    FOOD,       // Cosas que se comen
    WEAPON,     // Espadas, arcos
    CROP,       // El fruto ya cosechado (el tomate, el trigo)
    FISH        // Peces capturados
}

enum TOOL_TYPE {
    NONE,
    PICKAXE,
    AXE,
    SICKLE,
    HOE,
    WATERING_CAN,
    FISHING_ROD
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
    BRONCASTANIO // Metal fantástico único para Veredas Dream
}

global.seed_data = {
    // --- PRIMAVERA ---
    cherry_seeds:        { name: "Semilla de Cereza",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 0,  subimg: 0 },
    apricot_seeds:       { name: "Semilla de Chabacano",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 1,  subimg: 0 },
    strawberry_seeds:    { name: "Semilla de Fresa",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 2,  subimg: 0 },
    spring_onion_seeds:  { name: "Semilla de Cebolleta",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 3,  subimg: 0 },
    potato_seeds:        { name: "Semilla de Papa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 4,  subimg: 0 },
    onion_seeds:         { name: "Semilla de Cebolla",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 5,  subimg: 0 },
    carrot_seeds:        { name: "Semilla de Zanahoria",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 6,  subimg: 0 },
    blueberry_seeds:     { name: "Semilla de Mora Azul",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 7,  subimg: 0 },
    parsnip_seeds:       { name: "Semilla de Chirivía",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 8,  subimg: 0 },
    cabbage_seeds:       { name: "Semilla de Repollo",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 9,  subimg: 0 },
    cauliflower_seeds:   { name: "Semilla de Coliflor",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 10, subimg: 0 },
    rice_seeds:          { name: "Semilla de Arroz",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 11, subimg: 0 },
    broccoli_seeds:      { name: "Semilla de Brócoli",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 12, subimg: 0 },
    asparagus_seeds:     { name: "Semilla de Espárrago",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 13, subimg: 0 },

    // --- VERANO ---
    banana_seeds:        { name: "Semilla de Plátano",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 14, subimg: 0 },
    orange_seeds:        { name: "Semilla de Naranja",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 15, subimg: 0 },
    mango_seeds:         { name: "Semilla de Mango",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 16, subimg: 0 },
    peach_seeds:         { name: "Semilla de Durazno",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 17, subimg: 0 },
    tomato_seeds:        { name: "Semilla de Tomate",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 18, subimg: 0 },
    sunflower_seeds:     { name: "Semilla de Girasol",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 19, subimg: 0 },
    hot_pepper_seeds:    { name: "Semilla de Chile",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 20, subimg: 0 },
    corn_seeds:          { name: "Semilla de Maíz",        seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 21, subimg: 0 },
    green_pepper_seeds:  { name: "Semilla de Pimiento V.", seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 22, subimg: 0 },
    red_pepper_seeds:    { name: "Semilla de Pimiento R.", seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 23, subimg: 0 },
    yellow_pepper_seeds: { name: "Semilla de Pimiento A.", seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 24, subimg: 0 },
    melon_seeds:         { name: "Semilla de Melón",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 25, subimg: 0 },
    watermelon_seeds:    { name: "Semilla de Sandía",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 26, subimg: 0 },
    cucumber_seeds:      { name: "Semilla de Pepino",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 27, subimg: 0 },
    eggplant_seeds:      { name: "Semilla de Berenjena",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 28, subimg: 0 },
    pineapple_seeds:     { name: "Semilla de Piña",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 29, subimg: 0 },
    green_beans_seeds:   { name: "Semilla de Ejote",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 30, subimg: 0 },
    adzuki_bean_seeds:   { name: "Semilla de Frijol A.",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 31, subimg: 0 },
    wild_berry_seeds:    { name: "Semilla de Mora Silv.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 32, subimg: 0 },
    wheat_seeds:         { name: "Semilla de Trigo",       seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 33, subimg: 0 },
    aloe_seeds:          { name: "Semilla de Aloe",        seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 34, subimg: 0 },

    // --- OTOÑO ---
    beetroot_seeds:      { name: "Semilla de Betabel",     seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 35, subimg: 0 },
    pumpkin_seeds:       { name: "Semilla de Calabaza",    seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 36, subimg: 0 },
    grapes_seeds:        { name: "Semilla de Uva",         seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, row: 37, subimg: 0 }
};

global.crop_data = {
    // --- PRIMAVERA ---
    cherry:       { name: "Cereza",       seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 0,  subimg: 2 },
    apricot:      { name: "Chabacano",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 1,  subimg: 2 },
    strawberry:   { name: "Fresa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 2,  subimg: 2 },
    spring_onion: { name: "Cebolleta",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 3,  subimg: 2 },
    potato:       { name: "Papa",         seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 4,  subimg: 2 },
    onion:        { name: "Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 5,  subimg: 2 },
    carrot:       { name: "Zanahoria",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 6,  subimg: 2 },
    blueberry:    { name: "Mora Azul",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 7,  subimg: 2 },
    parsnip:      { name: "Chirivía",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 8,  subimg: 2 },
    cabbage:      { name: "Repollo",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 9,  subimg: 2 },
    cauliflower:  { name: "Coliflor",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 10, subimg: 2 },
    rice:         { name: "Arroz",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 11, subimg: 2 },
    broccoli:     { name: "Brócoli",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 12, subimg: 2 },
    asparagus:    { name: "Espárragos",   seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 13, subimg: 2 },

    // --- VERANO ---
    banana:        { name: "Plátano",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 14, subimg: 2 },
    orange:        { name: "Naranja",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 15, subimg: 2 },
    mango:         { name: "Mango",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 16, subimg: 2 },
    peach:         { name: "Durazno",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 17, subimg: 2 },
    tomato:        { name: "Tomate",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 18, subimg: 2 },
    sunflower:     { name: "Girasol",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 19, subimg: 2 },
    hot_pepper:    { name: "Chile Picante",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 20, subimg: 2 },
    corn:          { name: "Maíz",           seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 21, subimg: 2 },
    green_pepper:  { name: "Pimiento Verde", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 22, subimg: 2 },
    red_pepper:    { name: "Pimiento Rojo",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 23, subimg: 2 },
    yellow_pepper: { name: "Pimiento Amar.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 24, subimg: 2 },
    melon:         { name: "Melón",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 25, subimg: 2 },
    watermelon:    { name: "Sandía",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 26, subimg: 2 },
    cucumber:      { name: "Pepino",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 27, subimg: 2 },
    eggplant:      { name: "Berenjena",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 28, subimg: 2 },
    pineapple:     { name: "Piña",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 29, subimg: 2 },
    green_beans:   { name: "Ejote",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 30, subimg: 2 },
    adzuki_bean:   { name: "Frijol Adzuki",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 31, subimg: 2 },
    wild_berry:    { name: "Mora Silvestre", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 32, subimg: 2 },
    wheat:         { name: "Trigo",          seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 33, subimg: 2 },
    aloe:          { name: "Aloe",           seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 34, subimg: 2 },

    // --- OTOÑO ---
    beetroot:      { name: "Betabel",  seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 35, subimg: 2 },
    pumpkin:       { name: "Calabaza", seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 36, subimg: 2 },
    grapes:        { name: "Uva",      seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, row: 37, subimg: 2 }
};

// --- BASE DE DATOS DE HERRAMIENTAS Y ARMAS (CORREGIDA) ---
global.tool_data = {
    
    watering_can: { 
        name: "Regadera",    
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.WATERING_CAN, 
        sprite: sprite_tools, 
        subimg: 0 // Frame 1 - 1
    },
    
    pickaxe: { 
        name: "Pico",        
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.PICKAXE,      
        sprite: sprite_tools, 
        subimg: 1 // Frame 2 - 1
    },
    
    sword: { 
        name: "Espada",      
        type: ITEM_TYPE.WEAPON, 
        tool_type: TOOL_TYPE.NONE,         
        sprite: sprite_tools, 
        subimg: 2 // Frame 3 - 1
    },
    
    axe: { 
        name: "Hacha",       
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.AXE,          
        sprite: sprite_tools, 
        subimg: 3 // Frame 4 - 1
    },
    
    bow: { 
        name: "Arco",        
        type: ITEM_TYPE.WEAPON, 
        tool_type: TOOL_TYPE.NONE,         
        sprite: sprite_tools, 
        subimg: 4 // Frame 5 - 1
    },
    
    sickle: { 
        name: "Hoz", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SICKLE, 
        sprite: sprite_tools, 
        subimg: 6 // Frame 7 - 1 (Cuidado aquí, si el frame es 7, el índice es 6)
    },
    
    hoe: { 
        name: "Azada", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.HOE, 
        sprite: sprite_tools, 
        subimg: 7 // Frame 8 - 1
    }
};