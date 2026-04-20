if (room_get_name(room) == "rm_main_menu") exit;

if (!variable_instance_exists(id, "season")) season = 0;

if (load_needs_apply) {
    if (!instance_exists(obj_player)) instance_create_layer(0, 0, "Instances", obj_player);
    if (!instance_exists(obj_inventory)) instance_create_layer(0, 0, "Instances", obj_inventory);
    
    scr_apply_loaded_game(pending_loaded_game);
    pending_loaded_game = undefined;
    load_needs_apply = false;
}

// Populate farm with trees and rocks on first visit (fresh game only)
if (!global.farm_populated && room_get_name(room) == "farm"
        && instance_exists(obj_player) && instance_exists(obj_inventory)) {
    global.farm_populated = true;
    scr_populate_farm();
    scr_capture_current_room_state();
}

var _room_name = room_get_name(room);
if (current_room_name != _room_name) {
    current_room_name = _room_name;
    scr_restore_room_state(_room_name);
    scr_restore_room_drops(_room_name);
    update_tilesets();
}

if (global.forest_needs_repopulate && _room_name == "forest"
        && instance_exists(obj_player) && instance_exists(obj_inventory)) {
    global.forest_needs_repopulate = false;
    scr_populate_forest();
    scr_capture_current_room_state();
}

if (global.pending_player_room_name == _room_name && instance_exists(obj_player)) {
    obj_player.x = global.pending_player_x;
    obj_player.y = global.pending_player_y;
    obj_player.dir = global.pending_player_dir;
    obj_player.is_riding = false;
    global.pending_player_room_name = "";
}

time_tick_counter += 1;
if (time_tick_counter >= time_frames_per_minute) {
    time_tick_counter = 0;
    global.game_minute += 1;
    if (global.game_minute >= 60) {
        global.game_minute = 0;
        global.game_hour += 1;
        if (global.game_hour >= 24) start_new_day();
    }
}


// Fade in effect
if (is_fading_in) {
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        is_fading_in = false;
    }
}

// --- DEBUG CONSOLE / CHAT ---
if (keyboard_check_pressed(vk_enter) && !chat_open && !sleep_menu_open && !shipping_summary_open) {
    chat_open = true;
    keyboard_string = "";
    chat_text = "";
}
else if (chat_open) {
    chat_text = keyboard_string;
    if (keyboard_check_pressed(vk_enter)) {
        var _input = string_trim(chat_text);
        if (_input != "") {
            var _parts = string_split(_input, " ");
            var _cmd = _parts[0];
            
            if (_cmd == "add_item" && array_length(_parts) >= 3) {
                var _item = _parts[1];
                var _qty = real(_parts[2]);
                if (instance_exists(obj_inventory)) {
                    if (obj_inventory.add_item(_item, _qty)) {
                        scr_notify("Agregado: " + string(_qty) + " " + _item);
                    } else {
                        scr_notify("Inventario lleno");
                    }
                }
            } else if (_cmd == "add_animal" && array_length(_parts) >= 2) {
                var _animal = _parts[1];
                scr_add_animal(_animal);
            } else if (_cmd == "upgrade_tool" && array_length(_parts) >= 2) {
                var _item = _parts[1];
                scr_upgrade_tool(_item);
            } else if (_cmd == "buy_building" && array_length(_parts) >= 2) {
                var _bname = _parts[1];
                scr_buy_building(_bname);
            } else {
                scr_notify("Comando desconocido: " + _cmd);
            }
        }
        chat_open = false;
        keyboard_string = "";
    }
    if (keyboard_check_pressed(vk_escape)) {
        chat_open = false;
        keyboard_string = "";
    }
    exit; // Skip further input processing while chat is open
}

if (keyboard_check_pressed(ord("P"))) {
    global.season_index = (global.season_index + 1) mod 4;
    global.season = global.season_list[global.season_index];
    update_tilesets();
    show_debug_message("Estacion: " + global.season_names[$ global.season]);
}

if (keyboard_check_pressed(ord("O"))) start_new_day();

if (keyboard_check_pressed(ord("U"))) {
    if (instance_exists(obj_player)) {
        inventory_drop_item("tomato_seeds", 5, obj_player.x, obj_player.y);
        show_debug_message("Drop: 5 Tomato Seeds");
    }
}

