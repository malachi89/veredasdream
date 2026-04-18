function scr_advance_common_trees() {
    // Advance live instances in the current room
    with (obj_common_tree) grow();

    // Advance stored states for rooms not currently loaded
    var _current = room_get_name(room);
    var _rooms = variable_struct_get_names(global.room_states);
    for (var r = 0; r < array_length(_rooms); r++) {
        if (_rooms[r] == _current) continue;
        var _state = global.room_states[$ _rooms[r]];
        if (!variable_struct_exists(_state, "common_trees")) continue;
        for (var i = 0; i < array_length(_state.common_trees); i++) {
            if (_state.common_trees[i].growth_stage < 4) {
                _state.common_trees[i].growth_stage += 1;
            }
        }
        global.room_states[$ _rooms[r]] = _state;
    }
}
