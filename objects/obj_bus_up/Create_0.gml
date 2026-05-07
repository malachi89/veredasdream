image_speed = 0;
depth = -bbox_bottom;

bus_speed         = 50 / room_speed;
start_y           = 1000;
end_y             = -100;
pause_y           = 250;
pause_frames      = 180;
loop_pause_frames = 3900; // ~65 seg esperando → ciclo total ~90 seg (1.5 min)
state             = 0;
state_timer       = 0;
paused_at_y       = false;

x = 720;
y = start_y;
