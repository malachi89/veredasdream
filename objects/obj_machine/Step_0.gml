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
        var _recipe = scr_match_machine_recipe(machine_type, input_key);
        if (is_struct(_recipe) && variable_struct_exists(_recipe, "weight_min")) {
            output_weight = round(random_range(_recipe.weight_min, _recipe.weight_max) * 100) / 100;
        }
    } else {
        var _frame = 1 + ((process_time - timer) div 6) mod anim_frames;
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

depth = -bbox_bottom;
