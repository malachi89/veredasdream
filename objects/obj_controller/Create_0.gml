// --- CONFIGURACIÓN DE TIEMPO (Load from INI) ---
ini_open("settings.ini");
global.time_multiplier = ini_read_real("Time", "TimeSpeedMultiplier", 1.0);
global.days_per_season = ini_read_real("Time", "DaysPerSeason", 28);
ini_close();

// Variables de tiempo interno
global.game_minute = 0;
global.game_hour = 6; // Empezamos a las 6:00 AM
global.day = 1;
global.year = 1;
global.money = 500; // Empezamos con 500 pesos de prueba

// 1 minuto real (60s) = 10 minutos juego -> 60s / 10 = 6s real por 1m juego
// A 60 FPS: 6s * 60 = 360 frames por 1 minuto de juego.
// Con el multiplicador: 360 / multiplier.
time_tick_counter = 0;
time_frames_per_minute = (360 / global.time_multiplier);

// --- FUNCIONALIDAD DE NUEVO DÍA ---
function start_new_day() {
    global.game_minute = 0;
    global.game_hour = 6;
    global.day += 1;
    
    // Cambio de estación si pasaron los días
    if (global.day > global.days_per_season) {
        global.day = 1;
        global.season_index = (global.season_index + 1) mod 4;
        global.season = global.season_list[global.season_index];
        update_tilesets();
        
        // Cambio de año si terminaron las 4 estaciones
        if (global.season_index == 0) {
            global.year += 1;
        }
    }
    
    // Crecimiento de cultivos
    var _lay_id = layer_get_id("Tiles_tilled_watered");
    var _map_id = layer_tilemap_get_id(_lay_id);

    with(obj_crop) {
        var _tile = tilemap_get_at_pixel(_map_id, x, y);
        if (_tile == 168) is_watered = true;
        grow(); 
        if (_tile == 168) tilemap_set_at_pixel(_map_id, 72, x, y);
    }
    
    show_debug_message("Nuevo día: " + string(global.day) + " de " + global.season_names[$ global.season] + " Año " + string(global.year));
}

function update_tilesets() {
    var _tilesets = [ts_farm_spring, ts_farm_summer, ts_farm_fall, ts_farm_winter];
    var _map_bg = layer_tilemap_get_id(layer_get_id("Tiles_background"));
    var _map_det = layer_tilemap_get_id(layer_get_id("Tiles_details"));
    
    tilemap_tileset(_map_bg, _tilesets[global.season_index]);
    tilemap_tileset(_map_det, _tilesets[global.season_index]);
}

// --- RESTO DE VARIABLES ---
// Manejo del tiempo y estaciones
global.season_list = ["spring", "summer", "fall", "winter"];
global.season_index = 0; 
global.season = global.season_list[global.season_index];

global.season_names = {
    spring: "Primavera",
    summer: "Verano",
    fall:   "Otoño",
    winter: "Invierno"
};

global.day_names = ["Lun.", "Mar.", "Mie.", "Jue.", "Vie.", "Sab.", "Dom."];

// Variables para el selector de rango (UI)
gx = 0;
gy = 0;
show_selector = false;
selector_color = c_white;

// Sistema de Notificaciones (Feedback de recolección)
notifications = ds_list_create();