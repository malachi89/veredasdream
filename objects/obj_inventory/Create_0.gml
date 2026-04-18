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

// --- ESTRUCTURA DE DATOS ---
total_slots        = 10;
max_backpack_slots = 64;

inventory_array = array_create(total_slots, -1);
backpack_array  = array_create(max_backpack_slots, -1);

// --- VARIABLES DE ESTADO ---
selected_slot = 0;
show_backpack = false;
show_shipping = false;
held_item     = -1;

show_chest       = false;
current_chest_id = noone;

hovered_item_data = undefined;
hovered_item_slot_data = undefined;

max_shipping_slots = 64;
shipping_array     = array_create(max_shipping_slots, -1);

// Variables para división de stacks
split_timer = 0;
split_delay = 10; // Frames entre cada item tomado al mantener presionado

// --- TIENDA ---
shop_open      = false;
shop_npc_key   = "";
shop_scroll    = 0;
shop_msg       = "";
shop_msg_timer = 0;

// --- DIALOGO ---
dialog_open     = false;
dialog_npc_name = "";
dialog_text     = "";

// --- FUNCIONES DEL SISTEMA ---
function update_gui_positions() {
    // --- CALCULO DE POSICION (HOTBAR) ---
    var _menu_w  = (total_slots * slot_size) + ((total_slots - 1) * spacing);
    menu_x_start = (display_get_gui_width() / 2) - (_menu_w / 2);
    menu_y_start = display_get_gui_height() - slot_size - margin_bottom;
}

update_gui_positions();

function add_item(_item_key, _qty = 1) {
    // --- 1. Determinar si es stackable ---
    var _is_stackable = false;
    if (variable_struct_exists(global.seed_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.crop_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.material_data, _item_key)) _is_stackable = true;

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

    // --- 3. Si no es stackable o no se encontro espacio para sumar, buscar slot vacio ---
    var _new_struct = { key: _item_key, quantity: _qty };
    
    // Si es una herramienta, agregar calidad inicial
    if (variable_struct_exists(global.tool_data, _item_key)) {
        _new_struct.quality = global.tool_data[$ _item_key].quality;
    }

    // Intentar en Barra Rapida
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
    // Si estamos intentando mover algo al shipping bin, verificar si es vendible
    if (_target_array == shipping_array && is_struct(held_item)) {
        var _item_data = scr_get_item_data(held_item.key);
        if (is_struct(_item_data) && variable_struct_exists(_item_data, "sellable") && _item_data.sellable == false) {
            scr_notify("Este objeto no se puede vender");
            return;
        }
    }

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

    // Si no es el mismo item, hacemos el intercambio normal
    var _temp = _target_array[_index];
    _target_array[_index] = held_item;
    held_item = _temp;
}

function scr_inventory_split(_target_array, _index) {
    var _item_en_slot = _target_array[_index];
    
    // Solo podemos sacar si hay algo en el slot
    if (!is_struct(_item_en_slot)) return;
    
    // Si ya tenemos algo en mano, debe ser del mismo tipo para acumular
    if (is_struct(held_item)) {
        if (held_item.key != _item_en_slot.key) return; // Diferentes items
        if (held_item.quantity >= 999) return; // Mano llena
    }
    
    // Si estamos en el shipping bin, verificar si es vendible (aunque ya debería estar ahí, por seguridad)
    if (_target_array == shipping_array) {
        var _item_data = scr_get_item_data(_item_en_slot.key);
        if (is_struct(_item_data) && variable_struct_exists(_item_data, "sellable") && _item_data.sellable == false) {
            return;
        }
    }

    // Realizar la transferencia de 1 unidad
    if (!is_struct(held_item)) {
        // Crear nuevo stack en mano
        held_item = { key: _item_en_slot.key, quantity: 1 };
    } else {
        held_item.quantity += 1;
    }
    
    _item_en_slot.quantity -= 1;
    
    // Si se acabó el stack del slot, limpiar el slot
    if (_item_en_slot.quantity <= 0) {
        _target_array[_index] = -1;
    }
}

// --- CARGA INICIAL (EQUIPO) ---
add_item("watering_can", 1);
add_item("pickaxe", 1);
add_item("axe", 1);
add_item("sickle", 1);
add_item("hoe", 1);
add_item("tomato_seeds", 10);
