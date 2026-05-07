depth = -bbox_bottom;

if (state == 0) {
    var _prev_y = y;
    y -= bus_speed;

    if (!paused_at_y && _prev_y > pause_y && y <= pause_y) {
        y = pause_y;
        state = 1;
        state_timer = pause_frames;
        paused_at_y = true;
    }

    if (y < end_y) {
        y = start_y;
        paused_at_y = false;
    }
} else {
    state_timer -= 1;
    if (state_timer <= 0) state = 0;
}
