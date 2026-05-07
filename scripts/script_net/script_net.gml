// ============================================================
// script_net — Veredas Dream LAN Multiplayer helpers
// ============================================================
// Packet wire format: [u16 payload_size][u8 cmd][payload bytes]
// payload_size = bytes AFTER the 3-byte header (cmd + payload).

// Network socket type constants (GMS2 built-ins that may not resolve in all contexts)
#macro NET_SOCKET_TCP 0
#macro NET_SOCKET_UDP 1
// Total wire bytes = 3 + payload_size.
// ============================================================

// --- Send helpers ---

// Begin a new outgoing packet. Returns a buffer with a 5-byte header written.
// Caller writes payload bytes, then calls net_send() to finalise and send.
function net_begin(_cmd) {
    var _buf = buffer_create(256, buffer_grow, 1);
    buffer_write(_buf, buffer_u32, 0);   // placeholder for payload_size (4 bytes)
    buffer_write(_buf, buffer_u8, _cmd); // cmd at offset 4
    return _buf;
}

// Finalise size, send, and free the buffer.
function net_send(_socket, _buf) {
    var _payload_size = buffer_tell(_buf) - 5;
    buffer_poke(_buf, 0, buffer_u32, _payload_size);
    network_send_packet(_socket, _buf, buffer_tell(_buf));
    buffer_delete(_buf);
}

// Broadcast to all connected peers (host sends to client; client sends to host).
function net_broadcast(_buf) {
    if (!instance_exists(obj_net)) return;
    var _payload_size = buffer_tell(_buf) - 5;
    buffer_poke(_buf, 0, buffer_u32, _payload_size);
    var _total = buffer_tell(_buf);
    if (global.net_role == NET_ROLE.HOST && obj_net.peer_socket >= 0) {
        network_send_packet(obj_net.peer_socket, _buf, _total);
    } else if (global.net_role == NET_ROLE.CLIENT && obj_net.client_socket >= 0) {
        network_send_packet(obj_net.client_socket, _buf, _total);
    }
    buffer_delete(_buf);
}

// --- Receive / dispatch ---

// Called from obj_net Async Networking. Appends new data then parses complete packets.
function net_process_incoming(_raw_buf, _raw_size, _from_socket) {
    var _net = obj_net;
    // Append raw bytes to accumulation buffer
    buffer_copy(_raw_buf, 0, _raw_size, _net.recv_buf, _net.recv_fill);
    _net.recv_fill += _raw_size;

    var _pos = 0;
    while (_pos + 5 <= _net.recv_fill) {
        var _payload_size = buffer_peek(_net.recv_buf, _pos,     buffer_u32);
        var _total        = 5 + _payload_size;
        if (_pos + _total > _net.recv_fill) break; // incomplete packet — wait

        var _cmd = buffer_peek(_net.recv_buf, _pos + 4, buffer_u8);

        // Slice payload into its own buffer for the handler
        var _payload = buffer_create(_payload_size + 1, buffer_fixed, 1);
        if (_payload_size > 0) {
            buffer_copy(_net.recv_buf, _pos + 5, _payload_size, _payload, 0);
        }
        buffer_seek(_payload, buffer_seek_start, 0);

        net_dispatch(_cmd, _payload, _from_socket);
        buffer_delete(_payload);

        _pos += _total;
    }

    // Compact — shift remaining bytes to front
    var _remaining = _net.recv_fill - _pos;
    if (_pos > 0) {
        if (_remaining > 0) {
            buffer_copy(_net.recv_buf, _pos, _remaining, _net.recv_buf, 0);
        }
        _net.recv_fill = _remaining;
    }
}

// Dispatch a fully-assembled packet to the right handler.
function net_dispatch(_cmd, _payload, _from_socket) {
    switch (_cmd) {
        case NET_CMD.HANDSHAKE:
            net_handle_handshake(_payload, _from_socket);
            break;
        case NET_CMD.HANDSHAKE_ACK:
            net_handle_handshake_ack(_payload);
            break;
        case NET_CMD.FULL_SNAPSHOT:
            net_handle_full_snapshot(_payload);
            break;
        case NET_CMD.PLAYER_STATE:
            net_handle_player_state(_payload);
            break;
        case NET_CMD.ROOM_CHANGE:
            net_handle_room_change(_payload);
            break;
        case NET_CMD.ROOM_SNAPSHOT:
            net_handle_room_snapshot(_payload);
            break;
        case NET_CMD.WORLD_EVENT:
            net_handle_world_event(_payload);
            break;
        case NET_CMD.CMD_USE_ITEM:
            net_handle_use_item(_payload);
            break;
        case NET_CMD.CMD_FISH_REEL:
            net_handle_fish_reel();
            break;
        case NET_CMD.CMD_SHOP_BUY:
            net_handle_shop_buy(_payload);
            break;
        case NET_CMD.CMD_BUY_BUILDING:
            net_handle_buy_building(_payload);
            break;
        case NET_CMD.CMD_UPGRADE_TOOL:
            net_handle_upgrade_tool(_payload);
            break;
        case NET_CMD.CMD_PICKUP:
            net_handle_pickup(_payload);
            break;
        case NET_CMD.CMD_DROP:
            net_handle_drop(_payload);
            break;
        case NET_CMD.CMD_DONATE:
            net_handle_donate(_payload);
            break;
        case NET_CMD.TOWN_STAGE_UPDATE:
            net_handle_town_stage_update(_payload);
            break;
        case NET_CMD.CMD_MINE_ENTER:
            net_handle_mine_enter(_payload);
            break;
        case NET_CMD.CMD_MINE_GO_DEEPER:
            net_handle_mine_go_deeper(_payload);
            break;
        case NET_CMD.CMD_MINE_EXIT:
            net_handle_mine_exit(_payload);
            break;
        case NET_CMD.CMD_CHEST_SLOT:
            net_handle_chest_slot(_payload);
            break;
        case NET_CMD.INVENTORY_UPDATE:
            net_handle_inventory_update(_payload);
            break;
        case NET_CMD.MINE_STATE_UPDATE:
            net_handle_mine_state_update(_payload);
            break;
        case NET_CMD.MONEY_UPDATE:
            net_handle_money_update(_payload);
            break;
        case NET_CMD.ENERGY_UPDATE:
            net_handle_energy_update(_payload);
            break;
        case NET_CMD.TIME_UPDATE:
            net_handle_time_update(_payload);
            break;
        case NET_CMD.SLEEP_REQUEST:
            net_handle_sleep_request(_payload);
            break;
        case NET_CMD.SLEEP_PROMPT:
            net_handle_sleep_prompt();
            break;
        case NET_CMD.SLEEP_RESPONSE:
            net_handle_sleep_response(_payload);
            break;
        case NET_CMD.SHIPPING_SUMMARY:
            net_handle_shipping_summary(_payload);
            break;
        case NET_CMD.CMD_NAP:
            net_handle_nap();
            break;
        case NET_CMD.NEW_DAY:
            net_handle_new_day(_payload);
            break;
        case NET_CMD.NOTIFY:
            var _notify_pid = buffer_read(_payload, buffer_u8);
            var _msg        = buffer_read(_payload, buffer_string);
            // player_id 0 = broadcast; otherwise only show if it matches local player.
            var _lp_pid = instance_exists(global.local_player) ? global.local_player.player_id : 0;
            if (_notify_pid == 0 || _notify_pid == _lp_pid) scr_notify(_msg);
            break;
        case NET_CMD.DISCONNECT:
            var _reason = buffer_read(_payload, buffer_string);
            scr_notify("El otro jugador se desconecto");
            if (instance_exists(obj_net)) {
                obj_net.is_connected = false;
                obj_net.peer_socket  = -1;
            }
            break;
        default:
    }
}

