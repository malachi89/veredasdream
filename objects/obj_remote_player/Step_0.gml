// Interpolate toward the last received position for smooth movement.
x = lerp(x, target_x, 0.3);
y = lerp(y, target_y, 0.3);
depth = -floor(y);
