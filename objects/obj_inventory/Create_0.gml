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

function add_item(_item_key, _qty = 1) {
    // --- 1. Determinar si es stackable ---
    var _is_stackable = false;
    if (variable_struct_exists(global.seed_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.crop_data, _item_key)) _is_stackable = true;
    // Las herramientas no entran aquí, por lo que _is_stackable será false para ellas.

    // --- 2. Si es stackable, buscar si ya existe para sumar ---
    if (_is_stackable) {
        // Buscar en Hotbar
        for (var i = 0; i < total_slots; i++) {
            if (is_struct(inventory_array[i]) && inventory_array[i].key == _item_key) {
                if (inventory_array[i].quantity + _qty <= 999) {
                    inventory_array[i].quantity += _qty;
                    return true;
                }
            }
        }
        // Buscar en Mochila
        for (var i = 0; i < max_backpack_slots; i++) {
            if (is_struct(backpack_array[i]) && backpack_array[i].key == _item_key) {
                if (backpack_array[i].quantity + _qty <= 999) {
                    backpack_array[i].quantity += _qty;
                    return true;
                }
            }
        }
    }

    // --- 3. Si no es stackable o no se encontró espacio para sumar, buscar slot vacío ---
    var _new_struct = { key: _item_key, quantity: _qty };

    // Intentar en Barra Rápida
    for (var i = 0; i < total_slots; i++) {
        if (inventory_array[i] == -1) {
            inventory_array[i] = _new_struct;
            return true; 
        }
    }
    // Intentar en Mochila
    for (var i = 0; i < max_backpack_slots; i++) {
        if (backpack_array[i] == -1) {
            backpack_array[i] = _new_struct;
            return true;
        }
    }
    
    return false; // Inventario lleno
}

function scr_inventory_swap(_target_array, _index) {
    var _item_en_slot = _target_array[_index];

    // Caso especial: Stacking al soltar
    if (held_item != -1 && is_struct(_item_en_slot)) {
        if (held_item.key == _item_en_slot.key) {
            // Es el mismo item, sumamos
            var _total = _item_en_slot.quantity + held_item.quantity;
            if (_total <= 999) {
                _item_en_slot.quantity = _total;
                held_item = -1;
                return;
            }
        }
    }

    // Si no es el mismo item, hacemos el intercambio normal que ya tenías
    var _temp = _target_array[_index];
    _target_array[_index] = held_item;
    held_item = _temp;
}


// --- CARGA INICIAL (EQUIPO) ---
add_item("watering_can",1);
add_item("pickaxe",1);
add_item("axe",1);
add_item("sickle",1);
add_item("hoe",1);
add_item("tomato_seeds",40);