// --- Handshake ---

function net_send_handshake() {
    if (!instance_exists(obj_net)) return;
    var _buf = net_begin(NET_CMD.HANDSHAKE);
    buffer_write(_buf, buffer_u16, 1);            // protocol version
    buffer_write(_buf, buffer_string, "jugador"); // client name
    net_send(obj_net.client_socket, _buf);
}

function net_handle_handshake(_payload, _client_socket) {
    var _version = buffer_read(_payload, buffer_u16);
    var _name    = buffer_read(_payload, buffer_string);

    // Send ACK with assigned player_id=2
    var _ack = net_begin(NET_CMD.HANDSHAKE_ACK);
    buffer_write(_ack, buffer_u8, 2);  // player_id for client
    buffer_write(_ack, buffer_u16, 1); // protocol version
    net_send(_client_socket, _ack);

    // Send world snapshot
    net_send_full_snapshot(_client_socket);

    // Create ghost player_2 on host for server-side action simulation
    var _obj_p = asset_get_index("obj_player");
    if (_obj_p >= 0 && instance_exists(obj_net)) {
        if (instance_exists(obj_net.remote_player_ghost)) {
            instance_destroy(obj_net.remote_player_ghost);
        }
        var _g = instance_create_layer(-2000, -2000, "Instances", _obj_p, { is_local: false });
        _g.player_id  = 2;
        _g.is_local   = false;
        _g.is_host    = false;
        _g.persistent = true;
        _g.money      = 200;
        _g.energy     = 500;
        _g.hp         = 20;
        _g.max_hp     = 20;
        // Clear default inventory and give client starting items
        for (var _gi = 0; _gi < 30; _gi++) _g.inventory_array[_gi] = -1;
        for (var _gi = 0; _gi < 64; _gi++) _g.backpack_array[_gi]  = -1;
        _g.add_item("watering_can", 1);
        _g.add_item("pickaxe", 1);
        _g.add_item("axe", 1);
        _g.add_item("sickle", 1);
        _g.add_item("hoe", 1);
        _g.add_item("shovel", 1);
        _g.add_item("fishing_rod", 1);
        _g.add_item("bugnet", 1);
        _g.add_item("sword_1", 1);
        _g.add_item("bow_1", 1);
        _g.add_item("parsnip_seeds", 10);
        obj_net.remote_player_ghost = _g;
    }
}

function net_handle_handshake_ack(_payload) {
    var _pid     = buffer_read(_payload, buffer_u8);
    var _version = buffer_read(_payload, buffer_u16);
    if (instance_exists(obj_net)) obj_net.local_player_id = _pid;
    // Snapshot will arrive immediately after; wait for it.
    scr_notify("Conectado! Recibiendo datos...");
}

// --- Full snapshot ---

function net_send_full_snapshot(_client_socket) {
    scr_capture_current_room_state();

    // Client gets fresh player2 state; no saved inventory for them yet.
    var _snap = {
        time: {
            minute:       global.game_minute,
            hour:         global.game_hour,
            day:          global.day,
            year:         global.year,
            season_index: global.season_index,
            season:       global.season
        },
        player2: {
            room_name: room_get_name(room),
            x:         instance_exists(global.local_player) ? global.local_player.x + 32 : 192,
            y:         instance_exists(global.local_player) ? global.local_player.y       : 192,
            dir:       DIR.DOWN,
            money:     500,
            energy:    500,
            hp:        20
        },
        room_states:              global.room_states,
        room_drops:               global.room_drops,
        next_drop_uid:            global.next_drop_uid,
        farm_populated:           global.farm_populated,
        mine_state:               global.mine_state,
        mine_unlocks:             global.mine_unlocks,
        mine_progress:            global.mine_progress,
        mine_floor_room_assigned: global.mine_floor_room_assigned,
        cave_repopulate:          global.cave_repopulate,
        town_stage:               global.town_stage,
        town_donations:           global.town_donations,
        town_construction_day:    global.town_construction_day,
        town_construction_duration: global.town_construction_duration
    };

    var _json = json_stringify(_snap);
    var _buf  = net_begin(NET_CMD.FULL_SNAPSHOT);
    buffer_write(_buf, buffer_string, _json);
    net_send(_client_socket, _buf);
}

function net_handle_full_snapshot(_payload) {
    var _json = buffer_read(_payload, buffer_string);
    var _snap = json_parse(_json);

    // Apply time
    global.game_minute  = _snap.time.minute;
    global.game_hour    = _snap.time.hour;
    global.day          = _snap.time.day;
    global.year         = _snap.time.year;
    global.season_index = _snap.time.season_index;
    global.season       = _snap.time.season;

    // Apply world state
    global.room_states    = _snap.room_states;
    global.room_drops     = _snap.room_drops;
    global.next_drop_uid  = _snap.next_drop_uid;
    global.farm_populated           = _snap.farm_populated;
    global.mine_state               = _snap.mine_state;
    global.mine_unlocks             = _snap.mine_unlocks;
    global.mine_progress            = _snap.mine_progress;
    global.mine_floor_room_assigned = _snap.mine_floor_room_assigned;
    global.cave_repopulate          = _snap.cave_repopulate;
    global.town_stage                 = variable_struct_exists(_snap, "town_stage") ? _snap.town_stage : TownStage.INITIAL;
    global.town_donations             = variable_struct_exists(_snap, "town_donations") ? _snap.town_donations : {};
    global.town_construction_day      = variable_struct_exists(_snap, "town_construction_day") ? _snap.town_construction_day : 0;
    global.town_construction_duration = variable_struct_exists(_snap, "town_construction_duration") ? _snap.town_construction_duration : 0;

    // Destroy any existing players, spawn player2 as local player
    with (obj_player) instance_destroy();

    var _p = instance_create_layer(0, 0, "Instances", obj_player);
    _p.player_id = 2;
    _p.is_local  = true;
    _p.is_host   = false;
    _p.money     = _snap.player2.money;
    _p.energy    = _snap.player2.energy;
    if (variable_struct_exists(_snap.player2, "hp")) _p.hp = _snap.player2.hp;
    _p.add_item("watering_can", 1);
    _p.add_item("pickaxe", 1);
    _p.add_item("axe", 1);
    _p.add_item("sickle", 1);
    _p.add_item("hoe", 1);
    _p.add_item("shovel", 1);
    _p.add_item("fishing_rod", 1);
    _p.add_item("bugnet", 1);
    _p.add_item("sword_1", 1);
    _p.add_item("bow_1", 1);
    _p.add_item("parsnip_seeds", 10);
    global.local_player = _p;

    // Set position directly — persistent instance carries x/y/dir through room_goto.
    _p.x   = _snap.player2.x;
    _p.y   = _snap.player2.y;
    _p.dir = _snap.player2.dir;

    var _target = asset_get_index(_snap.player2.room_name);
    if (_target != -1 && room_get_name(room) != _snap.player2.room_name) {
        global.pending_player_room_name = "";
        room_goto(_target);
    } else {
        if (instance_exists(obj_controller)) {
            with (obj_controller) {
                scr_restore_room_state(room_get_name(room));
                scr_restore_room_drops(room_get_name(room));
                update_tilesets();
            }
        }
        global.pending_player_room_name = "";
    }

    scr_notify("Conectado como Jugador 2!");
}

