// 1. ENTRADAS (INPUTS)
var _h   = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);
var _mag = point_distance(0, 0, _h, _v);
var _prev_state = state;

// 2. LÓGICA DE INTERACCIÓN (Clic Izquierdo)
if (mouse_check_button_pressed(mb_left) && state != STATE.ACTING) {
    var _selected_item = obj_inventory.inventory_array[obj_inventory.selected_slot];
    
    var _tile_size = 16;
    var _gx = floor(mouse_x / _tile_size) * _tile_size;
    var _gy = floor(mouse_y / _tile_size) * _tile_size;
    var _dist_max = 32;
    var _p_cx = (bbox_left + bbox_right) / 2;
    var _p_cy = (bbox_top + bbox_bottom) / 2;

    // Calculamos la distancia actual una sola vez para que sea más limpio
    var _actual_dist = point_distance(_p_cx, _p_cy, _gx + 8, _gy + 8);

    // --- LA CONDICIÓN MÁGICA ---
    // Si está cerca O es el arco, ejecutamos la acción
    if (_actual_dist <= _dist_max || _selected_item == "bow") {
        
            
    if (instance_exists(obj_inventory)) {
        if (obj_inventory.show_backpack) exit; 
    }

    scr_use_item(_selected_item, _gx, _gy);
        
    }
}

// 3. ESTADO Y MOVIMIENTO (Bloqueado si está actuando)
var _mx = 0;
var _my = 0;

if (state != STATE.ACTING) {
    if (_mag == 0) {
        state = STATE.IDLE;
    } else {
        state = _run ? STATE.RUN : STATE.WALK;
        if (abs(_h) > abs(_v)) dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
        else                   dir = (_v > 0) ? DIR.DOWN  : DIR.UP;
    }

    var _spd = (state == STATE.RUN) ? move_speed_run : move_speed;
    _mx = (_mag != 0) ? (_h / _mag) * _spd : 0;
    _my = (_mag != 0) ? (_v / _mag) * _spd : 0;
}

move_and_collide(_mx, _my, obj_collision, 4, 0, 0, -1, -1);

// 4. LÓGICA DE ANIMACIÓN
if (state != _prev_state) frame_anim = 0;

if (state == STATE.ACTING) {
    var _spd_act = 0.2; 
    frame_anim += _spd_act;
    
    if (frame_anim >= frames_action) {
        state = STATE.IDLE;
        frame_anim = 0;
    }
    image_index = (dir * frames_action) + floor(frame_anim);
} else {
    var _anim_data = [
        [sprite_player_idle, 0.1,  frames_idle],
        [sprite_player_walk, 0.15, frames_walk],
        [sprite_player_run,  0.25, frames_run]
    ];

    var _current = _anim_data[state];
    sprite_index = _current[0];
    frame_anim += _current[1];
    
    if (frame_anim >= _current[2]) frame_anim = 0;
    image_index = (dir * _current[2]) + floor(frame_anim);
}

image_speed = 0;