var _data = global.npc_data[$ npc_key];

name      = _data.name;
dialog_id = _data.dialog_id;

var _skin    = _data.skin;
var _eye     = _data.eye_type + "_" + _data.eye_color;
var _hair    = _data.hair_style + "_" + _data.hair_color;
var _clothes = _data.clothes_color;

spr_skin_idle    = asset_get_index("sprite_npc_idle_skin_"    + string(_skin));
spr_eyes_idle    = asset_get_index("sprite_npc_idle_eyes_"    + _eye);
spr_clothes_idle = asset_get_index("sprite_npc_idle_clothes_" + _clothes);
spr_hair_idle    = asset_get_index("sprite_npc_idle_hair_"    + _hair);

spr_skin_walk    = asset_get_index("sprite_npc_walk_skin_"    + string(_skin));
spr_eyes_walk    = asset_get_index("sprite_npc_walk_eyes_"    + _eye);
spr_clothes_walk = asset_get_index("sprite_npc_walk_clothes_" + _clothes);
spr_hair_walk    = asset_get_index("sprite_npc_walk_hair_"    + _hair);

dir         = DIR.DOWN;
frame_anim  = 0;
frames_idle = 4;
frames_walk = 6;

wander_speed   = 0.6;
wander_timer   = 0;
wander_dx      = 0;
wander_dy      = 0;
wander_resting = false;

cur_skin    = spr_skin_idle;
cur_eyes    = spr_eyes_idle;
cur_clothes = spr_clothes_idle;
cur_hair    = spr_hair_idle;

var _tm_buildings = -1;
if (layer_exists("Tiles_buildings")) _tm_buildings = layer_tilemap_get_id("Tiles_buildings");
if (_tm_buildings != -1 && tilemap_get_at_pixel(_tm_buildings, x, y) != 0) {
    var _found = false;
    for (var _r = 16; _r <= 128 && !_found; _r += 16) {
        for (var _a = 0; _a < 360 && !_found; _a += 45) {
            var _tx = x + lengthdir_x(_r, _a);
            var _ty = y + lengthdir_y(_r, _a);
            if (tilemap_get_at_pixel(_tm_buildings, _tx, _ty) == 0) {
                x = _tx;
                y = _ty;
                _found = true;
            }
        }
    }
}
