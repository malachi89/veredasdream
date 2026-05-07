function scr_current_room_key() {
    if (global.mine_state.active) {
        return "mine_" + string(global.mine_state.door_index) + "_floor_" + string(global.mine_state.floor);
    }
    return room_get_name(room);
}

function inventory_drop_item(_key, _qty, _px, _py, _delay = 8) {
    var _room_name = scr_current_room_key();
    if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
        // Route through host so the drop UID is host-authoritative.
        // No local instance — host creates it and broadcasts back via WEVT_ROOM_REFRESH.
        net_send_drop(_room_name, _key, _qty, _px, _py, _delay);
        return;
    }
    var _inst = instance_create_layer(_px, _py, "Instances", obj_item_parent);
    with (_inst) {
        item_key = _key;
        quantity = _qty;
        collect_delay = _delay;
        ystart_pos = _py;
        vspeed = -2.5;
        hspeed = random_range(-1, 1);
        gravity = 0.15;
    }
    scr_register_room_drop(_inst, _room_name);
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        net_broadcast_room_state(_room_name);
    }
}

function scr_get_room_drops(_room_name) {
    if (!variable_struct_exists(global.room_drops, _room_name)) global.room_drops[$ _room_name] = [];
    return global.room_drops[$ _room_name];
}

function scr_register_room_drop(_inst, _room_name) {
    var _drops = scr_get_room_drops(_room_name);
    var _drop_id = global.next_drop_uid;
    global.next_drop_uid += 1;
    var _index = array_length(_drops);
    _drops[_index] = { id: _drop_id, item_key: _inst.item_key, quantity: _inst.quantity, x: _inst.x, y: _inst.y, collect_delay: _inst.collect_delay };
    global.room_drops[$ _room_name] = _drops;
    _inst.persistent_drop_id = _drop_id;
    _inst.source_room_name = _room_name;
}

function scr_update_room_drop(_inst) {
    if (!instance_exists(_inst)) exit;
    if (_inst.persistent_drop_id == -1) exit;
    var _drops = scr_get_room_drops(_inst.source_room_name);
    for (var i = 0; i < array_length(_drops); i++) {
        if (_drops[i].id == _inst.persistent_drop_id) {
            _drops[i].item_key = _inst.item_key;
            _drops[i].quantity = _inst.quantity;
            _drops[i].x = _inst.x;
            _drops[i].y = _inst.y;
            _drops[i].collect_delay = _inst.collect_delay;
            global.room_drops[$ _inst.source_room_name] = _drops;
            return;
        }
    }
}

function scr_remove_room_drop(_room_name, _drop_id) {
    if (_drop_id == -1) exit;
    if (!variable_struct_exists(global.room_drops, _room_name)) exit;
    var _drops = global.room_drops[$ _room_name];
    for (var i = 0; i < array_length(_drops); i++) {
        if (_drops[i].id == _drop_id) {
            array_delete(_drops, i, 1);
            global.room_drops[$ _room_name] = _drops;
            return;
        }
    }
}

function scr_restore_room_drops(_room_name) {
    var _drops = scr_get_room_drops(_room_name);

    // Build authoritative ID set
    var _stored_ids = {};
    for (var i = 0; i < array_length(_drops); i++) {
        _stored_ids[$ string(_drops[i].id)] = true;
    }

    // Destroy instances that are no longer in the authoritative state
    var _to_destroy = [];
    with (obj_item_parent) {
        if (source_room_name == _room_name
            && !variable_struct_exists(_stored_ids, string(persistent_drop_id))) {
            array_push(_to_destroy, id);
        }
    }
    for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

    // Build set of already-live instance IDs
    var _existing_ids = {};
    with (obj_item_parent) {
        if (source_room_name == _room_name && persistent_drop_id != -1) {
            _existing_ids[$ string(persistent_drop_id)] = true;
        }
    }

    // Create instances only for drops that have no live instance yet
    for (var i = 0; i < array_length(_drops); i++) {
        var _drop_data = _drops[i];
        if (variable_struct_exists(_existing_ids, string(_drop_data.id))) continue;
        var _inst = instance_create_layer(_drop_data.x, _drop_data.y, "Instances", obj_item_parent);
        with (_inst) {
            item_key = _drop_data.item_key;
            quantity = _drop_data.quantity;
            collect_delay = _drop_data.collect_delay;
            ystart_pos = _drop_data.y;
            vspeed = 0;
            hspeed = 0;
            gravity = 0;
            persistent_drop_id = _drop_data.id;
            source_room_name = _room_name;
        }
    }
}

function scr_restore_forest_insects() {
    with (obj_insect) instance_destroy();
    for (var i = 0; i < array_length(global.forest_insects); i++) {
        var _d    = global.forest_insects[i];
        var _inst = instance_create_layer(_d.x, _d.y, "Instances", obj_insect);
        _inst.insect_key   = _d.key;
        _inst.sprite_index = global.insect_data[$ _d.key].sprite;
    }
}

function scr_restore_forest_wild_animals() {
    with (obj_wild_animal) instance_destroy();
    for (var i = 0; i < array_length(global.forest_wild_animals); i++) {
        var _d    = global.forest_wild_animals[i];
        var _inst = instance_create_layer(_d.x, _d.y, "Instances", obj_wild_animal);
        _inst.animal_key    = _d.key;
        _inst.sprite_index  = _d.sprite;
        _inst.move_speed    = _d.move_speed;
        _inst.hp            = _d.hp;
        _inst.max_hp        = _d.max_hp;
    }
}

function scr_restore_forest_enemies() {
    with (obj_enemy) instance_destroy();
    for (var i = 0; i < array_length(global.forest_enemies); i++) {
        var _d     = global.forest_enemies[i];
        var _edata = global.enemy_data[$ _d.key];
        if (_edata == undefined) continue;
        var _inst  = instance_create_layer(_d.x, _d.y, "Instances", _edata.object);
        _inst.hp     = _d.hp;
        _inst.max_hp = _d.max_hp;
    }
}

function scr_get_room_state(_room_name) {
    if (!variable_struct_exists(global.room_states, _room_name)) {
        global.room_states[$ _room_name] = { crops: [], tilled_tiles: [], chests: [], buildings: [], horses: [], common_trees: [], rocks: [], animals: [], wild_animals: [], machines: [] };
    }
    var _s = global.room_states[$ _room_name];
    // Defensive fill — guards against {} sent for unvisited rooms in multiplayer ROOM_SNAPSHOT
    if (!variable_struct_exists(_s, "crops"))        _s.crops        = [];
    if (!variable_struct_exists(_s, "tilled_tiles")) _s.tilled_tiles = [];
    if (!variable_struct_exists(_s, "chests"))       _s.chests       = [];
    if (!variable_struct_exists(_s, "buildings"))    _s.buildings    = [];
    if (!variable_struct_exists(_s, "horses"))       _s.horses       = [];
    if (!variable_struct_exists(_s, "common_trees")) _s.common_trees = [];
    if (!variable_struct_exists(_s, "rocks"))        _s.rocks        = [];
    if (!variable_struct_exists(_s, "animals"))      _s.animals      = [];
    if (!variable_struct_exists(_s, "wild_animals")) _s.wild_animals = [];
    return _s;
}