// --- PLAYER_STATE ---

function net_send_player_state() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _lp = global.local_player;
    if (!instance_exists(_lp)) return;

    var _buf = net_begin(NET_CMD.PLAYER_STATE);
    buffer_write(_buf, buffer_u8,     _lp.player_id);
    buffer_write(_buf, buffer_string, room_get_name(room));
    buffer_write(_buf, buffer_f32,    _lp.x);
    buffer_write(_buf, buffer_f32,    _lp.y);
    buffer_write(_buf, buffer_u8,     _lp.dir);
    buffer_write(_buf, buffer_u8,     _lp.state);
    buffer_write(_buf, buffer_f32,    _lp.image_index);
    buffer_write(_buf, buffer_u8,     _lp.is_riding ? 1 : 0);
    buffer_write(_buf, buffer_u8,     _lp.mount_is_bear ? 1 : 0);
    if (_lp.state == STATE.ACTING || _lp.state == STATE.FISHING) {
        buffer_write(_buf, buffer_s32, _lp.action_sprite_skin);
        buffer_write(_buf, buffer_s32, _lp.action_sprite_tool);
        buffer_write(_buf, buffer_s32, _lp.action_sprite_hair);
        buffer_write(_buf, buffer_s32, _lp.action_sprite_clothes);
        buffer_write(_buf, buffer_s32, _lp.action_sprite_eyes);
    }
    net_broadcast(_buf);
}

function net_handle_player_state(_payload) {
    var _pid       = buffer_read(_payload, buffer_u8);
    var _room_name = buffer_read(_payload, buffer_string);
    var _px        = buffer_read(_payload, buffer_f32);
    var _py        = buffer_read(_payload, buffer_f32);
    var _dir       = buffer_read(_payload, buffer_u8);
    var _pstate    = buffer_read(_payload, buffer_u8);
    var _frame     = buffer_read(_payload, buffer_f32);
    var _riding    = buffer_read(_payload, buffer_u8) != 0;
    var _bear      = buffer_read(_payload, buffer_u8) != 0;
    var _act_skin = -1, _act_tool = -1, _act_hair = -1, _act_clothes = -1, _act_eyes = -1;
    if (_pstate == STATE.ACTING || _pstate == STATE.FISHING) {
        _act_skin    = buffer_read(_payload, buffer_s32);
        _act_tool    = buffer_read(_payload, buffer_s32);
        _act_hair    = buffer_read(_payload, buffer_s32);
        _act_clothes = buffer_read(_payload, buffer_s32);
        _act_eyes    = buffer_read(_payload, buffer_s32);
    }

    // String lookup avoids scope-resolution issues (defaultScriptType=1 runs in caller scope).
    var _obj_rp = asset_get_index("obj_remote_player");
    if (_obj_rp < 0) return; // object not yet registered in IDE

    var _local_room = room_get_name(room);

    // Find existing obj_remote_player for this pid
    var _rp = noone;
    with (_obj_rp) {
        if (player_id == _pid) { _rp = id; break; }
    }

    if (_room_name == _local_room) {
        if (_rp == noone) {
            _rp = instance_create_layer(_px, _py, "Instances", _obj_rp);
            _rp.player_id = _pid;
        }
        _rp.target_x  = _px;
        _rp.target_y  = _py;
        _rp.dir       = _dir;
        _rp.rem_state = _pstate;
        _rp.rem_frame = _frame;
        _rp.is_riding = _riding;
        _rp.mount_is_bear = _bear;
        _rp.room_name = _room_name;
        if (_pstate == STATE.ACTING || _pstate == STATE.FISHING) {
            _rp.act_skin    = _act_skin;
            _rp.act_tool    = _act_tool;
            _rp.act_hair    = _act_hair;
            _rp.act_clothes = _act_clothes;
            _rp.act_eyes    = _act_eyes;
        }
    } else {
        if (_rp != noone) instance_destroy(_rp);
    }
}

// --- Ghost inventory helper ---

// Add item to ghost and send whichever slot changed to the client.
function net_ghost_add_item(_ghost, _item_key, _qty) {
    _ghost.add_item(_item_key, _qty);
    for (var _i = 0; _i < 10; _i++) {
        var _s = _ghost.inventory_array[_i];
        if (is_struct(_s) && _s.key == _item_key) {
            net_send_inventory_update(2, 0, _i, _s);
            return;
        }
    }
    for (var _i = 0; _i < 64; _i++) {
        var _s = _ghost.backpack_array[_i];
        if (is_struct(_s) && _s.key == _item_key) {
            net_send_inventory_update(2, 1, _i, _s);
            return;
        }
    }
}

// --- Fishing ---

function net_send_fish_reel() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_FISH_REEL);
    net_broadcast(_buf);
}

function net_handle_fish_reel() {
    if (global.net_role != NET_ROLE.HOST) return;
    var _ghost = obj_net.remote_player_ghost;
    if (!instance_exists(_ghost)) return;

    var _pool = global.fish_pool[global.season_index];
    var _fish_key  = _pool[irandom(array_length(_pool) - 1)];
    var _fish_data = global.fish_data[$ _fish_key];

    net_ghost_add_item(_ghost, _fish_key, 1);
    _ghost.energy -= 10;
    net_send_energy_update(2, _ghost.energy);
    net_send_notify_peer("¡Atrapaste un " + _fish_data.name + "!");
}

// --- Shop purchases ---

function net_send_shop_buy(_npc_key, _item_key) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_SHOP_BUY);
    buffer_write(_buf, buffer_string, _npc_key);
    buffer_write(_buf, buffer_string, _item_key);
    net_broadcast(_buf);
}

