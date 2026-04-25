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

// Begin a new outgoing packet. Returns a buffer with a 3-byte header written.
// Caller writes payload bytes, then calls net_send() to finalise and send.
function net_begin(_cmd) {
    var _buf = buffer_create(256, buffer_grow, 1);
    buffer_write(_buf, buffer_u16, 0);   // placeholder for payload_size
    buffer_write(_buf, buffer_u8, _cmd);
    return _buf;
}

// Finalise size, send, and free the buffer.
function net_send(_socket, _buf) {
    var _payload_size = buffer_tell(_buf) - 3;
    buffer_poke(_buf, 0, buffer_u16, _payload_size);
    network_send_packet(_socket, _buf, buffer_tell(_buf));
    buffer_delete(_buf);
}

// Broadcast to all connected peers (host sends to client; client sends to host).
function net_broadcast(_buf) {
    if (!instance_exists(obj_net)) return;
    var _payload_size = buffer_tell(_buf) - 3;
    buffer_poke(_buf, 0, buffer_u16, _payload_size);
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
    while (_pos + 3 <= _net.recv_fill) {
        var _payload_size = buffer_peek(_net.recv_buf, _pos,     buffer_u16);
        var _total        = 3 + _payload_size;
        if (_pos + _total > _net.recv_fill) break; // incomplete packet — wait

        var _cmd = buffer_peek(_net.recv_buf, _pos + 2, buffer_u8);

        // Slice payload into its own buffer for the handler
        var _payload = buffer_create(_payload_size + 1, buffer_fixed, 1);
        if (_payload_size > 0) {
            buffer_copy(_net.recv_buf, _pos + 3, _payload_size, _payload, 0);
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
        case NET_CMD.WORLD_EVENT:
            net_handle_world_event(_payload);
            break;
        case NET_CMD.SLEEP_REQUEST:
            net_handle_sleep_request();
            break;
        case NET_CMD.NEW_DAY:
            net_handle_new_day(_payload);
            break;
        case NET_CMD.DISCONNECT:
            var _reason = buffer_read(_payload, buffer_string);
            show_debug_message("[NET] Peer DISCONNECT: " + _reason);
            scr_notify("El otro jugador se desconecto");
            if (instance_exists(obj_net)) {
                obj_net.is_connected = false;
                obj_net.peer_socket  = -1;
            }
            break;
        default:
            show_debug_message("[NET] Unhandled cmd 0x" + string_hex(_cmd));
    }
}

// --- Handshake ---

function net_send_handshake() {
    if (!instance_exists(obj_net)) return;
    var _buf = net_begin(NET_CMD.HANDSHAKE);
    buffer_write(_buf, buffer_u16, 1);            // protocol version
    buffer_write(_buf, buffer_string, "jugador"); // client name
    net_send(obj_net.client_socket, _buf);
    show_debug_message("[NET] Sent HANDSHAKE");
}

function net_handle_handshake(_payload, _client_socket) {
    var _version = buffer_read(_payload, buffer_u16);
    var _name    = buffer_read(_payload, buffer_string);
    show_debug_message("[NET] Handshake from " + _name + " (v" + string(_version) + ")");

    // Send ACK with assigned player_id=2
    var _ack = net_begin(NET_CMD.HANDSHAKE_ACK);
    buffer_write(_ack, buffer_u8, 2);  // player_id for client
    buffer_write(_ack, buffer_u16, 1); // protocol version
    net_send(_client_socket, _ack);

    // Send world snapshot
    net_send_full_snapshot(_client_socket);
}

function net_handle_handshake_ack(_payload) {
    var _pid     = buffer_read(_payload, buffer_u8);
    var _version = buffer_read(_payload, buffer_u16);
    show_debug_message("[NET] HANDSHAKE_ACK: player_id=" + string(_pid) + " v=" + string(_version));
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
            energy:    500
        },
        room_states:    global.room_states,
        room_drops:     global.room_drops,
        next_drop_uid:  global.next_drop_uid,
        farm_populated: global.farm_populated
    };

    var _json = json_stringify(_snap);
    var _buf  = net_begin(NET_CMD.FULL_SNAPSHOT);
    buffer_write(_buf, buffer_string, _json);
    net_send(_client_socket, _buf);
    show_debug_message("[NET] Sent FULL_SNAPSHOT (" + string(string_length(_json)) + " chars)");
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
    global.farm_populated = _snap.farm_populated;

    // Destroy any existing players, spawn player2 as local player
    with (obj_player) instance_destroy();

    var _p = instance_create_layer(0, 0, "Instances", obj_player);
    _p.player_id = 2;
    _p.is_local  = true;
    _p.is_host   = false;
    _p.money     = _snap.player2.money;
    _p.energy    = _snap.player2.energy;
    _p.add_item("watering_can", 1);
    _p.add_item("hoe", 1);
    _p.add_item("tomato_seeds", 5);
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
    show_debug_message("[NET] Applied FULL_SNAPSHOT, room=" + _snap.player2.room_name);
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
        _rp.room_name = _room_name;
    } else {
        if (_rp != noone) instance_destroy(_rp);
    }
}

// --- Sleep ---

function net_send_sleep_request() {
    if (!instance_exists(obj_net) || !obj_net.is_connected) return;
    var _buf = net_begin(NET_CMD.SLEEP_REQUEST);
    net_broadcast(_buf);
    show_debug_message("[NET] Sent SLEEP_REQUEST");
}

function net_handle_sleep_request() {
    // Client is ready to sleep. Day only advances when the HOST sleeps.
    show_debug_message("[NET] Client sent SLEEP_REQUEST");
    scr_notify("El otro jugador quiere dormir");
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
    show_debug_message("[NET] Sent NEW_DAY (day=" + string(global.day) + ")");
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
    show_debug_message("[NET] Applied NEW_DAY (day=" + string(global.day) + ")");
}

// --- World events ---

function net_handle_world_event(_payload) {
    var _evt_type  = buffer_read(_payload, buffer_u8);
    var _room_name = buffer_read(_payload, buffer_string);

    switch (_evt_type) {
        case 1: // WEVT_BUILDING_BUILT
            var _building_name = buffer_read(_payload, buffer_string);
            show_debug_message("[NET] WORLD_EVENT building_built=" + _building_name + " room=" + _room_name);
            if (_room_name == room_get_name(room)) {
                scr_buy_building(_building_name);
            }
            break;
        default:
            show_debug_message("[NET] Unknown WORLD_EVENT type: " + string(_evt_type));
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
        show_debug_message("[NET] Failed to create server");
        instance_destroy(_net);
        return false;
    }
    _net.role          = NET_ROLE.HOST;
    global.net_role    = NET_ROLE.HOST;
    show_debug_message("[NET] Hosting on port " + string(_net.port));
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
    show_debug_message("[NET] Connecting to " + _ip + ":" + string(_net.port));
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
