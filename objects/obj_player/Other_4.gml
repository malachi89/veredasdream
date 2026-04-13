if (instance_number(obj_player) > 1) {
    if (id != instance_find(obj_player, 0)) {
        instance_destroy();
        exit;
    }
}

show_debug_message("Player spawned in room: " + room_get_name(room) + " at (" + string(x) + ", " + string(y) + ")");
