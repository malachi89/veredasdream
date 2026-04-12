// --- CONFIGURACIÓN VISUAL ---
display_set_gui_size(window_get_width(), window_get_height());

gui_scale      = 1.7; 
slot_size      = 32 * gui_scale; 
spacing        = 2 * gui_scale;      
margin_bottom  = 10 * gui_scale; 

// --- ESTRUCTURA DE DATOS ---
total_slots        = 10;
max_backpack_slots = 112; 

inventory_array = array_create(total_slots, -1); 
backpack_array  = array_create(max_backpack_slots, -1);

// --- VARIABLES DE ESTADO ---
selected_slot = 0; 
show_backpack = false;
held_item     = -1;

// --- CÁLCULO DE POSICIÓN (HOTBAR) ---
var _menu_w  = (total_slots * slot_size) + ((total_slots - 1) * spacing);
menu_x_start = (display_get_gui_width() / 2) - (_menu_w / 2);
menu_y_start = display_get_gui_height() - slot_size - margin_bottom;

// --- FUNCIONES DEL SISTEMA ---

function add_item(_item_key) {
    // Intentar en Barra Rápida
    for (var i = 0; i < total_slots; i++) {
        if (inventory_array[i] == -1) {
            inventory_array[i] = _item_key;
            return true; 
        }
    }
    // Intentar en Mochila
    for (var i = 0; i < max_backpack_slots; i++) {
        if (backpack_array[i] == -1) {
            backpack_array[i] = _item_key;
            return true;
        }
    }
    return false;
}

function scr_inventory_swap(_target_array, _index) {
    // Si la mano está vacía, agarramos lo que hay en el slot
    if (held_item == -1) {
        if (_target_array[_index] != -1) {
            held_item = _target_array[_index];
            _target_array[_index] = -1;
            show_debug_message("Agarré ítem: " + string(held_item));
        }
    } 
    // Si la mano tiene algo, lo intercambiamos
    else {
        var _temp = _target_array[_index];
        _target_array[_index] = held_item;
        held_item = _temp;
        show_debug_message("Solté/Intercambié ítem");
    }
}

// --- CARGA INICIAL (EQUIPO) ---
add_item("watering_can");
add_item("pickaxe");
add_item("axe");
add_item("sickle");
add_item("hoe");
add_item("onion_seeds");