function scr_capture_current_room_state() {
    var _room_name = scr_current_room_key();
    var _state = { crops: [], tilled_tiles: [], chests: [], buildings: [], horses: [], animals: [], wild_animals: [], machines: [] };
    
    // Capture Regular Crops
    for (var i = 0; i < instance_number(obj_crop); i++) {
        var _inst = instance_find(obj_crop, i);
        var _idx = array_length(_state.crops);
        _state.crops[_idx] = {
            type: "crop",
            x: _inst.x, y: _inst.y, crop_type: _inst.crop_type, days_passed: _inst.days_passed,
            growth_stage: _inst.growth_stage, is_watered: _inst.is_watered, persistent_water: _inst.persistent_water,
            skip_blank_frame: _inst.skip_blank_frame,
            days_to_grow: _inst.days_to_grow, max_stages: _inst.max_stages, image_index: _inst.image_index
        };
    }
    
    // Capture Trees
    for (var i = 0; i < instance_number(obj_tree); i++) {
        var _inst = instance_find(obj_tree, i);
        var _idx = array_length(_state.crops);
        _state.crops[_idx] = {
            type: "tree",
            x: _inst.x, y: _inst.y, crop_type: _inst.crop_type, days_passed: _inst.days_passed,
            days_to_grow: _inst.days_to_grow, max_stages: _inst.max_stages,
            fruit_cycle_days: _inst.fruit_cycle_days,
            days_since_harvest: _inst.days_since_harvest,
            has_fruit: _inst.has_fruit,
            fruit_item: _inst.fruit_item,
            hits_remaining: _inst.hits_remaining
        };
    }
    
    // Capturar Cofres
    for (var i = 0; i < instance_number(obj_chest); i++) {
        var _chest = instance_find(obj_chest, i);
        // Verificar que el cofre esté inicializado antes de capturar
        if (variable_instance_exists(_chest, "storage_array")) {
            var _c_idx = array_length(_state.chests);
            _state.chests[_c_idx] = {
                x: _chest.x, y: _chest.y, storage_array: _chest.storage_array
            };
        }
    }

    // Capture Buildings
    var _building_objs = [obj_barn, obj_chicken, obj_greenhouse, obj_mill, obj_stable];
    for (var b = 0; b < array_length(_building_objs); b++) {
        var _obj = _building_objs[b];
        for (var i = 0; i < instance_number(_obj); i++) {
            var _inst = instance_find(_obj, i);
            array_push(_state.buildings, {
                obj: object_get_name(_obj),
                x: _inst.x,
                y: _inst.y
            });
        }
    }

    // Capture Machines
    if (variable_struct_exists(_state, "machines")) {
        for (var i = 0; i < instance_number(obj_machine); i++) {
            var _inst = instance_find(obj_machine, i);
            array_push(_state.machines, {
                x: _inst.x,
                y: _inst.y,
                machine_type: _inst.machine_type,
                state: _inst.state,
                timer: _inst.timer,
                passive_timer: _inst.passive_timer,
                input_key: _inst.input_key,
                output_key: _inst.output_key,
                output_qty: _inst.output_qty
            });
        }
    }

    // Capture Horses
    for (var i = 0; i < instance_number(obj_horse_parent); i++) {
        var _inst = instance_find(obj_horse_parent, i);
        array_push(_state.horses, {
            obj: object_get_name(_inst.object_index),
            x: _inst.x,
            y: _inst.y,
            dir: _inst.dir,
            is_bear: _inst.is_bear
        });
    }

    // Capture Farm Animals
    for (var i = 0; i < instance_number(obj_farm_animal); i++) {
        var _inst = instance_find(obj_farm_animal, i);
        array_push(_state.animals, {
            x:           _inst.x,
            y:           _inst.y,
            animal_type: _inst.animal_type,
            variant:     _inst.variant,
            dir:         _inst.dir
        });
    }

    // Capture Wild/Huntable Animals
    for (var i = 0; i < instance_number(obj_wild_animal); i++) {
        var _inst = instance_find(obj_wild_animal, i);
        array_push(_state.wild_animals, {
            x:              _inst.x,
            y:              _inst.y,
            animal_key:     _inst.animal_key,
            is_farm_animal: _inst.is_farm_animal,
            is_test_animal: _inst.is_test_animal,
            sprite_index:   sprite_get_name(_inst.sprite_index),
            move_speed:     _inst.move_speed,
            hp:             _inst.hp,
            max_hp:         _inst.max_hp,
            dir:            _inst.dir
        });
    }

    var _layer_id = layer_get_id("Tiles_tilled_watered");
    if (_layer_id != -1) {
        var _map_id = layer_tilemap_get_id(_layer_id);
        for (var _y = 0; _y < room_height; _y += 16) {
            for (var _x = 0; _x < room_width; _x += 16) {
                var _tile = tilemap_get_at_pixel(_map_id, _x, _y);
                if (_tile != 0 && _tile != -2147483648) {
                    var _tile_idx = array_length(_state.tilled_tiles);
                    _state.tilled_tiles[_tile_idx] = { x: _x, y: _y, tile: _tile };
                }
            }
        }
    }
    // Capture Common Trees
    var _ct_state = [];
    for (var i = 0; i < instance_number(obj_common_tree); i++) {
        var _inst = instance_find(obj_common_tree, i);
        array_push(_ct_state, { x: _inst.x, y: _inst.y, tree_type: _inst.tree_type, growth_stage: _inst.growth_stage, hits_remaining: _inst.hits_remaining });
    }
    _state.common_trees = _ct_state;

    // Capture Rocks
    var _rock_state = [];
    for (var i = 0; i < instance_number(obj_rock); i++) {
        var _inst = instance_find(obj_rock, i);
        array_push(_rock_state, {
            x: _inst.x, y: _inst.y,
            sprite_name: sprite_get_name(_inst.sprite_index),
            image_index: _inst.image_index,
            hits_remaining: _inst.hits_remaining,
            max_hits: _inst.max_hits,
            is_ore_rock: _inst.is_ore_rock,
            is_coal_rock: _inst.is_coal_rock,
            is_gemstone_rock: _inst.is_gemstone_rock,
            ore_type_index: _inst.ore_type_index,
            ore_item_key: _inst.ore_item_key,
            hit_counter: variable_instance_exists(_inst, "hit_counter") ? _inst.hit_counter : 0
        });
    }
    _state.rocks = _rock_state;

    // Capture Shoveled Holes
    _state.shoveled_tiles = [];
    for (var i = 0; i < instance_number(obj_shoveled); i++) {
        var _inst = instance_find(obj_shoveled, i);
        array_push(_state.shoveled_tiles, { x: _inst.x, y: _inst.y });
    }

    global.room_states[$ _room_name] = _state;

    if (_room_name == "forest") {
        global.forest_insects = [];
        for (var i = 0; i < instance_number(obj_insect); i++) {
            var _inst = instance_find(obj_insect, i);
            array_push(global.forest_insects, { key: _inst.insect_key, x: _inst.x, y: _inst.y });
        }
    }
}

// Helper: build a lookup map { "x_y": index } from an array of stored structs.
function _build_xy_map(_arr) {
    var _m = {};
    for (var _i = 0; _i < array_length(_arr); _i++) {
        var _e = _arr[_i];
        var _k = string(_e.x) + "_" + string(_e.y);
        _m[$ _k] = _i;
    }
    return _m;
}