if (instance_exists(obj_player) && instance_exists(obj_inventory)) {
    var _bed = collision_rectangle(obj_player.bbox_left, obj_player.bbox_top, obj_player.bbox_right, obj_player.bbox_bottom, obj_bed, false, true);
    var _touching_bed = (_bed != noone);
    if (_touching_bed && !bed_overlap_previous && !sleep_menu_open) {
        sleep_menu_open = true;
        sleep_menu_selection = 0;
        obj_inventory.show_backpack = false;
        obj_inventory.show_shipping = false;
        obj_inventory.held_item = -1;
    }
    bed_overlap_previous = _touching_bed;
}

if (sleep_menu_open) {
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S"))) sleep_menu_selection = 0;
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("N"))) sleep_menu_selection = 1;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _yes_x1 = _cx - 120;
    var _yes_y1 = _cy + 20;
    var _yes_x2 = _cx - 20;
    var _yes_y2 = _cy + 78;
    var _no_x1 = _cx + 20;
    var _no_y1 = _cy + 20;
    var _no_x2 = _cx + 120;
    var _no_y2 = _cy + 78;

    if (point_in_rectangle(_mx, _my, _yes_x1, _yes_y1, _yes_x2, _yes_y2)) sleep_menu_selection = 0;
    if (point_in_rectangle(_mx, _my, _no_x1, _no_y1, _no_x2, _no_y2)) sleep_menu_selection = 1;

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(_mx, _my, _yes_x1, _yes_y1, _yes_x2, _yes_y2)) {
            sleep_menu_open = false;
            scr_sleep_and_save();
        } else if (point_in_rectangle(_mx, _my, _no_x1, _no_y1, _no_x2, _no_y2)) {
            sleep_menu_open = false;
        }
    }

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))) {
        if (sleep_menu_selection == 0) {
            sleep_menu_open = false;
            scr_sleep_and_save();
        } else {
            sleep_menu_open = false;
        }
    }

    if (keyboard_check_pressed(vk_escape)) sleep_menu_open = false;
}

if (shipping_summary_open) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    
    // Boton "Continuar" (Debe coincidir EXACTAMENTE con el Draw Event)
    var _tw = 450;
    var _th = 550;
    var _ty2 = _cy + (_th / 2) - 40;
    
    var _btn_w = 240;
    var _btn_h = 60;
    var _btn_x1 = _cx - (_btn_w / 2);
    var _btn_y1 = _ty2 + 40;
    var _btn_x2 = _cx + (_btn_w / 2);
    var _btn_y2 = _btn_y1 + _btn_h;
    
    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2)) {
            shipping_summary_open = false;
            start_new_day();
            scr_save_game();
            scr_notify("Nuevo dia comenzado");
        }
    }
    
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space)) {
        shipping_summary_open = false;
        start_new_day();
        scr_save_game();
        scr_notify("Nuevo día comenzado");
    }
}

gx = floor(mouse_x / 16) * 16;
gy = floor(mouse_y / 16) * 16;
show_selector = false;

