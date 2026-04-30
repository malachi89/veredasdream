function scr_exit_mine() {
    var _di = global.mine_state.door_index;
    if (_di >= 0 && global.mine_state.floor > global.mine_progress[_di]) {
        global.mine_progress[_di] = global.mine_state.floor;
    }

    scr_capture_current_room_state();

    var _ex = global.mine_state.entry_door_x;
    var _ey = global.mine_state.entry_door_y;
    global.mine_state.active = false;
    global.mine_state.floor = 1;

    global.pending_player_room_name = "cave_entrance";
    global.pending_player_x = _ex;
    global.pending_player_y = _ey + 32;
    global.pending_player_dir = DIR.DOWN;

    room_goto(cave_entrance);
}
