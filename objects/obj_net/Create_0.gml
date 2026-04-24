// Singleton network manager — persists through room transitions.
if (instance_number(obj_net) > 1) {
    instance_destroy();
    exit;
}

role          = NET_ROLE.NONE;
server_socket = -1;
client_socket = -1;
peer_socket   = -1;
peer_ip       = "";
is_connected  = false;
connect_state = "idle";   // "idle" | "connecting" | "connected" | "failed"
local_player_id = 1;

port = net_read_port();

// Receive accumulation buffer (TCP data can arrive fragmented)
recv_buf  = buffer_create(65536, buffer_grow, 1);
recv_fill = 0;