// Reconcile: update/create/destroy instances to match stored state.
// Safer than destroy-all because it leaves untouched instances (e.g. from the other player) alone.
function scr_restore_room_state(_room_name) {
    var _state = scr_get_room_state(_room_name);

    // ---- TILEMAP (tilled/watered) — always wipe+reapply; no instances involved ----
    var _layer_id = layer_get_id("Tiles_tilled_watered");
    if (_layer_id != -1) {
        var _map_id = layer_tilemap_get_id(_layer_id);
        for (var _ty = 0; _ty < room_height; _ty += 16) {
            for (var _tx = 0; _tx < room_width; _tx += 16) {
                tilemap_set_at_pixel(_map_id, 0, _tx, _ty);
            }
        }
        for (var i = 0; i < array_length(_state.tilled_tiles); i++) {
            var _td = _state.tilled_tiles[i];
            tilemap_set_at_pixel(_map_id, _td.tile, _td.x, _td.y);
        }
    }

    // ---- CROPS & TREES ----
    if (layer_get_id("Instances_Crops") != -1) {
        var _crop_map = _build_xy_map(_state.crops);

        // Remove existing crops/trees not in stored state
        var _to_destroy = [];
        with (obj_crop) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_crop_map, _k)) array_push(_to_destroy, id);
        }
        with (obj_tree) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_crop_map, _k)) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

        // Create/update stored crops
        for (var i = 0; i < array_length(_state.crops); i++) {
            var _c_data = _state.crops[i];
            var _is_tree = false;
            if (variable_struct_exists(_c_data, "type")) {
                _is_tree = (_c_data.type == "tree");
            } else if (variable_struct_exists(_c_data, "is_fruit_tree")) {
                _is_tree = _c_data.is_fruit_tree;
            } else {
                var _c_info = global.crop_data[$ _c_data.crop_type];
                if (_c_info != undefined && variable_struct_exists(_c_info, "is_fruit_tree")) {
                    _is_tree = _c_info.is_fruit_tree;
                }
            }
            var _obj_type = _is_tree ? obj_tree : obj_crop;

            // Find existing instance at this position
            var _inst = noone;
            with (_obj_type) {
                if (x == _c_data.x && y == _c_data.y) { _inst = id; break; }
            }
            if (_inst == noone) {
                _inst = instance_create_layer(_c_data.x, _c_data.y, "Instances_Crops", _obj_type);
            }
            with (_inst) {
                crop_type    = _c_data.crop_type;
                days_passed  = _c_data.days_passed;
                days_to_grow = _c_data.days_to_grow;
                max_stages   = _c_data.max_stages;
                if (_is_tree) {
                    fruit_cycle_days   = variable_struct_exists(_c_data, "fruit_cycle_days")   ? _c_data.fruit_cycle_days   : 2;
                    days_since_harvest = variable_struct_exists(_c_data, "days_since_harvest") ? _c_data.days_since_harvest : 0;
                    has_fruit          = variable_struct_exists(_c_data, "has_fruit")          ? _c_data.has_fruit          : false;
                    fruit_item         = variable_struct_exists(_c_data, "fruit_item")         ? _c_data.fruit_item         : crop_type;
                    hits_remaining     = variable_struct_exists(_c_data, "hits_remaining")     ? _c_data.hits_remaining     : 10;
                } else {
                    growth_stage     = _c_data.growth_stage;
                    is_watered       = _c_data.is_watered;
                    persistent_water = variable_struct_exists(_c_data, "persistent_water") ? _c_data.persistent_water : false;
                    skip_blank_frame = _c_data.skip_blank_frame;
                    image_index      = _c_data.image_index;
                }
                image_speed = 0;
            }
        }
    }

    // ---- CHESTS ----
    if (variable_struct_exists(_state, "chests")) {
        var _chest_map = _build_xy_map(_state.chests);
        var _to_destroy = [];
        with (obj_chest) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_chest_map, _k)) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

        for (var i = 0; i < array_length(_state.chests); i++) {
            var _cd = _state.chests[i];
            if (_cd.x < 0 || _cd.y < 0 || _cd.x >= room_width - 16 || _cd.y >= room_height - 16) continue;
            var _inst = noone;
            with (obj_chest) { if (x == _cd.x && y == _cd.y) { _inst = id; break; } }
            if (_inst == noone) {
                _inst = instance_create_layer(_cd.x, _cd.y, "Instances", obj_chest);
                _inst.image_speed = 0;
                _inst.image_index = 0;
            }
            _inst.storage_array = _cd.storage_array;
        }
    }

    // ---- MACHINES ----
    if (variable_struct_exists(_state, "machines")) {
        var _mach_map = _build_xy_map(_state.machines);
        var _to_destroy = [];
        with (obj_machine) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_mach_map, _k)) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

        for (var i = 0; i < array_length(_state.machines); i++) {
            var _md = _state.machines[i];
            if (_md.x < 0 || _md.y < 0 || _md.x >= room_width - 16 || _md.y >= room_height - 16) continue;
            var _inst = noone;
            with (obj_machine) { if (x == _md.x && y == _md.y) { _inst = id; break; } }
            if (_inst == noone) {
                _inst = instance_create_layer(_md.x, _md.y, "Instances", obj_machine, { machine_type: _md.machine_type });
            }
            _inst.state = _md.state;
            _inst.timer = _md.timer;
            _inst.passive_timer = variable_struct_exists(_md, "passive_timer") ? _md.passive_timer : 0;
            _inst.input_key = _md.input_key;
            _inst.output_key = _md.output_key;
            _inst.output_qty = _md.output_qty;
            if (_inst.state == 1) {
                _inst.image_speed = 0;
                _inst.image_index = 1;
            } else if (_inst.state == 2) {
                _inst.image_speed = 0;
                _inst.image_index = _inst.anim_frames;
                _inst.done_signal = 60;
            } else {
                _inst.image_speed = 0;
                _inst.image_index = 0;
            }
        }
    }

    // ---- BUILDINGS ----
    if (variable_struct_exists(_state, "buildings") && array_length(_state.buildings) > 0) {
        for (var i = 0; i < array_length(_state.buildings); i++) {
            var _b_data = _state.buildings[i];
            var _obj = asset_get_index(_b_data.obj);
            if (_obj == -1) continue;

            // Already exists at this position?
            var _already = false;
            with (_obj) { if (x == _b_data.x && y == _b_data.y) { _already = true; break; } }
            if (_already) continue;

            // Remove placeholder
            var _placeholder = noone;
            switch (_obj) {
                case obj_barn:        _placeholder = obj_barn_placeholder;        break;
                case obj_chicken:     _placeholder = obj_chicken_placeholder;     break;
                case obj_greenhouse:  _placeholder = obj_greenhouse_placeholder;  break;
                case obj_mill:        _placeholder = obj_mill_placeholder;        break;
                case obj_stable:      _placeholder = obj_stable_placeholder;      break;
            }
            if (_placeholder != noone) {
                var _p_inst = instance_nearest(_b_data.x, _b_data.y, _placeholder);
                if (_p_inst != noone && point_distance(_b_data.x, _b_data.y, _p_inst.x, _p_inst.y) <= 1) {
                    instance_destroy(_p_inst);
                }
            }
            instance_create_layer(_b_data.x, _b_data.y, "Instances", _obj);
        }
    }

    // ---- HORSES ----
    if (variable_struct_exists(_state, "horses")) {
        var _horse_map = _build_xy_map(_state.horses);
        var _to_destroy = [];
        with (obj_horse_parent) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_horse_map, _k)) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

        for (var i = 0; i < array_length(_state.horses); i++) {
            var _hd = _state.horses[i];
            var _obj = asset_get_index(_hd.obj);
            if (_obj == -1) continue;
            var _inst = noone;
            with (obj_horse_parent) { if (x == _hd.x && y == _hd.y) { _inst = id; break; } }
            if (_inst == noone) _inst = instance_create_layer(_hd.x, _hd.y, "Instances", _obj);
            if (variable_instance_exists(_inst, "dir")) _inst.dir = _hd.dir;
            if (variable_struct_exists(_hd, "is_bear")) _inst.is_bear = _hd.is_bear;
        }
    }

    // ---- FARM ANIMALS ----
    if (variable_struct_exists(_state, "animals")) {
        // Animals wander so we can't reliably key by position; wipe and recreate.
        with (obj_farm_animal) instance_destroy();
        for (var i = 0; i < array_length(_state.animals); i++) {
            var _a = _state.animals[i];
            var _inst = instance_create_layer(_a.x, _a.y, "Instances", obj_farm_animal);
            with (_inst) {
                animal_type = _a.animal_type;
                variant     = _a.variant;
                dir         = _a.dir;
                sprite_anim = asset_get_index("sprite_" + animal_type + "_" + variant);
                if (sprite_anim == -1) sprite_anim = sprite_chicken_white;
                frame_count = sprite_get_number(sprite_anim);
                if (frame_count == 32 && idle_type > 3) idle_type = 3;
                var _data  = global.animal_data[$ animal_type];
                move_speed = (_data != undefined) ? _data.move_speed : 0.6;
            }
        }
    }

    // ---- WILD/HUNTABLE ANIMALS ----
    if (variable_struct_exists(_state, "wild_animals")) {
        with (obj_wild_animal) instance_destroy();
        for (var i = 0; i < array_length(_state.wild_animals); i++) {
            var _wa = _state.wild_animals[i];
            var _inst = instance_create_layer(_wa.x, _wa.y, "Instances", obj_wild_animal);
            with (_inst) {
                animal_key     = _wa.animal_key;
                is_farm_animal = _wa.is_farm_animal;
                is_test_animal = variable_struct_exists(_wa, "is_test_animal") ? _wa.is_test_animal : false;
                sprite_index   = asset_get_index(_wa.sprite_index);
                move_speed     = _wa.move_speed;
                hp             = _wa.hp;
                max_hp         = _wa.max_hp;
                dir            = _wa.dir;
            }
        }
    }

    // ---- COMMON TREES ----
    if (variable_struct_exists(_state, "common_trees")) {
        var _ct_map = _build_xy_map(_state.common_trees);
        var _to_destroy = [];
        with (obj_common_tree) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_ct_map, _k)) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

        for (var i = 0; i < array_length(_state.common_trees); i++) {
            var _ct = _state.common_trees[i];
            var _inst = noone;
            with (obj_common_tree) { if (x == _ct.x && y == _ct.y) { _inst = id; break; } }
            if (_inst == noone) _inst = instance_create_layer(_ct.x, _ct.y, "Instances", obj_common_tree);
            _inst.tree_type      = _ct.tree_type;
            _inst.growth_stage   = _ct.growth_stage;
            _inst.hits_remaining = variable_struct_exists(_ct, "hits_remaining") ? _ct.hits_remaining : 10;
        }
    }

    // ---- ROCKS ----
    if (variable_struct_exists(_state, "rocks")) {
        var _rock_map = _build_xy_map(_state.rocks);
        var _to_destroy = [];
        with (obj_rock) {
            var _k = string(x) + "_" + string(y);
            if (!variable_struct_exists(_rock_map, _k)) array_push(_to_destroy, id);
        }
        for (var i = 0; i < array_length(_to_destroy); i++) instance_destroy(_to_destroy[i]);

        for (var i = 0; i < array_length(_state.rocks); i++) {
            var _r = _state.rocks[i];
            var _inst = noone;
            with (obj_rock) { if (x == _r.x && y == _r.y) { _inst = id; break; } }
            if (_inst == noone) {
                _inst = instance_create_layer(_r.x, _r.y, "Instances", obj_rock);
                _inst.image_speed = 0;
            }
            var _spr = asset_get_index(_r.sprite_name);
            if (_spr != -1) _inst.sprite_index = _spr;
            _inst.image_index = variable_struct_exists(_r, "image_index") ? _r.image_index : 0;
            _inst.hits_remaining = variable_struct_exists(_r, "hits_remaining") ? _r.hits_remaining : 10;
            _inst.max_hits = variable_struct_exists(_r, "max_hits") ? _r.max_hits : 10;
            _inst.is_ore_rock = variable_struct_exists(_r, "is_ore_rock") ? _r.is_ore_rock : false;
            _inst.is_coal_rock = variable_struct_exists(_r, "is_coal_rock") ? _r.is_coal_rock : false;
            _inst.is_gemstone_rock = variable_struct_exists(_r, "is_gemstone_rock") ? _r.is_gemstone_rock : false;
            _inst.ore_type_index = variable_struct_exists(_r, "ore_type_index") ? _r.ore_type_index : -1;
            _inst.ore_item_key = variable_struct_exists(_r, "ore_item_key") ? _r.ore_item_key : "";
            _inst.hit_counter = variable_struct_exists(_r, "hit_counter") ? _r.hit_counter : 0;
        }
    }

    // ---- SHOVELED HOLES ----
    if (variable_struct_exists(_state, "shoveled_tiles")) {
        with (obj_shoveled) instance_destroy();
        for (var i = 0; i < array_length(_state.shoveled_tiles); i++) {
            var _t = _state.shoveled_tiles[i];
            if (_t.x >= 0 && _t.y >= 0 && _t.x < room_width - 16 && _t.y < room_height - 16) {
                instance_create_layer(_t.x, _t.y, "Instances", obj_shoveled);
            }
        }
    }
}