if (instance_exists(obj_inventory) && !sleep_menu_open && !obj_inventory.show_backpack) {
    var _slot_content = obj_inventory.inventory_array[obj_inventory.selected_slot];
    var _item_key = is_struct(_slot_content) ? _slot_content.key : _slot_content;
    if (_item_key != -1 && _item_key != "") {
        var _is_tool = variable_struct_exists(global.tool_data, _item_key);
        var _is_seed = variable_struct_exists(global.seed_data, _item_key);
        var _is_placeable = variable_struct_exists(global.placeable_data, _item_key);
        
        var _is_aoe_tool = _is_tool && (_item_key == "hoe" || _item_key == "watering_can" ||
                           _item_key == "shovel" || _item_key == "sickle" ||
                           _item_key == "pickaxe" || _item_key == "axe");
        if (_is_seed || _is_placeable || _is_aoe_tool) {
            show_selector = true;
            // Compute selector size from tier stats, swapped for UP/DOWN facing
            selector_w = 1;
            selector_h = 1;
            if (variable_struct_exists(global.tool_progression, _item_key)) {
                var _prog = global.tool_progression[$ _item_key];
                var _q = (is_struct(_slot_content) && variable_struct_exists(_slot_content, "quality")) ? _slot_content.quality : QUALITY.OXIDADO;
                if (_q >= 0 && _q < array_length(_prog)) {
                    var _ts = _prog[_q];
                    var _facing_vertical = instance_exists(obj_player) && (obj_player.dir == DIR.UP || obj_player.dir == DIR.DOWN);
                    selector_w = _facing_vertical ? _ts.area_height : _ts.area_width;
                    selector_h = _facing_vertical ? _ts.area_width  : _ts.area_height;
                }
            }
            if (instance_exists(obj_player)) {
                var _p_cx = (obj_player.bbox_left + obj_player.bbox_right) / 2;
                var _p_cy = (obj_player.bbox_top + obj_player.bbox_bottom) / 2;
                var _actual_dist = point_distance(_p_cx, _p_cy, gx + 8, gy + 8);
                
                // --- Re-fetch map IDs, as they might be -1 if not in the room ---
                var _layer_tilled = layer_get_id("Tiles_tilled_watered");
                var _map_id = (_layer_tilled != -1) ? layer_tilemap_get_id(_layer_tilled) : -1;
                var _layer_details = layer_get_id("Tiles_details");
                var _map_id_details = (_layer_details != -1) ? layer_tilemap_get_id(_layer_details) : -1;
                // --- End Re-fetch ---

                // NEW: Check if the seed is for a tree
                var _selected_item_data = (is_struct(_slot_content)) ? scr_get_item_data(_item_key) : undefined;
                var _is_fruit_tree_seed = variable_struct_exists(_selected_item_data, "is_fruit_tree") && _selected_item_data.is_fruit_tree;

                var _can_actually_place = false;

                if (_is_fruit_tree_seed) {
                    // For trees, check 2x3 area
                    var _tree_width_tiles = 2; // 32px / 16px
                    var _tree_height_tiles = 3; // 48px / 16px

                    var _gx_end = gx + (_tree_width_tiles * 16) - 1;
                    var _gy_end = gy + (_tree_height_tiles * 16) - 1;

                    // Check boundaries and collisions in the 2x3 area
                    var _tree_area_in_bounds = gx >= 0 && gy >= 0 && _gx_end < room_width && _gy_end < room_height;
                    var _tree_area_clear = _tree_area_in_bounds;

                    if (_tree_area_clear) {
                        for (var xx = gx; xx < gx + (_tree_width_tiles * 16); xx += 16) {
                            for (var yy = gy; yy < gy + (_tree_height_tiles * 16); yy += 16) {
                                if (instance_position(xx + 8, yy + 8, obj_crop) ||
instance_position(xx + 8, yy + 8, obj_tree) ||
                                    instance_position(xx + 8, yy + 8, obj_collision) ||
                                    instance_position(xx + 8, yy + 8, obj_item_parent) ||
                                    collision_rectangle(xx, yy, xx + 15, yy + 15, obj_player, false, true) || // Player collision in each tile
                                    (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, xx, yy) != 0)) {
                                    _tree_area_clear = false;
                                    break;
                                }
                            }
                            if (!_tree_area_clear) break;
                        }
                    }
                    _can_actually_place = _tree_area_clear && (_actual_dist <= 32); // Add distance check for trees
                } else {
                    // Existing logic for normal crops and placeable objects
                    var _occupied = instance_position(gx + 8, gy + 8, obj_collision) || 
                                    instance_position(gx + 8, gy + 8, obj_crop) || 
                                    instance_position(gx + 8, gy + 8, obj_tree) || 
                                    instance_position(gx + 8, gy + 8, obj_item_parent);
                    
                    var _collides_with_player = collision_rectangle(gx, gy, gx + 15, gy + 15, obj_player, false, true);
                    
                    var _in_bounds = gx >= 0 && gy >= 0 && gx < room_width - 16 && gy < room_height - 16;
                    
                    var _current_tile_at_gxgy = tilemap_get_at_pixel(_map_id, gx, gy); // Use _gx, _gy directly
                    var _is_tillable_ground = (_map_id != -1 && (_current_tile_at_gxgy == 72 || _current_tile_at_gxgy == 168)) && (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, gx, gy) == 0);
                    
                    _can_actually_place = (_actual_dist <= 32 || _is_placeable) && !_occupied && !_collides_with_player && _in_bounds;
                    
                    if (_is_seed) { // Only if it's a normal seed, it needs tilled soil
                        _can_actually_place = _can_actually_place && _is_tillable_ground;
                    }
                }
                
                if (_is_seed || _is_placeable) { // Selector only applies to seeds and placeables
                    selector_color = _can_actually_place ? c_green : c_red;
                } else {
                    selector_color = c_green; // Other tools always show green
                }
            }
        }
    }
}

for (var i = 0; i < ds_list_size(notifications); i++) {
    var _notif = notifications[| i];
    _notif.timer -= 1;
    if (_notif.timer < 30) _notif.alpha -= 0.03;
    if (_notif.timer <= 0) {
        ds_list_delete(notifications, i);
        i--;
    }
}
