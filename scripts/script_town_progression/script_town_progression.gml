/*
    Veredas Dream - Town Progression
    Gestiona las etapas de restauracion del town.
    Ver documents/plans/TOWN_PROGRESSION.md
*/

// =============================================================
// NOMBRES DE ETAPA (para UI / notificaciones)
// =============================================================

function scr_get_town_stage_name(_stage) {
    switch (_stage) {
        case TownStage.INITIAL:                   return "Limpiar las Calles";
        case TownStage.STREETS_CLEARED:           return "Restaurar Areas Verdes";
        case TownStage.GREENS_RESTORED:           return "Calles Restauradas";
        case TownStage.STREETS_RESTORED:          return "Tienda de Miraculos";
        case TownStage.SHOP_CONSTRUCTION:         return "Tienda en construccion";
        case TownStage.SHOP_RESTORED:             return "Herreria";
        case TownStage.BLACKSMITH_CONSTRUCTION:   return "Herreria en construccion";
        case TownStage.BLACKSMITH_RESTORED:       return "Arboles del Town";
        case TownStage.TREES_RESTORED:            return "Torre y Parque";
        case TownStage.BUILDINGS_CONSTRUCTION:    return "Torre y Parque en construccion";
        case TownStage.BUILDINGS_RESTORED:        return "Urbanizacion Final";
        case TownStage.URBANIZATION_CONSTRUCTION: return "Urbanizacion en construccion";
        case TownStage.URBANIZATION_COMPLETE:     return "Town Restaurado";
    }
    return "Desconocido";
}

// =============================================================
// REQUERIMIENTOS DE DONATIVOS POR ETAPA
// =============================================================
// El _stage es el estado ACTUAL del town. Las donaciones aplicables
// son para AVANZAR a la siguiente etapa.

function scr_get_town_stage_donations(_stage) {
    switch (_stage) {
        case TownStage.INITIAL:
            return {
                stone:      500,
                wood:       300,
                coal:       25,
                bar_plata:  15,
                bar_bronce: 15,
                dye_blue:   3,
                dye_red:    3,
                honey:      5
            };

        case TownStage.STREETS_CLEARED:
            return {
                parsnip:    50,
                carrot:     25,
                onion:      25,
                forage_any: 35,
                bar_oro:    10
            };

        case TownStage.GREENS_RESTORED:
            return {
                stone:            600,
                wood:             400,
                bar_broncastanio: 10,
                cloth_any:        30,
                leather_any:      15,
                thread_any:       10,
                wool:             5,
                dye_yellow:       3
            };

        case TownStage.STREETS_RESTORED:
            return {
                cheese:      20,
                goat_cheese: 15,
                butter:      20,
                honey:       5,
                thread_any:  15,
                egg_any:     15,
                dye_any:     3,
                fruit_any:   50,
                forage_any:  15
            };

        case TownStage.SHOP_RESTORED:
            return {
                bar_chubestanio: 10,
                leather_any:     40,
                pelt_any:        20,
                yarn_any:        20,
                gemstone_any:    10,
                stone:           200
            };

        case TownStage.BLACKSMITH_RESTORED:
            return {
                bar_vitolanio:    5,
                bar_chubestanio:  20,
                gemstone_any:     15,
                forage_f_any:     30,
                forage_m_any:     20,
                wood:             500,
                stone:            300
            };

        case TownStage.TREES_RESTORED:
            return {
                stone:         800,
                wood:          600,
                bar_vitolanio: 10,
                cloth_any:     40,
                leather_any:   25,
                yarn_any:      30,
                dye_green:     5,
                dye_orange:    5
            };

        case TownStage.BUILDINGS_RESTORED:
            return {
                stone:           400,
                bar_chubestanio: 30,
                coal:            15,
                cloth_any:       20,
                leather_any:     15
            };
    }
    return {};
}

