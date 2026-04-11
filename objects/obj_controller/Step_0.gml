// variable persistente en el objeto
if (!variable_instance_exists(id, "season")) season = 0;

// lista de tilesets
var tilesets = [
    ts_farm_spring,
    ts_farm_summer,
    ts_farm_fall,
    ts_farm_winter
];

// --- CAMBIO DE ESTACIÓN (Tecla P) ---
if (keyboard_check_pressed(ord("P"))) {
    global.season_index = (global.season_index + 1) mod 4;
    global.season = global.season_list[global.season_index];
    
    var _tilesets = [ts_farm_spring, ts_farm_summer, ts_farm_fall, ts_farm_winter];
    
    // Aplicar a los layers
    var _lay_bg = layer_get_id("Tiles_background");
    var _map_bg = layer_tilemap_get_id(_lay_bg);
    var _lay_det = layer_get_id("Tiles_details");
    var _map_det = layer_tilemap_get_id(_lay_det);
    
    tilemap_tileset(_map_bg, _tilesets[global.season_index]);
    tilemap_tileset(_map_det, _tilesets[global.season_index]);
    
    show_debug_message("Estación: " + global.season_names[$ global.season]);
}

if (keyboard_check_pressed(ord("O"))) {
    global.day += 1;
    
    var _lay_id = layer_get_id("Tiles_tilled_watered");
    var _map_id = layer_tilemap_get_id(_lay_id);

    with(obj_crop) {
        // 1. Antes de llamar a grow, revisamos el tilemap real
        var _tile = tilemap_get_at_pixel(_map_id, x, y);
        
        // Si el tile está regado (168), marcamos la variable interna
        if (_tile == 168) is_watered = true;
        
        // 2. Ejecutamos su lógica interna de crecimiento
        grow(); 
        
        // 3. Actualizamos el tilemap: si estaba regado, ahora está seco (72)
        if (_tile == 168) {
            tilemap_set_at_pixel(_map_id, 72, x, y);
        }
    }
    
    show_debug_message("Nuevo día: " + string(global.day));
}