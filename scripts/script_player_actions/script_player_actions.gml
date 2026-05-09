function scr_use_item(_item_data, _gx, _gy, _anim_only = false, _send_network = true) {
    // 1. Extraer Key (por si viene un struct o un string)
    var _item_key = is_struct(_item_data) ? _item_data.key : _item_data;
    if (_item_key == undefined || _item_key == -1) _item_key = "";

    // Leer estadísticas de progresión del tier actual
    var _tier_stats = undefined;
    if (variable_struct_exists(global.tool_progression, _item_key)) {
        var _prog = global.tool_progression[$ _item_key];
        var _quality = (is_struct(_item_data) && variable_struct_exists(_item_data, "quality")) ? _item_data.quality : QUALITY.OXIDADO;
        if (_quality >= 0 && _quality < array_length(_prog)) {
            _tier_stats = _prog[_quality];
        }
    }
    if (_tier_stats == undefined) {
        _tier_stats = { hits_required: 0, area_width: 1, area_height: 1, double_drop_chance: 0,
                        treasure_chance: 0, triple_drop_chance: 0, no_energy_chance: 0, water_persists_next_day: false, dig_chance: 0 };
    }
    var _skip_energy = (_item_key != "" && random(1) < _tier_stats.no_energy_chance);

    // Dimensiones efectivas: intercambiar si el jugador mira arriba/abajo
    var _facing_vertical = (self.dir == DIR.UP || self.dir == DIR.DOWN);
    var _eff_w = _facing_vertical ? _tier_stats.area_height : _tier_stats.area_width;
    var _eff_h = _facing_vertical ? _tier_stats.area_width  : _tier_stats.area_height;

    // Check Energy — host authoritative; skip in anim_only mode
    if (!_anim_only && self.energy <= 0 && _item_key != "" && !_skip_energy) {
        scr_notify("¡Sin energia!");
        return;
    }

    // 2. Definición de Variables de Posición
    var _p_center_x = (self.bbox_left + self.bbox_right) / 2;
    var _p_center_y = (self.bbox_top + self.bbox_bottom) / 2;
    var _target_x = _gx + 8;
    var _target_y = _gy + 8;

    // 3. Reorientación del Jugador
    var _view_x = (_item_key == "bow" || _item_key == "sickle") ? mouse_x : _target_x;
    var _view_y = (_item_key == "bow" || _item_key == "sickle") ? mouse_y : _target_y;
    var _diff_x = _view_x - _p_center_x;
    var _diff_y = _view_y - _p_center_y;

    if (abs(_diff_x) > abs(_diff_y)) {
        self.dir = (_diff_x > 0) ? DIR.RIGHT : DIR.LEFT;
    } else {
        self.dir = (_diff_y > 0) ? DIR.DOWN : DIR.UP;
    }

    // 4. Referencias de Mapa
    var _layer_tilled = layer_get_id("Tiles_tilled_watered");
    var _map_id = (_layer_tilled != -1) ? layer_tilemap_get_id(_layer_tilled) : -1;
    var _layer_details = layer_get_id("Tiles_details");
    var _map_id_details = (_layer_details != -1) ? layer_tilemap_get_id(_layer_details) : -1;
    var _layer_water = layer_get_id("Tiles_water");
    var _map_water = (_layer_water != -1) ? layer_tilemap_get_id(_layer_water) : -1;

    // --- LÓGICA DE COSECHA (Hoz o Mano) ---
    var _is_harvesting = false;

    if (_item_key == "sickle") {
        // Harvesting with Sickle (area from tier)
        var _sickle_hw = _eff_w * 8;
        var _sickle_hh = _eff_h * 8;
        var _x1 = _target_x - _sickle_hw;
        var _y1 = _target_y - _sickle_hh;
        var _x2 = _target_x + _sickle_hw;
        var _y2 = _target_y + _sickle_hh;
        var _dist = point_distance(_p_center_x, _p_center_y, _target_x, _target_y);

        if (_dist <= 64) {
            if (_anim_only) {
                _is_harvesting = true; // client validated range, just play animation
            } else {
                var _list = ds_list_create();
                var _count = collision_rectangle_list(_x1, _y1, _x2, _y2, obj_crop, false, true, _list, false);
                for (var i = 0; i < _count; i++) {
                    var _inst = _list[| i];
                    if (_inst.growth_stage >= _inst.max_stages) {
                        _is_harvesting = true;
                        if (!_skip_energy) self.energy -= 2;
                        var _drop_qty = 1;
                        if (random(1) < _tier_stats.double_drop_chance) _drop_qty *= 2;
                        if (random(1) < _tier_stats.triple_drop_chance) _drop_qty *= 3;
                        inventory_drop_item(_inst.crop_type, _drop_qty, _inst.x + 8, _inst.y + 8);
                        instance_destroy(_inst);
                    }
                }
                ds_list_clear(_list);

                _count = collision_rectangle_list(_x1, _y1, _x2, _y2, obj_tree, false, true, _list, false);
                for (var i = 0; i < _count; i++) {
                    var _inst = _list[| i];
                    if (_inst.has_fruit) {
                        _is_harvesting = true;
                        if (!_skip_energy) self.energy -= 2;
                        var _fdrop_qty = 1;
                        if (random(1) < _tier_stats.double_drop_chance) _fdrop_qty *= 2;
                        if (random(1) < _tier_stats.triple_drop_chance) _fdrop_qty *= 3;
                        inventory_drop_item(_inst.fruit_item, _fdrop_qty, _inst.x, _inst.y);
                        _inst.has_fruit = false;
                        _inst.days_since_harvest = 0;
                    }
                }
                ds_list_destroy(_list);
            }
        }
    } else if (_item_key == "") {
        // Manual harvest (1x1 Area)
        var _crop_inst = instance_position(_target_x, _target_y, obj_crop);
        var _tree_inst = instance_position(_target_x, _target_y, obj_tree);

        if (_tree_inst != noone && _tree_inst.has_fruit) {
            _is_harvesting = true;
            if (!_anim_only) {
                self.energy -= 2;
                inventory_drop_item(_tree_inst.fruit_item, 1, _tree_inst.x, _tree_inst.y);
                _tree_inst.has_fruit = false;
                _tree_inst.days_since_harvest = 0;
            }
        }

        if (_crop_inst != noone && _crop_inst.growth_stage >= _crop_inst.max_stages) {
            _is_harvesting = true;
            if (!_anim_only) {
                self.energy -= 2;
                inventory_drop_item(_crop_inst.crop_type, 1, _crop_inst.x + 8, _crop_inst.y + 8);
                instance_destroy(_crop_inst);
            }
        }
    }

    if (_is_harvesting) {
        if (_item_key == "sickle") {
            self.state = STATE.ACTING;
            self.frame_anim = 0;
            self.frames_action = 6;
            self.action_sprite_tool = sprite_player_sickle_axe_sickle;
            scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
        }
        exit;
    }

    // --- A. LÓGICA DE HERRAMIENTAS ---
    if (_item_key != "" && variable_struct_exists(global.tool_data, _item_key)) {
        self.state = STATE.ACTING;
        self.frame_anim = 0;

        // Guardar calidad para la animación
        if (is_struct(_item_data) && variable_struct_exists(_item_data, "quality")) {
            self.action_quality = _item_data.quality;
        } else {
            self.action_quality = 0;
        }

        switch (_item_key) {
            case "hoe":
                var _haw = _eff_w;
                var _hah = _eff_h;
                var _hox = floor(_haw / 2) * 16;
                var _hoy = floor(_hah / 2) * 16;
                var _tilled_any = false;
                for (var _hty = 0; _hty < _hah; _hty++) {
                    for (var _htx = 0; _htx < _haw; _htx++) {
                        var _htx_px = _gx - _hox + _htx * 16;
                        var _hty_px = _gy - _hoy + _hty * 16;
                        var _cur_tile = tilemap_get_at_pixel(_map_id, _htx_px, _hty_px);
                        if ((_cur_tile != 72 && _cur_tile != 168) &&
                            (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _htx_px, _hty_px) == 0)) {
                            if (!_anim_only) {
                                tilemap_set_at_pixel(_map_id, 72, _htx_px, _hty_px);
                                var _shoveled = instance_position(_htx_px + 8, _hty_px + 8, obj_shoveled);
                                if (_shoveled != noone) instance_destroy(_shoveled);
                            }
                            _tilled_any = true;
                        }
                    }
                }
                if (_tilled_any && !_skip_energy && !_anim_only) self.energy -= 2;
                if (_tilled_any) audio_play_sound(hoe, 1, false);
                self.frames_action = 6;
                self.action_sprite_tool = sprite_player_hoe_pickaxe_hoe_insects;
                scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
            break;

            case "watering_can":
                var _waw = _eff_w;
                var _wah = _eff_h;
                var _wox = floor(_waw / 2) * 16;
                var _woy = floor(_wah / 2) * 16;
                var _watered_any = false;
                for (var _wty = 0; _wty < _wah; _wty++) {
                    for (var _wtx = 0; _wtx < _waw; _wtx++) {
                        var _wtx_px = _gx - _wox + _wtx * 16;
                        var _wty_px = _gy - _woy + _wty * 16;
                        if ((tilemap_get_at_pixel(_map_id, _wtx_px, _wty_px) == 72) &&
                            (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _wtx_px, _wty_px) == 0)) {
                            if (!_anim_only) tilemap_set_at_pixel(_map_id, 168, _wtx_px, _wty_px);
                            _watered_any = true;
                        }
                        if (!_anim_only) {
                            var _wcrop = instance_position(_wtx_px + 8, _wty_px + 8, obj_crop);
                            if (_wcrop != noone) {
                                _wcrop.is_watered = true;
                                if (_tier_stats.water_persists_next_day) _wcrop.persistent_water = true;
                            }
                        }
                    }
                }
                if (_watered_any && !_skip_energy && !_anim_only) self.energy -= 2;
                if (_watered_any) audio_play_sound(watering_can, 1, false);
                self.frames_action = 8;
                self.action_sprite_tool = sprite_player_watering_can_watering;
                scr_set_player_action_sprites(sprite_player_skin_watering, sprite_player_hair_watering, sprite_player_clothes_watering, sprite_player_eyes_watering);
            break;

            case "axe":
            case "pickaxe":
                if (!_anim_only) {
                    // Lógica para quitar cofres
                    var _chest_to_remove = instance_position(_target_x, _target_y, obj_chest);
                    if (_chest_to_remove != noone) {
                        var _is_empty = true;
                        for (var i = 0; i < 64; i++) {
                            if (_chest_to_remove.storage_array[i] != -1) {
                                _is_empty = false;
                                break;
                            }
                        }
                        if (_is_empty) {
                            inventory_drop_item("chest", 1, _chest_to_remove.x + 8, _chest_to_remove.y + 8);
                            instance_destroy(_chest_to_remove);
                            if (!_skip_energy) self.energy -= 2;
                        } else {
                            scr_notify("No se pueden quitar cofres con articulos adentro");
                        }
                    } else {
                        if (_item_key == "axe") {
                            var _workbench_hit = instance_position(_target_x, _target_y, obj_workbench);
                            if (_workbench_hit != noone) {
                                if (self.add_item("workbench", 1)) {
                                    scr_notify("Mesa de trabajo recogida");
                                    instance_destroy(_workbench_hit);
                                    if (!_skip_energy) self.energy -= 2;
                                } else {
                                    scr_notify("Inventario lleno");
                                }
                            }
                            var _machine_hit = instance_position(_target_x, _target_y, obj_machine);
                            if (_workbench_hit == noone && _machine_hit != noone) {
                                if (_machine_hit.state == 1) {
                                    scr_notify("La maquina esta en uso");
                                } else if (_machine_hit.state == 2) {
                                    scr_notify("La maquina tiene un articulo listo");
                                } else {
                                    var _machine_item_key = "machine_" + _machine_hit.machine_type;
                                    if (self.add_item(_machine_item_key, 1)) {
                                        scr_notify("Maquina recogida");
                                        instance_destroy(_machine_hit);
                                        if (!_skip_energy) self.energy -= 2;
                                    } else {
                                        scr_notify("Inventario lleno");
                                    }
                                }
                            } else {
                            show_debug_message("=== AXE DEBUG === click tile: (" + string(_gx) + ", " + string(_gy) + ")  target: (" + string(_target_x) + ", " + string(_target_y) + ")");
                            var _nearest_dist = 999999;
                            var _nearest_id   = noone;
                            with (obj_common_tree) {
                                var _d = point_distance(x, y, _gx, _gy);
                                show_debug_message("  common_tree id=" + string(id) + " pos=(" + string(x) + "," + string(y) + ") dist_to_tile=" + string(_d));
                                if (_d < _nearest_dist) { _nearest_dist = _d; _nearest_id = id; }
                            }
                            show_debug_message("  nearest common_tree: id=" + string(_nearest_id) + " dist=" + string(_nearest_dist));
                            var _tree_to_remove = noone;
                            with (obj_common_tree) {
                                var _spr = asset_get_index("sprite_tree_" + tree_type);
                                if (sprite_exists(_spr)) {
                                    var _bx1 = x + sprite_get_bbox_left(_spr);
                                    var _by1 = y + sprite_get_bbox_top(_spr);
                                    var _bx2 = x + sprite_get_bbox_right(_spr);
                                    var _by2 = y + sprite_get_bbox_bottom(_spr);
                                    // Check tile overlap with bbox rather than point-in-bbox
                                    if (_gx < _bx2 && _gx + 16 > _bx1 && _gy < _by2 && _gy + 16 > _by1) {
                                        _tree_to_remove = id;
                                        break;
                                    }
                                }
                            }
                            if (_tree_to_remove == noone) _tree_to_remove = instance_position(_target_x, _target_y, obj_tree);
                            show_debug_message("  tree_to_remove=" + string(_tree_to_remove));
                            if (_tree_to_remove != noone) {
                                audio_play_sound(axe, 1, false);
                                var _dmg_ax = 1 + _tier_stats.hits_required;
                                _tree_to_remove.hits_remaining -= _dmg_ax;
                                if (_tree_to_remove.hits_remaining <= 0) {
                                    var _wood_qty = irandom_range(3, 5);
                                    if (random(1) < _tier_stats.double_drop_chance) _wood_qty *= 2;
                                    inventory_drop_item("wood", _wood_qty, _tree_to_remove.x, _tree_to_remove.y);
                                    instance_destroy(_tree_to_remove);
                                }
                                if (!_skip_energy) self.energy -= 2;
                            }
                            } // end else (no machine hit)
                        } else if (_item_key == "pickaxe") {
                            var _rock_to_remove = instance_position(_target_x, _target_y, obj_rock);
                            if (_rock_to_remove != noone) {
                                audio_play_sound(pickaxe, 1, false);
                                var _dmg_pk = 1 + _tier_stats.hits_required;
                                var _can_mine = true;

                                if (_rock_to_remove.is_ore_rock) {
                                    var _pk_tier = (is_struct(_item_data) && variable_struct_exists(_item_data, "quality")) ? _item_data.quality : QUALITY.OXIDADO;
                                    var _ore_tier = _rock_to_remove.ore_type_index + 1;
                                    var _tdiff = _ore_tier - _pk_tier;

                                    if (_tdiff >= 3) {
                                        scr_notify("Necesitas un pico mas fuerte");
                                        _can_mine = false;
                                    } else if (_tdiff == 2) {
                                        _rock_to_remove.hit_counter++;
                                        if (_rock_to_remove.hit_counter mod 2 != 0) _can_mine = false;
                                    }
                                }

                                if (_can_mine) {
                                    _rock_to_remove.hits_remaining -= _dmg_pk;
                                    if (_rock_to_remove.hits_remaining <= 0) {
                                        if (_rock_to_remove.is_gemstone_rock) {
                                            var _gkey = global.gemstone_pool[irandom(array_length(global.gemstone_pool) - 1)];
                                            inventory_drop_item(_gkey, 1, _rock_to_remove.x, _rock_to_remove.y);
                                        } else if (_rock_to_remove.is_coal_rock) {
                                            var _coal_qty = irandom_range(1, 3);
                                            if (random(1) < _tier_stats.double_drop_chance) _coal_qty *= 2;
                                            inventory_drop_item("coal", _coal_qty, _rock_to_remove.x, _rock_to_remove.y);
                                        } else if (_rock_to_remove.is_ore_rock) {
                                            var _qty = irandom_range(1, 3);
                                            if (random(1) < _tier_stats.double_drop_chance) _qty *= 2;
                                            inventory_drop_item(_rock_to_remove.ore_item_key, _qty, _rock_to_remove.x, _rock_to_remove.y);
                                        } else {
                                            var _stone_qty = irandom_range(1, 3);
                                            if (random(1) < _tier_stats.double_drop_chance) _stone_qty *= 2;
                                            inventory_drop_item("stone", _stone_qty, _rock_to_remove.x, _rock_to_remove.y);
                                        }
                                        if (global.mine_state.active && global.mine_state.floor < 10 && random(1) < 0.03) {
                                            if (!instance_position(_rock_to_remove.x, _rock_to_remove.y, obj_ladder_down)
                                                    && !instance_position(_rock_to_remove.x, _rock_to_remove.y, obj_rock)) {
                                                instance_create_layer(_rock_to_remove.x, _rock_to_remove.y, "Instances", obj_ladder_down);
                                            }
                                        }
                                        instance_destroy(_rock_to_remove);
                                        if (global.mine_state.active && global.mine_state.floor < 10
                                                && instance_number(obj_rock) == 0 && instance_number(obj_ladder_down) == 0) {
                                            instance_create_layer(self.x, self.y - 16, "Instances", obj_ladder_down);
                                            scr_notify("Aparecio una escalera...");
                                        }
                                    }
                                }
                                if (!_skip_energy && _can_mine) self.energy -= 2;
                            }
                        }
                    }
                }

                self.frames_action = 6;
                self.action_sprite_tool = (_item_key == "axe") ? sprite_player_axe_axe_sickle : sprite_player_pickaxe_pickaxe_hoe_insects;
                if (_item_key == "axe") {
                    scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
                } else {
                    scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
                }
            break;

            case "sickle":
                audio_play_sound(sickle, 1, false);
                self.frames_action = 6;
                self.action_sprite_tool = sprite_player_sickle_axe_sickle;
                scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
            break;

            case "bugnet":
                if (!_skip_energy && !_anim_only) self.energy -= 6;
                self.frames_action = 6;
                self.bugnet_caught = false;
                self.action_sprite_tool = sprite_player_bugnet_pickaxe_hoe_insects;
                scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
            break;

            case "shovel":
                if (!_anim_only) self.energy -= 2;
                self.frames_action = 6;
                self.action_sprite_tool = sprite_player_shovel_shovel;
                scr_set_player_action_sprites(sprite_player_skin_shovel, sprite_player_hair_shovel, sprite_player_clothes_shovel, sprite_player_eyes_shovel);

                if (!_anim_only) {
                    var _room_name = room_get_name(room);
                    if (_room_name == "farm" || _room_name == "forest" || string_starts_with(_room_name, "cave_") || _room_name == "graveyard") {
                        var _sw = _eff_w;
                        var _sh = _eff_h;
                        var _sox = floor(_sw / 2) * 16;
                        var _soy = floor(_sh / 2) * 16;

                        for (var _sty = 0; _sty < _sh; _sty++) {
                            for (var _stx = 0; _stx < _sw; _stx++) {
                                var _px = _gx - _sox + _stx * 16;
                                var _py = _gy - _soy + _sty * 16;

                                if (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _px, _py) != 0) continue;
                                if (_map_water != -1 && tilemap_get_at_pixel(_map_water, _px, _py) != 0) continue;

                                var _existing = instance_position(_px + 8, _py + 8, obj_shoveled);
                                if (_existing == noone) {
                                    instance_create_layer(_px, _py, "Instances", obj_shoveled);
                                }

                                if (random(1) < _tier_stats.dig_chance) {
                                    var _drop_x = _px + 8;
                                    var _drop_y = _py + 8;

                                    if (random(1) < 0.03) {
                                        // 3% de encontrar un arma enterrada
                                        var _w_type  = choose("sword", "bow");
                                        var _w_level = irandom(9) + 1;
                                        inventory_drop_item(_w_type + "_" + string(_w_level), 1, _drop_x, _drop_y, 15);
                                    } else if (random(1) < _tier_stats.treasure_chance) {
                                        var _gkey = global.gemstone_pool[irandom(array_length(global.gemstone_pool) - 1)];
                                        inventory_drop_item(_gkey, 1, _drop_x, _drop_y, 15);
                                    } else {
                                        var _loot_roll = random(1);
                                        if (_loot_roll < 0.30) {
                                            var _stone_qty = irandom_range(1, 2 + floor(_tier_stats.dig_chance * 5));
                                            inventory_drop_item("stone", _stone_qty, _drop_x, _drop_y, 15);
                                        } else if (_loot_roll < 0.55) {
                                            var _coal_qty = irandom_range(1, 1 + floor(_tier_stats.dig_chance * 3));
                                            inventory_drop_item("coal", _coal_qty, _drop_x, _drop_y, 15);
                                        } else if (_loot_roll < 0.70) {
                                            var _ore_key = "ore_" + global.ore_names[irandom(array_length(global.ore_names) - 1)];
                                            inventory_drop_item(_ore_key, 1, _drop_x, _drop_y, 15);
                                        } else if (_loot_roll < 0.85) {
                                            var _seed_keys = variable_struct_get_names(global.seed_data);
                                            if (array_length(_seed_keys) > 0) {
                                                var _rand_seed = _seed_keys[irandom(array_length(_seed_keys) - 1)];
                                                var _seed_qty = irandom_range(1, min(3, 1 + floor(_tier_stats.dig_chance * 3)));
                                                inventory_drop_item(_rand_seed, _seed_qty, _drop_x, _drop_y, 15);
                                            }
                                        } else {
                                            if (array_length(global.insect_pool) > 0) {
                                                var _insect_key = global.insect_pool[irandom(array_length(global.insect_pool) - 1)];
                                                inventory_drop_item(_insect_key, 1, _drop_x, _drop_y, 15);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            break;

            case "fishing_rod":
                if (_map_water == -1) { self.state = STATE.IDLE; exit; }
                var _fw_x = self.x;
                var _fw_y = self.y;
                switch (self.dir) {
                    case DIR.UP:    _fw_y -= 16; break;
                    case DIR.DOWN:  _fw_y += 16; break;
                    case DIR.LEFT:  _fw_x -= 16; break;
                    case DIR.RIGHT: _fw_x += 16; break;
                }
                if (tilemap_get_at_pixel(_map_water, _fw_x, _fw_y) == 0) { self.state = STATE.IDLE; exit; }
                self.state = STATE.FISHING;
                self.fishing_substate = FISHING_STATE.CASTING;
                self.fishing_wait_timer = 0;
                self.fishing_bite_timer = 0;
                self.action_sprite_tool = sprite_player_fishing_cast_weapon;
                scr_set_player_action_sprites(
                    sprite_player_fishing_cast_skins_2,
                    sprite_player_fishing_cast_hairs_fawn_black,
                    sprite_player_fishing_cast_clothes_purple,
                    sprite_player_fishing_cast_eyes_female_brown
                );
            break;
        }
    }

    // --- D. LÓGICA DE ARMAS ---
    else if (_item_key != "" && variable_struct_exists(global.weapon_data, _item_key)) {
        var _wdata = global.weapon_data[$ _item_key];
        self.state        = STATE.ACTING;
        self.frame_anim   = 0;
        self.action_quality = 0;

        if (_wdata.tool_type == TOOL_TYPE.SWORD) {
            if (!_anim_only) {
                var _sword_damage = _wdata.damage;
                var _hit_range    = 48;
                var _hit_side     = 20;
                var _hx1 = self.x; var _hy1 = self.y; var _hx2 = self.x; var _hy2 = self.y;
                switch (self.dir) {
                    case DIR.RIGHT: _hx1 = self.x;              _hy1 = self.y - _hit_side;  _hx2 = self.x + _hit_range; _hy2 = self.y + _hit_side;  break;
                    case DIR.LEFT:  _hx1 = self.x - _hit_range; _hy1 = self.y - _hit_side;  _hx2 = self.x;              _hy2 = self.y + _hit_side;  break;
                    case DIR.DOWN:  _hx1 = self.x - _hit_side;  _hy1 = self.y;              _hx2 = self.x + _hit_side;  _hy2 = self.y + _hit_range; break;
                    case DIR.UP:    _hx1 = self.x - _hit_side;  _hy1 = self.y - _hit_range; _hx2 = self.x + _hit_side;  _hy2 = self.y;              break;
                }
                var _targets = ds_list_create();
                collision_rectangle_list(_hx1, _hy1, _hx2, _hy2, obj_enemy,       false, true, _targets, false);
                collision_rectangle_list(_hx1, _hy1, _hx2, _hy2, obj_wild_animal,  false, true, _targets, false);
                collision_rectangle_list(_hx1, _hy1, _hx2, _hy2, obj_farm_animal,  false, true, _targets, false);
                for (var _si = 0; _si < ds_list_size(_targets); _si++) {
                    var _hit = _targets[| _si];
                    var _was_enemy = object_is_ancestor(_hit.object_index, obj_enemy);
                    var _was_wild = object_get_name(_hit.object_index) == "obj_wild_animal";
                    var _was_farm = object_get_name(_hit.object_index) == "obj_farm_animal";
                    var _pre_hp = _hit.hp;
                    _hit.hp -= _sword_damage;
                    _hit.hurt_flash_timer = 15;
                    if (variable_instance_exists(_hit, "snd_hurt") && _hit.snd_hurt != undefined) audio_play_sound(_hit.snd_hurt, 1, false);
                    if (_was_wild || _was_farm) scr_animal_hurt_sound();

                    if (_send_network && self.is_local) {
                        var _room_name = room_get_name(room);
                        if (_was_enemy && variable_struct_exists(_hit, "enemy_key")) {
                            if (_hit.hp <= 0 && _pre_hp > 0) {
                                var _drops = [];
                                var _edata = global.enemy_data[$ _hit.enemy_key];
                                if (_edata != undefined) {
                                    if (array_length(_edata.product_drops) > 0) {
                                        array_push(_drops, { key: _edata.product_drops[irandom(array_length(_edata.product_drops) - 1)], qty: 1 });
                                    }
                                    if (variable_struct_exists(_edata, "dye_drops") && array_length(_edata.dye_drops) > 0 && irandom(2) == 0) {
                                        array_push(_drops, { key: _edata.dye_drops[irandom(array_length(_edata.dye_drops) - 1)], qty: 1 });
                                    }
                                    if (variable_struct_exists(_edata, "weapon_drop_chance") && random(1) < _edata.weapon_drop_chance) {
                                        var _wtype = choose("sword", "bow");
                                        var _wlevel = ceil(10 * power(random(1), 2));
                                        array_push(_drops, { key: _wtype + "_" + string(_wlevel), qty: 1 });
                                    }
                                }
                                net_send_enemy_death(_hit.enemy_key, _hit.x, _hit.y, _room_name, json_stringify(_drops));
                            } else {
                                net_send_enemy_damage(_hit.enemy_key, _hit.x, _hit.y, _sword_damage, _room_name);
                            }
                        } else if (_was_wild || _was_farm) {
                            if (_hit.hp <= 0 && _pre_hp > 0) {
                                var _animal_key = _was_wild ? _hit.animal_key : _hit.animal_type;
                                var _adata = _was_wild ? global.wild_animal_data[$ _animal_key] : global.animal_data[$ _animal_key];
                                var _drops = [];
                                if (_adata != undefined && variable_struct_exists(_adata, "product_drops")) {
                                    array_push(_drops, { key: _adata.product_drops[irandom(array_length(_adata.product_drops) - 1)], qty: 1 });
                                }
                                var _data_json = json_stringify(_drops);
                                net_send_animal_event(2, _animal_key, _hit.x, _hit.y, _room_name, _data_json);
                            } else {
                                var _animal_key = _was_wild ? _hit.animal_key : _hit.animal_type;
                                var _data_json = json_stringify({ hp: _hit.hp });
                                net_send_animal_event(1, _animal_key, _hit.x, _hit.y, _room_name, _data_json);
                            }
                        }
                    }

                    var _fdir = point_direction(self.x, self.y, _hit.x, _hit.y);
                    if (_fdir >= 45 && _fdir < 135)       _hit.dir = DIR.UP;
                    else if (_fdir >= 135 && _fdir < 225) _hit.dir = DIR.LEFT;
                    else if (_fdir >= 225 && _fdir < 315) _hit.dir = DIR.DOWN;
                    else                                   _hit.dir = DIR.RIGHT;
                    if (object_is_ancestor(_hit.object_index, obj_enemy)) {
                        if (variable_instance_exists(_hit, "hurt_anim_timer")) _hit.hurt_anim_timer = 15;
                        if (_hit.hp > 0) {
                            _hit.state = ANIMAL_STATE.CHASING;
                            _hit.chase_timer = _hit.chase_timer_max;
                        }
                    } else if (object_get_name(_hit.object_index) == "obj_wild_animal") {
                        if (_hit.animal_key == "bear") {
                            var _segs = [[0.00, 1.00], [4.50, 5.70], [5.70, 7.50]];
                            var _seg  = _segs[irandom(2)];
                            scr_play_sound_clip(sound_bear, _seg[0], _seg[1]);
                            _hit.state       = ANIMAL_STATE.CHASING;
                            _hit.chase_timer = 360;
                            _hit.is_panicked = true;
                        } else {
                            _hit.is_panicked = true;
                            _hit.flee_timer  = 180;
                            _hit.state       = ANIMAL_STATE.FLEEING;
                        }
                    } else {
                        _hit.flee_timer = 90;
                        _hit.state      = ANIMAL_STATE.FLEEING;
                    }
                }
                ds_list_destroy(_targets);
                self.energy -= 2;
            }
            self.frames_action      = 10;
            self.action_sprite_tool = sprite_player_sword_sword;
            scr_set_player_action_sprites(sprite_player_skin_sword, sprite_player_hair_sword, sprite_player_clothes_sword, sprite_player_eyes_sword);

        } else if (_wdata.tool_type == TOOL_TYPE.BOW) {
            self.frames_action      = 7;
            self.action_sprite_tool = sprite_player_bow_archer;
            scr_set_player_action_sprites(sprite_player_skin_archer, sprite_player_hair_archer, sprite_player_clothes_archer, sprite_player_eyes_archer);
        }
    }

    // --- B. LÓGICA DE SEMILLAS ---
    else if (_item_key != "" && variable_struct_exists(global.seed_data, _item_key)) {
        var _seed_info = global.seed_data[$ _item_key];
        var _is_fruit_tree_seed = variable_struct_exists(_seed_info, "is_fruit_tree") && _seed_info.is_fruit_tree;

        var _season_ok = false;
        for (var _si = 0; _si < array_length(_seed_info.seasons); _si++) {
            if (_seed_info.seasons[_si] == global.season_index || _seed_info.seasons[_si] == SEASON.ALL) {
                _season_ok = true;
                break;
            }
        }
        if (!_season_ok) {
            if (!_anim_only) scr_notify("Esta semilla no se puede plantar en " + global.season_names[$ global.season] + ".");
            exit;
        }

        var _can_plant_here = false;

        if (_is_fruit_tree_seed) {
            // Check for fruit tree placement (2x3 area)
            var _tree_width_tiles = 2;
            var _tree_height_tiles = 3;

            var _gx_end = _gx + (_tree_width_tiles * 16) - 1;
            var _gy_end = _gy + (_tree_height_tiles * 16) - 1;

            _can_plant_here = _gx >= 0 && _gy >= 0 && _gx_end < room_width && _gy_end < room_height;

            if (_can_plant_here) {
                for (var xx = _gx; xx < _gx + (_tree_width_tiles * 16); xx += 16) {
                    for (var yy = _gy; yy < _gy + (_tree_height_tiles * 16); yy += 16) {
                        if (instance_position(xx + 8, yy + 8, obj_crop) ||
                            instance_position(xx + 8, yy + 8, obj_tree) ||
                            instance_position(xx + 8, yy + 8, obj_collision) ||
                            instance_position(xx + 8, yy + 8, obj_item_parent) ||
                            (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, xx, yy) != 0)) {
                            _can_plant_here = false;
                            break;
                        }
                    }
                    if (!_can_plant_here) break;
                }
            }
        } else {
            var _current_tile_at_gxgy = tilemap_get_at_pixel(_map_id, _gx, _gy);
            _can_plant_here = ((_current_tile_at_gxgy == 72 || _current_tile_at_gxgy == 168) &&
                               (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _gx, _gy) == 0) &&
                               !instance_position(_gx + 8, _gy + 8, obj_crop) &&
                               !instance_position(_gx + 8, _gy + 8, obj_tree));
        }

        if (_can_plant_here && !_anim_only) {
            audio_play_sound(sound_seeds, 1, false);
            var _obj_to_create = _is_fruit_tree_seed ? obj_tree : obj_crop;
            var _new_inst  = instance_create_layer(_gx, _gy, "Instances_Crops", _obj_to_create);

            with(_new_inst) {
                crop_type    = _seed_info.crop_base_name;
                days_to_grow = _seed_info.growth_time;
                max_stages   = _seed_info.growth_time;

                if (_is_fruit_tree_seed) {
                    fruit_item = crop_type;
                    fruit_cycle_days = 2;
                    days_since_harvest = 0;
                    has_fruit = false;
                } else {
                    if (crop_type == "pumpkin" || crop_type == "grapes") skip_blank_frame = true;
                }
            }

            // Gastar item del inventario
            var _inv_slot = self.inventory_array[self.selected_slot];
            if (is_struct(_inv_slot)) {
                _inv_slot.quantity -= 1;
                if (_inv_slot.quantity <= 0) self.inventory_array[self.selected_slot] = -1;
            }
        }
    }

    // --- C. LÓGICA DE OBJETOS COLOCABLES (Cofres, etc.) ---
    else if (_item_key != "" && variable_struct_exists(global.placeable_data, _item_key)) {
        // Bloquear si el selector está en rojo (distancia o colisión con jugador)
        if (instance_exists(obj_controller) && obj_controller.selector_color == c_red) exit;

        var _data = global.placeable_data[$ _item_key];
        var _spr = _data.sprite;
        var _tw = variable_struct_exists(_data, "tile_w") ? _data.tile_w : ceil(sprite_get_width(_spr) / 16);
        var _th = variable_struct_exists(_data, "tile_h") ? _data.tile_h : ceil(sprite_get_height(_spr) / 16);
        var _px_end = _gx + _tw * 16;
        var _py_end = _gy + _th * 16;

        var _can_place = true;
        for (var _tx = _gx; _tx < _px_end; _tx += 16) {
            for (var _ty = _gy; _ty < _py_end; _ty += 16) {
                if (instance_position(_tx + 8, _ty + 8, obj_collision) ||
                    instance_position(_tx + 8, _ty + 8, obj_crop) ||
                    instance_position(_tx + 8, _ty + 8, obj_tree) ||
                    instance_position(_tx + 8, _ty + 8, obj_item_parent)) {
                    _can_place = false;
                    break;
                }
            }
            if (!_can_place) break;
        }
        _can_place = _can_place && _gx >= 0 && _gy >= 0 && _px_end <= room_width && _py_end <= room_height;

        // Verificar que el jugador no esté en el camino
        if (_can_place) {
            if (collision_rectangle(_gx, _gy, _px_end - 1, _py_end - 1, self, false, true)) {
                _can_place = false;
            }
        }

        if (_can_place && !_anim_only) {
            var _off_x = variable_struct_exists(_data, "place_offset_x") ? _data.place_offset_x : 0;
            var _off_y = variable_struct_exists(_data, "place_offset_y") ? _data.place_offset_y : 0;

            if (variable_struct_exists(_data, "machine_type")) {
                var _inst = instance_create_layer(_gx + _off_x, _gy + _off_y, "Instances", obj_machine, { machine_type: _data.machine_type });
            } else if (variable_struct_exists(_data, "is_workbench")) {
                var _inst = instance_create_layer(_gx + _off_x, _gy + _off_y, "Instances", obj_workbench);
            } else {
                var _inst = instance_create_layer(_gx + _off_x, _gy + _off_y, "Instances", obj_chest);
            }

            // Gastar item del inventario
            var _inv_slot = self.inventory_array[self.selected_slot];
            if (is_struct(_inv_slot)) {
                _inv_slot.quantity -= 1;
                if (_inv_slot.quantity <= 0) self.inventory_array[self.selected_slot] = -1;
            }
        }
    }
}

// Función auxiliar para no repetir tanto código de sprites
function scr_set_player_action_sprites(_skin, _hair, _clothes, _eyes) {
    self.action_sprite_skin    = _skin;
    self.action_sprite_hair    = _hair;
    self.action_sprite_clothes = _clothes;
    self.action_sprite_eyes    = _eyes;
}

function scr_buy_building(_building_name, _from_net = false) {
    var _placeholder_obj = noone;
    var _actual_obj = noone;

    switch (_building_name) {
        case "chicken_coop":
            _placeholder_obj = obj_chicken_placeholder;
            _actual_obj = obj_chicken;
            break;
        case "barn":
            _placeholder_obj = obj_barn_placeholder;
            _actual_obj = obj_barn;
            break;
        case "stable":
            _placeholder_obj = obj_stable_placeholder;
            _actual_obj = obj_stable;
            break;
        case "mill":
            _placeholder_obj = obj_mill_placeholder;
            _actual_obj = obj_mill;
            break;
        case "greenhouse":
            _placeholder_obj = obj_greenhouse_placeholder;
            _actual_obj = obj_greenhouse;
            break;
        default:
            scr_notify("Edificio desconocido: " + _building_name);
            return false;
    }

    if (instance_exists(_placeholder_obj)) {
        var _inst = instance_find(_placeholder_obj, 0);
        var _x = _inst.x;
        var _y = _inst.y;
        var _layer = _inst.layer;

        instance_destroy(_inst);
        instance_create_layer(_x, _y, _layer, _actual_obj);

        if (_building_name == "stable") {
            instance_create_layer(_x + 96, _y + 16, "Instances", obj_horse1);
            instance_create_layer(_x + 96, _y + 40, "Instances", obj_horse1);
        }

        scr_capture_current_room_state();

        // Broadcast so the other player sees the building. Guard _from_net to prevent echo loops.
        if (!_from_net && global.net_role != NET_ROLE.NONE && instance_exists(obj_net) && obj_net.is_connected) {
            var _wbuf = net_begin(NET_CMD.WORLD_EVENT);
            buffer_write(_wbuf, buffer_u8,     1); // WEVT_BUILDING_BUILT
            buffer_write(_wbuf, buffer_string, room_get_name(room));
            buffer_write(_wbuf, buffer_string, _building_name);
            net_broadcast(_wbuf);
        }

        scr_notify("!" + _building_name + " comprado!");
        return true;
    } else {
        scr_notify("No se encontro el lugar para " + _building_name);
        return false;
    }
}

function scr_upgrade_tool(_tool_key) {
    var _lp = global.local_player;
    if (!instance_exists(_lp)) { scr_notify("Sin jugador local"); return; }
    var _arrays = [_lp.inventory_array, _lp.backpack_array];
    for (var a = 0; a < 2; a++) {
        var _arr = _arrays[a];
        for (var i = 0; i < array_length(_arr); i++) {
            var _slot = _arr[i];
            if (is_struct(_slot) && variable_struct_exists(_slot, "key") && _slot.key == _tool_key) {
                var _cur = variable_struct_exists(_slot, "quality") ? _slot.quality : QUALITY.OXIDADO;
                if (_cur >= QUALITY.VITOLANIO) {
                    scr_notify(_tool_key + " ya esta al maximo");
                    return;
                }
                if (_cur >= QUALITY.BRONCASTANIO && global.town_stage < TownStage.BLACKSMITH_RESTORED) {
                    scr_notify("La herreria del town no esta lista para upgrades mayores.");
                    return;
                }
                _slot.quality = _cur + 1;
                scr_notify(_tool_key + " mejorado a " + global.quality_names[_slot.quality]);
                return;
            }
        }
    }
    scr_notify("Herramienta no encontrada: " + _tool_key);
}