// Dias de construccion al donar la etapa actual (0 = instantaneo)
function scr_get_stage_construction_duration(_donation_stage) {
    switch (_donation_stage) {
        case TownStage.STREETS_RESTORED:   return 3; // Tienda Miraculos
        case TownStage.SHOP_RESTORED:      return 3; // Herreria
        case TownStage.TREES_RESTORED:     return 4; // Torre + Parque
        case TownStage.BUILDINGS_RESTORED: return 3; // Urbanizacion
    }
    return 0;
}

// =============================================================
// RESOLUCION DE _any KEYS
// =============================================================

function scr_match_donation_key(_req_key, _item_key) {
    if (_req_key == _item_key) return true;
    if (string_length(_req_key) <= 4) return false;

    var _suffix = string_copy(_req_key, string_length(_req_key) - 3, 4);
    if (_suffix != "_any") return false;

    if (_req_key == "fruit_any") {
        var _crop = global.crop_data[$ _item_key];
        if (_crop != undefined && variable_struct_exists(_crop, "is_fruit_tree") && _crop.is_fruit_tree) return true;
        return false;
    }

    if (_req_key == "pelt_any") {
        if (string_pos("pelt_", _item_key) == 1) return true;
        if (string_pos("rabbit_pelt_", _item_key) == 1) return true;
        return false;
    }

    var _prefix = string_copy(_req_key, 1, string_length(_req_key) - 4);
    return (string_pos(_prefix, _item_key) == 1);
}

function scr_resolve_donation_target(_item_key, _stage) {
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    for (var _i = 0; _i < array_length(_req_keys); _i++) {
        if (_req_keys[_i] == _item_key) return _req_keys[_i];
    }
    for (var _i = 0; _i < array_length(_req_keys); _i++) {
        if (scr_match_donation_key(_req_keys[_i], _item_key)) return _req_keys[_i];
    }
    return undefined;
}

// =============================================================
// PROGRESO Y COMPLETITUD
// =============================================================

function scr_get_donation_progress(_req_key) {
    if (variable_struct_exists(global.town_donations, _req_key)) {
        return global.town_donations[$ _req_key];
    }
    return 0;
}

function scr_check_donations_complete(_stage) {
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    for (var _i = 0; _i < array_length(_req_keys); _i++) {
        var _rk = _req_keys[_i];
        if (scr_get_donation_progress(_rk) < _reqs[$ _rk]) return false;
    }
    return true;
}

// =============================================================
// DONACION
// =============================================================

function scr_donate_to_town(_player = global.local_player) {
    var _result = { donated: false, items_donated: 0, completed: false };
    if (!instance_exists(_player)) return _result;

    var _stage = global.town_stage;
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    if (array_length(_req_keys) == 0) return _result;

    var _slots_to_check = [_player.inventory_array, _player.backpack_array];
    for (var _ai = 0; _ai < array_length(_slots_to_check); _ai++) {
        var _arr = _slots_to_check[_ai];
        var _len = array_length(_arr);
        for (var _si = 0; _si < _len; _si++) {
            var _slot = _arr[_si];
            if (!is_struct(_slot)) continue;

            var _ikey = _slot.key;
            var _target = scr_resolve_donation_target(_ikey, _stage);
            if (_target == undefined) continue;

            var _needed = _reqs[$ _target] - scr_get_donation_progress(_target);
            if (_needed <= 0) continue;

            var _take = min(_slot.quantity, _needed);
            if (_take <= 0) continue;

            _slot.quantity -= _take;
            if (_slot.quantity <= 0) _arr[@ _si] = -1;

            global.town_donations[$ _target] = scr_get_donation_progress(_target) + _take;

            _result.donated = true;
            _result.items_donated += _take;
        }
    }

    if (_result.donated && scr_check_donations_complete(_stage)) {
        _result.completed = true;
        scr_complete_donation_stage(_stage);
    }

    return _result;
}

// =============================================================
// DONACION DIRIGIDA A UN REQUIREMENT ESPECIFICO
// =============================================================
// Para uso desde la UI: cuando el jugador clickea una fila,
// se dona lo disponible de items que cumplan ese requirement
// hasta cubrir lo faltante.

