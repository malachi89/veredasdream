if (is_initialized) {
    var _fw       = sprite_get_width(item_sprite);
    var _fh       = sprite_get_height(item_sprite);
    var _s        = 16 / _fw;
    var _y_offset = (row * 16) + row_offset;
    var _x_offset = col_offset;
    var _dx       = x + col_offset;
    var _dy       = y - 8;

    draw_sprite_part_ext(
        item_sprite, subimg,
        _x_offset, _y_offset, _fw, _fh,
        _dx + 1, _dy + 0.5,
        _s, _s, c_black, 0.4
    );

    if (string_starts_with(item_key, "forage_")) {
        var _pulse      = (sin(current_time * 0.004 + (x + y) * 0.05) + 1) * 0.5;
        var _out_alpha  = lerp(0.2, 0.5, _pulse);
        var _out_s      = _s * lerp(1.08, 1.14, _pulse);
        var _out_off    = (16 * _out_s / _s - 16) * 0.5;
        draw_sprite_part_ext(
            item_sprite, subimg,
            _x_offset, _y_offset, _fw, _fh,
            _dx - _out_off, _dy - _out_off,
            _out_s, _out_s, c_white, _out_alpha
        );
    }

    draw_sprite_part_ext(
        item_sprite, subimg,
        _x_offset, _y_offset, _fw, _fh,
        _dx, _dy,
        _s, _s, c_white, 1
    );
}