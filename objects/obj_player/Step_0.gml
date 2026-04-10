// 1. ENTRADAS (INPUTS)
var _h   = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);
var _mag = point_distance(0, 0, _h, _v);
var _prev_state = state;

// 2. ESTADO Y DIRECCIÓN
if (_mag == 0) {
    state = STATE.IDLE;
} else {
    state = _run ? STATE.RUN : STATE.WALK;
    if (abs(_h) > abs(_v)) dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
    else                   dir = (_v > 0) ? DIR.DOWN  : DIR.UP;
}

// 3. MOVIMIENTO (Basado en tu lógica de colisión)
var _spd = (state == STATE.RUN) ? move_speed_run : move_speed;
var _mx = (_mag != 0) ? (_h / _mag) * _spd : 0;
var _my = (_mag != 0) ? (_v / _mag) * _spd : 0;

move_and_collide(_mx, _my, obj_collision, 4, 0, 0, -1, -1);

// 4. LÓGICA DE HERRAMIENTAS / ITEMS (Al hacer Clic Izquierdo)
// ... (dentro del Step, donde va la lógica de interacción)

if (mouse_check_button_pressed(mb_left)) {
    var _selected_item = obj_inventory.inventory_array[obj_inventory.selected_slot];
    
    // Grid
    var _tile_size = 16;
    var _gx = floor(mouse_x / _tile_size) * _tile_size;
    var _gy = floor(mouse_y / _tile_size) * _tile_size;
    
    // Distancia
    var _dist_max = 32;
    var _p_cx = (bbox_left + bbox_right) / 2;
    var _p_cy = (bbox_top + bbox_bottom) / 2;

    if (point_distance(_p_cx, _p_cy, _gx + 8, _gy + 8) <= _dist_max) {
        // ¡LLAMADA AL SCRIPT!
        scr_use_item(_selected_item, _gx, _gy);
    }
}


// 5. TEST: GENERAR ITEM AL SUELO (Tecla B)
if (keyboard_check_pressed(ord("B"))) {
    var _seeds = ["cherry_seeds", "tomato_seeds", "pumpkin_seeds", "potato_seeds"];
    var _chosen = _seeds[irandom(array_length(_seeds) - 1)];
    var _inst = instance_create_layer(x + 16, y + 16, "Instances", obj_item_seed);
    with(_inst) init_item(_chosen);
}

// 6. ANIMACIÓN
if (state != _prev_state) frame_anim = 0;

var _anim_data = [
    [sprite_player_idle, 0.1,  frames_idle],
    [sprite_player_walk, 0.15, frames_walk],
    [sprite_player_run,  0.25, frames_run]
];

var _current_anim = _anim_data[state];
sprite_index = _current_anim[0];
frame_anim += _current_anim[1];
if (frame_anim >= _current_anim[2]) frame_anim = 0;

image_index = (dir * _current_anim[2]) + floor(frame_anim);
image_speed = 0;