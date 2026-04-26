// Ghost players and non-local players must never trigger transitions.
if (!other.is_local) exit;
if (target_room == noone) exit;

if (global.net_role == NET_ROLE.CLIENT) {
    // Prevent duplicate requests while waiting for ROOM_SNAPSHOT.
    if (instance_exists(obj_controller) && obj_controller.room_change_pending) exit;
    if (instance_exists(obj_controller)) obj_controller.room_change_pending = true;
    net_send_room_change(room_get_name(target_room), target_x, target_y);
} else {
    // Host or single-player: capture state and change room immediately.
    scr_capture_current_room_state();
    var _old_room = room_get_name(room);
    room_goto(target_room);
    other.x = target_x;
    other.y = target_y;
    // Tell client the final state of the room host just left.
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        net_broadcast_room_state(_old_room);
    }
}