function scr_advance_stored_room_states(_exclude_room_name) {
    var _rooms = variable_struct_get_names(global.room_states);
    for (var r = 0; r < array_length(_rooms); r++) {
        var _room_name = _rooms[r];
        if (_room_name == _exclude_room_name) continue;
        var _state = global.room_states[$ _room_name];

        // Rain auto-watering for off-screen rooms
        if (global.weather_today == "rain") {
            for (var _ri = 0; _ri < array_length(_state.crops); _ri++) {
                var _rc = _state.crops[_ri];
                var _is_tree_rc = variable_struct_exists(_rc, "is_fruit_tree") && _rc.is_fruit_tree;
                if (!_is_tree_rc) _rc.is_watered = true;
            }
            for (var _rj = 0; _rj < array_length(_state.tilled_tiles); _rj++) {
                if (_state.tilled_tiles[_rj].tile == 72)
                    _state.tilled_tiles[_rj].tile = 168;
            }
        }

        for (var i = 0; i < array_length(_state.crops); i++) {
            var _c_data = _state.crops[i];
            
            // Determine type
            var _is_tree = false;
            if (variable_struct_exists(_c_data, "type")) {
                _is_tree = (_c_data.type == "tree");
            } else if (variable_struct_exists(_c_data, "is_fruit_tree")) {
                _is_tree = _c_data.is_fruit_tree;
            } else {
                var _c_info = global.crop_data[$ _c_data.crop_type];
                if (_c_info != undefined && variable_struct_exists(_c_info, "is_fruit_tree")) {
                    _is_tree = _c_info.is_fruit_tree;
                }
            }

            if (_is_tree) {
                // Tree growth and fruiting logic
                if (_c_data.days_passed < _c_data.max_stages) {
                    _c_data.days_passed += 1;
                } else {
                    if (!variable_struct_exists(_c_data, "days_since_harvest")) _c_data.days_since_harvest = 0;
                    if (!variable_struct_exists(_c_data, "fruit_cycle_days")) _c_data.fruit_cycle_days = 2;
                    if (!variable_struct_exists(_c_data, "has_fruit")) _c_data.has_fruit = false;
                    
                    _c_data.days_since_harvest += 1;
                    if (!_c_data.has_fruit && _c_data.days_since_harvest >= _c_data.fruit_cycle_days) {
                        _c_data.has_fruit = true;
                    }
                }
                _state.crops[i] = _c_data;
            } else if (_c_data.is_watered) {
                // Regular crop growth logic
                _c_data.days_passed += 1;
                var _ideal = floor((_c_data.days_passed / _c_data.days_to_grow) * _c_data.max_stages);
                _c_data.growth_stage = clamp(_ideal, 0, _c_data.max_stages);
                _c_data.image_index = (_c_data.skip_blank_frame && _c_data.growth_stage == 1) ? 0 : _c_data.growth_stage;
                _c_data.is_watered = (variable_struct_exists(_c_data, "persistent_water") && _c_data.persistent_water);
                _state.crops[i] = _c_data;
            }
        }
        for (var j = 0; j < array_length(_state.tilled_tiles); j++) {
            if (_state.tilled_tiles[j].tile == 168) _state.tilled_tiles[j].tile = 72;
        }
        // Re-water tiles for crops with persistent_water
        for (var ci = 0; ci < array_length(_state.crops); ci++) {
            var _cd = _state.crops[ci];
            if (variable_struct_exists(_cd, "persistent_water") && _cd.persistent_water &&
                variable_struct_exists(_cd, "type") && _cd.type == "crop") {
                for (var ti = 0; ti < array_length(_state.tilled_tiles); ti++) {
                    if (_state.tilled_tiles[ti].x == _cd.x && _state.tilled_tiles[ti].y == _cd.y) {
                        _state.tilled_tiles[ti].tile = 168;
                        break;
                    }
                }
            }
        }
        global.room_states[$ _room_name] = _state;
    }
}

