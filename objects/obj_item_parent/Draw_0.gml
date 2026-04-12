if (is_initialized) {
    var _y_offset = row * 16;
    
    // Dibujamos la parte de 16x16 que corresponde sin offset de flotación
    draw_sprite_part_ext(
        item_sprite, subimg,
        0, _y_offset, 16, 16,
        x - 8, y - 8,
        1, 1, c_white, 1
    );
}