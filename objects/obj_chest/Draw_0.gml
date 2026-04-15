/// @description Dibujar cofre
image_speed = 0;
image_index = is_open ? 8 : 0;
//draw_sprite_ext(sprite_index, image_index, x, y + 4, 1, 1, 0, c_black, 0.3); // Sombra simple
draw_self();
