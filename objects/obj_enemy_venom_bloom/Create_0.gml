enemy_key = "venom_bloom";
event_inherited();
var _d = global.enemy_data[$ enemy_key];
if (_d != undefined) {
    hp                  = _d.hp;
    max_hp              = _d.max_hp;
    attack_damage       = _d.attack_damage;
    attack_cooldown_max = _d.attack_cooldown;
    attack_range        = _d.attack_range;
    death_anim_frames   = _d.death_anim_frames;
    product_drops       = _d.product_drops;
}
move_speed = 0;

vb_state            = 0; // 0=dormant 1=waking 2=idle 3=attacking
vb_dormant_range    = 100;
vb_attack_range_on  = 250;
vb_attack_range_off = 350;
vb_prev_hp          = hp;

projectile_speed = 6;

sprite_index = sprite_venom_bloom_wake_up;
frame_anim   = 0;
anim_frames  = 1;
