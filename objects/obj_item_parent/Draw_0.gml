if (is_initialized) {
    var _y_offset = (row * 16) + row_offset;
    var _x_offset = col_offset;
    
    // Dibujamos la parte de 16x16 que corresponde sin offset de flotación
    draw_sprite_part_ext(
        item_sprite, subimg,
        _x_offset, _y_offset, 16, 16, // Takes a 16x16 part
        x + col_offset, y - 8, // Draws it offset from instance x,y
        1, 1, c_white, 1
    );
}