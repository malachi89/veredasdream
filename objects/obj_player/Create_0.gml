// Destroy room-layout duplicate when a persistent player already exists in this session.
// Exception: ghost players (is_local=false) are intentionally created by net_handle_handshake.
var _creating_ghost = variable_instance_exists(id, "is_local") && !is_local;
if (!_creating_ghost && instance_exists(global.local_player) && global.local_player != id) {
    instance_destroy();
    exit;
}

// --- IDENTIDAD MP ---
// player_id: 1 for host/solo player, 2 for remote/client.
// is_local: true on the machine that controls this player via keyboard/mouse.
// is_host: true only on the host process (in single-player, the only player is the host).
if (!variable_instance_exists(id, "player_id")) player_id = 1;
if (!variable_instance_exists(id, "is_local")) {
    // In any MP mode, if a local player already exists this new instance must not claim is_local.
    // Covers: CLIENT room-layout duplicates, and HOST ghost player spawned by net_handle_handshake.
    is_local = !(global.net_role != NET_ROLE.NONE && instance_exists(global.local_player));
}
if (!variable_instance_exists(id, "is_host")) is_host = (global.net_role != NET_ROLE.CLIENT);
room_name = room_get_name(room);

if (is_local) global.local_player = id;

// Variables para controlar la animación de acción
is_riding = false;
mount_is_bear = false;
action_sprite_skin = -1;
action_sprite_tool = -1;
action_sprite_hair = -1;
action_sprite_clothes = -1;
action_sprite_eyes = -1;
action_quality = 0;
frames_action = 6;

dir = DIR.DOWN;
state = STATE.IDLE;

frame_anim = 0;

fishing_substate = FISHING_STATE.CASTING;
fishing_bite_timer = 0;
fishing_wait_timer = 0;
show_fishing_alert = false;

move_speed = 1.3;
move_speed_run = move_speed * 1.5;


frames_idle = 4;
frames_walk = 6;
frames_run  = 8;

max_energy = 500;
energy = 500;

max_hp = 20;
hp = 20;
hurt_timer = 0;

tool_cooldown    = 0;
tool_locked_frames = 0;
bugnet_caught    = false;
bow_drawing           = false;
bow_sound_id          = -1;
bow_quality           = 0;
net_state_timer  = 0;

// --- ECONOMIA PER-PLAYER ---
money = 200;

// --- INVENTARIO PER-PLAYER ---
total_slots        = 30;
max_backpack_slots = 64;
max_shipping_slots = 64;

inventory_array = array_create(total_slots, -1);
backpack_array  = array_create(max_backpack_slots, -1);
shipping_array  = array_create(max_shipping_slots, -1);

selected_slot = 0;
held_item     = -1;

// --- UI FLAGS PER-PLAYER ---
show_backpack    = false;
show_shipping    = false;
show_chest       = false;
current_chest_id = noone;

hovered_item_data      = undefined;
hovered_item_slot_data = undefined;

split_timer = 0;
split_delay = 10;

// --- TIENDA / DIALOGO PER-PLAYER ---
shop_open      = false;
shop_npc_key   = "";
shop_scroll    = 0;
shop_msg       = "";
shop_msg_timer = 0;

dialog_open     = false;
dialog_npc_name = "";
dialog_text     = "";
sign_panel_open  = false;
sign_panel_title = "";
sign_panel_items = [];
sign_scroll      = 0;
prev_on_door = false;

// --- METODOS DE INVENTARIO (migrados desde obj_inventory) ---
function add_item(_item_key, _qty = 1, _weight = undefined) {
    if (!variable_struct_exists(global.collected_items, _item_key)) {
        global.collected_items[$ _item_key] = true;
        scr_check_collection_unlocks();
    }
    var _is_stackable = false;
    if (variable_struct_exists(global.seed_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.crop_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.material_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.ore_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.bar_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.jam_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.gemstone_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.dye_data, _item_key)) _is_stackable = true;
    if (variable_struct_exists(global.placeable_data, _item_key)) _is_stackable = true;

    if (_is_stackable) {
        for (var i = 0; i < total_slots; i++) {
            if (is_struct(inventory_array[i]) && inventory_array[i].key == _item_key) {
                if (inventory_array[i].quantity + _qty <= 999) {
                    inventory_array[i].quantity += _qty;
                    return true;
                }
            }
        }
        for (var i = 0; i < max_backpack_slots; i++) {
            if (is_struct(backpack_array[i]) && backpack_array[i].key == _item_key) {
                if (backpack_array[i].quantity + _qty <= 999) {
                    backpack_array[i].quantity += _qty;
                    return true;
                }
            }
        }
    }

    var _new_struct = { key: _item_key, quantity: _qty };
    if (_weight != undefined) _new_struct.weight = _weight;
    if (variable_struct_exists(global.tool_data, _item_key)) {
        _new_struct.quality = global.tool_data[$ _item_key].quality;
    }

    for (var i = 0; i < total_slots; i++) {
        if (inventory_array[i] == -1) {
            inventory_array[i] = _new_struct;
            return true;
        }
    }
    for (var i = 0; i < max_backpack_slots; i++) {
        if (backpack_array[i] == -1) {
            backpack_array[i] = _new_struct;
            return true;
        }
    }

    return false;
}

function scr_inventory_swap(_target_array, _index) {
    if (_target_array == shipping_array && is_struct(held_item)) {
        var _item_data = scr_get_item_data(held_item.key);
        if (is_struct(_item_data) && variable_struct_exists(_item_data, "sellable") && _item_data.sellable == false) {
            scr_notify("Este objeto no se puede vender");
            return;
        }
    }

    var _item_en_slot = _target_array[_index];

    if (held_item != -1 && is_struct(_item_en_slot)) {
        if (held_item.key == _item_en_slot.key) {
            var _total = _item_en_slot.quantity + held_item.quantity;
            if (_total <= 999) {
                _item_en_slot.quantity = _total;
                held_item = -1;
                return;
            }
        }
    }

    var _temp = _target_array[_index];
    _target_array[_index] = held_item;
    held_item = _temp;
}

function scr_inventory_split(_target_array, _index) {
    var _item_en_slot = _target_array[_index];
    if (!is_struct(_item_en_slot)) return;

    if (is_struct(held_item)) {
        if (held_item.key != _item_en_slot.key) return;
        if (held_item.quantity >= 999) return;
    }

    if (_target_array == shipping_array) {
        var _item_data = scr_get_item_data(_item_en_slot.key);
        if (is_struct(_item_data) && variable_struct_exists(_item_data, "sellable") && _item_data.sellable == false) {
            return;
        }
    }

    if (!is_struct(held_item)) {
        held_item = { key: _item_en_slot.key, quantity: 1 };
    } else {
        held_item.quantity += 1;
    }

    _item_en_slot.quantity -= 1;
    if (_item_en_slot.quantity <= 0) {
        _target_array[_index] = -1;
    }
}

// Equipo inicial (solo en creacion fresh; load del save sobreescribe arrays mas tarde)
if (is_host) {
    add_item("watering_can", 1);
    add_item("pickaxe", 1);
    add_item("axe", 1);
    add_item("sickle", 1);
    add_item("hoe", 1);
    add_item("shovel", 1);
    add_item("fishing_rod", 1);
    add_item("bugnet", 1);
    add_item("sword_1", 1);
    add_item("bow_1", 1);
    add_item("workbench", 1);
    add_item("parsnip_seeds", 10);

    // Materiales básicos para craftear
    add_item("wood",  10);
    add_item("stone", 10);
}
