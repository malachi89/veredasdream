/// Draw Event
// Draw shadow (tinted black, offset by x+1, y+0.5)
draw_sprite_ext(sprite_index, image_index, x + 1, y + 0.5, image_xscale, image_yscale, image_angle, c_black, 0.4);

// Draw the object itself
draw_self();

// Draw health bar if damaged
if (hits_remaining < 10) {
    var _bar_w = 20;
    var _bar_h = 2;
    var _px = x + (sprite_width / 2) - (_bar_w / 2);
    var _py = bbox_top - 8;

    draw_set_color(c_black);
    draw_rectangle(_px - 1, _py - 1, _px + _bar_w + 1, _py + _bar_h + 1, false);

    draw_set_color(c_green);
    var _fill_w = (hits_remaining / 10) * _bar_w;
    if (_fill_w > 0) {
        draw_rectangle(_px, _py, _px + _fill_w, _py + _bar_h, false);
    }

    draw_set_color(c_white);
}
