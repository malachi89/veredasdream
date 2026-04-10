/// @description Dibujo automático del icono
if (item_sprite != noone) {
    draw_sprite(item_sprite, 0, x, y);
}

// Opcional: Dibujar la cantidad si es más de 1
if (is_stackable && quantity > 1) {
    draw_set_halign(fa_right);
    draw_text(x + 8, y + 8, string(quantity));
}