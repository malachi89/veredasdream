draw_sprite(cur_skin,    image_index, x, y);
draw_sprite(cur_eyes,    image_index, x, y);
draw_sprite(cur_clothes, image_index, x, y);
draw_sprite(cur_hair,    image_index, x, y);

if (instance_exists(obj_player) && instance_exists(obj_inventory)
    && !obj_inventory.shop_open && !obj_inventory.dialog_open) {
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    if (_dist < 48) {
        var _has_shop = variable_struct_exists(global.shop_data, npc_key);
        var _hint     = _has_shop ? "[E] Comprar" : "[E] Hablar";
        draw_set_font(fnt_pixel_operator);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);
        draw_text_transformed(x, y - 24, _hint, 0.85, 0.85, 0);
    }
}
