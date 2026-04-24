// Async - Networking event
var _type = async_load[? "type"];
var _sock = async_load[? "id"];

switch (_type) {

    case network_type_connect:
        if (role == NET_ROLE.HOST) {
            peer_socket  = async_load[? "socket"];
            peer_ip      = async_load[? "ip"];
            is_connected = true;
            connect_state = "connected";
            show_debug_message("[NET] Client connected from " + peer_ip);
            net_handle_handshake_incoming(peer_socket);
        } else if (role == NET_ROLE.CLIENT) {
            is_connected  = true;
            connect_state = "connected";
            show_debug_message("[NET] Connected to host");
            net_send_handshake();
        }
        break;

    case network_type_disconnect:
        show_debug_message("[NET] Socket disconnected: " + string(_sock));
        is_connected  = false;
        connect_state = "idle";
        peer_socket   = -1;
        scr_notify("Desconectado de la partida");
        break;

    case network_type_data:
        var _raw_buf  = async_load[? "buffer"];
        var _raw_size = async_load[? "size"];
        net_process_incoming(_raw_buf, _raw_size, _sock);
        break;
}

// Waits for a handshake from the client (host side does not send first).
function net_handle_handshake_incoming(_client_sock) {
    // Nothing to do here; the client will send HANDSHAKE first.
    // We just update state so the debug overlay looks right.
    show_debug_message("[NET] Waiting for HANDSHAKE from client...");
}
