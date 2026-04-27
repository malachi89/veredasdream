// Difficulty: 0: Easy, 1: Moderate, 2: Hard, 3: Extreme
if (!variable_instance_exists(id, "difficulty")) difficulty = 0;

var _speeds = [1.2, 2.0, 3.0, 4.5];
var _ranges = [8, 5, 3, 1.5]; // Narrower hitbox for harder levels

indicator_pos = 0; // 0 to 100
indicator_speed = _speeds[difficulty];
direction = 1;

// The bar's drawable area is roughly from x=2 to x=125 in sprite_time_bar (width 123)
hitbox_pos = irandom_range(20, 80); 
hitbox_range = _ranges[difficulty]; 

result = 0; // 0: playing, 1: success, -1: failure
timer_after = 0; // Wait a few frames after result before destroying

bounces = 0;
max_bounces = (difficulty == 3) ? 2 : 6; // Extreme gives less time (1 full cycle)
