function scr_get_crop_key_from_seed(_seed_key) {
    return string_replace(_seed_key, "_seeds", "");
}

function scr_is_tier_unlocked(_tier) {
    var _season = global.season_index;
    var _tiers = global.seed_unlock_tiers[_season];
    if (_tiers == undefined || _tier <= 0) return true;
    var _prev_tier = _tiers[_tier - 1];
    if (_prev_tier == undefined) return false;
    for (var s = 0; s < array_length(_prev_tier); s++) {
        var _crop_key = scr_get_crop_key_from_seed(_prev_tier[s]);
        var _shipped = global.shipped_quantities[$ _crop_key];
        if (_shipped == undefined || _shipped < 100) return false;
    }
    return true;
}

function scr_is_seed_unlocked(_seed_key) {
    var _season = global.season_index;
    var _tiers = global.seed_unlock_tiers[_season];
    if (_tiers == undefined) return true;
    var _my_tier = -1;
    for (var t = 0; t < array_length(_tiers); t++) {
        var _tier = _tiers[t];
        for (var s = 0; s < array_length(_tier); s++) {
            if (_tier[s] == _seed_key) {
                _my_tier = t;
                break;
            }
        }
        if (_my_tier >= 0) break;
    }
    if (_my_tier < 0) return true;
    return scr_is_tier_unlocked(_my_tier);
}

function scr_get_miraculos_shop_items() {
    var _shop = global.shop_data[$ "Miraculos"];
    if (_shop == undefined || !_shop.available) return [];
    var _result = [];
    for (var i = 0; i < array_length(_shop.items); i++) {
        var _entry = _shop.items[i];
        var _seed_data = global.seed_data[$ _entry.item_key];
        if (_seed_data == undefined) {
            array_push(_result, _entry);
            continue;
        }
        var _season_ok = false;
        var _seasons = _seed_data.seasons;
        for (var s = 0; s < array_length(_seasons); s++) {
            if (_seasons[s] == global.season_index || _seasons[s] == SEASON.ALL) {
                _season_ok = true;
                break;
            }
        }
        if (!_season_ok) continue;
        if (!scr_is_seed_unlocked(_entry.item_key)) continue;
        array_push(_result, _entry);
    }
    return _result;
}

function scr_on_item_shipped(_item_key, _quantity) {
    if (!variable_struct_exists(global.crop_data, _item_key)) return;
    var _current = global.shipped_quantities[$ _item_key];
    if (_current == undefined) _current = 0;
    global.shipped_quantities[$ _item_key] = _current + _quantity;
}

function scr_count_unlocked_tiers() {
    var _season = global.season_index;
    var _tiers = global.seed_unlock_tiers[_season];
    if (_tiers == undefined) return 0;
    var _count = 0;
    for (var t = 0; t < array_length(_tiers); t++) {
        if (scr_is_tier_unlocked(t)) {
            _count++;
        } else {
            break;
        }
    }
    return _count;
}
