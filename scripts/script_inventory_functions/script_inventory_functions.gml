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
    if (!variable_struct_exists(global.room_states, _room_name)) global.room_states[$ _room_name] = { crops: [], tilled_tiles: [], chests: [] };
    return global.room_states[$ _room_name];
}

function scr_capture_current_room_state() {
    var _room_name = room_get_name(room);
    var _state = { crops: [], tilled_tiles: [], chests: [] };
    for (var i = 0; i < instance_number(obj_crop); i++) {
        var _crop = instance_find(obj_crop, i);
        var _idx = array_length(_state.crops);
        _state.crops[_idx] = {
            x: _crop.x, y: _crop.y, crop_type: _crop.crop_type, days_passed: _crop.days_passed,
            growth_stage: _crop.growth_stage, is_watered: _crop.is_watered, skip_blank_frame: _crop.skip_blank_frame,
            days_to_grow: _crop.days_to_grow, max_stages: _crop.max_stages, image_index: _crop.image_index
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
        for (var i = 0; i < array_length(_state.crops); i++) {
            var _crop_data = _state.crops[i];
            var _crop = instance_create_layer(_crop_data.x, _crop_data.y, "Instances_Crops", obj_crop);
            var _asset_name = "sprite_crop_" + _crop_data.crop_type;
            with (_crop) {
                sprite_index = asset_get_index(_asset_name);
                crop_type = _crop_data.crop_type;
                days_passed = _crop_data.days_passed;
                growth_stage = _crop_data.growth_stage;
                is_watered = _crop_data.is_watered;
                skip_blank_frame = _crop_data.skip_blank_frame;
                days_to_grow = _crop_data.days_to_grow;
                max_stages = _crop_data.max_stages;
                image_index = _crop_data.image_index;
                image_speed = 0;
            }
        }
    }
    
    // Restaurar Cofres
    if (variable_struct_exists(_state, "chests")) {
        for (var i = 0; i < array_length(_state.chests); i++) {
            var _c_data = _state.chests[i];
            var _chest = instance_create_layer(_c_data.x, _c_data.y, "Instances", obj_chest);
            _chest.storage_array = _c_data.storage_array;
            _chest.image_speed = 0;
            _chest.image_index = 0;
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
            var _crop = _state.crops[i];
            if (_crop.is_watered) {
                _crop.days_passed += 1;
                var _ideal = floor((_crop.days_passed / _crop.days_to_grow) * _crop.max_stages);
                _crop.growth_stage = clamp(_ideal, 0, _crop.max_stages);
                _crop.image_index = (_crop.skip_blank_frame && _crop.growth_stage == 1) ? 0 : _crop.growth_stage;
                _crop.is_watered = false;
                _state.crops[i] = _crop;
            }
        }
        for (var j = 0; j < array_length(_state.tilled_tiles); j++) {
            if (_state.tilled_tiles[j].tile == 168) _state.tilled_tiles[j].tile = 72;
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
    if (variable_struct_exists(global.storage_data, _key)) return global.storage_data[$ _key];
    return undefined;
}