function net_handle_shop_buy(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _npc_key  = buffer_read(_payload, buffer_string);
    var _item_key = buffer_read(_payload, buffer_string);

    var _ghost = obj_net.remote_player_ghost;
    if (!instance_exists(_ghost)) return;

    var _shop = global.shop_data[$ _npc_key];
    if (_shop == undefined || !_shop.available) {
        net_send_notify_peer("Tienda no disponible");
        return;
    }

    var _entry = undefined;
    for (var _i = 0; _i < array_length(_shop.items); _i++) {
        if (_shop.items[_i].item_key == _item_key) { _entry = _shop.items[_i]; break; }
    }
    if (_entry == undefined) { net_send_notify_peer("Articulo no encontrado"); return; }

    var _can_afford = _ghost.money >= _entry.price_money;
    var _items_ok   = true;
    for (var _j = 0; _j < array_length(_entry.price_items); _j++) {
        var _req = _entry.price_items[_j];
        if (scr_count_item(_req.key, _ghost) < _req.qty) { _items_ok = false; break; }
    }

    if (_can_afford && _items_ok) {
        _ghost.money -= _entry.price_money;
        for (var _j = 0; _j < array_length(_entry.price_items); _j++) {
            var _req = _entry.price_items[_j];
            scr_remove_item(_req.key, _req.qty, _ghost);
        }
        net_ghost_add_item(_ghost, _item_key, 1);
        net_send_money_update(2, _ghost.money);
        net_send_notify_peer("Comprado!");
    } else if (!_can_afford) {
        net_send_notify_peer("Fondos insuficientes");
    } else {
        net_send_notify_peer("Te faltan materiales");
    }
}

// --- Building purchase ---

function net_send_buy_building(_building_name) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_BUY_BUILDING);
    buffer_write(_buf, buffer_string, _building_name);
    net_broadcast(_buf);
}

function net_handle_buy_building(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _name = buffer_read(_payload, buffer_string);
    scr_buy_building(_name);
}

// --- Tool upgrade ---

function net_send_upgrade_tool(_tool_key) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_UPGRADE_TOOL);
    buffer_write(_buf, buffer_string, _tool_key);
    net_broadcast(_buf);
}

function net_handle_upgrade_tool(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _tool_key = buffer_read(_payload, buffer_string);
    var _ghost    = obj_net.remote_player_ghost;
    if (!instance_exists(_ghost)) return;

    var _arrays = [_ghost.inventory_array, _ghost.backpack_array];
    for (var _a = 0; _a < 2; _a++) {
        var _arr = _arrays[_a];
        for (var _i = 0; _i < array_length(_arr); _i++) {
            var _slot = _arr[_i];
            if (is_struct(_slot) && variable_struct_exists(_slot, "key") && _slot.key == _tool_key) {
                var _cur = variable_struct_exists(_slot, "quality") ? _slot.quality : QUALITY.OXIDADO;
                if (_cur < QUALITY.VITOLANIO) {
                    _slot.quality = _cur + 1;
                    net_send_inventory_update(2, _a, _i, _slot);
                    net_send_notify_peer(_tool_key + " mejorado a " + global.quality_names[_slot.quality]);
                } else {
                    net_send_notify_peer(_tool_key + " ya esta al maximo");
                }
                return;
            }
        }
    }
    net_send_notify_peer("No tienes ese item");
}

// --- Room transitions ---

// Client → host: "I want to go to this room."
function net_send_room_change(_room_name, _target_x, _target_y) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.ROOM_CHANGE);
    buffer_write(_buf, buffer_string, _room_name);
    buffer_write(_buf, buffer_s32,    _target_x);
    buffer_write(_buf, buffer_s32,    _target_y);
    net_broadcast(_buf);
}

// Host receives client's room-change request; sends a ROOM_SNAPSHOT back.
function net_handle_room_change(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _room_name = buffer_read(_payload, buffer_string);
    var _target_x  = buffer_read(_payload, buffer_s32);
    var _target_y  = buffer_read(_payload, buffer_s32);

    // If host is live in the target room, capture current state before snapshotting.
    if (room_get_name(room) == _room_name) {
        scr_capture_current_room_state();
    }

    net_send_room_snapshot(_room_name, _target_x, _target_y);
}

// Host → client: authoritative state for the room the client is entering.
function net_send_room_snapshot(_room_name, _target_x, _target_y) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;

    var _state = scr_get_room_state(_room_name);
    var _drops = variable_struct_exists(global.room_drops, _room_name)
                 ? global.room_drops[$  _room_name] : [];

    var _buf = net_begin(NET_CMD.ROOM_SNAPSHOT);
    buffer_write(_buf, buffer_string, _room_name);
    buffer_write(_buf, buffer_s32,    _target_x);
    buffer_write(_buf, buffer_s32,    _target_y);
    buffer_write(_buf, buffer_string, json_stringify(_state));
    buffer_write(_buf, buffer_string, json_stringify(_drops));
    net_broadcast(_buf);
}

// Client receives ROOM_SNAPSHOT: apply world state then call room_goto.
function net_handle_room_snapshot(_payload) {
    var _room_name  = buffer_read(_payload, buffer_string);
    var _target_x   = buffer_read(_payload, buffer_s32);
    var _target_y   = buffer_read(_payload, buffer_s32);
    var _state_json = buffer_read(_payload, buffer_string);
    var _drops_json = buffer_read(_payload, buffer_string);

    // Update canonical world state so scr_restore_room_state has correct data on entry.
    global.room_states[$ _room_name] = json_parse(_state_json);
    global.room_drops[$  _room_name] = json_parse(_drops_json);

    // Position player correctly when the new room's Step first runs.
    global.pending_player_room_name = _room_name;
    global.pending_player_x         = _target_x;
    global.pending_player_y         = _target_y;
    if (instance_exists(global.local_player)) {
        global.pending_player_dir = global.local_player.dir;
    }

    var _target_room = asset_get_index(_room_name);
    if (_target_room >= 0) {
        room_goto(_target_room);
    } else {
        if (instance_exists(obj_controller)) obj_controller.room_change_pending = false;
    }
}

// --- Sleep ---

function net_send_sleep_request() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _lp = global.local_player;
    var _shipping_json = "[]";
    if (instance_exists(_lp)) _shipping_json = json_stringify(_lp.shipping_array);
    var _buf = net_begin(NET_CMD.SLEEP_REQUEST);
    buffer_write(_buf, buffer_string, _shipping_json);
    net_broadcast(_buf);
}

function net_handle_sleep_request(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _shipping_json = buffer_read(_payload, buffer_string);
    // Apply client's shipping array to ghost so host can process it.
    if (instance_exists(obj_net)) {
        var _ghost = obj_net.remote_player_ghost;
        if (instance_exists(_ghost) && _shipping_json != "" && _shipping_json != "[]") {
            _ghost.shipping_array = json_parse(_shipping_json);
        }
    }
    if (!instance_exists(obj_controller)) return;
    obj_controller.client_wants_sleep = true;
    // If we already sent SLEEP_PROMPT, the client will respond via SLEEP_RESPONSE
    // — don't trigger scr_sleep_and_save_mp() here to avoid double execution.
    if (obj_controller.host_wants_sleep && !obj_controller.sleep_prompt_sent) {
        obj_controller.host_wants_sleep  = false;
        obj_controller.client_wants_sleep = false;
        scr_sleep_and_save_mp();
    } else if (!obj_controller.host_wants_sleep) {
        scr_notify("El invitado quiere dormir");
    }
}

