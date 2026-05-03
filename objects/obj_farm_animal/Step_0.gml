frame_anim += 0.1;

if (hurt_flash_timer > 0) hurt_flash_timer -= 1;

if (hp <= 0) {
    var _adata = global.animal_data[$ animal_type];
    if (_adata != undefined && variable_struct_exists(_adata, "product_drops") && array_length(_adata.product_drops) > 0) {
        var _product = _adata.product_drops[irandom(array_length(_adata.product_drops) - 1)];
        inventory_drop_item(_product, 1, x, y);
    }
    if (_adata != undefined && variable_struct_exists(_adata, "crafting_drops") && array_length(_adata.crafting_drops) > 0 && irandom(1) == 0) {
        var _cd = _adata.crafting_drops;
        inventory_drop_item(_cd[irandom(array_length(_cd) - 1)], 1, x, y);
    }
    // 5% de probabilidad de dropear un arma
    if (random(1) < 0.05) {
        var _w_type  = choose("sword", "bow");
        var _w_level = irandom(9) + 1;
        inventory_drop_item(_w_type + "_" + string(_w_level), 1, x, y, 15);
    }

    global.collected_items[$ "farm_" + animal_type] = true;
    scr_check_collection_unlocks();
    instance_destroy();
    exit;
}

switch (state) {

    case ANIMAL_STATE.IDLE:
        if (frame_anim >= 4) frame_anim -= 4;
        idle_timer -= 1;
        if (idle_timer <= 0) {
            dir              = irandom(3);
            state            = ANIMAL_STATE.WANDERING;
            frame_anim       = 0;
            max_wander_steps = irandom_range(60, 180);
            wander_steps     = max_wander_steps;
        }
    break;

    case ANIMAL_STATE.WANDERING:
        if (frame_anim >= 4) frame_anim -= 4;
        var _dx = 0, _dy = 0;
        switch (dir) {
            case DIR.DOWN:  _dy =  move_speed; break;
            case DIR.UP:    _dy = -move_speed; break;
            case DIR.RIGHT: _dx =  move_speed; break;
            case DIR.LEFT:  _dx = -move_speed; break;
        }
        if (!place_meeting(x + _dx, y + _dy, obj_collision)) {
            x += _dx;
            y += _dy;
        } else {
            dir          = irandom(3);
            wander_steps = max_wander_steps;
        }
        wander_steps -= 1;
        if (wander_steps <= 0) {
            state      = ANIMAL_STATE.IDLE;
            frame_anim = 0;
            idle_type  = irandom(4);
            if (frame_count == 32 && idle_type > 3) idle_type = 3;
            idle_timer = irandom_range(120, 300);
        }
    break;
    
    case ANIMAL_STATE.FLEEING:
        if (frame_anim >= 4) frame_anim -= 4;
        var _fspeed = move_speed * (is_panicked ? 5.0 : 2.5);
        var _fdx = 0, _fdy = 0;
        switch (dir) {
            case DIR.DOWN:  _fdy =  _fspeed; break;
            case DIR.UP:    _fdy = -_fspeed; break;
            case DIR.RIGHT: _fdx =  _fspeed; break;
            case DIR.LEFT:  _fdx = -_fspeed; break;
        }
        if (!place_meeting(x + _fdx, y + _fdy, obj_collision)) {
            x += _fdx;
            y += _fdy;
        } else {
            dir = irandom(3);
        }
        flee_timer--;
        if (flee_timer <= 0) {
            state       = ANIMAL_STATE.IDLE;
            frame_anim  = 0;
            is_panicked = false;
            idle_timer  = irandom_range(120, 300);
        }
    break;
}

depth = -bbox_bottom;
