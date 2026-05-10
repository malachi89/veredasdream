// obj_inventory es un singleton de UI/input para el jugador local.
// Los datos (inventario, mochila, shipping, dinero, held_item, flags UI) viven en obj_player.
if (instance_number(obj_inventory) > 1) {
    instance_destroy();
    exit;
}

// --- CONFIGURACION VISUAL ---
display_set_gui_size(window_get_width(), window_get_height());

gui_scale      = 1.7;
slot_size      = 32 * gui_scale;
spacing        = 2 * gui_scale;
margin_bottom  = 10 * gui_scale;

// Tamanos de datos (para layouts de UI; los arrays reales viven en obj_player).
total_slots        = 10;
max_backpack_slots = 64;
max_shipping_slots = 64;

// Referencia al jugador local cuya UI dibujamos/operamos.
// Se fija en obj_controller cuando existe obj_player.
local_player = noone;

function update_gui_positions() {
    var _total_to_draw = total_slots + 1; // 10 slots + 1 indicador de hotbar
    var _menu_w  = (_total_to_draw * slot_size) + ((_total_to_draw - 1) * spacing);
    menu_x_start = (display_get_gui_width() / 2) - (_menu_w / 2);
    menu_y_start = display_get_gui_height() - slot_size - margin_bottom;
}


update_gui_positions();

// --- DELEGADORES (para codigo existente que llamaba obj_inventory.add_item(...)) ---
function add_item(_item_key, _qty = 1) {
    if (!instance_exists(local_player)) return false;
    with (local_player) return add_item(_item_key, _qty);
}

function scr_inventory_swap(_target_array, _index) {
    if (!instance_exists(local_player)) return;
    with (local_player) scr_inventory_swap(_target_array, _index);
}

function scr_inventory_split(_target_array, _index) {
    if (!instance_exists(local_player)) return;
    with (local_player) scr_inventory_split(_target_array, _index);
}