function net_send_sleep_prompt() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.SLEEP_PROMPT);
    net_broadcast(_buf);
}

function net_handle_sleep_prompt() {
    if (global.net_role != NET_ROLE.CLIENT) return;
    if (!instance_exists(obj_controller)) return;
    if (obj_controller.sent_sleep_request) {
        net_send_sleep_response(true);
        scr_notify("Esperando nuevo dia...");
    } else {
        obj_controller.sleep_prompt_open      = true;
        obj_controller.sleep_prompt_selection = 0;
    }
}

function net_send_sleep_response(_accept) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _lp = global.local_player;
    var _shipping_json = "[]";
    if (_accept && instance_exists(_lp)) _shipping_json = json_stringify(_lp.shipping_array);
    var _buf = net_begin(NET_CMD.SLEEP_RESPONSE);
    buffer_write(_buf, buffer_u8,     _accept ? 1 : 0);
    buffer_write(_buf, buffer_string, _shipping_json);
    net_broadcast(_buf);
}

function net_handle_sleep_response(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _accept        = buffer_read(_payload, buffer_u8);
    var _shipping_json = buffer_read(_payload, buffer_string);
    if (!instance_exists(obj_controller)) return;
    obj_controller.host_wants_sleep  = false;
    obj_controller.client_wants_sleep = false;
    obj_controller.sleep_prompt_sent = false;
    if (_accept) {
        // Apply client's shipping array to ghost.
        if (instance_exists(obj_net)) {
            var _ghost = obj_net.remote_player_ghost;
            if (instance_exists(_ghost) && _shipping_json != "" && _shipping_json != "[]") {
                _ghost.shipping_array = json_parse(_shipping_json);
            }
        }
        scr_sleep_and_save_mp();
    } else {
        scr_notify("El invitado no quiere dormir");
        net_send_notify_peer("Dormir cancelado");
    }
}

function net_send_shipping_summary(_player_id, _summary) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.SHIPPING_SUMMARY);
    buffer_write(_buf, buffer_u8,     _player_id);
    buffer_write(_buf, buffer_string, json_stringify(_summary));
    net_broadcast(_buf);
}

function net_handle_shipping_summary(_payload) {
    var _pid     = buffer_read(_payload, buffer_u8);
    var _json    = buffer_read(_payload, buffer_string);
    var _summary = json_parse(_json);
    if (!instance_exists(obj_controller)) return;
    obj_controller.shipping_summary_data = _summary;
    if (array_length(_summary.items) > 0) {
        obj_controller.shipping_summary_open = true;
    }
}

function net_send_time_update() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.TIME_UPDATE);
    buffer_write(_buf, buffer_u8,  global.game_minute);
    buffer_write(_buf, buffer_u8,  global.game_hour);
    buffer_write(_buf, buffer_u16, global.day);
    buffer_write(_buf, buffer_u16, global.year);
    buffer_write(_buf, buffer_u8,  global.season_index);
    net_broadcast(_buf);
}

function net_handle_time_update(_payload) {
    var _prev_season    = global.season_index;
    global.game_minute  = buffer_read(_payload, buffer_u8);
    global.game_hour    = buffer_read(_payload, buffer_u8);
    global.day          = buffer_read(_payload, buffer_u16);
    global.year         = buffer_read(_payload, buffer_u16);
    global.season_index = buffer_read(_payload, buffer_u8);
    global.season       = global.season_list[global.season_index];
    if (global.season_index != _prev_season && instance_exists(obj_controller)) {
        with (obj_controller) update_tilesets();
    }
}

function net_send_money_update(_player_id, _money) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.MONEY_UPDATE);
    buffer_write(_buf, buffer_u8,  _player_id);
    buffer_write(_buf, buffer_s32, _money);
    net_broadcast(_buf);
}

function net_handle_money_update(_payload) {
    var _pid   = buffer_read(_payload, buffer_u8);
    var _money = buffer_read(_payload, buffer_s32);
    var _lp = global.local_player;
    if (!instance_exists(_lp) || _lp.player_id != _pid) return;
    _lp.money = _money;
}

// player_id 0 = show to all peers; pass a specific id for directed notifications.
function net_send_notify_peer(_text, _player_id = 0) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.NOTIFY);
    buffer_write(_buf, buffer_u8,     _player_id);
    buffer_write(_buf, buffer_string, _text);
    net_broadcast(_buf);
}

function net_send_new_day() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _data = {
        minute:       global.game_minute,
        hour:         global.game_hour,
        day:          global.day,
        year:         global.year,
        season_index: global.season_index,
        season:       global.season,
        room_states:  global.room_states,
        room_drops:   global.room_drops
    };
    var _json = json_stringify(_data);
    var _buf  = net_begin(NET_CMD.NEW_DAY);
    buffer_write(_buf, buffer_string, _json);
    net_broadcast(_buf);
}

function net_handle_new_day(_payload) {
    var _json = buffer_read(_payload, buffer_string);
    var _data = json_parse(_json);

    global.game_minute  = _data.minute;
    global.game_hour    = _data.hour;
    global.day          = _data.day;
    global.year         = _data.year;
    global.season_index = _data.season_index;
    global.season       = _data.season;
    global.room_states  = _data.room_states;
    global.room_drops   = _data.room_drops;

    if (instance_exists(obj_controller)) {
        with (obj_controller) {
            scr_restore_room_state(room_get_name(room));
            scr_restore_room_drops(room_get_name(room));
            update_tilesets();
            is_fading_in = true;
            fade_alpha   = 1.0;
        }
    }
    scr_notify("Nuevo dia: dia " + string(global.day));
}

// --- Nap (client → host) ---

function net_send_nap() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_NAP);
    net_broadcast(_buf);
}

function net_handle_nap() {
    if (global.net_role != NET_ROLE.HOST) return;

    global.game_hour += 5;

    // Restore energy on ghost
    var _ghost = obj_net.remote_player_ghost;
    if (instance_exists(_ghost)) {
        _ghost.energy = _ghost.max_energy;
        net_send_energy_update(2, _ghost.energy);
    }

    // Sync time and notify
    net_send_time_update();
    net_send_notify_peer("Siesta completada. Energia restaurada.");
}

// --- World events ---

function net_handle_world_event(_payload) {
    var _evt_type  = buffer_read(_payload, buffer_u8);
    var _room_name = buffer_read(_payload, buffer_string);

    switch (_evt_type) {
        case 1: // WEVT_BUILDING_BUILT
            var _building_name = buffer_read(_payload, buffer_string);
            if (_room_name == room_get_name(room)) {
                scr_buy_building(_building_name, true);
            }
            break;
        case 2: // WEVT_ROOM_REFRESH — full room state sync
            var _state_json = buffer_read(_payload, buffer_string);
            var _drops_json = buffer_read(_payload, buffer_string);
            global.room_states[$ _room_name] = json_parse(_state_json);
            global.room_drops[$  _room_name] = json_parse(_drops_json);
            var _mine_key = global.mine_state.active
                ? "mine_" + string(global.mine_state.door_index) + "_floor_" + string(global.mine_state.floor)
                : room_get_name(room);
            if ((_room_name == room_get_name(room) || _room_name == _mine_key) && instance_exists(obj_controller)) {
                with (obj_controller) {
                    scr_restore_room_state(_room_name);
                    scr_restore_room_drops(_room_name);
                }
            }
            break;
        default:
            break;
    }
}

