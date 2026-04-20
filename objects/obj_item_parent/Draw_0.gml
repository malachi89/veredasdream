if (is_initialized) {
    var _fw       = sprite_get_width(item_sprite);
    var _fh       = sprite_get_height(item_sprite);
    var _s        = 16 / _fw;
    var _y_offset = (row * 16) + row_offset;
    var _x_offset = col_offset;
    var _dx       = x + col_offset;
    var _dy       = y - 8;

    if (string_starts_with(item_key, "forage_")) {
        var _pulse      = (sin(current_time * 0.004 + (x + y) * 0.05) + 1) * 0.5;
        var _glow_alpha = lerp(0.25, 0.55, _pulse);
        var _glow_s     = _s * lerp(1.4, 1.8, _pulse);
        var _glow_off   = (16 * _glow_s / _s - 16) * 0.5;
        draw_sprite_part_ext(
            item_sprite, subimg,
            _x_offset, _y_offset, _fw, _fh,
            _dx - _glow_off, _dy - _glow_off,
            _glow_s, _glow_s, c_yellow, _glow_alpha
        );
    }

    draw_sprite_part_ext(
        item_sprite, subimg,
        _x_offset, _y_offset, _fw, _fh,
        _dx, _dy,
        _s, _s, c_white, 1
    );
}