function scr_write_text_file(_path, _text) {
    var _file = file_text_open_write(_path);
    file_text_write_string(_file, _text);
    file_text_close(_file);
}

function scr_read_text_file(_path) {
    if (!file_exists(_path)) return "";
    var _file = file_text_open_read(_path);
    var _text = "";
    while (!file_text_eof(_file)) {
        _text += file_text_read_string(_file);
        if (!file_text_eof(_file)) {
            file_text_readln(_file);
            _text += "\n";
        }
    }
    file_text_close(_file);
    return _text;
}

function scr_save_game() {
    scr_capture_current_room_state();

    // Serializar todos los jugadores (versión 2)
    var _players_arr = [];
    with (obj_player) {
        array_push(_players_arr, {
            player_id:       player_id,
            room_name:       room_get_name(room),
            x:               x,
            y:               y,
            dir:             dir,
            money:           money,
            energy:          energy,
            hp:              hp,
            selected_slot:   selected_slot,
            inventory_array: inventory_array,
            backpack_array:  backpack_array,
            shipping_array:  shipping_array,
            held_item:       held_item
        });
    }

    var _save_data = {
        version: 3,
        slot: global.save_slot,
        player_name: global.player_name,
        farm_name: global.farm_name,
        time: { minute: global.game_minute, hour: global.game_hour, day: global.day, year: global.year, season_index: global.season_index, season: global.season },
        players: _players_arr,
        room_states: global.room_states,
        room_drops: global.room_drops,
        next_drop_uid: global.next_drop_uid,
        mine_unlocks: global.mine_unlocks,
        mine_progress: global.mine_progress,
        collected_items: global.collected_items,
        shipped_quantities: global.shipped_quantities,
        weather: global.weather_today,
        town_stage: global.town_stage,
        town_donations: global.town_donations,
        town_construction_day: global.town_construction_day,
        town_construction_duration: global.town_construction_duration
    };
    scr_write_text_file(global.save_file_path, json_stringify(_save_data));
    if (global.save_slot > 0) scr_slot_write_info(global.save_slot);
    show_debug_message("Game saved to: " + global.save_file_path);
    scr_notify("Juego guardado");
}

function scr_read_save_game() {
    if (!file_exists(global.save_file_path)) return undefined;
    var _raw = scr_read_text_file(global.save_file_path);
    if (_raw == "") return undefined;
    return json_parse(_raw);
}

function scr_apply_loaded_game(_save_data) {
    if (!is_struct(_save_data)) exit;
    global.game_minute = _save_data.time.minute;
    global.game_hour = _save_data.time.hour;
    global.day = _save_data.time.day;
    global.year = _save_data.time.year;
    global.season_index = _save_data.time.season_index;
    global.season = _save_data.time.season;
    if (variable_struct_exists(_save_data, "weather"))
        global.weather_today = _save_data.weather;
    else
        global.weather_today = "sunny";
    global.room_states = _save_data.room_states;
    global.farm_populated = variable_struct_exists(global.room_states, "farm");
    global.room_drops = _save_data.room_drops;
    global.next_drop_uid = _save_data.next_drop_uid;
    if (variable_struct_exists(_save_data, "player_name")) global.player_name = _save_data.player_name;
    if (variable_struct_exists(_save_data, "farm_name")) global.farm_name = _save_data.farm_name;
    if (variable_struct_exists(_save_data, "slot") && _save_data.slot > 0) scr_set_save_slot(_save_data.slot);
    if (variable_struct_exists(_save_data, "mine_unlocks")) global.mine_unlocks = _save_data.mine_unlocks;
    if (variable_struct_exists(_save_data, "mine_progress")) global.mine_progress = _save_data.mine_progress;
    if (variable_struct_exists(_save_data, "collected_items")) {
        global.collected_items = _save_data.collected_items;
    } else {
        // Migrate: mark all items currently in inventory as collected (pre-collection saves)
        for (var _mi = 0; _mi < array_length(_players_arr); _mi++) {
            var _mpd = _players_arr[_mi];
            for (var _msi = 0; _msi < array_length(_mpd.inventory_array); _msi++) {
                if (is_struct(_mpd.inventory_array[_msi])) global.collected_items[$ _mpd.inventory_array[_msi].key] = true;
            }
            for (var _msi = 0; _msi < array_length(_mpd.backpack_array); _msi++) {
                if (is_struct(_mpd.backpack_array[_msi])) global.collected_items[$ _mpd.backpack_array[_msi].key] = true;
            }
            for (var _msi = 0; _msi < array_length(_mpd.shipping_array); _msi++) {
                if (is_struct(_mpd.shipping_array[_msi])) global.collected_items[$ _mpd.shipping_array[_msi].key] = true;
            }
        }
    }

    if (variable_struct_exists(_save_data, "shipped_quantities")) {
        global.shipped_quantities = _save_data.shipped_quantities;
    } else {
        global.shipped_quantities = {};
    }

    // Town progression
    if (variable_struct_exists(_save_data, "town_stage")) {
        global.town_stage = _save_data.town_stage;
        global.town_donations = variable_struct_exists(_save_data, "town_donations") ? _save_data.town_donations : {};
        global.town_construction_day = variable_struct_exists(_save_data, "town_construction_day") ? _save_data.town_construction_day : 0;
        global.town_construction_duration = variable_struct_exists(_save_data, "town_construction_duration") ? _save_data.town_construction_duration : 0;
    } else {
        global.town_stage = TownStage.INITIAL;
        global.town_donations = {};
        global.town_construction_day = 0;
        global.town_construction_duration = 0;
    }
    scr_update_shop_availability();

    // Migrar guardados v1 -> v2
    var _players_arr;
    if (_save_data.version == 1) {
        _players_arr = [{
            player_id:       1,
            room_name:       _save_data.player.room_name,
            x:               _save_data.player.x,
            y:               _save_data.player.y,
            dir:             _save_data.player.dir,
            money:           _save_data.economy.money,
            energy:          500,
            selected_slot:   _save_data.inventory.selected_slot,
            inventory_array: _save_data.inventory.inventory_array,
            backpack_array:  _save_data.inventory.backpack_array,
            shipping_array:  _save_data.inventory.shipping_array,
            held_item:       _save_data.inventory.held_item
        }];
    } else {
        _players_arr = _save_data.players;
    }

    // Limpiar jugadores existentes antes de recrear desde el guardado
    // (evita duplicados si el room layout ya tenia un obj_player colocado)
    with (obj_player) instance_destroy();

    // Restaurar cada jugador
    var _first_room = "";
    for (var _pi = 0; _pi < array_length(_players_arr); _pi++) {
        var _pd = _players_arr[_pi];

        var _pinst = instance_create_layer(0, 0, "Instances", obj_player);
        _pinst.player_id = _pd.player_id;
        _pinst.is_local  = (_pd.player_id == 1);
        _pinst.is_host   = (_pd.player_id == 1);

        _pinst.money          = _pd.money;
        _pinst.energy         = _pd.energy;
        if (variable_struct_exists(_pd, "hp")) _pinst.hp = _pd.hp;
        _pinst.selected_slot  = _pd.selected_slot;
        _pinst.inventory_array = _pd.inventory_array;
        _pinst.backpack_array  = _pd.backpack_array;
        _pinst.shipping_array  = _pd.shipping_array;

        // Asegurar tamaño correcto del inventory array (hotbar cyclable)
        if (array_length(_pinst.inventory_array) < 30) {
            var _extra = 30 - array_length(_pinst.inventory_array);
            for (var i = 0; i < _extra; i++) array_push(_pinst.inventory_array, -1);
        }

        _pinst.held_item       = _pd.held_item;
        _pinst.show_backpack   = false;
        _pinst.show_shipping   = false;

        // Asegurar tamaño correcto del shipping array
        if (array_length(_pinst.shipping_array) < _pinst.max_shipping_slots) {
            var _extra = _pinst.max_shipping_slots - array_length(_pinst.shipping_array);
            for (var i = 0; i < _extra; i++) array_push(_pinst.shipping_array, -1);
        }

        if (_pd.player_id == 1) {
            // El jugador local (host/single-player) usa pending para reposicionarse
            global.local_player = _pinst;
            global.pending_player_room_name = _pd.room_name;
            global.pending_player_x         = _pd.x;
            global.pending_player_y         = _pd.y;
            global.pending_player_dir        = _pd.dir;
            _first_room = _pd.room_name;
        }
    }

    var _target_room = asset_get_index(_first_room);
    if (_target_room != -1 && room_get_name(room) != _first_room) {
        room_goto(_target_room);
    } else {
        if (instance_exists(global.local_player)) {
            global.local_player.x        = global.pending_player_x;
            global.local_player.y        = global.pending_player_y;
            global.local_player.dir      = global.pending_player_dir;
            global.local_player.is_riding = false;
            global.local_player.mount_is_bear = false;
        }
        scr_restore_room_state(room_get_name(room));
        scr_restore_room_drops(room_get_name(room));
        if (instance_exists(obj_controller)) with (obj_controller) update_tilesets();
        global.pending_player_room_name = "";
    }
    scr_check_collection_unlocks();
}

