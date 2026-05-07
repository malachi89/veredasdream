image_speed = 0;
depth = -bbox_bottom;

bus_speed     = 50 / room_speed; // ~50 px/seg
start_y       = -100;
end_y         = 1000;
pause_y       = 740;
pause_frames  = 180; // 3 segundos a 60fps
state         = 0;   // 0=moviendo, 1=pausado
state_timer   = 0;
paused_at_y   = false;

x = 700;
y = start_y;
