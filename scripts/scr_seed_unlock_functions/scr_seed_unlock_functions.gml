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
    scr_generate_miraculos_daily_specials();
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
    for (var i = 0; i < array_length(_shop.daily_specials); i++) {
        array_push(_result, _shop.daily_specials[i]);
    }
    return _result;
}

function scr_generate_miraculos_daily_specials() {
    var _shop = global.shop_data[$ "Miraculos"];
    if (_shop == undefined) return;
    if (_shop.specials_day == global.day && _shop.specials_day != -1) return;
    _shop.specials_day = global.day;
    _shop.daily_specials = [];

    var _forage_keys = struct_get_names(global.forage_data);
    var _forage_picks = _scr_miraculos_weighted_pick(_forage_keys, 3, global.forage_data, 3.0);
    for (var i = 0; i < array_length(_forage_picks); i++) {
        array_push(_shop.daily_specials, _forage_picks[i]);
    }

    var _fish_keys_all = struct_get_names(global.fish_data);
    var _fish_keys = [];
    for (var i = 0; i < array_length(_fish_keys_all); i++) {
        var _fk = _fish_keys_all[i];
        var _fd = global.fish_data[$ _fk];
        var _seasons = _fd.seasons;
        for (var s = 0; s < array_length(_seasons); s++) {
            if (_seasons[s] == global.season_index || _seasons[s] == SEASON.ALL) {
                array_push(_fish_keys, _fk);
                break;
            }
        }
    }
    var _fish_picks = _scr_miraculos_weighted_pick(_fish_keys, 2, global.fish_data, 2.5);
    for (var i = 0; i < array_length(_fish_picks); i++) {
        array_push(_shop.daily_specials, _fish_picks[i]);
    }
}

function _scr_miraculos_weighted_pick(_keys, _count, _db, _price_mult) {
    var _pool = [];
    var _total_w = 0;
    for (var i = 0; i < array_length(_keys); i++) {
        var _k = _keys[i];
        var _w = variable_struct_exists(global.collected_items, _k) ? 1 : 5;
        array_push(_pool, { key: _k, w: _w });
        _total_w += _w;
    }
    var _result = [];
    var _rem_w = _total_w;
    repeat (min(_count, array_length(_pool))) {
        if (_rem_w <= 0) break;
        var _r = irandom(_rem_w - 1);
        var _cum = 0;
        for (var i = 0; i < array_length(_pool); i++) {
            _cum += _pool[i].w;
            if (_r < _cum) {
                var _k = _pool[i].key;
                var _data = _db[$ _k];
                var _entry = { item_key: _k, price_money: 0, price_items: [] };
                if (variable_struct_exists(_data, "weight_min")) {
                    var _avg_w = (_data.weight_min + _data.weight_max) / 2;
                    _entry.price_money = max(10, round(_data.base_sell_price * _avg_w * _price_mult));
                    _entry.weight = _avg_w;
                } else {
                    _entry.price_money = max(5, round(_data.base_sell_price * _price_mult));
                }
                array_push(_result, _entry);
                _rem_w -= _pool[i].w;
                array_delete(_pool, i, 1);
                break;
            }
        }
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
