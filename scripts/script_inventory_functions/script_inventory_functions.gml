function inventory_drop_item(_key, _qty, _px, _py, _delay = 15) {
    var _room_name = room_get_name(room);
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
    for (var i = 0; i < array_length(_drops); i++) {
        var _drop_data = _drops[i];
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

function scr_get_room_state(_room_name) {
    if (!variable_struct_exists(global.room_states, _room_name)) global.room_states[$ _room_name] = { crops: [], tilled_tiles: [], chests: [], buildings: [], horses: [], common_trees: [], rocks: [] };
    return global.room_states[$ _room_name];
}

function scr_capture_current_room_state() {
    var _room_name = room_get_name(room);
    var _state = { crops: [], tilled_tiles: [], chests: [], buildings: [], horses: [] };
    
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

    // Capture Horses
    for (var i = 0; i < instance_number(obj_horse_parent); i++) {
        var _inst = instance_find(obj_horse_parent, i);
        array_push(_state.horses, {
            obj: object_get_name(_inst.object_index),
            x: _inst.x,
            y: _inst.y,
            dir: _inst.dir
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
        array_push(_rock_state, { x: _inst.x, y: _inst.y, sprite_name: sprite_get_name(_inst.sprite_index), hits_remaining: _inst.hits_remaining });
    }
    _state.rocks = _rock_state;

    global.room_states[$ _room_name] = _state;
}

function scr_restore_room_state(_room_name) {
    var _state = scr_get_room_state(_room_name);
    var _layer_id = layer_get_id("Tiles_tilled_watered");
    if (_layer_id != -1) {
        var _map_id = layer_tilemap_get_id(_layer_id);
        for (var _y = 0; _y < room_height; _y += 16) {
            for (var _x = 0; _x < room_width; _x += 16) {
                tilemap_set_at_pixel(_map_id, 0, _x, _y);
            }
        }
        for (var i = 0; i < array_length(_state.tilled_tiles); i++) {
            var _tile_data = _state.tilled_tiles[i];
            tilemap_set_at_pixel(_map_id, _tile_data.tile, _tile_data.x, _tile_data.y);
        }
    }
    if (layer_get_id("Instances_Crops") != -1) {
        // First destroy existing ones to avoid duplicates if re-entering
        with (obj_crop) instance_destroy();
        with (obj_tree) instance_destroy();
        
        for (var i = 0; i < array_length(_state.crops); i++) {
            var _c_data = _state.crops[i];
            
            // Determine object type (with backward compatibility)
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
            var _inst = instance_create_layer(_c_data.x, _c_data.y, "Instances_Crops", _obj_type);
            
            with (_inst) {
                crop_type = _c_data.crop_type;
                days_passed = _c_data.days_passed;
                days_to_grow = _c_data.days_to_grow;
                max_stages = _c_data.max_stages;
                
                if (_is_tree) {
                    fruit_cycle_days = variable_struct_exists(_c_data, "fruit_cycle_days") ? _c_data.fruit_cycle_days : 2;
                    days_since_harvest = variable_struct_exists(_c_data, "days_since_harvest") ? _c_data.days_since_harvest : 0;
                    has_fruit = variable_struct_exists(_c_data, "has_fruit") ? _c_data.has_fruit : false;
                    fruit_item = variable_struct_exists(_c_data, "fruit_item") ? _c_data.fruit_item : crop_type;
                    hits_remaining = variable_struct_exists(_c_data, "hits_remaining") ? _c_data.hits_remaining : 10;
                } else {
                    growth_stage = _c_data.growth_stage;
                    is_watered = _c_data.is_watered;
                    persistent_water = variable_struct_exists(_c_data, "persistent_water") ? _c_data.persistent_water : false;
                    skip_blank_frame = _c_data.skip_blank_frame;
                    image_index = _c_data.image_index;
                }
                image_speed = 0;
            }
        }
    }
    
    // Restaurar Cofres
    if (variable_struct_exists(_state, "chests")) {
        with (obj_chest) instance_destroy();
        for (var i = 0; i < array_length(_state.chests); i++) {
            var _c_data = _state.chests[i];
            // Verificar que las coordenadas estén dentro de los límites de la habitación
            if (_c_data.x >= 0 && _c_data.y >= 0 && _c_data.x < room_width - 16 && _c_data.y < room_height - 16) {
                var _chest = instance_create_layer(_c_data.x, _c_data.y, "Instances", obj_chest);
                _chest.storage_array = _c_data.storage_array;
                _chest.image_speed = 0;
                _chest.image_index = 0;
            }
        }
    }

    // Restore Buildings
    if (variable_struct_exists(_state, "buildings") && array_length(_state.buildings) > 0) {
        for (var i = 0; i < array_length(_state.buildings); i++) {
            var _b_data = _state.buildings[i];
            var _obj = asset_get_index(_b_data.obj);
            if (_obj != -1) {
                // Determine corresponding placeholder
                var _placeholder = noone;
                switch (_obj) {
                    case obj_barn: _placeholder = obj_barn_placeholder; break;
                    case obj_chicken: _placeholder = obj_chicken_placeholder; break;
                    case obj_greenhouse: _placeholder = obj_greenhouse_placeholder; break;
                    case obj_mill: _placeholder = obj_mill_placeholder; break;
                    case obj_stable: _placeholder = obj_stable_placeholder; break;
                }
                
                // Destroy placeholder if it exists at this position
                if (_placeholder != noone) {
                    var _p_inst = instance_place(_b_data.x, _b_data.y, _placeholder);
                    if (_p_inst == noone) {
                        // try instance_nearest if instance_place fails due to collision issues
                        _p_inst = instance_nearest(_b_data.x, _b_data.y, _placeholder);
                        if (_p_inst != noone && point_distance(_b_data.x, _b_data.y, _p_inst.x, _p_inst.y) > 1) {
                            _p_inst = noone;
                        }
                    }
                    if (_p_inst != noone) instance_destroy(_p_inst);
                }
                
                // Create actual building
                if (!instance_exists(_obj) || instance_number(_obj) < array_length(_state.buildings)) {
                     instance_create_layer(_b_data.x, _b_data.y, "Instances", _obj);
                }
            }
        }
    }

    // Restore Horses
    if (variable_struct_exists(_state, "horses")) {
        with (obj_horse_parent) instance_destroy();
        for (var i = 0; i < array_length(_state.horses); i++) {
            var _h_data = _state.horses[i];
            var _obj = asset_get_index(_h_data.obj);
            if (_obj != -1) {
                var _inst = instance_create_layer(_h_data.x, _h_data.y, "Instances", _obj);
                if (variable_instance_exists(_inst, "dir")) _inst.dir = _h_data.dir;
            }
        }
    }

    // Restore Common Trees
    if (variable_struct_exists(_state, "common_trees")) {
        with (obj_common_tree) instance_destroy();
        for (var i = 0; i < array_length(_state.common_trees); i++) {
            var _ct = _state.common_trees[i];
            var _inst = instance_create_layer(_ct.x, _ct.y, "Instances", obj_common_tree);
            _inst.tree_type      = _ct.tree_type;
            _inst.growth_stage   = _ct.growth_stage;
            _inst.hits_remaining = variable_struct_exists(_ct, "hits_remaining") ? _ct.hits_remaining : 10;
        }
    }

    // Restore Rocks
    if (variable_struct_exists(_state, "rocks")) {
        with (obj_rock) instance_destroy();
        for (var i = 0; i < array_length(_state.rocks); i++) {
            var _r = _state.rocks[i];
            var _inst = instance_create_layer(_r.x, _r.y, "Instances", obj_rock);
            var _spr = asset_get_index(_r.sprite_name);
            if (_spr != -1) _inst.sprite_index = _spr;
            _inst.image_speed = 0;
            _inst.hits_remaining = variable_struct_exists(_r, "hits_remaining") ? _r.hits_remaining : 10;
            _inst.image_index = 0;
        }
    }
}

function scr_advance_stored_room_states(_exclude_room_name) {
    var _rooms = variable_struct_get_names(global.room_states);
    for (var r = 0; r < array_length(_rooms); r++) {
        var _room_name = _rooms[r];
        if (_room_name == _exclude_room_name) continue;
        var _state = global.room_states[$ _room_name];
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
    var _save_data = {
        version: 1,
        time: { minute: global.game_minute, hour: global.game_hour, day: global.day, year: global.year, season_index: global.season_index, season: global.season },
        economy: { money: global.money },
        player: { room_name: room_get_name(room), x: obj_player.x, y: obj_player.y, dir: obj_player.dir },
        inventory: { selected_slot: obj_inventory.selected_slot, inventory_array: obj_inventory.inventory_array, backpack_array: obj_inventory.backpack_array, shipping_array: obj_inventory.shipping_array, held_item: obj_inventory.held_item },
        room_states: global.room_states,
        room_drops: global.room_drops,
        next_drop_uid: global.next_drop_uid
    };
    scr_write_text_file(global.save_file_path, json_stringify(_save_data));
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
    global.money = _save_data.economy.money;
    global.room_states = _save_data.room_states;
    global.farm_populated = variable_struct_exists(global.room_states, "farm");
    global.room_drops = _save_data.room_drops;
    global.next_drop_uid = _save_data.next_drop_uid;
    obj_inventory.selected_slot = _save_data.inventory.selected_slot;
    obj_inventory.inventory_array = _save_data.inventory.inventory_array;
    obj_inventory.backpack_array = _save_data.inventory.backpack_array;
    obj_inventory.shipping_array = _save_data.inventory.shipping_array;
    
    // Asegurar que el shipping_array tenga el tamaño correcto si se cargó un guardado viejo
    if (array_length(obj_inventory.shipping_array) < obj_inventory.max_shipping_slots) {
        var _extra = obj_inventory.max_shipping_slots - array_length(obj_inventory.shipping_array);
        for (var i = 0; i < _extra; i++) array_push(obj_inventory.shipping_array, -1);
    }
    
    obj_inventory.held_item = _save_data.inventory.held_item;
    obj_inventory.show_backpack = false;
    obj_inventory.show_shipping = false;
    global.pending_player_room_name = _save_data.player.room_name;
    global.pending_player_x = _save_data.player.x;
    global.pending_player_y = _save_data.player.y;
    global.pending_player_dir = _save_data.player.dir;
    var _target_room = asset_get_index(global.pending_player_room_name);
    if (_target_room != -1 && room_get_name(room) != global.pending_player_room_name) {
        room_goto(_target_room);
    } else {
        obj_player.x = global.pending_player_x;
        obj_player.y = global.pending_player_y;
        obj_player.dir = global.pending_player_dir;
        obj_player.is_riding = false;
        scr_restore_room_state(room_get_name(room));
        scr_restore_room_drops(room_get_name(room));
        update_tilesets();
        global.pending_player_room_name = "";
    }
}

function scr_sleep_and_save() {
    var _bed = instance_find(obj_bed, 0);
    if (_bed == noone) exit;
    obj_player.is_riding = false;
    obj_player.state = STATE.IDLE;
    obj_player.dir = DIR.RIGHT;
    obj_player.x = _bed.x + 40;
    obj_player.y = _bed.y + 18;
    
    // Procesar ventas y obtener datos para el resumen
    var _summary = scr_process_shipping();
    
    // Si hubo ventas, mostrar resumen antes de avanzar
    if (array_length(_summary.items) > 0) {
        if (instance_exists(obj_controller)) {
            obj_controller.shipping_summary_data = _summary;
            obj_controller.shipping_summary_open = true;
        }
    } else {
        // Si no hay ventas, avanzar dia directamente
        start_new_day();
        scr_save_game();
        scr_notify("Dia terminado");
    }
}

function scr_process_shipping() {
    var _summary = { items: [], total: 0 };
    if (!instance_exists(obj_inventory)) return _summary;
    
    var _shipping_array = obj_inventory.shipping_array;
    
    for (var i = 0; i < array_length(_shipping_array); i++) {
        var _item = _shipping_array[i];
        if (is_struct(_item)) {
            var _data = scr_get_item_data(_item.key);
            if (is_struct(_data) && variable_struct_exists(_data, "base_sell_price")) {
                var _subtotal = _data.base_sell_price * _item.quantity;
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
                        unit_price: _data.base_sell_price,
                        subtotal: _subtotal,
                        sprite: _data.sprite,
                        subimg: _data.subimg
                    });
                }
            }
            // Limpiar slot del shipping bin
            _shipping_array[i] = -1;
        }
    }
    
    if (_summary.total > 0) {
        global.money += _summary.total;
    }
    
    return _summary;
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

function scr_get_item_data(_key) {
    if (variable_struct_exists(global.seed_data, _key)) return global.seed_data[$ _key];
    if (variable_struct_exists(global.crop_data, _key)) return global.crop_data[$ _key];
    if (variable_struct_exists(global.tool_data, _key)) return global.tool_data[$ _key];
    if (variable_struct_exists(global.placeable_data, _key)) return global.placeable_data[$ _key];
    if (variable_struct_exists(global.material_data, _key)) return global.material_data[$ _key];
    return undefined;
}
function scr_count_item(_key) {
    var _inv   = obj_inventory;
    var _total = 0;
    for (var i = 0; i < _inv.total_slots; i++) {
        var _s = _inv.inventory_array[i];
        if (is_struct(_s) && _s.key == _key) _total += _s.quantity;
    }
    for (var i = 0; i < _inv.max_backpack_slots; i++) {
        var _s = _inv.backpack_array[i];
        if (is_struct(_s) && _s.key == _key) _total += _s.quantity;
    }
    return _total;
}

function scr_remove_item(_key, _qty) {
    if (scr_count_item(_key) < _qty) return false;
    var _inv  = obj_inventory;
    var _left = _qty;
    for (var i = 0; i < _inv.total_slots && _left > 0; i++) {
        var _s = _inv.inventory_array[i];
        if (is_struct(_s) && _s.key == _key) {
            var _take = min(_s.quantity, _left);
            _s.quantity -= _take;
            _left       -= _take;
            if (_s.quantity <= 0) _inv.inventory_array[i] = -1;
        }
    }
    for (var i = 0; i < _inv.max_backpack_slots && _left > 0; i++) {
        var _s = _inv.backpack_array[i];
        if (is_struct(_s) && _s.key == _key) {
            var _take = min(_s.quantity, _left);
            _s.quantity -= _take;
            _left       -= _take;
            if (_s.quantity <= 0) _inv.backpack_array[i] = -1;
        }
    }
    return true;
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

