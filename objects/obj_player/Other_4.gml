// Room Start: destroy room-layout duplicates.
// When a persistent player (spawned by code) already has the same player_id,
// the new room-layout instance is the duplicate — destroy it.
// Having different player_ids is allowed (for multiplayer).

// CLIENT: room-layout instances are never needed; host is shown via obj_remote_player.
if (global.net_role == NET_ROLE.CLIENT && !is_local) {
    instance_destroy();
    exit;
}

var _is_duplicate = false;
with (obj_player) {
    if (id != other.id && player_id == other.player_id) {
        _is_duplicate = true;
        break;
    }
}
if (_is_duplicate && !is_local) {
    instance_destroy();
    exit;
}

show_debug_message("Jugador " + string(player_id) + " en sala: " + room_get_name(room) + " en (" + string(x) + ", " + string(y) + ")");
