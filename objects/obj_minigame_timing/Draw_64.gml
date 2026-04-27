var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _scale = 3;
var _base_width = 128;
var _scaled_width = _base_width * _scale;

var _bx = _gui_w / 2 - (_scaled_width / 2); 
var _by = _gui_h - (40 * _scale); // Positioned at the bottom

// Draw Bar (scaled 300%)
draw_sprite_ext(sprite_time_bar, 0, _bx, _by, _scale, _scale, 0, c_white, 1);

// Draw Hitbox (scaled 300%)
// Internal 0-100 mapped to 2-125 (drawable area of bar), then scaled
var _hitbox_x = _bx + (2 * _scale) + (hitbox_pos / 100) * (123 * _scale);
draw_sprite_ext(sprite_time_bar_hitbox, 0, _hitbox_x, _by + (3 * _scale), _scale, _scale, 0, c_white, 1);

// Draw Indicator (scaled 300%)
var _indicator_x = _bx + (2 * _scale) + (indicator_pos / 100) * (123 * _scale) - (8 * _scale); 
draw_sprite_ext(sprite_time_bar_indicator, 0, _indicator_x, _by, _scale, _scale, 0, c_white, 1);

// Result feedback
if (result != 0) {
    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_center);
    var _text_y = _by - (20 * _scale);
    if (result == 1) {
        draw_set_color(c_lime);
        draw_text_transformed(_gui_w / 2, _text_y, "¡EXITO!", 2, 2, 0);
    } else if (result == -1) {
        draw_set_color(c_red);
        draw_text_transformed(_gui_w / 2, _text_y, "¡FALLO!", 2, 2, 0);
    }
    draw_set_color(c_white);
    draw_set_halign(fa_left);
}
