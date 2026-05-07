depth = -bbox_bottom;

if (interaction_cooldown > 0) interaction_cooldown -= 1;

var _lp = global.local_player;
if (!instance_exists(_lp)) exit;
if (_lp.shop_open || _lp.dialog_open) exit;
if (_lp.show_backpack || _lp.show_shipping || _lp.show_chest) exit;

var _dist = point_distance(x, y, _lp.x, _lp.y);
if (_dist >= 48) exit;

if (interaction_cooldown > 0) exit;
if (!keyboard_check_pressed(ord("E"))) exit;

interaction_cooldown = 20;

// Si el town ya esta totalmente restaurado, mostrar mensaje
if (global.town_stage >= TownStage.URBANIZATION_COMPLETE) {
    scr_notify("El town esta completamente restaurado.");
    exit;
}

// Si hay construccion en progreso, mostrar dias restantes
if (global.town_construction_duration > 0) {
    var _days_left = global.town_construction_duration - (global.day - global.town_construction_day);
    scr_notify("Construccion en progreso (" + string(_days_left) + " dias).");
    exit;
}

// Donar items aplicables del inventario
var _res = scr_donate_to_town(_lp);

if (_res.completed) {
    scr_notify("Etapa completada!");
} else if (_res.donated) {
    scr_notify("Donados " + string(_res.items_donated) + " items.");

    // Resumen de progreso restante
    var _stage = global.town_stage;
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    var _missing = [];
    for (var _i = 0; _i < array_length(_req_keys); _i++) {
        var _rk = _req_keys[_i];
        var _have = scr_get_donation_progress(_rk);
        var _need = _reqs[$ _rk];
        if (_have < _need) {
            array_push(_missing, _rk + ": " + string(_have) + "/" + string(_need));
        }
    }
    if (array_length(_missing) > 0) {
        var _line = "Faltan: ";
        for (var _i = 0; _i < min(3, array_length(_missing)); _i++) {
            _line += _missing[_i];
            if (_i < min(3, array_length(_missing)) - 1) _line += ", ";
        }
        if (array_length(_missing) > 3) _line += " (+" + string(array_length(_missing) - 3) + " mas)";
        scr_notify(_line);
    }
} else {
    scr_notify("No tienes items que donar para esta etapa.");
}
