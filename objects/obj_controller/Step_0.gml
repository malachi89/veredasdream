// variable persistente en el objeto
if (!variable_instance_exists(id, "season")) season = 0;

// lista de tilesets
var tilesets = [
    ts_farm_spring,
    ts_farm_summer,
    ts_farm_fall,
    ts_farm_winter
];

// --- SISTEMA DE TIEMPO ---
time_tick_counter += 1;

if (time_tick_counter >= time_frames_per_minute) {
    time_tick_counter = 0;
    global.game_minute += 1;
    
    if (global.game_minute >= 60) {
        global.game_minute = 0;
        global.game_hour += 1;
        
        if (global.game_hour >= 24) {
            start_new_day();
        }
    }
}

// --- CAMBIO DE ESTACIÓN (Tecla P - Debug) ---
if (keyboard_check_pressed(ord("P"))) {
    global.season_index = (global.season_index + 1) mod 4;
    global.season = global.season_list[global.season_index];
    update_tilesets();
    show_debug_message("Estación: " + global.season_names[$ global.season]);
}

// --- CAMBIO DE DÍA (Tecla O - Debug) ---
if (keyboard_check_pressed(ord("O"))) {
    start_new_day();
}

// --- PRUEBA DROP (Tecla U) ---
if (keyboard_check_pressed(ord("U"))) {
    if (instance_exists(obj_player)) {
        inventory_drop_item("tomato_seeds", 5, obj_player.x, obj_player.y);
        show_debug_message("Drop: 5 Tomato Seeds");
    }
}

// --- LÓGICA DE SELECTOR Y CURSOR ---
var _tile_size = 16;
gx = floor(mouse_x / _tile_size) * _tile_size;
gy = floor(mouse_y / _tile_size) * _tile_size;

show_selector = false;

if (instance_exists(obj_inventory)) {
    if (!obj_inventory.show_backpack) {
        var _slot_content = obj_inventory.inventory_array[obj_inventory.selected_slot];
        var _item_key = is_struct(_slot_content) ? _slot_content.key : _slot_content;
        
        if (_item_key != -1 && _item_key != "") {
            var _is_tool = variable_struct_exists(global.tool_data, _item_key);
            var _is_seed = variable_struct_exists(global.seed_data, _item_key);
            
            if (_is_seed || (_is_tool && (_item_key == "hoe" || _item_key == "watering_can" || _item_key == "shovel"))) {
                show_selector = true;
                
                if (instance_exists(obj_player)) {
                    var _dist_max = 32;
                    var _p_cx = (obj_player.bbox_left + obj_player.bbox_right) / 2;
                    var _p_cy = (obj_player.bbox_top + obj_player.bbox_bottom) / 2;
                    var _actual_dist = point_distance(_p_cx, _p_cy, gx + 8, gy + 8);
                    
                    selector_color = (_actual_dist <= _dist_max) ? c_green : c_red;
                }
            }
        }
    }
}

// --- GESTIÓN DE NOTIFICACIONES ---
for (var i = 0; i < ds_list_size(notifications); i++) {
    var _notif = notifications[| i];
    _notif.timer -= 1;
    
    // Desvanecimiento suave al final
    if (_notif.timer < 30) {
        _notif.alpha -= 0.03;
    }
    
    // Eliminar si terminó el tiempo
    if (_notif.timer <= 0) {
        ds_list_delete(notifications, i);
        i--; // Ajustar índice tras borrar
    }
}