function scr_sleep_and_save() {
    var _bed = instance_find(obj_bed, 0);
    if (_bed == noone) exit;

    var _lp = global.local_player;
    if (instance_exists(_lp)) {
        _lp.is_riding = false;
        _lp.mount_is_bear = false;
        _lp.state     = STATE.IDLE;
        _lp.dir       = DIR.RIGHT;
        _lp.x         = _bed.x + 40;
        _lp.y         = _bed.y + 18;
    }

    // Procesar ventas de cada jugador; solo el local muestra el resumen aqui
    var _summary = scr_process_shipping(_lp);

    if (array_length(_summary.items) > 0) {
        if (instance_exists(obj_controller)) {
            obj_controller.shipping_summary_data = _summary;
            obj_controller.shipping_summary_open = true;
        }
    } else {
        start_new_day();
        scr_save_game();
        scr_notify("Dia terminado");
    }
}

// Called from obj_controller Step when local player clicks "Si" on the sleep menu.
// Routes to the right sleep function based on net role.
function scr_on_sleep_yes() {
    if (global.net_role == NET_ROLE.CLIENT) {
        if (instance_exists(obj_controller)) obj_controller.sent_sleep_request = true;
        net_send_sleep_request();
        scr_notify("Esperando que el anfitrion duerma...");
    } else if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        if (instance_exists(obj_controller)) obj_controller.host_wants_sleep = true;
        if (instance_exists(obj_controller) && obj_controller.client_wants_sleep) {
            obj_controller.host_wants_sleep  = false;
            obj_controller.client_wants_sleep = false;
            obj_controller.sleep_prompt_sent = false;
            scr_sleep_and_save_mp();
        } else {
            obj_controller.sleep_prompt_sent = true;
            net_send_sleep_prompt();
            scr_notify("Esperando respuesta del invitado...");
        }
    } else {
        scr_sleep_and_save();
    }
}

// Called when the player chooses "Siesta" from the sleep menu.
// Advances time by 5 hours and restores energy without ending the day.
function scr_take_nap() {
    var _lp = global.local_player;
    if (!instance_exists(_lp)) exit;

    if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
        // Request nap from host — host handles time/energy authority.
        net_send_nap();
        scr_notify("Esperando siesta...");
        return;
    }

    global.game_hour += 5;
    _lp.energy = _lp.max_energy;

    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        // Restore energy on ghost as well
        var _ghost = obj_net.remote_player_ghost;
        if (instance_exists(_ghost)) {
            _ghost.energy = _ghost.max_energy;
            net_send_energy_update(2, _ghost.energy);
        }
        net_send_time_update();
    }

    scr_notify("Siesta completada. Energia restaurada.");
}

// Multiplayer sleep: process both players' shipping, send client summary, start new day.
// Called on HOST when both players have agreed to sleep.
function scr_sleep_and_save_mp() {
    var _bed = instance_find(obj_bed, 0);
    if (_bed == noone) exit;

    var _lp = global.local_player;
    if (instance_exists(_lp)) {
        _lp.is_riding = false;
        _lp.mount_is_bear = false;
        _lp.state     = STATE.IDLE;
        _lp.dir       = DIR.RIGHT;
        _lp.x         = _bed.x + 40;
        _lp.y         = _bed.y + 18;
    }

    // Process client (ghost) shipping; send summary and money update to client.
    if (instance_exists(obj_net)) {
        var _ghost = obj_net.remote_player_ghost;
        if (instance_exists(_ghost)) {
            var _client_summary = scr_process_shipping(_ghost);
            net_send_money_update(2, _ghost.money);
            net_send_shipping_summary(2, _client_summary);
        }
    }

    // Process host shipping and show summary (or start new day immediately).
    var _host_summary = scr_process_shipping(_lp);
    if (array_length(_host_summary.items) > 0) {
        if (instance_exists(obj_controller)) {
            obj_controller.shipping_summary_data = _host_summary;
            obj_controller.shipping_summary_open = true;
        }
    } else {
        start_new_day();
        scr_save_game();
        scr_notify("Dia terminado");
    }
}

function scr_process_shipping(_player = global.local_player) {
    var _summary = { items: [], total: 0 };
    if (!instance_exists(_player)) return _summary;

    var _prev_tiers = scr_count_unlocked_tiers();
    var _shipping_array = _player.shipping_array;
    
    for (var i = 0; i < array_length(_shipping_array); i++) {
        var _item = _shipping_array[i];
        if (is_struct(_item)) {
            var _data = scr_get_item_data(_item.key);
            if (is_struct(_data) && variable_struct_exists(_data, "base_sell_price")) {
                var _item_weight = variable_struct_exists(_item, "weight") ? _item.weight : 1;
                var _mult = 1;
                if (variable_struct_exists(global.insect_data, _item.key)) {
                    var _bq = scr_get_tool_quality("bugnet", _player);
                    if (_bq >= 0) _mult = 1 + ((_bq + 1) * 0.05);
                }
                if (variable_struct_exists(global.fish_data, _item.key)) {
                    var _fq = scr_get_tool_quality("fishing_rod", _player);
                    if (_fq >= 0) _mult = 1 + ((_fq + 1) * 0.05);
                }
                var _subtotal = _data.base_sell_price * _item.quantity * _item_weight * _mult;
                _summary.total += _subtotal;
                
                // Buscar si ya lo agregamos al resumen para agruparlo
                var _found = false;
                for (var j = 0; j < array_length(_summary.items); j++) {
                    if (_summary.items[j].key == _item.key) {
                        _summary.items[j].quantity += _item.quantity;
                        _summary.items[j].subtotal += _subtotal;
                        _found = true;
                        break;
                    }
                }
                
                    if (!_found) {
                    array_push(_summary.items, {
                        key: _item.key,
                        name: _data.name,
                        quantity: _item.quantity,
                        unit_price: _data.base_sell_price * _mult,
                        subtotal: _subtotal,
                        sprite: _data.sprite,
                        subimg: _data.subimg
                    });
                }
            }
            scr_on_item_shipped(_item.key, _item.quantity);
            // Limpiar slot del shipping bin
            _shipping_array[i] = -1;
        }
    }
    
    if (_summary.total > 0) {
        _player.money += _summary.total;
    }
    
    var _new_tiers = scr_count_unlocked_tiers();
    if (_new_tiers > _prev_tiers) {
        scr_notify("Nuevas semillas disponibles en la tienda de Miraculos!");
    }
    
    return _summary;
}

