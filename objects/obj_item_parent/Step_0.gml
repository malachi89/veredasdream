// 1. Inicializacion (solo ocurre una vez al nacer)
if (!is_initialized && item_key != "") {
    var _data = undefined;
    if (variable_struct_exists(global.tool_data, item_key)) _data = global.tool_data[$ item_key];
    else if (variable_struct_exists(global.crop_data, item_key)) _data = global.crop_data[$ item_key];
    else if (variable_struct_exists(global.tool_data, item_key)) _data = global.tool_data[$ item_key];
    else if (variable_struct_exists(global.placeable_data, item_key)) _data = global.placeable_data[$ item_key];

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
    if (instance_exists(obj_player)) {
        var _dist = point_distance(x, y, obj_player.x, obj_player.y);

        // Efecto magnetico si esta cerca
        if (_dist <= magnetic_range) {
            var _dir = point_direction(x, y, obj_player.x, obj_player.y);
            var _mag_spd = 3;
            x += lengthdir_x(_mag_spd, _dir);
            y += lengthdir_y(_mag_spd, _dir);
        }

        if (_dist <= 10) {
            if (obj_inventory.add_item(item_key, quantity)) {
                scr_remove_room_drop(source_room_name, persistent_drop_id);

                var _name = "Item";
                if (variable_struct_exists(global.tool_data, item_key)) _name = global.tool_data[$ item_key].name;
                else if (variable_struct_exists(global.seed_data, item_key)) _name = global.seed_data[$ item_key].name;
                else if (variable_struct_exists(global.crop_data, item_key)) _name = global.crop_data[$ item_key].name;
                else if (variable_struct_exists(global.placeable_data, item_key)) _name = global.placeable_data[$ item_key].name;

                scr_notify("+" + string(quantity) + " " + _name);
                instance_destroy();
            }
        }
    }
}

scr_update_room_drop(id);
depth = -bbox_bottom;
