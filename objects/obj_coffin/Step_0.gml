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
        // 15% efectivo: summon skeleton
        instance_create_layer(x, y, "Instances", obj_enemy_skeleton);
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