function scr_donate_specific_target(_target_key, _player = global.local_player) {
    var _result = { donated: false, items_donated: 0, completed: false };
    if (!instance_exists(_player)) return _result;

    var _stage = global.town_stage;
    var _reqs = scr_get_town_stage_donations(_stage);
    if (!variable_struct_exists(_reqs, _target_key)) return _result;

    var _needed = _reqs[$ _target_key] - scr_get_donation_progress(_target_key);
    if (_needed <= 0) return _result;

    var _slots_to_check = [_player.inventory_array, _player.backpack_array];
    for (var _ai = 0; _ai < array_length(_slots_to_check); _ai++) {
        var _arr = _slots_to_check[_ai];
        var _len = array_length(_arr);
        for (var _si = 0; _si < _len && _needed > 0; _si++) {
            var _slot = _arr[_si];
            if (!is_struct(_slot)) continue;

            // El slot debe satisfacer ESTE target especifico
            if (!scr_match_donation_key(_target_key, _slot.key)) continue;

            var _take = min(_slot.quantity, _needed);
            if (_take <= 0) continue;

            _slot.quantity -= _take;
            if (_slot.quantity <= 0) _arr[@ _si] = -1;

            global.town_donations[$ _target_key] = scr_get_donation_progress(_target_key) + _take;
            _result.donated = true;
            _result.items_donated += _take;
            _needed -= _take;
        }
    }

    if (_result.donated && scr_check_donations_complete(_stage)) {
        _result.completed = true;
        scr_complete_donation_stage(_stage);
    }

    return _result;
}

// =============================================================
// METADATA DE DISPLAY POR REQUIREMENT (icono + nombre)
// =============================================================

function scr_get_donation_target_display(_target_key) {
    // Match exacto: usar item data directo
    var _idata = scr_get_item_data(_target_key);
    if (_idata != undefined) {
        return { sprite: _idata.sprite, subimg: _idata.subimg, name: _idata.name, is_group: false };
    }

    // _any keys: nombre legible + sprite del primer item que matchea
    var _name_map = {
        cloth_any:           "Tela (cualquier color)",
        thread_any:          "Hilo (cualquier color)",
        yarn_any:            "Estambre (cualquier color)",
        leather_any:         "Cuero (cualquier color)",
        pelt_any:            "Piel (cualquier color)",
        egg_any:             "Huevo (cualquier tipo)",
        dye_any:             "Tinte (cualquier color)",
        gemstone_any:        "Gema (cualquier tipo)",
        forage_any:          "Forage (cualquier tipo)",
        forage_m_any:        "Champinon (cualquiera)",
        forage_f_any:        "Flor (cualquiera)",
        forage_h_any:        "Hierba (cualquiera)",
        fruit_any:           "Fruta (cualquiera)"
    };

    var _name = variable_struct_exists(_name_map, _target_key) ? _name_map[$ _target_key] : _target_key;

    // Buscar primer item que matchee para usar su sprite como icono
    var _candidate_keys = [
        // Las primeras claves de cada categoria como representativos
        "cloth_red", "thread_red", "yarn_red", "leather_red", "pelt_red",
        "egg_chicken_brown_reg", "dye_red", "gemstone_ruby",
        "forage_m00", "forage_f00", "forage_h00", "cherry"
    ];
    for (var _i = 0; _i < array_length(_candidate_keys); _i++) {
        var _ck = _candidate_keys[_i];
        if (scr_match_donation_key(_target_key, _ck)) {
            var _cd = scr_get_item_data(_ck);
            if (_cd != undefined) {
                return { sprite: _cd.sprite, subimg: _cd.subimg, name: _name, is_group: true };
            }
        }
    }

    // Fallback: sin sprite
    return { sprite: -1, subimg: 0, name: _name, is_group: true };
}

// =============================================================
// COMPLETITUD DE ETAPA - decide construccion o avance directo
// =============================================================

