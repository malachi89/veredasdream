var _frame   = floor(frame_anim);
var _xscale  = (dir == DIR.LEFT) ? -1 : 1;
var _draw_x  = (dir == DIR.LEFT) ? x + sprite_get_width(sprite_index) : x;
var _blend   = (hurt_flash_timer > 0) ? c_red : c_white;
draw_sprite_ext(sprite_index, _frame, _draw_x, y, _xscale, 1, 0, _blend, 1);
