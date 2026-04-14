if (target_room != noone) {
    scr_capture_current_room_state();
    room_goto(target_room);
    other.x = target_x;
    other.y = target_y;
}