function scr_complete_donation_stage(_current_stage) {
    var _construction_days = scr_get_stage_construction_duration(_current_stage);
    var _next_stage = _current_stage + 1;

    if (_construction_days > 0) {
        scr_advance_town_stage(_next_stage);
        scr_start_town_construction(_construction_days);
    } else {
        scr_advance_town_stage(_next_stage);
    }
}

// =============================================================
// AVANCE DE ETAPA
// =============================================================

function scr_advance_town_stage(_new_stage) {
    global.town_stage = _new_stage;
    global.town_donations = {};
    scr_update_shop_availability();
    scr_restore_town_stage();
    show_debug_message("Town stage avanzo a: " + string(_new_stage) + " (" + scr_get_town_stage_name(_new_stage) + ")");
}

// =============================================================
// DISPONIBILIDAD DE TIENDAS NPC (Miraculos / Carlos)
// =============================================================

function scr_update_shop_availability() {
    if (variable_struct_exists(global.shop_data, "Miraculos")) {
        global.shop_data[$ "Miraculos"].available = (global.town_stage >= TownStage.SHOP_RESTORED);
    }
    if (variable_struct_exists(global.shop_data, "Carlos")) {
        global.shop_data[$ "Carlos"].available = (global.town_stage >= TownStage.BLACKSMITH_RESTORED);
    }
}

// =============================================================
// RESTAURACION VISUAL
// =============================================================

function scr_restore_town_stage() {
    if (room_get_name(room) != "town") return;

    var _stage = global.town_stage;

    var _show_destroyed_details   = (_stage < TownStage.STREETS_CLEARED);
    var _show_destroyed_floors    = (_stage < TownStage.STREETS_RESTORED);
    var _show_restored_floors     = (_stage >= TownStage.GREENS_RESTORED);
    var _show_restored_road       = (_stage >= TownStage.STREETS_RESTORED);
    var _show_trees               = (_stage >= TownStage.TREES_RESTORED);
    var _show_urban_road          = (_stage >= TownStage.URBANIZATION_COMPLETE);

    scr_set_layer_visible("Tiles_details_destroyed_1", _show_destroyed_details);
    scr_set_layer_visible("Tiles_floors_destroyed",    _show_destroyed_floors);
    scr_set_layer_visible("Tiles_floors_restored",     _show_restored_floors);
    scr_set_layer_visible("Tiles_road_restored",       _show_restored_road);
    scr_set_layer_visible("Tiles_trees",               _show_trees);
    scr_set_layer_visible("Tiles_urban_road",          _show_urban_road);

    // Capas de instancias siempre visibles (control por instancia)
    scr_set_layer_visible("Instances_destroyed_buildings", true);
    scr_set_layer_visible("Instances_restored_buildings",  true);

    scr_set_town_instance_visibility();
    scr_clear_construction_sites();

    if (global.town_construction_duration > 0) {
        scr_spawn_construction_sites_for_stage(_stage);
    }

    scr_setup_buses(_stage);
}

function scr_set_layer_visible(_name, _visible) {
    var _lay = layer_get_id(_name);
    if (_lay != -1) layer_set_visible(_lay, _visible);
}

// =============================================================
// VISIBILIDAD POR INSTANCIA EN EL TOWN
// =============================================================
// Identifica edificios por su posicion (ya que GMS no expone editor name).

