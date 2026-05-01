draw_self();

if (state == 2 && output_key != "") {
    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_yellow, 0.3 + 0.3 * sin(done_signal * 0.1));

    var _item_data = scr_get_item_data(output_key);
    if (_item_data != undefined) {
        var _spr = _item_data.sprite;
        var _sub = variable_struct_exists(_item_data, "subimg") ? _item_data.subimg : 0;
        var _sw = sprite_get_width(_spr);
        var _sh = sprite_get_height(_spr);
        var _scale = min(1, 12 / max(_sw, _sh));
        var _bx = x + sprite_get_width(sprite_index) div 2;
        var _by = y - 14;

        draw_sprite(sprite_ballon, 0, _bx - 8, _by - 8);
        draw_sprite_ext(_spr, _sub, _bx - _sw * _scale / 2, _by - _sh * _scale / 2, _scale, _scale, 0, c_white, 1);
    }
}
