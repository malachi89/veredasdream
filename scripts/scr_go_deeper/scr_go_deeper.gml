function scr_go_deeper() {
    if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
        net_send_mine_go_deeper();
        return;
    }

    scr_capture_current_room_state();

    global.mine_state.floor++;
    var _di = global.mine_state.door_index;

    if (global.mine_state.floor > global.mine_progress[_di]) {
        global.mine_progress[_di] = global.mine_state.floor;
    }

    if (global.mine_state.floor >= 10) {
        var _next = _di + 1;
        if (_next < 8) {
            global.mine_unlocks[_next] = true;
            scr_notify("Has llegado al fondo de esta mina. La siguiente puerta esta abierta.");
        } else {
            scr_notify("Has llegado al fondo de la ultima mina.");
        }
    }

    var _floor_key = "mine_" + string(_di) + "_floor_" + string(global.mine_state.floor);
    var _room_name;
    if (struct_exists(global.room_states, _floor_key) && struct_exists(global.mine_floor_room_assigned, _floor_key)) {
        _room_name = global.mine_floor_room_assigned[$ _floor_key];
    } else {
        _room_name = "cave_" + string(irandom(5) + 1);
        global.mine_floor_room_assigned[$ _floor_key] = _room_name;
        global.cave_repopulate[$ _room_name] = true;
    }

    global.pending_player_room_name = _room_name;
    global.pending_player_x = 64;
    global.pending_player_y = 64;
    global.pending_player_dir = DIR.DOWN;

    room_goto(asset_get_index(_room_name));
}
