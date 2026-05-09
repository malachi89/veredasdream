function scr_schedule_season_event() {
    global.farm_event_scheduled_day = -1;
    global.farm_event_type = "";

    if (random(1) >= 0.15) exit;

    var _types = ["bears", "storm", "enemies"];
    global.farm_event_type = _types[irandom(2)];
    global.farm_event_scheduled_day = irandom_range(3, max(3, global.days_per_season - 2));
}

function scr_apply_farm_event(_event_type) {
    switch (_event_type) {
        case "bears":   scr_apply_bear_attack();    break;
        case "storm":   scr_apply_great_storm();    break;
        case "enemies": scr_apply_enemy_invasion(); break;
    }
}

function scr_apply_bear_attack() {
    var _farm_state = scr_get_room_state("farm");
    scr_farm_destroy_crops(_farm_state);

    var _count = irandom_range(3, 7);
    var _bear_data = global.wild_animal_data[$ "bear"];
    var _occ = scr_farm_occupied_positions(_farm_state);

    repeat (_count) {
        var _pos = scr_farm_find_free_pos(_occ);
        if (_pos.valid) {
            array_push(_farm_state.wild_animals, {
                x: _pos.x,  y: _pos.y,
                animal_key:     "bear",
                is_farm_animal: false,
                is_test_animal: false,
                sprite_index:   sprite_get_name(_bear_data.sprite),
                move_speed:     _bear_data.move_speed,
                hp:             _bear_data.hp,
                max_hp:         _bear_data.max_hp,
                dir:            irandom(3)
            });
            _occ[$ string(_pos.x) + "_" + string(_pos.y)] = true;
        }
    }

    global.room_states[$ "farm"] = _farm_state;
}

function scr_apply_great_storm() {
    global.weather_today = "rain";

    var _farm_state = scr_get_room_state("farm");
    scr_farm_destroy_crops(_farm_state);
    scr_farm_storm_spawn_resources(_farm_state);

    var _shelter_pool = ["deer", "rabbit", "fox", "capibara"];
    var _shelter_count = irandom_range(3, 6);
    var _occ = scr_farm_occupied_positions(_farm_state);

    repeat (_shelter_count) {
        var _key = _shelter_pool[irandom(array_length(_shelter_pool) - 1)];
        var _data = global.wild_animal_data[$ _key];
        if (_data == undefined) continue;
        var _pos = scr_farm_find_free_pos(_occ);
        if (_pos.valid) {
            array_push(_farm_state.wild_animals, {
                x: _pos.x,  y: _pos.y,
                animal_key:     _key,
                is_farm_animal: false,
                is_test_animal: false,
                sprite_index:   sprite_get_name(_data.sprite),
                move_speed:     _data.move_speed,
                hp:             _data.hp,
                max_hp:         _data.max_hp,
                dir:            irandom(3)
            });
            _occ[$ string(_pos.x) + "_" + string(_pos.y)] = true;
        }
    }

    global.room_states[$ "farm"] = _farm_state;
}

function scr_apply_enemy_invasion() {
    global.pending_farm_event_enemies = [];
    var _pool = [
        "slime_blue", "slime_green", "slime_black", "slime_pink",
        "myconid_blue", "myconid_green", "goblin"
    ];
    var _count = irandom_range(6, 12);
    repeat (_count) {
        array_push(global.pending_farm_event_enemies, _pool[irandom(array_length(_pool) - 1)]);
    }
}

function scr_farm_destroy_crops(_farm_state) {
    var _new_crops = [];
    for (var i = 0; i < array_length(_farm_state.crops); i++) {
        var _entry = _farm_state.crops[i];
        var _is_tree = variable_struct_exists(_entry, "type") && _entry.type == "tree";
        if (_is_tree || random(1) >= 0.5) {
            array_push(_new_crops, _entry);
        }
    }
    _farm_state.crops = _new_crops;
}

