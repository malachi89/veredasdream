depth = -bbox_bottom;

if (interaction_cooldown > 0) interaction_cooldown -= 1;

var _lp = global.local_player;
if (!instance_exists(_lp)) exit;
if (_lp.shop_open || _lp.dialog_open || _lp.donation_box_open) exit;
if (_lp.show_backpack || _lp.show_shipping || _lp.show_chest) exit;

var _dist = point_distance(x, y, _lp.x, _lp.y);
if (_dist >= 48) exit;

if (interaction_cooldown > 0) exit;
if (!keyboard_check_pressed(ord("E"))) exit;

interaction_cooldown = 20;

// Si el town ya esta totalmente restaurado
if (global.town_stage >= TownStage.URBANIZATION_COMPLETE) {
    scr_notify("El town esta completamente restaurado.");
    exit;
}

// Si hay construccion en progreso, mostrar dias restantes
if (global.town_construction_duration > 0) {
    var _days_left = global.town_construction_duration - (scr_total_days() - global.town_construction_day);
    scr_notify("Construccion en progreso (" + string(max(_days_left, 0)) + " dias).");
    exit;
}

// Abrir panel de donativo
_lp.donation_box_open = true;
_lp.donation_msg = "";
_lp.donation_msg_timer = 0;
