if (is_initialized) {
    var _fw      = sprite_get_width(item_sprite);
    var _fh      = sprite_get_height(item_sprite);
    var _s       = 16 / _fw;
    var _y_offset = (row * 16) + row_offset;
    var _x_offset = col_offset;

    draw_sprite_part_ext(
        item_sprite, subimg,
        _x_offset, _y_offset, _fw, _fh,
        x + col_offset, y - 8,
        _s, _s, c_white, 1
    );
}