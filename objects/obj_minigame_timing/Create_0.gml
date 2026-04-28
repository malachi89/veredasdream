// Difficulty: 0: Easy, 1: Moderate, 2: Hard, 3: Extreme
if (!variable_instance_exists(id, "difficulty")) difficulty = 0;

var _speeds = [2.5, 5.0, 16.0, 24.0];
var _ranges = [4.0, 2.5, 1.2, 0.7]; // Much narrower hitboxes for precision

indicator_pos = 0; // 0 to 100
indicator_speed = _speeds[difficulty];
indicator_dir = 1;

// The bar's drawable area is roughly from x=2 to x=125 in sprite_time_bar (width 123)
hitbox_pos = irandom_range(20, 80); 
hitbox_range = _ranges[difficulty]; 

result = 0; // 0: playing, 1: success, -1: failure
timer_after = 0; // Wait a few frames after result before destroying