// --- Connection helpers (called from main menu) ---

function net_host_game() {
    if (instance_exists(obj_net)) with (obj_net) instance_destroy();
    var _net = instance_create_layer(0, 0, "Instances", obj_net);

    _net.port          = net_read_port();
    _net.server_socket = network_create_server(NET_SOCKET_TCP, _net.port, 1);
    if (_net.server_socket < 0) {
        instance_destroy(_net);
        return false;
    }
    _net.role          = NET_ROLE.HOST;
    global.net_role    = NET_ROLE.HOST;
    return true;
}

function net_join_game(_ip) {
    if (instance_exists(obj_net)) with (obj_net) instance_destroy();
    var _net = instance_create_layer(0, 0, "Instances", obj_net);

    _net.port          = net_read_port();
    _net.client_socket = network_create_socket(NET_SOCKET_TCP);
    _net.role          = NET_ROLE.CLIENT;
    global.net_role    = NET_ROLE.CLIENT;
    _net.connect_state = "connecting";
    _net.peer_ip       = _ip;
    network_connect_async(_net.client_socket, _ip, _net.port);
    return true;
}

function net_disconnect(_reason) {
    if (!instance_exists(obj_net)) return;
    var _net = obj_net;
    var _sock = (_net.role == NET_ROLE.HOST) ? _net.peer_socket : _net.client_socket;
    if (_sock >= 0) {
        var _buf = net_begin(NET_CMD.DISCONNECT);
        buffer_write(_buf, buffer_string, _reason);
        net_send(_sock, _buf);
    }
    if (_net.server_socket >= 0) network_destroy(_net.server_socket);
    if (_net.client_socket >= 0) network_destroy(_net.client_socket);
    instance_destroy(_net);
    global.net_role = NET_ROLE.NONE;
}

function net_read_port() {
    ini_open("settings.ini");
    var _p = ini_read_real("Network", "Port", 7777);
    ini_close();
    return _p;
}

// --- CMD_USE_ITEM (client → host) ---

function net_send_use_item(_item_key, _quality, _quantity, _selected_slot, _gx, _gy, _dir) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _lp = global.local_player;
    if (!instance_exists(_lp)) return;
    // -1 (empty slot) and any other non-string → empty string for wire protocol
    if (!is_string(_item_key)) _item_key = "";
    var _buf = net_begin(NET_CMD.CMD_USE_ITEM);
    buffer_write(_buf, buffer_s32,    _gx);
    buffer_write(_buf, buffer_s32,    _gy);
    buffer_write(_buf, buffer_f32,    _lp.x);
    buffer_write(_buf, buffer_f32,    _lp.y);
    buffer_write(_buf, buffer_u8,     _dir);
    buffer_write(_buf, buffer_u8,     _selected_slot);
    buffer_write(_buf, buffer_string, _item_key);
    buffer_write(_buf, buffer_u8,     _quality);
    buffer_write(_buf, buffer_u16,    _quantity);
    net_broadcast(_buf);
}

function net_handle_use_item(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;

    var _gx            = buffer_read(_payload, buffer_s32);
    var _gy            = buffer_read(_payload, buffer_s32);
    var _px            = buffer_read(_payload, buffer_f32);
    var _py            = buffer_read(_payload, buffer_f32);
    var _dir           = buffer_read(_payload, buffer_u8);
    var _selected_slot = buffer_read(_payload, buffer_u8);
    var _item_key      = buffer_read(_payload, buffer_string);
    var _quality       = buffer_read(_payload, buffer_u8);
    var _quantity      = buffer_read(_payload, buffer_u16);


    var _ghost = obj_net.remote_player_ghost;
    if (!instance_exists(_ghost)) {
        return;
    }

    // Only process if client is in the same room (cross-room tool use is Phase 7)
    var _obj_rp = asset_get_index("obj_remote_player");
    var _client_room = "";
    with (_obj_rp) {
        if (player_id == 2) { _client_room = room_name; break; }
    }
    if (_client_room == "" || _client_room != room_get_name(room)) {
        return;
    }

    // Position ghost at client's location for correct direction and bbox calculations
    _ghost.x            = _px;
    _ghost.y            = _py;
    _ghost.dir          = _dir;
    _ghost.selected_slot = _selected_slot;

    // Mirror the client's exact slot state onto the ghost before simulation
    // so that inventory decrements (seeds, consumables) produce the right result.
    var _item_data = (_item_key != "") ? { key: _item_key, quantity: _quantity, quality: _quality } : -1;
    _ghost.inventory_array[_selected_slot] = _item_data;

    // Execute action on ghost (full mutation — no _anim_only)
    with (_ghost) {
        scr_use_item(_item_data, _gx, _gy);
    }

    // Bugnet: Step_0 ACTING check never runs on ghost, so resolve catch here.
    if (_item_key == "bugnet") {
        var _nearest = instance_nearest(_ghost.x, _ghost.y, obj_insect);
        if (_nearest != noone && point_distance(_ghost.x, _ghost.y, _nearest.x, _nearest.y) <= 40) {
            var _ikey  = _nearest.insect_key;
            var _idata = global.insect_data[$ _ikey];
            net_ghost_add_item(_ghost, _ikey, 1);
            net_send_notify_peer("¡Atrapaste un " + _idata.name + "!");
            instance_destroy(_nearest);
        } else {
            net_send_notify_peer("¡Fallaste!");
        }
    }

    // Bow: scr_use_item only sets animation for BOW type; create arrow manually.
    // The ghost never runs its Step event so bow_drawing never triggers arrow creation.
    if (variable_struct_exists(global.weapon_data, _item_key)) {
        var _wdata = global.weapon_data[$ _item_key];
        if (_wdata.tool_type == TOOL_TYPE.BOW) {
            var _arr = instance_create_layer(_ghost.x + 16, _ghost.y + 16, "Instances", obj_arrow);
            _arr.damage = _wdata.damage;
        }
    }

    // Return ghost off-screen
    _ghost.x = -2000;
    _ghost.y = -2000;

    // Send authoritative state back to client
    net_send_inventory_update(2, 0, _selected_slot, _ghost.inventory_array[_selected_slot]);
    net_send_energy_update(2, _ghost.energy);

    // Broadcast updated room state so both players see the world change
    scr_capture_current_room_state();
    net_broadcast_room_state(scr_current_room_key());
}

// --- Room state broadcast (host → client) ---