function scr_set_town_instance_visibility() {
    var _stage = global.town_stage;

    // obj_shop_destroyed (Miraculos en y=412, Blacksmith en y=82)
    with (obj_shop_destroyed) {
        if (room_get_name(room) != "town") {
            // skip
        } else if (abs(y - 412) < 80) {
            // Miraculos shop: oculta cuando empieza construccion
            visible = (_stage <= TownStage.STREETS_RESTORED);
        } else if (abs(y - 82) < 80) {
            // Blacksmith: oculta cuando empieza construccion
            visible = (_stage <= TownStage.SHOP_RESTORED);
        }
    }

    // obj_shop (restaurados: Miraculos en y=343, Blacksmith en y=25)
    with (obj_shop) {
        if (room_get_name(room) != "town") {
            // skip
        } else if (abs(y - 343) < 80) {
            visible = (_stage >= TownStage.SHOP_RESTORED);
        } else if (abs(y - 25) < 80) {
            visible = (_stage >= TownStage.BLACKSMITH_RESTORED);
        }
    }

    // Edificios al stage 7
    with (obj_apartments_tower) {
        if (room_get_name(room) == "town") visible = (_stage >= TownStage.BUILDINGS_RESTORED);
    }
    with (obj_kid_park) {
        if (room_get_name(room) == "town") visible = (_stage >= TownStage.BUILDINGS_RESTORED);
    }

    // Bus stops al stage 8
    with (obj_bus_stop_1) {
        if (room_get_name(room) == "town") visible = (_stage >= TownStage.URBANIZATION_COMPLETE);
    }
    with (obj_bus_stop_2) {
        if (room_get_name(room) == "town") visible = (_stage >= TownStage.URBANIZATION_COMPLETE);
    }

    // NPC Carlos en town: solo visible al stage 5+
    with (obj_npc) {
        if (room_get_name(room) == "town" && variable_instance_exists(id, "npc_key") && npc_key == "Carlos") {
            visible = (_stage >= TownStage.BLACKSMITH_RESTORED);
        }
    }
}

// =============================================================
// CONSTRUCTION SITES
// =============================================================

function scr_clear_construction_sites() {
    with (obj_construction_site) instance_destroy();
}

function scr_spawn_construction_sites_for_stage(_stage) {
    var _layer = layer_get_id("Instances_restored_buildings");
    if (_layer == -1) _layer = layer_get_id("Instances");
    if (_layer == -1) return;

    var _positions = [];
    switch (_stage) {
        case TownStage.SHOP_CONSTRUCTION:
            array_push(_positions, { x: 871, y: 412 });
            break;
        case TownStage.BLACKSMITH_CONSTRUCTION:
            array_push(_positions, { x: 865, y: 82 });
            break;
        case TownStage.BUILDINGS_CONSTRUCTION:
            array_push(_positions, { x: 100, y: 93 });   // apartments
            array_push(_positions, { x: 385, y: 242 });  // kid_park
            break;
        case TownStage.URBANIZATION_CONSTRUCTION:
            array_push(_positions, { x: 788, y: 247 });  // bus_stop_1
            array_push(_positions, { x: 573, y: 734 });  // bus_stop_2
            break;
    }

    for (var _i = 0; _i < array_length(_positions); _i++) {
        var _p = _positions[_i];
        instance_create_layer(_p.x, _p.y, _layer, obj_construction_site);
    }
}

// =============================================================
// BUSES (etapa final)
// =============================================================

function scr_setup_buses(_stage) {
    var _layer = layer_get_id("Instances_restored_buildings");
    if (_layer == -1) _layer = layer_get_id("Instances");
    if (_layer == -1) return;

    if (_stage >= TownStage.URBANIZATION_COMPLETE) {
        // Spawn si no existen
        if (!instance_exists(obj_bus_down)) {
            instance_create_layer(700, -100, _layer, obj_bus_down);
        }
        if (!instance_exists(obj_bus_up)) {
            instance_create_layer(750, 1000, _layer, obj_bus_up);
        }
    } else {
        // Limpiar si existen
        with (obj_bus_down) instance_destroy();
        with (obj_bus_up) instance_destroy();
    }
}

// =============================================================
// CONSTRUCCION (dias)
// =============================================================

function scr_total_days() {
    return ((global.year - 1) * 4 * global.days_per_season)
         + (global.season_index * global.days_per_season)
         + global.day;
}

function scr_start_town_construction(_duration) {
    global.town_construction_day = scr_total_days();
    global.town_construction_duration = _duration;
}

function scr_check_town_construction_completed() {
    if (global.town_construction_duration <= 0) return false;
    var _days_passed = scr_total_days() - global.town_construction_day;
    if (_days_passed >= global.town_construction_duration) {
        global.town_construction_duration = 0;
        global.town_construction_day = 0;
        return true;
    }
    return false;
}
