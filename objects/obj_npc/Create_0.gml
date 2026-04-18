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

wander_speed = 0.6;
wander_timer = 0;
wander_dx    = 0;
wander_dy    = 0;

cur_skin    = spr_skin_idle;
cur_eyes    = spr_eyes_idle;
cur_clothes = spr_clothes_idle;
cur_hair    = spr_hair_idle;