function scr_farm_storm_spawn_resources(_farm_state) {
    var _occ = scr_farm_occupied_positions(_farm_state);
    var _tree_types = ["birch", "mahogany", "pine", "maple"];

    var _tree_count = irandom_range(5, 10);
    repeat (_tree_count) {
        var _pos = scr_farm_find_free_pos(_occ);
        if (_pos.valid) {
            array_push(_farm_state.common_trees, {
                x: _pos.x,  y: _pos.y,
                tree_type:      _tree_types[irandom(3)],
                growth_stage:   irandom_range(3, 7),
                hits_remaining: 10
            });
            _occ[$ string(_pos.x) + "_" + string(_pos.y)] = true;
        }
    }

    var _rock_count = irandom_range(8, 15);
    repeat (_rock_count) {
        var _pos = scr_farm_find_free_pos(_occ);
        if (_pos.valid) {
            array_push(_farm_state.rocks, {
                x: _pos.x,  y: _pos.y,
                sprite_name:    choose("sprite_rock1", "sprite_rock2"),
                image_index:    0,
                hits_remaining: 10,  max_hits: 10,
                is_ore_rock:    false,  is_coal_rock: false,  is_gemstone_rock: false,
                ore_type_index: -1,  ore_item_key: "",  hit_counter: 0
            });
            _occ[$ string(_pos.x) + "_" + string(_pos.y)] = true;
        }
    }

    if (!variable_struct_exists(_farm_state, "weeds")) _farm_state.weeds = [];
    var _weed_count = irandom_range(3, 8);
    repeat (_weed_count) {
        var _pos = scr_farm_find_free_pos(_occ);
        if (_pos.valid) {
            array_push(_farm_state.weeds, { x: _pos.x, y: _pos.y });
            _occ[$ string(_pos.x) + "_" + string(_pos.y)] = true;
        }
    }
}

function scr_farm_event_notify(_event_type) {
    switch (_event_type) {
        case "bears":
            scr_notify("Osos salvajes olieron que habia comida aqui y vinieron a buscarla...", 300);
            scr_notify("Algunos cultivos fueron destruidos. Cuidado con los osos!", 300);
            break;
        case "storm":
            scr_notify("Hubo una gran tormenta en la noche...", 300);
            scr_notify("Destruyo cultivos y trajo arboles, rocas, hierbas y animales que buscan refugio.", 300);
            break;
        case "enemies":
            scr_notify("Monstruos invaden tu granja!", 300);
            scr_notify("Defiendela antes de que lleguen mas!", 300);
            break;
    }
}

function scr_farm_clear_event_animals() {
    if (!variable_struct_exists(global.room_states, "farm")) exit;
    var _farm_state = global.room_states[$ "farm"];
    if (!variable_struct_exists(_farm_state, "wild_animals")) exit;

    var _kept = [];
    for (var i = 0; i < array_length(_farm_state.wild_animals); i++) {
        var _a = _farm_state.wild_animals[i];
        if (variable_struct_exists(_a, "is_farm_animal") && _a.is_farm_animal) {
            array_push(_kept, _a);
        }
    }
    _farm_state.wild_animals = _kept;
    global.room_states[$ "farm"] = _farm_state;

    if (room_get_name(room) == "farm") {
        var _to_destroy = [];
        with (obj_wild_animal) {
            if (!is_farm_animal) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);
    }
}

function scr_farm_occupied_positions(_farm_state) {
    var _occ = {};
    var _arrays = ["crops", "common_trees", "rocks", "weeds", "wild_animals", "buildings"];
    for (var _a = 0; _a < array_length(_arrays); _a++) {
        var _arr = _farm_state[$ _arrays[_a]];
        if (!is_array(_arr)) continue;
        for (var _i = 0; _i < array_length(_arr); _i++) {
            var _e = _arr[_i];
            if (variable_struct_exists(_e, "x") && variable_struct_exists(_e, "y")) {
                _occ[$ string(_e.x) + "_" + string(_e.y)] = true;
            }
        }
    }
    return _occ;
}

function scr_farm_find_free_pos(_occ) {
    var _x1 = 48;   var _x2 = 1440;
    var _y1 = 96;   var _y2 = 848;
    var _grid = 16;

    repeat (50) {
        var _px = floor(random_range(_x1, _x2 - 1) / _grid) * _grid;
        var _py = floor(random_range(_y1, _y2 - 1) / _grid) * _grid;
        var _key = string(_px) + "_" + string(_py);
        if (!variable_struct_exists(_occ, _key)) {
            return { valid: true, x: _px, y: _py };
        }
    }
    return { valid: false, x: 0, y: 0 };
}
