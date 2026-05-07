function scr_magic_chest_generate_loot() {
    var _pool    = [];
    var _total_w = 0;

    // Materials
    array_push(_pool, { key: "wood",  qty: irandom_range(3, 8), w: 8 }); _total_w += 8;
    array_push(_pool, { key: "stone", qty: irandom_range(2, 6), w: 8 }); _total_w += 8;
    array_push(_pool, { key: "coal",  qty: irandom_range(1, 4), w: 6 }); _total_w += 6;

    // Crops (3 unique)
    var _crop_keys   = variable_struct_get_names(global.crop_data);
    var _crop_added  = {};
    var _crop_count  = 0;
    var _att = 0;
    while (_crop_count < min(3, array_length(_crop_keys)) && _att < 20) {
        var _ck = _crop_keys[irandom(array_length(_crop_keys) - 1)];
        if (!variable_struct_exists(_crop_added, _ck)) {
            _crop_added[$ _ck] = true;
            _crop_count++;
            array_push(_pool, { key: _ck, qty: irandom_range(1, 3), w: 5 }); _total_w += 5;
        }
        _att++;
    }

    // Animal products (2 unique)
    var _ap_keys  = variable_struct_get_names(global.animal_product_data);
    var _ap_added = {};
    var _ap_count = 0;
    _att = 0;
    while (_ap_count < min(2, array_length(_ap_keys)) && _att < 20) {
        var _apk = _ap_keys[irandom(array_length(_ap_keys) - 1)];
        if (!variable_struct_exists(_ap_added, _apk)) {
            _ap_added[$ _apk] = true;
            _ap_count++;
            array_push(_pool, { key: _apk, qty: 1, w: 4 }); _total_w += 4;
        }
        _att++;
    }

    // Forage rarity 1-2 (3 unique)
    var _forage_keys = variable_struct_get_names(global.forage_data);
    var _fr12_added  = {};
    var _fr12_count  = 0;
    _att = 0;
    while (_fr12_count < 3 && _att < 50) {
        var _fk      = _forage_keys[irandom(array_length(_forage_keys) - 1)];
        var _frarity = global.forage_data[$ _fk].rarity;
        if (_frarity <= 2 && !variable_struct_exists(_fr12_added, _fk)) {
            _fr12_added[$ _fk] = true;
            _fr12_count++;
            array_push(_pool, { key: _fk, qty: 1, w: 3 }); _total_w += 3;
        }
        _att++;
    }

    // Forage rarity 3-5 (2 unique)
    var _fr35_added = {};
    var _fr35_count = 0;
    _att = 0;
    while (_fr35_count < 2 && _att < 50) {
        var _fk      = _forage_keys[irandom(array_length(_forage_keys) - 1)];
        var _frarity = global.forage_data[$ _fk].rarity;
        if (_frarity >= 3 && !variable_struct_exists(_fr35_added, _fk)) {
            _fr35_added[$ _fk] = true;
            _fr35_count++;
            var _fw = max(1, 5 - _frarity);
            array_push(_pool, { key: _fk, qty: 1, w: _fw }); _total_w += _fw;
        }
        _att++;
    }

    // Ores
    array_push(_pool, { key: "ore_bronce",       qty: irandom_range(1, 3), w: 3 }); _total_w += 3;
    array_push(_pool, { key: "ore_plata",        qty: irandom_range(1, 2), w: 2 }); _total_w += 2;
    array_push(_pool, { key: "ore_oro",          qty: 1,                   w: 2 }); _total_w += 2;
    array_push(_pool, { key: "ore_broncastanio", qty: 1,                   w: 1 }); _total_w += 1;
    array_push(_pool, { key: "ore_chubestanio",  qty: 1,                   w: 1 }); _total_w += 1;

    // Bars
    array_push(_pool, { key: "bar_bronce", qty: irandom_range(1, 2), w: 2 }); _total_w += 2;
    array_push(_pool, { key: "bar_plata",  qty: 1,                   w: 1 }); _total_w += 1;

    // Gem (rarity-weighted)
    var _gem_keys = variable_struct_get_names(global.gemstone_data);
    var _gem_pool = [];
    for (var i = 0; i < array_length(_gem_keys); i++) {
        var _gk = _gem_keys[i];
        repeat (global.gemstone_data[$ _gk].rarity) { array_push(_gem_pool, _gk); }
    }
    if (array_length(_gem_pool) > 0) {
        var _gkey = _gem_pool[irandom(array_length(_gem_pool) - 1)];
        array_push(_pool, { key: _gkey, qty: 1, w: 1 }); _total_w += 1;
    }

    // Weapon (low tier)
    var _wep = ["sword_1", "sword_2", "bow_1", "bow_2"];
    array_push(_pool, { key: _wep[irandom(3)], qty: 1, w: 1 }); _total_w += 1;

    // Pick 2-3 unique items by weighted draw without replacement
    var _count  = irandom_range(2, 3);
    var _result = [];
    var _used   = {};

    for (var pick = 0; pick < _count && _total_w > 0; pick++) {
        var _roll   = random(_total_w);
        var _cursor = 0;
        for (var i = 0; i < array_length(_pool); i++) {
            if (_pool[i].w <= 0) continue;
            _cursor += _pool[i].w;
            if (_roll < _cursor) {
                var _pkey = _pool[i].key;
                if (!variable_struct_exists(_used, _pkey)) {
                    array_push(_result, { key: _pkey, quantity: _pool[i].qty });
                    _used[$ _pkey] = true;
                    _total_w    -= _pool[i].w;
                    _pool[i].w   = 0;
                }
                break;
            }
        }
    }

    return _result;
}