function net_broadcast_room_state(_room_name) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    if (global.net_role != NET_ROLE.HOST) return;

    var _state = undefined;
    if (variable_struct_exists(global.room_states, _room_name)) {
        _state = global.room_states[$ _room_name];
    }
    if (_state == undefined) return;

    var _drops = variable_struct_exists(global.room_drops, _room_name)
                 ? global.room_drops[$ _room_name] : [];

    var _buf = net_begin(NET_CMD.WORLD_EVENT);
    buffer_write(_buf, buffer_u8,     2); // WEVT_ROOM_REFRESH
    buffer_write(_buf, buffer_string, _room_name);
    buffer_write(_buf, buffer_string, json_stringify(_state));
    buffer_write(_buf, buffer_string, json_stringify(_drops));
    net_broadcast(_buf);
}

// --- INVENTORY_UPDATE ---

function net_send_inventory_update(_player_id, _slot_kind, _slot_index, _slot_data) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.INVENTORY_UPDATE);
    buffer_write(_buf, buffer_u8,     _player_id);
    buffer_write(_buf, buffer_u8,     _slot_kind);   // 0=hotbar, 1=backpack
    buffer_write(_buf, buffer_u8,     _slot_index);
    buffer_write(_buf, buffer_string, json_stringify(_slot_data));
    net_broadcast(_buf);
}

function net_handle_inventory_update(_payload) {
    var _pid   = buffer_read(_payload, buffer_u8);
    var _kind  = buffer_read(_payload, buffer_u8);
    var _index = buffer_read(_payload, buffer_u8);
    var _json  = buffer_read(_payload, buffer_string);

    var _slot = (_json == "null" || _json == "-1") ? -1 : json_parse(_json);

    // Update local player if this update targets them.
    var _lp = global.local_player;
    if (instance_exists(_lp) && _lp.player_id == _pid) {
        if (_kind == 0) {
            _lp.inventory_array[_index] = _slot;
        } else if (_kind == 1) {
            _lp.backpack_array[_index] = _slot;
        }
        return;
    }

    // If host, also forward the update to the ghost so ghost inventory stays in sync.
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net)) {
        var _ghost = obj_net.remote_player_ghost;
        if (instance_exists(_ghost) && _ghost.player_id == _pid) {
            if (_kind == 0) {
                _ghost.inventory_array[_index] = _slot;
            } else if (_kind == 1) {
                _ghost.backpack_array[_index] = _slot;
            }
        }
    }
}

// --- ENERGY_UPDATE ---

function net_send_energy_update(_player_id, _new_energy) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.ENERGY_UPDATE);
    buffer_write(_buf, buffer_u8,  _player_id);
    buffer_write(_buf, buffer_s32, _new_energy);
    net_broadcast(_buf);
}

function net_handle_energy_update(_payload) {
    var _pid    = buffer_read(_payload, buffer_u8);
    var _energy = buffer_read(_payload, buffer_s32);

    var _lp = global.local_player;
    if (!instance_exists(_lp) || _lp.player_id != _pid) return;
    _lp.energy = _energy;
}

// --- CMD_DROP (client → host) ---

function net_send_drop(_room_name, _item_key, _quantity, _px, _py, _delay) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_DROP);
    buffer_write(_buf, buffer_string, _room_name);
    buffer_write(_buf, buffer_string, _item_key);
    buffer_write(_buf, buffer_u16,    _quantity);
    buffer_write(_buf, buffer_s32,    _px);
    buffer_write(_buf, buffer_s32,    _py);
    buffer_write(_buf, buffer_u16,    _delay);
    net_broadcast(_buf);
}

function net_handle_drop(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _room_name = buffer_read(_payload, buffer_string);
    var _item_key  = buffer_read(_payload, buffer_string);
    var _quantity  = buffer_read(_payload, buffer_u16);
    var _px        = buffer_read(_payload, buffer_s32);
    var _py        = buffer_read(_payload, buffer_s32);
    var _delay     = buffer_read(_payload, buffer_u16);

    if (_room_name != room_get_name(room)) {
        return;
    }
    // inventory_drop_item will register the drop and broadcast room state
    inventory_drop_item(_item_key, _quantity, _px, _py, _delay);
}

// --- CMD_PICKUP (client → host) ---

function net_send_pickup(_drop_uid, _room_name, _item_key, _quantity) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_PICKUP);
    buffer_write(_buf, buffer_u32,    _drop_uid);
    buffer_write(_buf, buffer_string, _room_name);
    buffer_write(_buf, buffer_string, _item_key);
    buffer_write(_buf, buffer_u16,    _quantity);
    net_broadcast(_buf);
}

function net_handle_pickup(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _drop_uid  = buffer_read(_payload, buffer_u32);
    var _room_name = buffer_read(_payload, buffer_string);
    var _item_key  = buffer_read(_payload, buffer_string);
    var _quantity  = buffer_read(_payload, buffer_u16);

    // Server-side inventory tracking on ghost
    var _ghost = obj_net.remote_player_ghost;
    if (instance_exists(_ghost)) _ghost.add_item(_item_key, _quantity);

    // Remove from canonical room drops
    scr_remove_room_drop(_room_name, _drop_uid);

    // Destroy live drop instance if it is in the current room
    with (obj_item_parent) {
        if (persistent_drop_id == _drop_uid) { instance_destroy(); break; }
    }

    // Broadcast so global.room_drops is identical on both machines
    net_broadcast_room_state(_room_name);
}

// --- Mine navigation (client ↔ host) ---

function net_send_mine_enter(_door_index, _door_x, _door_y) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_MINE_ENTER);
    buffer_write(_buf, buffer_u8, _door_index);
    buffer_write(_buf, buffer_s32, _door_x);
    buffer_write(_buf, buffer_s32, _door_y);
    net_broadcast(_buf);
}

function net_send_mine_go_deeper() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_MINE_GO_DEEPER);
    net_broadcast(_buf);
}

function net_send_mine_exit() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_MINE_EXIT);
    net_broadcast(_buf);
}

function net_send_mine_state_update() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _data = {
        mine_state:               global.mine_state,
        mine_unlocks:             global.mine_unlocks,
        mine_progress:            global.mine_progress,
        mine_floor_room_assigned: global.mine_floor_room_assigned,
        cave_repopulate:          global.cave_repopulate,
        target_room_name:         global.pending_player_room_name,
        target_x:                 global.pending_player_x,
        target_y:                 global.pending_player_y
    };
    var _buf = net_begin(NET_CMD.MINE_STATE_UPDATE);
    buffer_write(_buf, buffer_string, json_stringify(_data));
    net_broadcast(_buf);
}

