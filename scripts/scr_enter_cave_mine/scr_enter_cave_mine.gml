function scr_enter_cave_mine(_door_index) {
    var _player = global.local_player;
    if (!instance_exists(_player)) exit;

    var _door = instance_nearest(_player.x, _player.y, obj_cave_door_open);
    if (_door == noone) _door = instance_nearest(_player.x, _player.y, obj_cave_door_closed);
    var _door_x = (_door != noone) ? _door.x : 0;
    var _door_y = (_door != noone) ? _door.y : 0;

    if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
        net_send_mine_enter(_door_index, _door_x, _door_y);
        return;
    }

    scr_capture_current_room_state();

    var _start_floor = max(1, global.mine_progress[_door_index]);

    global.mine_state.active = true;
    global.mine_state.door_index = _door_index;
    global.mine_state.ore_type = _door_index;
    global.mine_state.floor = _start_floor;

    if (_door != noone) {
        global.mine_state.entry_door_x = _door.x;
        global.mine_state.entry_door_y = _door.y;
    }

    var _floor_key = "mine_" + string(_door_index) + "_floor_" + string(_start_floor);
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
