if (!instance_exists(target)) exit;

// posición objetivo (centrada en player)
var target_x = target.x - cam_width / 2;
var target_y = target.y - cam_height / 2;

// posición actual
var current_x = camera_get_view_x(cam);
var current_y = camera_get_view_y(cam);

// suavizado
var new_x = lerp(current_x, target_x, smooth);
var new_y = lerp(current_y, target_y, smooth);

// limitar al room (opcional pero recomendado)
new_x = clamp(new_x, 0, room_width - cam_width);
new_y = clamp(new_y, 0, room_height - cam_height);

// aplicar
camera_set_view_pos(cam, new_x, new_y);

// cuánto se adelanta
var look_ahead = 16;

// dirección del jugador
var offset_x = sign(target.hspeed) * look_ahead;
var offset_y = sign(target.vspeed) * look_ahead;

// aplicar al target
target_x += offset_x;
target_y += offset_y;