// Formato legible para pesos: gramos, kg o toneladas
function scr_format_weight(_w) {
    if (_w < 1.0)    return string(round(_w * 1000)) + "g";
    if (_w < 1000.0) return string(round(_w)) + "kg";
    return string_format(_w / 1000, 1, 1) + "t";
}

function scr_notify(_text) {
    if (instance_exists(obj_controller)) {
        var _notif = { text: _text, timer: 120, alpha: 1.0 };
        ds_list_add(obj_controller.notifications, _notif);
    }
}

function scr_draw_interact_prompt(_x, _y, _text) {
    draw_set_font(fnt_pixel_operator);
    var _tw = string_width(_text);
    var _th = string_height(_text);
    var _pad = 4;
    var _x1 = _x - (_tw / 2) - _pad;
    var _y1 = _y - _th - (_pad * 2) - 8;
    var _x2 = _x + (_tw / 2) + _pad;
    var _y2 = _y - 8;
    draw_set_alpha(0.8);
    draw_roundrect_color_ext(_x1, _y1, _x2, _y2, 8, 8, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_x1, _y1, _x2, _y2, 8, 8, c_white, c_white, true);
    draw_primitive_begin(pr_trianglelist);
    draw_vertex_color(_x - 4, _y2, c_black, 0.8);
    draw_vertex_color(_x + 4, _y2, c_black, 0.8);
    draw_vertex_color(_x, _y2 + 6, c_black, 0.8);
    draw_primitive_end();
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_color(_x, (_y1 + _y2) / 2, _text, c_white, c_white, c_white, c_white, 1.0);
}

function scr_inventory_cycle_hotbars(_player = global.local_player) {
    if (!instance_exists(_player)) return;
    
    var _row_size = 10;
    var _total_hotbar = array_length(_player.inventory_array);
    
    // Ensure the array matches the player's total_slots expectation
    if (_total_hotbar < 20) {
         // If for some reason it's too small, try to use the instance variable or just return
         if (variable_instance_exists(_player, "total_slots") && _player.total_slots >= 20) {
             // Fill it up
             while(array_length(_player.inventory_array) < _player.total_slots) array_push(_player.inventory_array, -1);
             _total_hotbar = array_length(_player.inventory_array);
         } else {
             return; 
         }
    }
    
    // Rotate rows: R0 -> temp, R1 -> R0, R2 -> R1, temp -> R2
    var _temp_r0 = array_create(_row_size);
    for (var i = 0; i < _row_size; i++) _temp_r0[i] = _player.inventory_array[i];
    
    // Shift rows up
    for (var i = 0; i < _total_hotbar - _row_size; i++) {
        _player.inventory_array[i] = _player.inventory_array[i + _row_size];
    }
    
    // Put Row 0 at the end
    var _last_row_start = _total_hotbar - _row_size;
    for (var i = 0; i < _row_size; i++) {
        _player.inventory_array[_last_row_start + i] = _temp_r0[i];
    }
    
    // Network Sync
    if (global.net_role != NET_ROLE.NONE && instance_exists(obj_net) && obj_net.is_connected) {
        for (var i = 0; i < _total_hotbar; i++) {
            net_send_inventory_update(_player.player_id, 0, i, _player.inventory_array[i]);
        }
    }
}

function scr_get_item_data(_key) {
    if (variable_struct_exists(global.seed_data,   _key)) return global.seed_data[$   _key];
    if (variable_struct_exists(global.crop_data,   _key)) return global.crop_data[$   _key];
    if (variable_struct_exists(global.tool_data,   _key)) return global.tool_data[$   _key];
    if (variable_struct_exists(global.weapon_data, _key)) return global.weapon_data[$ _key];
    if (variable_struct_exists(global.placeable_data, _key)) return global.placeable_data[$ _key];
    if (variable_struct_exists(global.material_data, _key)) return global.material_data[$ _key];
    if (variable_struct_exists(global.forage_data,   _key)) return global.forage_data[$   _key];
    if (variable_struct_exists(global.fish_data,     _key)) return global.fish_data[$     _key];
    if (variable_struct_exists(global.insect_data,   _key)) return global.insect_data[$   _key];
    if (variable_struct_exists(global.animal_product_data,     _key)) return global.animal_product_data[$     _key];
    if (variable_struct_exists(global.crafting_material_data, _key)) return global.crafting_material_data[$ _key];
    if (variable_struct_exists(global.ore_data, _key)) return global.ore_data[$ _key];
    if (variable_struct_exists(global.bar_data, _key)) return global.bar_data[$ _key];
    if (variable_struct_exists(global.jam_data, _key)) return global.jam_data[$ _key];
    if (variable_struct_exists(global.gemstone_data, _key)) return global.gemstone_data[$ _key];
    if (variable_struct_exists(global.dye_data, _key)) return global.dye_data[$ _key];
    if (variable_struct_exists(global.enemy_collection_data, _key)) return global.enemy_collection_data[$ _key];
    if (variable_struct_exists(global.wild_animal_collection_data, _key)) return global.wild_animal_collection_data[$ _key];
    if (variable_struct_exists(global.farm_animal_collection_data, _key)) return global.farm_animal_collection_data[$ _key];
    return undefined;
}
function scr_count_item(_key, _player = global.local_player) {
    if (!instance_exists(_player)) return 0;
    var _total = 0;
    for (var i = 0; i < _player.total_slots; i++) {
        var _s = _player.inventory_array[i];
        if (is_struct(_s) && _s.key == _key) _total += _s.quantity;
    }
    for (var i = 0; i < _player.max_backpack_slots; i++) {
        var _s = _player.backpack_array[i];
        if (is_struct(_s) && _s.key == _key) _total += _s.quantity;
    }
    return _total;
}

function scr_remove_item(_key, _qty, _player = global.local_player) {
    if (scr_count_item(_key, _player) < _qty) return false;
    var _left = _qty;
    for (var i = 0; i < _player.total_slots && _left > 0; i++) {
        var _s = _player.inventory_array[i];
        if (is_struct(_s) && _s.key == _key) {
            var _take = min(_s.quantity, _left);
            _s.quantity -= _take;
            _left       -= _take;
            if (_s.quantity <= 0) _player.inventory_array[i] = -1;
        }
    }
    for (var i = 0; i < _player.max_backpack_slots && _left > 0; i++) {
        var _s = _player.backpack_array[i];
        if (is_struct(_s) && _s.key == _key) {
            var _take = min(_s.quantity, _left);
            _s.quantity -= _take;
            _left       -= _take;
            if (_s.quantity <= 0) _player.backpack_array[i] = -1;
        }
    }
    return true;
}

function scr_count_item_group(_group_keys, _player = global.local_player) {
    var _total = 0;
    for (var _gi = 0; _gi < array_length(_group_keys); _gi++) {
        _total += scr_count_item(_group_keys[_gi], _player);
    }
    return _total;
}

function scr_remove_items_from_group(_group_keys, _qty, _player = global.local_player) {
    var _left = _qty;
    for (var _gi = 0; _gi < array_length(_group_keys) && _left > 0; _gi++) {
        var _available = scr_count_item(_group_keys[_gi], _player);
        if (_available > 0) {
            var _remove = min(_available, _left);
            scr_remove_item(_group_keys[_gi], _remove, _player);
            _left -= _remove;
        }
    }
    return (_left == 0);
}

function scr_notify_item(_qty, _name) {
    if (instance_exists(obj_controller)) {
        // Check if an item notification for this item type already exists
        for (var i = 0; i < ds_list_size(obj_controller.notifications); i++) {
            var _n = obj_controller.notifications[| i];
            
            // Check if this notification is for the same item name
            // The format is "+QTY NAME"
            var _space_pos = string_pos(" ", _n.text);
            if (_space_pos > 0) {
                var _existing_name = string_copy(_n.text, _space_pos + 1, string_length(_n.text) - _space_pos);
                if (_existing_name == _name) {
                    // Update quantity
                    var _current_qty = real(string_copy(_n.text, 2, _space_pos - 2));
                    var _new_qty = _current_qty + _qty;
                    
                    _n.text = "+" + string(_new_qty) + " " + _name;
                    _n.timer = 120; // Reset timer
                    _n.alpha = 1.0;
                    return;
                }
            }
        }
        // Otherwise create new notification
        scr_notify("+" + string(_qty) + " " + _name);
    }
}

