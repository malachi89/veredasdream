// 1. Inicialización (solo ocurre una vez al nacer)
if (!is_initialized && item_key != "") {
    var _data = undefined;
    if (variable_struct_exists(global.tool_data, item_key)) _data = global.tool_data[$ item_key];
    else if (variable_struct_exists(global.seed_data, item_key)) _data = global.seed_data[$ item_key];
    else if (variable_struct_exists(global.crop_data, item_key)) _data = global.crop_data[$ item_key];

    if (_data != undefined) {
        item_sprite = _data.sprite;
        row = variable_struct_exists(_data, "row") ? _data.row : 0;
        subimg = _data.subimg;
    }
    is_initialized = true;
}

// 2. Física de caída (Suelo)
if (y >= ystart_pos && vspeed >= 0) {
    vspeed = 0;
    hspeed = 0;
    gravity = 0;
    y = ystart_pos;
}

// 3. Lógica de recogida y magnetismo
if (collect_delay > 0) {
    collect_delay -= 1;
} else {
    // Si ya puede recogerse, buscamos al jugador
    if (instance_exists(obj_player)) {
        var _dist = point_distance(x, y, obj_player.x, obj_player.y);
        
        // Efecto magnético si está cerca
        if (_dist <= magnetic_range) {
            var _dir = point_direction(x, y, obj_player.x, obj_player.y);
            var _mag_spd = 3; 
            x += lengthdir_x(_mag_spd, _dir);
            y += lengthdir_y(_mag_spd, _dir);
        }

        // Recogida por distancia (más fiable que place_meeting para magnetismo)
        if (_dist <= 10) { 
            if (obj_inventory.add_item(item_key, quantity)) {
                // Generar notificación de recogida
                var _name = "Item";
                if (variable_struct_exists(global.tool_data, item_key)) _name = global.tool_data[$ item_key].name;
                else if (variable_struct_exists(global.seed_data, item_key)) _name = global.seed_data[$ item_key].name;
                else if (variable_struct_exists(global.crop_data, item_key)) _name = global.crop_data[$ item_key].name;
                
                scr_notify("+" + string(quantity) + " " + _name);
                instance_destroy();
            }
        }
    }
}