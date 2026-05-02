function scr_get_collection_categories() {
    return [
        { name: "Semillas",     db: global.seed_data },
        { name: "Cultivos",     db: global.crop_data },
        { name: "Pescados",     db: global.fish_data },
        { name: "Insectos",     db: global.insect_data },
        { name: "Forraje",      db: global.forage_data },
        { name: "Productos",    db: global.animal_product_data },
        { name: "Materiales",   db: global.crafting_material_data },
        { name: "Minerales",    db: global.ore_data },
        { name: "Lingotes",     db: global.bar_data },
        { name: "Gemas",        db: global.gemstone_data },
        { name: "Tintes",       db: global.dye_data },
        { name: "Mermeladas",   db: global.jam_data },
        { name: "Enemigos",     db: global.enemy_collection_data },
        { name: "Fauna",        db: global.wild_animal_collection_data },
        { name: "Granja",       db: global.farm_animal_collection_data }
    ];
}

function scr_get_collection_keys(_cat_db) {
    var _keys = variable_struct_get_names(_cat_db);
    array_sort(_keys, true);
    return _keys;
}

function scr_count_collected_in_category(_cat_db) {
    var _keys = variable_struct_get_names(_cat_db);
    var _count = 0;
    for (var _i = 0; _i < array_length(_keys); _i++) {
        if (variable_struct_exists(global.collected_items, _keys[_i])) _count++;
    }
    return _count;
}

function scr_check_collection_req(_entry) {
    if (!variable_struct_exists(_entry, "collection_req")) return true;
    var _cr = _entry.collection_req;
    var _cats = scr_get_collection_categories();
    var _cat = _cats[_cr.cat];
    return scr_count_collected_in_category(_cat.db) >= _cr.min;
}

function scr_check_collection_unlocks() {
    if (!variable_struct_exists(global, "greenhouse_unlocked")) global.greenhouse_unlocked = false;
    if (!variable_struct_exists(global, "stable_unlocked")) global.stable_unlocked = false;

    // Check room_states for already-unlocked buildings (important on save load)
    if (variable_struct_exists(global.room_states, "farm")) {
        var _farm_blds = global.room_states[$ "farm"].buildings;
        if (is_array(_farm_blds)) {
            for (var _i = 0; _i < array_length(_farm_blds); _i++) {
                if (_farm_blds[_i].obj == "obj_greenhouse") global.greenhouse_unlocked = true;
                if (_farm_blds[_i].obj == "obj_stable") global.stable_unlocked = true;
            }
        }
    }

    var _room_name = room_get_name(room);
    if (_room_name == "farm") {
        if (instance_exists(obj_greenhouse)) global.greenhouse_unlocked = true;
        if (instance_exists(obj_stable)) global.stable_unlocked = true;
    }

    if (!global.greenhouse_unlocked) {
        var _seed_keys = variable_struct_get_names(global.seed_data);
        var _crop_keys = variable_struct_get_names(global.crop_data);
        var _all_seeds = true;
        var _all_crops = true;

        for (var _i = 0; _i < array_length(_seed_keys); _i++) {
            if (!variable_struct_exists(global.collected_items, _seed_keys[_i])) { _all_seeds = false; break; }
        }
        if (_all_seeds) {
            for (var _i = 0; _i < array_length(_crop_keys); _i++) {
                if (!variable_struct_exists(global.collected_items, _crop_keys[_i])) { _all_crops = false; break; }
            }
        }

        if (_all_seeds && _all_crops) {
            global.greenhouse_unlocked = true;
            scr_notify("Invernadero desbloqueado!");
            if (_room_name == "farm" && instance_exists(obj_greenhouse_placeholder)) {
                var _inst = instance_find(obj_greenhouse_placeholder, 0);
                instance_create_layer(_inst.x, _inst.y, _inst.layer, obj_greenhouse);
                instance_destroy(_inst);
                scr_capture_current_room_state();
            }
        }
    }

    if (!global.stable_unlocked) {
        var _ap_keys = variable_struct_get_names(global.animal_product_data);
        var _wa_keys = variable_struct_get_names(global.wild_animal_data);
        var _all_products = true;
        var _all_wild = true;

        for (var _i = 0; _i < array_length(_ap_keys); _i++) {
            if (!variable_struct_exists(global.collected_items, _ap_keys[_i])) { _all_products = false; break; }
        }
        if (_all_products) {
            for (var _i = 0; _i < array_length(_wa_keys); _i++) {
                if (!variable_struct_exists(global.collected_items, _wa_keys[_i])) { _all_wild = false; break; }
            }
        }

        if (_all_products && _all_wild) {
            global.stable_unlocked = true;
            scr_notify("Establo desbloqueado!");
            if (_room_name == "farm" && instance_exists(obj_stable_placeholder)) {
                var _inst = instance_find(obj_stable_placeholder, 0);
                var _sx = _inst.x;
                var _sy = _inst.y;
                instance_create_layer(_sx, _sy, _inst.layer, obj_stable);
                instance_destroy(_inst);
                instance_create_layer(_sx + 96, _sy + 16, "Instances", obj_horse1);
                instance_create_layer(_sx + 96, _sy + 40, "Instances", obj_horse1);
                scr_capture_current_room_state();
            }
        }
    }
}
