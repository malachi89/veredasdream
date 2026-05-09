depth = -bbox_bottom;
if (hurt_flash_timer > 0) hurt_flash_timer -= 1;

// Detectar daño recibido externamente (flechas / espada)
var _just_hurt = (hp < vb_prev_hp && is_dying == 0);
if (_just_hurt) {
    scr_play_sound_clip(sound_venom_bloom, 0.3, 1.0);
    if (vb_state == 0) {
        vb_state    = 1;
        frame_anim  = 0;
        anim_frames = sprite_get_number(sprite_venom_bloom_wake_up);
        audio_play_sound(sound_venom_bloom, 1, false);
    }
}
vb_prev_hp = hp;

// Muerte: countdown y drops
if (is_dying > 0) {
    is_dying  -= 1;
    frame_anim = min(frame_anim + 0.1, sprite_get_number(sprite_venom_bloom_dead) - 0.01);
    if (is_dying <= 0) {
        if (array_length(product_drops) > 0) {
            inventory_drop_item(product_drops[irandom(array_length(product_drops) - 1)], 1, x, y);
        }
        var _dd = global.enemy_data[$ enemy_key];
        if (_dd != undefined && variable_struct_exists(_dd, "dye_drops")
                && array_length(_dd.dye_drops) > 0 && irandom(2) == 0) {
            inventory_drop_item(_dd.dye_drops[irandom(array_length(_dd.dye_drops) - 1)], 1, x, y, 30);
        }
        global.collected_items[$ enemy_key] = true;
        instance_destroy();
    }
    exit;
}

if (hp <= 0) {
    is_dying     = death_anim_frames;
    sprite_index = sprite_venom_bloom_dead;
    frame_anim   = 0;
    anim_frames  = sprite_get_number(sprite_venom_bloom_dead);
    audio_play_sound(sound_venom_bloom, 1, false);
    exit;
}

if (!instance_exists(obj_player)) exit;
var _dist = point_distance(x, y, obj_player.x, obj_player.y);

switch (vb_state) {
    case 0: // DORMANT — frozen en frame 0, parece forageable
        if (_dist < vb_dormant_range) {
            vb_state    = 1;
            frame_anim  = 0;
            anim_frames = sprite_get_number(sprite_venom_bloom_wake_up);
            audio_play_sound(sound_venom_bloom, 1, false);
        }
    break;

    case 1: // WAKING — reproduce wake_up una vez completa
        sprite_index = sprite_venom_bloom_wake_up;
        frame_anim  += 0.1;
        if (frame_anim >= sprite_get_number(sprite_venom_bloom_wake_up)) {
            frame_anim = 0;
            if (_dist < vb_attack_range_on) {
                vb_state     = 3;
                sprite_index = sprite_venom_bloom_attack;
                anim_frames  = sprite_get_number(sprite_venom_bloom_attack);
            } else {
                vb_state     = 2;
                sprite_index = sprite_venom_bloom_idle;
                anim_frames  = sprite_get_number(sprite_venom_bloom_idle);
            }
        }
    break;

    case 2: // IDLE — espera; ataca si el jugador se acerca
        frame_anim += 0.1;
        if (frame_anim >= sprite_get_number(sprite_venom_bloom_idle)) frame_anim -= sprite_get_number(sprite_venom_bloom_idle);
        if (_dist < vb_attack_range_on) {
            vb_state     = 3;
            sprite_index = sprite_venom_bloom_attack;
            anim_frames  = sprite_get_number(sprite_venom_bloom_attack);
            frame_anim   = 0;
        }
        if (irandom(299) == 0) scr_play_sound_clip(sound_venom_bloom, 0.9, 1.56);
    break;

    case 3: // ATTACKING — daña al jugador si está en rango
        frame_anim += 0.12;
        if (frame_anim >= sprite_get_number(sprite_venom_bloom_attack)) frame_anim -= sprite_get_number(sprite_venom_bloom_attack);
        if (_dist > vb_attack_range_off) {
            vb_state     = 2;
            sprite_index = sprite_venom_bloom_idle;
            anim_frames  = sprite_get_number(sprite_venom_bloom_idle);
            frame_anim   = 0;
        } else {
            if (attack_cooldown > 0) attack_cooldown--;
            if (attack_cooldown <= 0 && _dist < attack_range && obj_player.hp > 0) {
                obj_player.hp -= attack_damage;
                obj_player.hurt_timer = 60;
                audio_play_sound(sound_hurt, 1, false);
                scr_play_sound_clip(sound_venom_bloom, 0.0, 0.8);
                attack_cooldown = attack_cooldown_max;
            }
        }
    break;
}
