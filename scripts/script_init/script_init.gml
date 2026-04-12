
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
    BRONCASTANIO // Metal fantástico único para Veredas Dream
}

global.seed_data = {
    // --- PRIMAVERA ---
    cherry_seeds:       { name: "Semilla de Cereza",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 0,   growth_time: 6, crop_base_name: "cherry" },
    apricot_seeds:      { name: "Semilla de Chabacano",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 8,   growth_time: 6, crop_base_name: "apricot" },
    strawberry_seeds:   { name: "Semilla de Fresa",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 16,  growth_time: 6, crop_base_name: "strawberry" },
    spring_onion_seeds: { name: "Semilla de Cebolleta",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 24,  growth_time: 6, crop_base_name: "spring_onion" },
    potato_seeds:       { name: "Semilla de Papa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 32,  growth_time: 6, crop_base_name: "potato" },
    onion_seeds:        { name: "Semilla de Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 40,  growth_time: 6, crop_base_name: "onion" },
    carrot_seeds:       { name: "Semilla de Zanahoria",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 48,  growth_time: 6, crop_base_name: "carrot" },
    blueberry_seeds:    { name: "Semilla de Mora Azul",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 56,  growth_time: 6, crop_base_name: "blueberry" },
    parsnip_seeds:      { name: "Semilla de Chirivía",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 64,  growth_time: 5, crop_base_name: "parsnip" },
    cabbage_seeds:      { name: "Semilla de Repollo",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 72,  growth_time: 7, crop_base_name: "cabbage" },
    cauliflower_seeds:  { name: "Semilla de Coliflor",    seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 80,  growth_time: 6, crop_base_name: "cauliflower" },
    rice_seeds:         { name: "Semilla de Arroz",       seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 88,  growth_time: 6, crop_base_name: "rice" },
    broccoli_seeds:     { name: "Semilla de Brócoli",     seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 96,  growth_time: 5, crop_base_name: "broccoli" },
    asparagus_seeds:    { name: "Semilla de Espárrago",   seasons: [SEASON.SPRING], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 104, growth_time: 5, crop_base_name: "asparagus" },

    // --- VERANO ---
    tomato_seeds:        { name: "Semilla de Tomate",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 144, growth_time: 5, crop_base_name: "tomato" },
    sunflower_seeds:     { name: "Semilla de Girasol",     seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 152, growth_time: 6, crop_base_name: "sunflower" },
    hot_pepper_seeds:    { name: "Semilla de Chile",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 160, growth_time: 7, crop_base_name: "hot_pepper" },
    corn_seeds:          { name: "Semilla de Maíz",        seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 168, growth_time: 8, crop_base_name: "corn" },
    green_pepper_seeds:  { name: "Semilla de Pimiento V.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 176, growth_time: 6, crop_base_name: "green_pepper" },
    melon_seeds:         { name: "Semilla de Melón",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 200, growth_time: 6, crop_base_name: "melon" },
    watermelon_seeds:    { name: "Semilla de Sandía",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 208, growth_time: 8, crop_base_name: "watermelon" },
    cucumber_seeds:      { name: "Semilla de Pepino",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 216, growth_time: 6, crop_base_name: "cucumber" },
    eggplant_seeds:      { name: "Semilla de Berenjena",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 224, growth_time: 6, crop_base_name: "eggplant" },
    pineapple_seeds:     { name: "Semilla de Piña",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 232, growth_time: 6, crop_base_name: "pineapple" },
    green_beans_seeds:   { name: "Semilla de Ejote",       seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 240, growth_time: 7, crop_base_name: "green_beans" },
    adzuki_bean_seeds:   { name: "Semilla de Frijol A.",   seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 248, growth_time: 7, crop_base_name: "adzuki_bean" },
    wild_berry_seeds:    { name: "Semilla de Mora Silv.",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 256, growth_time: 7, crop_base_name: "wild_berry" },
    wheat_seeds:         { name: "Semilla de Trigo",       seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 264, growth_time: 6, crop_base_name: "wheat" },
    aloe_seeds:          { name: "Semilla de Aloe",        seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 272, growth_time: 6, crop_base_name: "aloe" },

    // --- OTOÑO ---
    beetroot_seeds:      { name: "Semilla de Betabel",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 280, growth_time: 6, crop_base_name: "beetroot" },
    pumpkin_seeds:       { name: "Semilla de Calabaza",   seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 288, growth_time: 6, crop_base_name: "pumpkin" },
    grapes_seeds:        { name: "Semilla de Uva",         seasons: [SEASON.FALL], type: ITEM_TYPE.SEED, sprite: sprite_crops_icons, subimg: 296, growth_time: 6, crop_base_name: "grapes" }
};

global.crop_data = {
    // --- PRIMAVERA ---
    cherry:       { name: "Cereza",       seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 2 },
    apricot:      { name: "Chabacano",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 10 },
    strawberry:   { name: "Fresa",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 18 },
    spring_onion: { name: "Cebolleta",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 26 },
    potato:       { name: "Papa",         seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 34 },
    onion:        { name: "Cebolla",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 42 },
    carrot:       { name: "Zanahoria",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 50 },
    blueberry:    { name: "Mora Azul",    seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 58 },
    parsnip:      { name: "Chirivía",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 66 },
    cabbage:      { name: "Repollo",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 74 },
    cauliflower:  { name: "Coliflor",     seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 82 },
    rice:         { name: "Arroz",        seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 90 },
    broccoli:     { name: "Brócoli",      seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 98 },
    asparagus:    { name: "Espárragos",   seasons: [SEASON.SPRING], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 106 },

    // --- VERANO ---
    tomato:        { name: "Tomate",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 146 },
    sunflower:     { name: "Girasol",        seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 154 },
    hot_pepper:    { name: "Chile Picante",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 162 },
    corn:          { name: "Maíz",           seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 170 },
    green_pepper:  { name: "Pimiento Verde", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 178 },
    melon:         { name: "Melón",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 202 },
    watermelon:    { name: "Sandía",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 210 },
    cucumber:      { name: "Pepino",         seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 218 },
    eggplant:      { name: "Berenjena",      seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 226 },
    pineapple:     { name: "Piña",           seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 234 },
    green_beans:   { name: "Ejote",          seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 242 },
    adzuki_bean:   { name: "Frijol Adzuki",  seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 250 },
    wild_berry:    { name: "Mora Silvestre", seasons: [SEASON.SUMMER], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 258 },
    wheat:         { name: "Trigo",          seasons: [SEASON.SUMMER, SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 266 },
    aloe:          { name: "Aloe",           seasons: [SEASON.SUMMER, SEASON.ALL],  type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 274 },

    // --- OTOÑO ---
     beetroot:      { name: "Betabel",  seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 282 },
     pumpkin:       { name: "Calabaza", seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 290 },
     grapes:        { name: "Uva",      seasons: [SEASON.FALL], type: ITEM_TYPE.CROP, sprite: sprite_crops_icons, subimg: 298 }
};

// --- BASE DE DATOS DE HERRAMIENTAS Y ARMAS (CORREGIDA) ---
global.tool_data = {
    
    watering_can: { 
        name: "Regadera",    
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.WATERING_CAN, 
        sprite: sprite_tools, 
        subimg: 0 // Frame 1
    },
    
    pickaxe: { 
        name: "Pico",        
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.PICKAXE,      
        sprite: sprite_tools, 
        subimg: 1 // Frame 2
    },
    
    sword: { 
        name: "Espada",      
        type: ITEM_TYPE.TOOL,   // Cambiado a TOOL
        tool_type: TOOL_TYPE.SWORD,         
        sprite: sprite_tools, 
        subimg: 2 // Frame 3
    },
    
    axe: { 
        name: "Hacha",       
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.AXE,          
        sprite: sprite_tools, 
        subimg: 3 // Frame 4
    },
    
    bow: { 
        name: "Arco",        
        type: ITEM_TYPE.TOOL,   // Cambiado a TOOL
        tool_type: TOOL_TYPE.BOW,         
        sprite: sprite_tools, 
        subimg: 4 // Frame 5
    },
    
    hoe: { 
        name: "Azada", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.HOE, 
        sprite: sprite_tools, 
        subimg: 6 // Frame 7 (El 6 era la flecha, saltamos al 7)
    },

    shovel: { 
        name: "Pala", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SHOVEL, 
        sprite: sprite_tools, 
        subimg: 7 // Frame 8
    },
    
    sickle: { 
        name: "Hoz", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.SICKLE, 
        sprite: sprite_tools, 
        subimg: 8 // Frame 9
    },

    fishing_rod: {
        name: "Caña de pescar",
        type: ITEM_TYPE.TOOL,
        tool_type: TOOL_TYPE.FISHING_ROD,
        sprite: sprite_tools,
        subimg: 22 // Frame 23
    },

    bugnet: { 
        name: "Red de bichos", 
        type: ITEM_TYPE.TOOL,   
        tool_type: TOOL_TYPE.BUGNET,
        sprite: sprite_bugnet,    
        subimg: 0                 
    }
};