function scr_setup_forest_trees() {
    if (!layer_exists("Tiles_trees")) return;
    if (layer_exists("Tiles_trees_top")) return;

    var _back_layer = layer_get_id("Tiles_trees");
    var _back_tm    = layer_tilemap_get_id(_back_layer);
    if (_back_tm == -1) return;

    var _map_w = tilemap_get_width(_back_tm);
    var _map_h = tilemap_get_height(_back_tm);

    var _front_layer = layer_create(-2000, "Tiles_trees_top");
    var _front_tm = layer_tilemap_create(
        _front_layer,
        tilemap_get_x(_back_tm),
        tilemap_get_y(_back_tm),
        tilemap_get_tileset(_back_tm),
        _map_w,
        _map_h
    );

    for (var _cx = 0; _cx < _map_w; _cx++) {
        for (var _cy = 0; _cy < _map_h; _cy++) {
            var _tile = tilemap_get(_back_tm, _cx, _cy);
            if (_tile != 0) {
                var _below = (_cy + 1 < _map_h) ? tilemap_get(_back_tm, _cx, _cy + 1) : 0;
                if (_below != 0) {
                    tilemap_set(_front_tm, _tile, _cx, _cy);
                    tilemap_set(_back_tm,  0,     _cx, _cy);
                }
            }
        }
    }
}

/// Devuelve los requisitos para mejorar una herramienta desde la calidad dada
function scr_get_upgrade_requirements(_quality) {
    var _tiers = [
        { bar: "bar_bronce",      stone: 10, coal: 5,  money: 500   },
        { bar: "bar_plata",       stone: 15, coal: 8,  money: 1000  },
        { bar: "bar_oro",         stone: 20, coal: 10, money: 2000  },
        { bar: "bar_broncastanio", stone: 25, coal: 12, money: 4000  },
        { bar: "bar_chubestanio", stone: 30, coal: 15, money: 8000  },
        { bar: "bar_picastanio",  stone: 35, coal: 18, money: 16000 },
        { bar: "bar_hitlerstanio", stone: 40, coal: 20, money: 32000 },
        { bar: "bar_vitolanio",   stone: 50, coal: 25, money: 64000 },
    ];
    if (_quality >= 0 && _quality < array_length(_tiers)) {
        var _t = _tiers[_quality];
        return {
            price_money: _t.money,
            price_items: [
                { key: _t.bar, qty: 10 },
                { key: "stone", qty: _t.stone },
                { key: "coal", qty: _t.coal }
            ]
        };
    }
    return undefined;
}

/// Devuelve la calidad actual de una herramienta en el inventario del jugador (-1 si no la tiene)
function scr_get_tool_quality(_tool_key, _player = global.local_player) {
    if (!instance_exists(_player)) return -1;
    var _arrays = [_player.inventory_array, _player.backpack_array];
    for (var a = 0; a < 2; a++) {
        var _arr = _arrays[a];
        for (var i = 0; i < array_length(_arr); i++) {
            var _slot = _arr[i];
            if (is_struct(_slot) && _slot.key == _tool_key) {
                return variable_struct_exists(_slot, "quality") ? _slot.quality : QUALITY.OXIDADO;
            }
        }
    }
    return -1;
}

/// Intenta mejorar una herramienta en la herreria: verifica requisitos, descuenta materiales y mejora
function scr_blacksmith_upgrade(_tool_key, _player = global.local_player) {
    if (!instance_exists(_player)) return;
    var _quality = scr_get_tool_quality(_tool_key, _player);
    if (_quality < 0) {
        var _idata = scr_get_item_data(_tool_key);
        var _tname = (_idata != undefined) ? _idata.name : _tool_key;
        _player.shop_msg = "No tienes " + _tname;
        _player.shop_msg_timer = 90;
        return;
    }
    if (_quality >= QUALITY.VITOLANIO) {
        _player.shop_msg = "Ya esta al maximo!";
        _player.shop_msg_timer = 90;
        return;
    }
    var _reqs = scr_get_upgrade_requirements(_quality);
    if (_reqs == undefined) {
        _player.shop_msg = "Error en requisitos";
        _player.shop_msg_timer = 90;
        return;
    }
    if (_player.money < _reqs.price_money) {
        _player.shop_msg = "Fondos insuficientes";
        _player.shop_msg_timer = 90;
        return;
    }
    for (var i = 0; i < array_length(_reqs.price_items); i++) {
        var _req = _reqs.price_items[i];
        if (scr_count_item(_req.key, _player) < _req.qty) {
            _player.shop_msg = "Te faltan materiales";
            _player.shop_msg_timer = 90;
            return;
        }
    }
    _player.money -= _reqs.price_money;
    for (var i = 0; i < array_length(_reqs.price_items); i++) {
        var _req = _reqs.price_items[i];
        scr_remove_item(_req.key, _req.qty, _player);
    }
    scr_upgrade_tool(_tool_key);
    _player.shop_msg = "Herramienta mejorada!";
    _player.shop_msg_timer = 90;
    scr_play_sound_clip(sound_item_pickup, 0.75, 1.00);
}

function scr_slot_get_path(_slot) {
    return "saves/slot_" + string(_slot) + "/savegame.json";
}

function scr_slot_get_info_path(_slot) {
    return "saves/slot_" + string(_slot) + "/slot_info.json";
}

function scr_slot_is_occupied(_slot) {
    return file_exists(scr_slot_get_path(_slot));
}

function scr_slot_read_info(_slot) {
    // Try reading slot_info.json first (fast path)
    var _info_path = scr_slot_get_info_path(_slot);
    if (file_exists(_info_path)) {
        var _raw = scr_read_text_file(_info_path);
        if (_raw != "") {
            var _parsed = json_parse(_raw);
            if (is_struct(_parsed)) return _parsed;
        }
    }
    // Fallback: read full savegame
    var _save_path = scr_slot_get_path(_slot);
    if (!file_exists(_save_path)) return undefined;
    var _raw = scr_read_text_file(_save_path);
    if (_raw == "") return undefined;
    var _data = json_parse(_raw);
    if (!is_struct(_data)) return undefined;
    return {
        farm_name: variable_struct_exists(_data, "farm_name") ? _data.farm_name : "",
        player_name: variable_struct_exists(_data, "player_name") ? _data.player_name : "",
        day: _data.time.day,
        season_index: _data.time.season_index,
        season: variable_struct_exists(_data.time, "season") ? _data.time.season : "spring",
        year: _data.time.year
    };
}

function scr_slot_write_info(_slot) {
    if (_slot <= 0) exit;
    var _info = {
        farm_name: global.farm_name,
        player_name: global.player_name,
        day: global.day,
        season_index: global.season_index,
        season: global.season,
        year: global.year
    };
    var _path = scr_slot_get_info_path(_slot);
    scr_write_text_file(_path, json_stringify(_info));
}

function scr_set_save_slot(_slot) {
    global.save_slot = _slot;
    global.save_dir = "saves";
    if (!directory_exists(global.save_dir)) directory_create(global.save_dir);
    var _slot_dir = "saves/slot_" + string(_slot);
    if (!directory_exists(_slot_dir)) directory_create(_slot_dir);
    global.save_file_path = _slot_dir + "/savegame.json";
}

function scr_delete_save_slot(_slot) {
    var _save_path = scr_slot_get_path(_slot);
    var _info_path = scr_slot_get_info_path(_slot);
    if (file_exists(_save_path)) file_delete(_save_path);
    if (file_exists(_info_path)) file_delete(_info_path);
}