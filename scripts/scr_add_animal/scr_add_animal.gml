function scr_add_animal(_animal_type) {
    if (!variable_struct_exists(global.animal_data, _animal_type)) {
        scr_notify("Animal desconocido: " + _animal_type);
        return false;
    }

    var _v_list  = global.animal_data[$ _animal_type].variants;
    var _variant = "white";
    if (_v_list != undefined && array_length(_v_list) > 0) {
        _variant = _v_list[irandom(array_length(_v_list) - 1)];
    }

    // Place at mouse position
    var _inst = instance_create_layer(mouse_x, mouse_y, "Instances", obj_farm_animal);
    with (_inst) {
        // Set type and variant
        animal_type = _animal_type;
        variant     = _variant;
        
        // Re-initialize sprite based on the new type/variant
        sprite_anim = asset_get_index("sprite_" + animal_type + "_" + variant);
        if (sprite_anim == -1) {
            sprite_anim = sprite_chicken_white;
        }
        sprite_index = sprite_anim;
        frame_count  = sprite_get_number(sprite_anim);
        
        // Update stats from global data
        var _data  = global.animal_data[$ animal_type];
        move_speed = (_data != undefined) ? _data.move_speed : 0.6;
        
        // Set random idle behavior
        idle_type  = irandom(4);
        if (frame_count == 32 && idle_type > 3) idle_type = 3;
    }

    scr_notify("Animal colocado: " + _animal_type + " (" + _variant + ")");
    return true;
}
