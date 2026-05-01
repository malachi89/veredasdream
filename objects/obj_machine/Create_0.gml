var _md = global.machine_data[$ machine_type];
if (_md == undefined) {
    show_debug_message("Unknown machine type: " + machine_type);
    instance_destroy();
}
if (_md == undefined) {
    show_debug_message("Unknown machine type: " + machine_type);
    instance_destroy();
}

sprite_index = _md.sprite;
anim_frames = _md.anim_frames;
process_time = _md.process_time;
preserve_color = _md.preserve_color;
passive = variable_struct_exists(_md, "passive") ? _md.passive : false;

state = 0;
timer = 0;
passive_timer = passive ? 300 : 0;
input_key = "";
output_key = "";
output_qty = 0;
output_weight = 0;
done_signal = 0;
image_speed = 0;
image_index = 0;
depth = -bbox_bottom;
