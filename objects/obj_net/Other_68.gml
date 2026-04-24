// Async - Networking event (eventNum 68)
// Literal macro values — avoids constant-scope resolution issues.
// network_type_connect=1             fires on HOST when a client connects
// network_type_disconnect=2
// network_type_data=3
// network_type_non_blocking_connect=4  fires on CLIENT when async connect completes
#macro NET_EV_CONNECT         1
#macro NET_EV_DISCONNECT      2
#macro NET_EV_DATA            3
#macro NET_EV_CONNECT_ASYNC   4

var _type = async_load[? "type"];
var _sock = async_load[? "id"];

show_debug_message("[NET] Async event: type=" + string(_type) + " sock=" + string(_sock));

switch (_type) {

    case NET_EV_CONNECT:
        // Server side: incoming client connection
        peer_socket   = async_load[? "socket"];
        peer_ip       = async_load[? "ip"];
        is_connected  = true;
        connect_state = "connected";
        show_debug_message("[NET] Client connected from " + peer_ip);
        // Client sends HANDSHAKE first; host just waits.
        break;

    case NET_EV_CONNECT_ASYNC:
        // Client side: async connect to host completed
        is_connected  = true;
        connect_state = "connected";
        show_debug_message("[NET] Connected to host");
        net_send_handshake();
        break;

    case NET_EV_DISCONNECT:
        show_debug_message("[NET] Socket disconnected: " + string(_sock));
        is_connected  = false;
        connect_state = "idle";
        peer_socket   = -1;
        scr_notify("Desconectado de la partida");
        break;

    case NET_EV_DATA:
        var _raw_buf  = async_load[? "buffer"];
        var _raw_size = async_load[? "size"];
        net_process_incoming(_raw_buf, _raw_size, _sock);
        break;

    default:
        show_debug_message("[NET] Unknown async type: " + string(_type));
        break;
}
