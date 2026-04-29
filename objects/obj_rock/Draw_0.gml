/// Draw Event
// Draw shadow (tinted black, offset by x+1, y+0.5)
draw_sprite_ext(sprite_index, image_index, x + 1, y + 0.5, image_xscale, image_yscale, image_angle, c_black, 0.4);

// Draw the object itself
draw_self();
