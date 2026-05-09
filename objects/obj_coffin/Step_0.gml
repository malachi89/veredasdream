depth = -bbox_bottom;

if (is_open) exit;

var _lp = global.local_player;
if (!instance_exists(_lp)) exit;

var _dist = point_distance(x, y, _lp.x, _lp.y);
if (_dist >= 40) exit;

if (keyboard_check_pressed(ord("E"))) {
    is_open = true;
    sprite_index = asset_get_index("sprite_coffin_opened_" + string(irandom_range(1, 5)));

    if (irandom(1) == 0) {
        // 50%: nada
    } else if (irandom(9) < 3) {
        // 15% efectivo: summon skeleton - busca posición libre cercana
        var _sx = x;
        var _sy = y;
        var _coffin_offsets = [[0,0],[32,0],[-32,0],[0,32],[0,-32],[32,32],[-32,32],[32,-32],[-32,-32],[64,0],[-64,0],[0,64],[0,-64]];
        for (var _oi = 0; _oi < array_length(_coffin_offsets); _oi++) {
            var _tx = x + _coffin_offsets[_oi][0];
            var _ty = y + _coffin_offsets[_oi][1];
            if (collision_rectangle(_tx - 16, _ty - 16, _tx + 16, _ty + 16, obj_collision, false, false) == noone) {
                _sx = _tx;
                _sy = _ty;
                break;
            }
        }
        instance_create_layer(_sx, _sy, "Instances", obj_enemy_skeleton);
    } else {
        // 35% efectivo: drop item
        var _pool = [
            "gemstone_ruby","gemstone_sapphire","gemstone_emerald","gemstone_topaz",
            // primavera
            "cherry","apricot","strawberry","spring_onion","potato","onion","carrot",
            "blueberry","parsnip","cabbage","cauliflower","rice","broccoli","asparagus",
            // verano
            "tomato","banana","orange","mango","peach","sunflower","hot_pepper","corn",
            "green_pepper","melon","watermelon","cucumber","eggplant","pineapple",
            "green_beans","adzuki_bean","wild_berry","wheat","aloe",
            // otoño
            "beetroot","pumpkin","grapes","apple"
        ];
        var _item = _pool[irandom(array_length(_pool) - 1)];
        inventory_drop_item(_item, 1, x, y);
    }
}
