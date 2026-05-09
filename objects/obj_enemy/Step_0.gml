depth = -bbox_bottom;

// Escape si está dentro de una colisión (e.g. spawneado encima de un árbol)
if (place_meeting(x, y, obj_collision)) {
    var _push_steps = [4, 8, 16, 32];
    var _push_angles = [0, 90, 180, 270, 45, 135, 225, 315];
    var _escaped = false;
    for (var _si = 0; _si < array_length(_push_steps) && !_escaped; _si++) {
        for (var _ai = 0; _ai < array_length(_push_angles) && !_escaped; _ai++) {
            var _ex = x + lengthdir_x(_push_steps[_si], _push_angles[_ai]);
            var _ey = y + lengthdir_y(_push_steps[_si], _push_angles[_ai]);
            if (!place_meeting(_ex, _ey, obj_collision)) {
                x = _ex;
                y = _ey;
                _escaped = true;
            }
        }
    }
}

frame_anim += 0.15;
while (frame_anim >= anim_frames) frame_anim -= anim_frames;
while (frame_anim < 0) frame_anim += anim_frames;

if (hurt_flash_timer > 0) hurt_flash_timer -= 1;

if (is_dying > 0) {
    is_dying -= 1;
    if (is_dying <= 0) {
        if (array_length(product_drops) > 0) {
            inventory_drop_item(product_drops[irandom(array_length(product_drops) - 1)], 1, x, y);
        }
        var _d_data = global.enemy_data[$ enemy_key];
        if (_d_data != undefined && variable_struct_exists(_d_data, "dye_drops") && array_length(_d_data.dye_drops) > 0 && irandom(2) == 0) {
            var _dd = _d_data.dye_drops;
            inventory_drop_item(_dd[irandom(array_length(_dd) - 1)], 1, x, y, 30);
        }
        if (_d_data != undefined && variable_struct_exists(_d_data, "weapon_drop_chance") && random(1) < _d_data.weapon_drop_chance) {
            var _w_type  = choose("sword", "bow");
            var _w_level = ceil(10 * power(random(1), 2));
            inventory_drop_item(_w_type + "_" + string(_w_level), 1, x, y, 30);
        }
        global.collected_items[$ enemy_key] = true;
        instance_destroy();
    }
    exit;
}

if (hp <= 0) {
    if (snd_death != undefined) audio_play_sound(snd_death, 1, false);
    is_dying = death_anim_frames;
    exit;
}

switch (state) {
    case ANIMAL_STATE.IDLE:
        // Proactive aggro
        if (is_aggressive && instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < aggro_range) {
            state = ANIMAL_STATE.CHASING;
            chase_timer = chase_timer_max;
            break;
        }
        idle_timer -= 1;
        if (idle_timer <= 0) {
            state            = ANIMAL_STATE.WANDERING;
            dir              = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
            wander_steps     = max_wander_steps;
        }
        if (snd_idle != undefined && instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 400 && irandom(299) == 0) audio_play_sound(snd_idle, 1, false);
    break;

    case ANIMAL_STATE.WANDERING:
        if (is_aggressive && instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < aggro_range) {
            state = ANIMAL_STATE.CHASING;
            chase_timer = chase_timer_max;
            break;
        }
        var _dx = 0;
        var _dy = 0;
        if (dir == DIR.LEFT) _dx = -move_speed;
        else if (dir == DIR.RIGHT) _dx = move_speed;
        else if (dir == DIR.UP) _dy = -move_speed;
        else if (dir == DIR.DOWN) _dy = move_speed;

        if (!place_meeting(x + _dx, y + _dy, obj_collision)) {
            x += _dx;
            y += _dy;
        } else {
            dir = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
        }
        wander_steps -= 1;
        if (wander_steps <= 0) {
            state            = ANIMAL_STATE.IDLE;
            idle_timer       = irandom_range(60, 240);
            max_wander_steps = irandom_range(30, 120);
        }
        if (snd_idle != undefined && instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 400 && irandom(299) == 0) audio_play_sound(snd_idle, 1, false);
    break;

    case ANIMAL_STATE.CHASING:
        if (!instance_exists(obj_player)) {
            state       = ANIMAL_STATE.IDLE;
            chase_timer = 0;
            break;
        }

        var _pdir = point_direction(x, y, obj_player.x, obj_player.y);
        var _dist = point_distance(x, y, obj_player.x, obj_player.y);

        if (_pdir >= 45 && _pdir < 135) dir = DIR.UP;
        else if (_pdir >= 135 && _pdir < 225) dir = DIR.LEFT;
        else if (_pdir >= 225 && _pdir < 315) dir = DIR.DOWN;
        else dir = DIR.RIGHT;

        if (_dist > 28) {
            var _cspeed = move_speed * chase_speed_mult;
            var _cdx = lengthdir_x(_cspeed, _pdir);
            var _cdy = lengthdir_y(_cspeed, _pdir);

            if (!place_meeting(x + _cdx, y + _cdy, obj_collision)) {
                x += _cdx;
                y += _cdy;
            } else {
                if (!place_meeting(x + _cdx, y, obj_collision)) x += _cdx;
                if (!place_meeting(x, y + _cdy, obj_collision)) y += _cdy;
            }
        }

        if (attack_cooldown > 0) attack_cooldown--;

        if (attack_cooldown <= 0 && _dist < attack_range && obj_player.hp > 0) {
            obj_player.hp -= attack_damage;
            obj_player.hurt_timer = 60;
            audio_play_sound(sound_hurt, 1, false);
            if (snd_attack != undefined) audio_play_sound(snd_attack, 1, false);
            attack_cooldown = attack_cooldown_max;
        }

        if (snd_timer > 0) snd_timer--;
        if (snd_move != undefined && snd_timer <= 0) {
            audio_play_sound(snd_move, 1, false);
            snd_timer = 90;
        }

        if (_dist > 500) chase_timer -= 3;
        else chase_timer--;

        if (chase_timer <= 0) {
            state      = ANIMAL_STATE.IDLE;
            idle_timer = irandom_range(60, 240);
        }
    break;
}
