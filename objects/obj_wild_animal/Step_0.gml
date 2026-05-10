depth = -bbox_bottom;

var _frame_count = sprite_get_number(sprite_index);
frame_anim += 0.15;
if (frame_anim >= _frame_count) frame_anim -= _frame_count;

if (hurt_flash_timer > 0) hurt_flash_timer -= 1;

if (hp <= 0) {
    if (is_farm_animal) {
        var _adata = global.animal_data[$ animal_key];
        if (_adata != undefined && variable_struct_exists(_adata, "product_drops") && array_length(_adata.product_drops) > 0) {
            var _product = _adata.product_drops[irandom(array_length(_adata.product_drops) - 1)];
            inventory_drop_item(_product, 1, x, y);
        }
        if (_adata != undefined && variable_struct_exists(_adata, "crafting_drops") && array_length(_adata.crafting_drops) > 0 && irandom(1) == 0) {
            var _cd = _adata.crafting_drops;
            inventory_drop_item(_cd[irandom(array_length(_cd) - 1)], 1, x, y);
        }
    } else {
        var _wdata = global.wild_animal_data[$ animal_key];
        if (_wdata != undefined && variable_struct_exists(_wdata, "product_drops") && array_length(_wdata.product_drops) > 0) {
            var _wdrops = _wdata.product_drops;
            inventory_drop_item(_wdrops[irandom(array_length(_wdrops) - 1)], 1, x, y);
        }
    }
    var _wdata_ref = is_farm_animal ? global.animal_data[$ animal_key] : global.wild_animal_data[$ animal_key];
    var _w_chance  = (_wdata_ref != undefined && variable_struct_exists(_wdata_ref, "weapon_drop_chance"))
        ? _wdata_ref.weapon_drop_chance
        : (is_farm_animal ? 0 : 0.05);
    if (random(1) < _w_chance) {
        var _w_type = choose("sword", "bow");
        var _tool_type = _w_type == "sword" ? TOOL_TYPE.SWORD : TOOL_TYPE.BOW;
        var _player_level = scr_get_player_max_weapon_level(_tool_type);
        var _w_level = min(_player_level + 1, 10);
        inventory_drop_item(_w_type + "_" + string(_w_level), 1, x, y, 15);
    }

    if (is_farm_animal) {
        global.collected_items[$ "farm_" + animal_key] = true;
    } else {
        global.collected_items[$ animal_key] = true;
    }
    if (animal_key == "bear") {
        global.bears_killed++;
        if (global.bears_killed >= 20 && !global.bear_unlocked && instance_exists(obj_stable)) {
            global.bear_unlocked = true;
            var _stable = instance_find(obj_stable, 0);
            var _bear = instance_create_layer(_stable.x + 96, _stable.y + 64, "Instances", obj_horse1);
            _bear.is_bear = true;
            scr_notify("!Un oso salvaje ha llegado al establo!");
        }
    }

    scr_check_collection_unlocks();
    instance_destroy();
    exit;
}

if (state != ANIMAL_STATE.FLEEING && state != ANIMAL_STATE.CHASING && instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) < 80) {
        state      = ANIMAL_STATE.FLEEING;
        flee_timer = 90;
        // Flee in all 4 directions based on player position
        var _pdir = point_direction(obj_player.x, obj_player.y, x, y);
        if (_pdir >= 45 && _pdir < 135) dir = DIR.UP;
        else if (_pdir >= 135 && _pdir < 225) dir = DIR.LEFT;
        else if (_pdir >= 225 && _pdir < 315) dir = DIR.DOWN;
        else dir = DIR.RIGHT;
    }
}

switch (state) {
    case ANIMAL_STATE.IDLE:
        idle_timer -= 1;
        if (idle_timer <= 0) {
            state        = ANIMAL_STATE.WANDERING;
            dir          = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
            wander_steps = max_wander_steps;
        }
    break;

    case ANIMAL_STATE.WANDERING:
        var _dx = 0;
        var _dy = 0;
        if (dir == DIR.LEFT) _dx = -move_speed;
        else if (dir == DIR.RIGHT) _dx = move_speed;
        else if (dir == DIR.UP) _dy = -move_speed;
        else if (dir == DIR.DOWN) _dy = move_speed;
        
        var _check_x = x + _dx + (dir == DIR.LEFT ? -4 : (dir == DIR.RIGHT ? 4 : 0));
        var _check_y = y + _dy + (dir == DIR.UP ? -4 : (dir == DIR.DOWN ? 4 : 0));
        
        if (!instance_position(_check_x, _check_y, obj_collision)) {
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
    break;

    case ANIMAL_STATE.FLEEING:
        var _fspeed = move_speed * (is_panicked ? 2.5 : 2.0);
        var _fdx = 0;
        var _fdy = 0;
        if (dir == DIR.LEFT) _fdx = -_fspeed;
        else if (dir == DIR.RIGHT) _fdx = _fspeed;
        else if (dir == DIR.UP) _fdy = -_fspeed;
        else if (dir == DIR.DOWN) _fdy = _fspeed;

        var _check_fx = x + _fdx + (dir == DIR.LEFT ? -4 : (dir == DIR.RIGHT ? 4 : 0));
        var _check_fy = y + _fdy + (dir == DIR.UP ? -4 : (dir == DIR.DOWN ? 4 : 0));

        if (!instance_position(_check_fx, _check_fy, obj_collision)) {
            x += _fdx;
            y += _fdy;
        } else {
            dir = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
        }
        flee_timer--;
        if (flee_timer <= 0) {
            state      = ANIMAL_STATE.IDLE;
            idle_timer = irandom_range(60, 240);
            is_panicked = false;
        }
    break;

    case ANIMAL_STATE.CHASING:
        if (!instance_exists(obj_player)) {
            state = ANIMAL_STATE.IDLE;
            chase_timer = 0;
            break;
        }

        var _pdir = point_direction(x, y, obj_player.x, obj_player.y);
        var _dist = point_distance(x, y, obj_player.x, obj_player.y);

        // Face toward player
        if (_pdir >= 45 && _pdir < 135) dir = DIR.UP;
        else if (_pdir >= 135 && _pdir < 225) dir = DIR.LEFT;
        else if (_pdir >= 225 && _pdir < 315) dir = DIR.DOWN;
        else dir = DIR.RIGHT;

        // Stop at 28px to avoid jittering into the player
        if (_dist > 28) {
            var _cspeed = move_speed * 2.5;
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

        // Bear attacks player directly when within range
        if (attack_cooldown <= 0 && _dist < 32 && obj_player.hp > 0) {
            obj_player.hp -= 2;
            obj_player.hurt_timer = 60;
            audio_play_sound(sound_hurt, 1, false);
            attack_cooldown = 60;
        }

        if (_dist > 500) {
            chase_timer -= 3;
        } else {
            chase_timer--;
        }

        if (chase_timer <= 0) {
            state = ANIMAL_STATE.IDLE;
            idle_timer = irandom_range(60, 240);
            is_panicked = false;
        }
    break;
}