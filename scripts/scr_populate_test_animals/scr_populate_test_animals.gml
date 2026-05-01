function scr_populate_test_animals() {
    // 1. Destroy existing test animals in the room
    with (obj_wild_animal) {
        if (is_test_animal) instance_destroy();
    }

    // 2. Setup spawn parameters
    var _test_x = 300;
    var _test_y = 300;
    var _spacing = 48;
    var _layer = "Instances";
    
    // Ensure we are in a room where we want to spawn (usually farm)
    if (room_get_name(room) != "farm") return;

    // 3. Spawn Wild Animals
    var _wild_keys = variable_struct_get_names(global.wild_animal_data);
    for (var i = 0; i < array_length(_wild_keys); i++) {
        var _key = _wild_keys[i];
        var _data = global.wild_animal_data[$ _key];
        
        var _inst = instance_create_layer(_test_x, _test_y, _layer, obj_wild_animal);
        _inst.animal_key = _key;
        _inst.is_farm_animal = false;
        _inst.is_test_animal = true;
        _inst.sprite_index = _data.sprite;
        _inst.move_speed = 0; // Stationary
        _inst.hp = _data.hp;
        _inst.max_hp = _data.max_hp;
        
        _test_x += _spacing;
    }
    
    // 4. Reset X and move Y for second row
    _test_x = 300;
    _test_y += _spacing;
    
    // 5. Spawn Farm Animals (as hunted objects)
    var _farm_keys = variable_struct_get_names(global.animal_data);
    for (var i = 0; i < array_length(_farm_keys); i++) {
        var _key = _farm_keys[i];
        var _fdata = global.animal_data[$ _key];
        
        // Pick the first variant
        var _variant = _fdata.variants[0];
        var _fspr = asset_get_index("sprite_" + _key + "_" + _variant);
        if (_fspr == -1) _fspr = sprite_chicken_white;
        
        var _inst = instance_create_layer(_test_x, _test_y, _layer, obj_wild_animal);
        _inst.animal_key = _key;
        _inst.is_farm_animal = true;
        _inst.is_test_animal = true;
        _inst.sprite_index = _fspr;
        _inst.move_speed = 0; // Stationary
        _inst.hp = _fdata.hp;
        _inst.max_hp = _fdata.max_hp;
        
        _test_x += _spacing;
    }
    
    // 6. Spawn a moving bear for debug (chase/attack testing)
    var _bear_data = global.wild_animal_data[$ "bear"];
    var _bear = instance_create_layer(900, 600, _layer, obj_wild_animal);
    _bear.animal_key = "bear";
    _bear.is_farm_animal = false;
    _bear.is_test_animal = true;
    _bear.sprite_index = _bear_data.sprite;
    _bear.move_speed = _bear_data.move_speed;
    _bear.hp = _bear_data.hp;
    _bear.max_hp = _bear_data.max_hp;

    show_debug_message("Farm test animals repopulated.");
}