function net_handle_mine_enter(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _door_index = buffer_read(_payload, buffer_u8);
    var _door_x = buffer_read(_payload, buffer_s32);
    var _door_y = buffer_read(_payload, buffer_s32);

    var _start_floor = max(1, global.mine_progress[_door_index]);

    global.mine_state.active = true;
    global.mine_state.door_index = _door_index;
    global.mine_state.ore_type = _door_index;
    global.mine_state.floor = _start_floor;
    global.mine_state.entry_door_x = _door_x;
    global.mine_state.entry_door_y = _door_y;

    var _floor_key = "mine_" + string(_door_index) + "_floor_" + string(_start_floor);
    var _room_name;
    if (struct_exists(global.room_states, _floor_key) && struct_exists(global.mine_floor_room_assigned, _floor_key)) {
        _room_name = global.mine_floor_room_assigned[$ _floor_key];
    } else {
        _room_name = "cave_" + string(irandom(5) + 1);
        global.mine_floor_room_assigned[$ _floor_key] = _room_name;
        global.cave_repopulate[$ _room_name] = true;
    }

    global.pending_player_room_name = _room_name;
    global.pending_player_x = 64;
    global.pending_player_y = 64;
    global.pending_player_dir = DIR.DOWN;

    net_send_mine_state_update();
}

function net_handle_mine_go_deeper(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;

    global.mine_state.floor++;
    var _di = global.mine_state.door_index;

    if (global.mine_state.floor > global.mine_progress[_di]) {
        global.mine_progress[_di] = global.mine_state.floor;
    }

    if (global.mine_state.floor >= 10) {
        var _next = _di + 1;
        if (_next < 8) {
            global.mine_unlocks[_next] = true;
        }
    }

    var _floor_key = "mine_" + string(_di) + "_floor_" + string(global.mine_state.floor);
    var _room_name;
    if (struct_exists(global.room_states, _floor_key) && struct_exists(global.mine_floor_room_assigned, _floor_key)) {
        _room_name = global.mine_floor_room_assigned[$ _floor_key];
    } else {
        _room_name = "cave_" + string(irandom(5) + 1);
        global.mine_floor_room_assigned[$ _floor_key] = _room_name;
        global.cave_repopulate[$ _room_name] = true;
    }

    global.pending_player_room_name = _room_name;
    global.pending_player_x = 64;
    global.pending_player_y = 64;
    global.pending_player_dir = DIR.DOWN;

    net_send_mine_state_update();
}

function net_handle_mine_exit(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;

    var _di = global.mine_state.door_index;
    if (_di >= 0 && global.mine_state.floor > global.mine_progress[_di]) {
        global.mine_progress[_di] = global.mine_state.floor;
    }

    var _ex = global.mine_state.entry_door_x;
    var _ey = global.mine_state.entry_door_y;
    global.mine_state.active = false;
    global.mine_state.floor = 1;

    global.pending_player_room_name = "cave_entrance";
    global.pending_player_x = _ex;
    global.pending_player_y = _ey + 32;
    global.pending_player_dir = DIR.DOWN;

    net_send_mine_state_update();
}

function net_handle_mine_state_update(_payload) {
    var _data = json_parse(buffer_read(_payload, buffer_string));
    global.mine_state               = _data.mine_state;
    global.mine_unlocks             = _data.mine_unlocks;
    global.mine_progress            = _data.mine_progress;
    global.mine_floor_room_assigned = _data.mine_floor_room_assigned;
    global.cave_repopulate          = _data.cave_repopulate;
    global.pending_player_room_name = _data.target_room_name;
    global.pending_player_x         = _data.target_x;
    global.pending_player_y         = _data.target_y;
    if (instance_exists(global.local_player)) {
        global.pending_player_dir = global.local_player.dir;
    }
    var _target = asset_get_index(_data.target_room_name);
    if (_target >= 0) room_goto(_target);
}

// --- CMD_CHEST_SLOT (either player → peer) ---

function net_send_chest_slot(_cx, _cy, _room_name, _slot_index, _slot_data) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_CHEST_SLOT);
    buffer_write(_buf, buffer_s32,    _cx);
    buffer_write(_buf, buffer_s32,    _cy);
    buffer_write(_buf, buffer_string, _room_name);
    buffer_write(_buf, buffer_u8,     _slot_index);
    buffer_write(_buf, buffer_string, json_stringify(_slot_data));
    net_broadcast(_buf);
}

function net_handle_chest_slot(_payload) {
    var _cx         = buffer_read(_payload, buffer_s32);
    var _cy         = buffer_read(_payload, buffer_s32);
    var _room_name  = buffer_read(_payload, buffer_string);
    var _slot_index = buffer_read(_payload, buffer_u8);
    var _slot_json  = buffer_read(_payload, buffer_string);
    var _slot_data  = (_slot_json == "null" || _slot_json == "-1") ? -1 : json_parse(_slot_json);

    if (_room_name != room_get_name(room)) {
        return;
    }

    with (obj_chest) {
        if (abs(x - _cx) < 4 && abs(y - _cy) < 4) {
            storage_array[_slot_index] = _slot_data;
            break;
        }
    }
}

// --- TOWN_STAGE_UPDATE (host → client) ---

function net_send_town_stage_update() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _data = {
        town_stage:               global.town_stage,
        town_donations:           global.town_donations,
        town_construction_day:    global.town_construction_day,
        town_construction_duration: global.town_construction_duration
    };
    var _buf = net_begin(NET_CMD.TOWN_STAGE_UPDATE);
    buffer_write(_buf, buffer_string, json_stringify(_data));
    net_broadcast(_buf);
}

function net_handle_town_stage_update(_payload) {
    var _data = json_parse(buffer_read(_payload, buffer_string));
    global.town_stage                 = _data.town_stage;
    global.town_donations             = _data.town_donations;
    global.town_construction_day      = _data.town_construction_day;
    global.town_construction_duration = _data.town_construction_duration;
    if (room_get_name(room) == "town") scr_restore_town_stage();
}

// --- CMD_DONATE (client → host) ---

function net_send_donate(_target_key) {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.CMD_DONATE);
    buffer_write(_buf, buffer_string, _target_key);
    net_broadcast(_buf);
}

function net_handle_donate(_payload) {
    if (global.net_role != NET_ROLE.HOST) return;
    var _target_key = buffer_read(_payload, buffer_string);
    if (!instance_exists(obj_net)) return;
    var _ghost = obj_net.remote_player_ghost;
    if (!instance_exists(_ghost)) return;

    // Snapshot inventory before to detect which slots change
    var _inv_before  = array_create(10);
    var _back_before = array_create(64);
    for (var _i = 0; _i < 10;  _i++) _inv_before[_i]  = _ghost.inventory_array[_i];
    for (var _i = 0; _i < 64; _i++) _back_before[_i] = _ghost.backpack_array[_i];

    var _result = scr_donate_specific_target(_target_key, _ghost);
    if (!_result.donated) return;

    for (var _i = 0; _i < 10; _i++) {
        if (_ghost.inventory_array[_i] != _inv_before[_i]) {
            net_send_inventory_update(2, 0, _i, _ghost.inventory_array[_i]);
        }
    }
    for (var _i = 0; _i < 64; _i++) {
        if (_ghost.backpack_array[_i] != _back_before[_i]) {
            net_send_inventory_update(2, 1, _i, _ghost.backpack_array[_i]);
        }
    }

    // Stage advance broadcasts via scr_advance_town_stage; only needed here for partial donations
    if (!_result.completed) net_send_town_stage_update();
}
