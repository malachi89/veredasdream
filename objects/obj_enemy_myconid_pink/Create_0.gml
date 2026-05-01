enemy_key = "myconid_pink";
event_inherited();
var _d = global.enemy_data[$ enemy_key];
if (_d != undefined) {
    sprite_idle   = _d.sprite_idle;
    sprite_walk   = _d.sprite_walk;
    sprite_attack = _d.sprite_attack;
    sprite_damage = _d.sprite_damage;
    sprite_dead   = _d.sprite_dead;
    sprite_index  = sprite_idle;
    move_speed    = _d.move_speed;
    if (variable_struct_exists(_d, "chase_speed_mult")) chase_speed_mult = _d.chase_speed_mult;
    hp                = _d.hp;
    max_hp            = _d.max_hp;
    chase_timer_max   = _d.chase_timer;
    attack_damage     = _d.attack_damage;
    attack_cooldown_max = _d.attack_cooldown;
    attack_range      = _d.attack_range;
    death_anim_frames = _d.death_anim_frames;
    product_drops     = _d.product_drops;
}
anim_frames = sprite_get_number(sprite_idle) / 4;
hurt_anim_timer = 0;
