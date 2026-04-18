var _moving = false;

if (wanders) {
    wander_timer--;
    if (wander_timer <= 0) {
        wander_timer = irandom_range(60, 180);
        var _angle = irandom(7) * 45;
        wander_dx = lengthdir_x(1, _angle);
        wander_dy = lengthdir_y(1, _angle);
    }

    var _nx = x + wander_dx * wander_speed;
    var _ny = y + wander_dy * wander_speed;

    var _blocked = place_meeting(_nx, _ny, obj_collision);
    if (!_blocked) {
        var _tm_buildings = layer_tilemap_get_id("Tiles_buildings");
        var _tm_trees     = layer_tilemap_get_id("Tiles_trees");
        if (_tm_buildings != -1 && tilemap_get_at_pixel(_tm_buildings, _nx, _ny) != 0) _blocked = true;
        if (_tm_trees     != -1 && tilemap_get_at_pixel(_tm_trees,     _nx, _ny) != 0) _blocked = true;
    }

    if (!_blocked) {
        x = _nx;
        y = _ny;
        _moving = (wander_dx != 0 || wander_dy != 0);
        if (_moving) {
            if (abs(wander_dx) >= abs(wander_dy))
                dir = (wander_dx > 0) ? DIR.RIGHT : DIR.LEFT;
            else
                dir = (wander_dy > 0) ? DIR.DOWN : DIR.UP;
        }
    } else {
        wander_timer = 0;
        wander_dx    = 0;
        wander_dy    = 0;
    }
}

var _frames = _moving ? frames_walk : frames_idle;
var _spd    = _moving ? 0.15 : 0.1;

frame_anim += _spd;
if (frame_anim >= _frames) frame_anim = 0;

image_index  = (dir * _frames) + floor(frame_anim);
image_speed  = 0;
sprite_index = _moving ? spr_skin_walk : spr_skin_idle;
var _counter_layer = layer_get_id("Tiles_blacksmith");
depth = (_counter_layer != -1) ? layer_get_depth(_counter_layer) + 1 : -bbox_bottom;

cur_skin    = _moving ? spr_skin_walk    : spr_skin_idle;
cur_eyes    = _moving ? spr_eyes_walk    : spr_eyes_idle;
cur_clothes = _moving ? spr_clothes_walk : spr_clothes_idle;
cur_hair    = _moving ? spr_hair_walk    : spr_hair_idle;
