draw_self();
if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 60) {
    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text_transformed(x, y - sprite_height / 2 - 4, "[E] Leer", 1.2, 1.2, 0);
}
