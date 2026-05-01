// 1. Inicializacion (solo ocurre una vez al nacer)
if (!is_initialized && item_key != "") {
    var _data = undefined;
    if (variable_struct_exists(global.tool_data, item_key)) _data = global.tool_data[$ item_key];
    else if (variable_struct_exists(global.crop_data, item_key)) _data = global.crop_data[$ item_key];
    else if (variable_struct_exists(global.seed_data, item_key)) _data = global.seed_data[$ item_key];
    else if (variable_struct_exists(global.placeable_data, item_key)) _data = global.placeable_data[$ item_key];
    else if (variable_struct_exists(global.material_data, item_key)) _data = global.material_data[$ item_key];
    else if (variable_struct_exists(global.forage_data,   item_key)) _data = global.forage_data[$   item_key];
    else if (variable_struct_exists(global.animal_product_data,     item_key)) _data = global.animal_product_data[$     item_key];
    else if (variable_struct_exists(global.crafting_material_data, item_key)) _data = global.crafting_material_data[$ item_key];
    else if (variable_struct_exists(global.ore_data, item_key)) _data = global.ore_data[$ item_key];
    else if (variable_struct_exists(global.bar_data, item_key)) _data = global.bar_data[$ item_key];
    else if (variable_struct_exists(global.jam_data, item_key)) _data = global.jam_data[$ item_key];
    else if (variable_struct_exists(global.gemstone_data, item_key)) _data = global.gemstone_data[$ item_key];

    if (_data != undefined) {

        item_sprite = _data.sprite;
        row = variable_struct_exists(_data, "row") ? _data.row : 0;
        subimg = _data.subimg;
        col_offset = variable_struct_exists(_data, "offset_x") ? _data.offset_x : 0;
        row_offset = variable_struct_exists(_data, "offset_y") ? _data.offset_y : 0;
    }
    is_initialized = true;
}

// 2. Fisica de caida (Suelo)
if (y >= ystart_pos && vspeed >= 0) {
    vspeed = 0;
    hspeed = 0;
    gravity = 0;
    y = ystart_pos;
}

// 3. Logica de recogida y magnetismo
if (collect_delay > 0) {
    collect_delay -= 1;
} else {
    var _lp = global.local_player;
    if (instance_exists(_lp)) {
        var _dist = point_distance(x, y, _lp.x, _lp.y);

        // Efecto magnetico si esta cerca
        if (_dist <= magnetic_range) {
            var _dir = point_direction(x, y, _lp.x, _lp.y);
            var _mag_spd = 3;
            x += lengthdir_x(_mag_spd, _dir);
            y += lengthdir_y(_mag_spd, _dir);
        }

        if (_dist <= 10) {
            var _picked = false;
            if (global.net_role == NET_ROLE.CLIENT
                && instance_exists(obj_net) && obj_net.is_connected) {
                net_send_pickup(persistent_drop_id, source_room_name, item_key, quantity);
                _picked = _lp.add_item(item_key, quantity);
                if (_picked) scr_remove_room_drop(source_room_name, persistent_drop_id);
            } else {
                _picked = _lp.add_item(item_key, quantity);
                if (_picked) {
                    scr_remove_room_drop(source_room_name, persistent_drop_id);
                    if (global.net_role == NET_ROLE.HOST
                        && instance_exists(obj_net) && obj_net.is_connected) {
                        net_broadcast_room_state(source_room_name);
                    }
                }
            }
            if (_picked) {
                var _name = "Item";
                if (variable_struct_exists(global.seed_data, item_key)) _name = global.seed_data[$ item_key].name;
                else if (variable_struct_exists(global.crop_data, item_key)) _name = global.crop_data[$ item_key].name;
                else if (variable_struct_exists(global.tool_data, item_key)) _name = global.tool_data[$ item_key].name;
                else if (variable_struct_exists(global.placeable_data, item_key)) _name = global.placeable_data[$ item_key].name;
                else if (variable_struct_exists(global.material_data, item_key)) _name = global.material_data[$ item_key].name;
                else if (variable_struct_exists(global.forage_data,   item_key)) _name = global.forage_data[$   item_key].name;
                else if (variable_struct_exists(global.animal_product_data,     item_key)) _name = global.animal_product_data[$     item_key].name;
                else if (variable_struct_exists(global.crafting_material_data, item_key)) _name = global.crafting_material_data[$ item_key].name;
                else if (variable_struct_exists(global.ore_data, item_key)) _name = global.ore_data[$ item_key].name;
                else if (variable_struct_exists(global.bar_data, item_key)) _name = global.bar_data[$ item_key].name;
                else if (variable_struct_exists(global.jam_data, item_key)) _name = global.jam_data[$ item_key].name;
                else if (variable_struct_exists(global.gemstone_data, item_key)) _name = global.gemstone_data[$ item_key].name;

                scr_notify_item(quantity, _name);
                scr_play_sound_clip(sound_item_pickup, 0.75, 1.00);
                instance_destroy();
            }
        }
    }
}

scr_update_room_drop(id);
depth = -bbox_bottom;
