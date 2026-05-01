if (state == 0 && passive) {
    passive_timer--;
    if (passive_timer <= 0) {
        state = 1;
        timer = process_time;
        var _md = global.machine_data[$ machine_type];
        output_key = _md.output;
        output_qty = _md.output_qty;
    }
}

if (state == 1) {
    timer--;
    if (timer <= 0) {
        state = 2;
        image_speed = 0;
        image_index = anim_frames;
        done_signal = 60;
    } else {
        var _frame = 1 + (timer div 6) mod anim_frames;
        image_index = _frame;
    }
}

if (state == 2) {
    done_signal--;
    if (done_signal <= 0) done_signal = 60;
    if (done_signal > 30) {
        image_index = anim_frames;
    } else {
        image_index = anim_frames - 1;
    }
}

var _lp = global.local_player;
if (instance_exists(_lp) && state == 0 && mouse_check_button_pressed(mb_right)) {
    var _dist = point_distance(x, y, _lp.x, _lp.y);
    if (_dist < 48) {
        var _item_key = "machine_" + machine_type;
        if (_lp.add_item(_item_key, 1)) {
            scr_notify("Maquina recogida");
            instance_destroy();
        } else {
            scr_notify("Inventario lleno");
        }
    }
}

depth = -bbox_bottom;
