/*
    Veredas Dream - Town Progression
    Gestiona las etapas de restauracion del town.
    Ver documents/plans/TOWN_PROGRESSION.md
*/

// =============================================================
// REQUERIMIENTOS DE DONATIVOS POR ETAPA
// =============================================================
// Devuelve struct {req_key: cantidad}. Las keys que terminan en
// "_any" se resuelven por prefijo en runtime (ver scr_match_donation_key).

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

// =============================================================
// RESOLUCION DE _any KEYS
// =============================================================
// Verifica si _item_key cumple el _req_key. Soporta:
//  - Match exacto: req_key == item_key
//  - Prefijo: req_key termina en "_any", item_key empieza con prefijo
//  - Caso especial pelt_any: incluye pelt_* y rabbit_pelt_*
//  - Caso especial fruit_any: filtra crop_data por is_fruit_tree

function scr_match_donation_key(_req_key, _item_key) {
    if (_req_key == _item_key) return true;
    if (string_length(_req_key) <= 4) return false;

    var _suffix = string_copy(_req_key, string_length(_req_key) - 3, 4);
    if (_suffix != "_any") return false;

    // Caso especial: fruit_any
    if (_req_key == "fruit_any") {
        var _crop = global.crop_data[$ _item_key];
        if (_crop != undefined && variable_struct_exists(_crop, "is_fruit_tree") && _crop.is_fruit_tree) return true;
        return false;
    }

    // Caso especial: pelt_any incluye rabbit_pelt_*
    if (_req_key == "pelt_any") {
        if (string_pos("pelt_", _item_key) == 1) return true;
        if (string_pos("rabbit_pelt_", _item_key) == 1) return true;
        return false;
    }

    // Resto: prefijo simple (todo lo anterior a "_any")
    var _prefix = string_copy(_req_key, 1, string_length(_req_key) - 4);
    return (string_pos(_prefix, _item_key) == 1);
}

// Devuelve la req_key contra la cual cuenta este item para la etapa actual,
// o undefined si el item no aplica a ningun requirement
function scr_resolve_donation_target(_item_key, _stage) {
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    // Prefer exact matches first
    for (var _i = 0; _i < array_length(_req_keys); _i++) {
        if (_req_keys[_i] == _item_key) return _req_keys[_i];
    }
    // Then _any matches
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
// DONACION (mover items del inventario del jugador a town_donations)
// =============================================================
// Para cada requirement de la etapa actual, escanea inventario+backpack
// del jugador y dona items que apliquen, hasta cubrir lo faltante.
// Retorna struct { donated: bool, items_donated: int, completed: bool }

function scr_donate_to_town(_player = global.local_player) {
    var _result = { donated: false, items_donated: 0, completed: false };
    if (!instance_exists(_player)) return _result;

    var _stage = global.town_stage;
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    if (array_length(_req_keys) == 0) return _result;

    // Iterar todos los slots del jugador y donar lo que aplique
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

            // Restar del inventario
            _slot.quantity -= _take;
            if (_slot.quantity <= 0) _arr[@ _si] = -1;

            // Sumar a donaciones
            global.town_donations[$ _target] = scr_get_donation_progress(_target) + _take;

            _result.donated = true;
            _result.items_donated += _take;
        }
    }

    // Verificar si se completo la etapa
    if (_result.donated && scr_check_donations_complete(_stage)) {
        _result.completed = true;
        scr_advance_town_stage(_stage + 1);
    }

    return _result;
}

// =============================================================
// AVANCE DE ETAPA
// =============================================================
// Aplica los efectos visuales/NPC al transicionar a una nueva etapa.
// Limpia las donaciones (la nueva etapa empieza en cero).

function scr_advance_town_stage(_new_stage) {
    global.town_stage = _new_stage;
    global.town_donations = {};
    scr_restore_town_stage();
    show_debug_message("Town stage avanzo a: " + string(_new_stage));
}

// =============================================================
// RESTAURACION VISUAL (al entrar al town o cargar partida)
// =============================================================
// Aplica visibilidad de capas e instancias segun global.town_stage.

function scr_restore_town_stage() {
    if (room_get_name(room) != "town") return;

    var _stage = global.town_stage;

    // Capas destruidas (visibles en estados tempranos)
    var _show_destroyed_buildings = (_stage < TownStage.STREETS_RESTORED);
    var _show_destroyed_floors    = (_stage < TownStage.STREETS_RESTORED);
    var _show_destroyed_details   = (_stage < TownStage.STREETS_CLEARED);

    // Capas restauradas (se van revelando progresivamente)
    var _show_restored_floors     = (_stage >= TownStage.GREENS_RESTORED);
    var _show_restored_road       = (_stage >= TownStage.STREETS_RESTORED);
    var _show_restored_buildings  = (_stage >= TownStage.STREETS_RESTORED);
    var _show_trees               = (_stage >= TownStage.TREES_RESTORED);
    var _show_urban_road          = (_stage >= TownStage.URBANIZATION_COMPLETE);

    scr_set_layer_visible("Tiles_details_destroyed_1",   _show_destroyed_details);
    scr_set_layer_visible("Tiles_floors_destroyed",      _show_destroyed_floors);
    scr_set_layer_visible("Instances_destroyed_buildings", _show_destroyed_buildings);
    scr_set_layer_visible("Tiles_floors_restored",       _show_restored_floors);
    scr_set_layer_visible("Tiles_road_restored",         _show_restored_road);
    scr_set_layer_visible("Instances_restored_buildings", _show_restored_buildings);
    scr_set_layer_visible("Tiles_trees",                 _show_trees);
    scr_set_layer_visible("Tiles_urban_road",            _show_urban_road);
}

function scr_set_layer_visible(_name, _visible) {
    var _lay = layer_get_id(_name);
    if (_lay != -1) layer_set_visible(_lay, _visible);
}

// =============================================================
// CONSTRUCCION (etapas con duracion en dias)
// =============================================================

function scr_start_town_construction(_duration) {
    global.town_construction_day = global.day;
    global.town_construction_duration = _duration;
}

// Llamar al iniciar partida o entrar al town para verificar si una
// construccion en progreso ya termino (por dias transcurridos).
function scr_check_town_construction_completed() {
    if (global.town_construction_duration <= 0) return false;
    var _days_passed = global.day - global.town_construction_day;
    if (_days_passed >= global.town_construction_duration) {
        global.town_construction_duration = 0;
        global.town_construction_day = 0;
        return true;
    }
    return false;
}
