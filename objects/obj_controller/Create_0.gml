if (instance_number(obj_controller) > 1) {
    instance_destroy();
    exit;
}

window_set_fullscreen(false);

var _display_w = display_get_width();
var _display_h = display_get_height();
var _window_w = max(1280, _display_w - 120);
var _window_h = max(720, _display_h - 120);

window_set_size(_window_w, _window_h);
window_center();

ini_open("settings.ini");
global.time_multiplier = ini_read_real("Time", "TimeSpeedMultiplier", 1.0);
global.days_per_season = ini_read_real("Time", "DaysPerSeason", 28);
global.music_volume = clamp(ini_read_real("Audio", "MusicVolume", 0.0), 0, 1);
ini_close();

global.game_minute = 0;
global.game_hour = 6;
global.day = 1;
global.year = 1;
global.farm_needs_repopulate_test_animals = false; // used by debug command test_animals on/off
// money vive en obj_player.money (per-player). global.local_player apunta al jugador de esta maquina.
global.local_player = noone;
global.net_role = NET_ROLE.NONE;
global.player_name = "";
global.farm_name = "";
global.save_slot = 0;

time_tick_counter = 0;
time_frames_per_minute = (360 / global.time_multiplier);

midnight_collapse_done = false;

function start_new_day() {
    midnight_collapse_done = false;
    global.lightning_flash = 0;

    if (global.force_rain_tomorrow) {
        global.weather_today = "rain";
        global.force_rain_tomorrow = false;
    } else {
        global.weather_today = (irandom(99) < 20) ? "rain" : "sunny";
    }
    if (global.weather_today == "rain") scr_notify("Hoy llovera");
    fade_alpha = 1.0;
    is_fading_in = true;

    global.game_minute = 0;
    global.game_hour = 6;
    global.day += 1;

    var _is_season_change = false;
    if (global.day > global.days_per_season) {
        _is_season_change = true;
        global.day = 1;
        global.season_index = (global.season_index + 1) mod 4;
        global.season = global.season_list[global.season_index];
        update_tilesets();
        if (global.season_index == 0) global.year += 1;

        // NEW: Remove fruit trees in winter
        if (global.season == "winter") {
            with(obj_tree) {
                instance_destroy();
            }
        }
    }

    // Farm events: schedule for this season on season change, then check each day
    if (_is_season_change) scr_schedule_season_event();
    scr_farm_clear_event_animals();
    global.pending_farm_event = "";
    if (global.farm_event_scheduled_day != -1 && global.day == global.farm_event_scheduled_day) {
        global.pending_farm_event = global.farm_event_type;
        global.farm_event_scheduled_day = -1;
        global.farm_event_type = "";
        scr_apply_farm_event(global.pending_farm_event);
    }

global.forest_needs_repopulate = true;
global.graveyard_needs_repopulate = true;
    var _cave_keys = struct_get_names(global.cave_repopulate);
    for (var _i = 0; _i < array_length(_cave_keys); _i++) {
        global.cave_repopulate[$ _cave_keys[_i]] = true;
    }
    scr_advance_stored_room_states(room_get_name(room));
    scr_advance_common_trees();
    if (_is_season_change) scr_remove_out_of_season_crops();

    if (global.weather_today == "rain") {
        var _rain_lay = layer_get_id("Tiles_tilled_watered");
        if (_rain_lay != -1) {
            var _rain_map = layer_tilemap_get_id(_rain_lay);
            var _tw = tilemap_get_width(_rain_map);
            var _th = tilemap_get_height(_rain_map);
            for (var _rtx = 0; _rtx < _tw; _rtx++) {
                for (var _rty = 0; _rty < _th; _rty++) {
                    if (tilemap_get(_rain_map, _rtx, _rty) == 72)
                        tilemap_set(_rain_map, 168, _rtx, _rty);
                }
            }
        }
        with (obj_crop) is_watered = true;
    }

    var _lay_id = layer_get_id("Tiles_tilled_watered");
    if (_lay_id != -1) {
        var _map_id = layer_tilemap_get_id(_lay_id);
        
        // Advance Regular Crops
        with (obj_crop) {
            var _tile = tilemap_get_at_pixel(_map_id, x, y);
            if (_tile == 168 || persistent_water) is_watered = true;
            grow();
            if (persistent_water) {
                tilemap_set_at_pixel(_map_id, 168, x, y);
            } else if (_tile == 168) {
                tilemap_set_at_pixel(_map_id, 72, x, y);
            }
        }
        
        // Advance Trees (Independent of watered soil)
        with (obj_tree) {
            grow();
        }
    }

    scr_daily_farm_spawn(_is_season_change);

    if (instance_exists(global.local_player)) {
        global.local_player.hp = global.local_player.max_hp;
        global.local_player.energy = global.local_player.max_energy;
    }

    // Notificacion diferida: se muestra cuando el jugador entra a la granja
    scr_capture_current_room_state();
    show_debug_message("Nuevo dia: " + string(global.day) + " de " + global.season_names[$ global.season] + " Ano " + string(global.year));

    var _mshop = global.shop_data[$ "Miraculos"];
    if (_mshop != undefined) _mshop.specials_day = -1;
    scr_generate_miraculos_daily_specials();

    // Broadcast new day state to client so their world advances in sync.
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        net_send_new_day();
    }
}

function midnight_collapse() {
    if (midnight_collapse_done) exit;
    midnight_collapse_done = true;

    var _lp = global.local_player;
    if (!instance_exists(_lp)) {
        start_new_day();
        exit;
    }

    scr_notify("Te has desmayado por el cansancio...");
    _lp.tool_locked_frames = 60;
    _lp.is_riding = false;
    _lp.mount_is_bear = false;
    _lp.state = STATE.IDLE;

    // Transition to farm_house if not already there
    if (room_get_name(room) != "farm_house") {
        scr_capture_current_room_state();
        room_goto(farm_house);
    }

    // Position player by bed
    var _bed = instance_find(obj_bed, 0);
    if (_bed != noone && instance_exists(global.local_player)) {
        global.local_player.x = _bed.x + 40;
        global.local_player.y = _bed.y + 18;
        global.local_player.dir = DIR.RIGHT;
    }

    // Process ghost (client) shipping first so their items are not lost
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        var _ghost = obj_net.remote_player_ghost;
        if (instance_exists(_ghost)) {
            var _client_summary = scr_process_shipping(_ghost);
            net_send_money_update(2, _ghost.money);
            net_send_shipping_summary(2, _client_summary);
        }
    }

    // Process host shipping
    var _summary = scr_process_shipping(_lp);

    if (array_length(_summary.items) > 0) {
        shipping_summary_data = _summary;
        shipping_summary_open = true;
    } else {
        start_new_day();
        if (global.net_role != NET_ROLE.CLIENT) scr_save_game();
        scr_notify("Dia terminado");
    }
}

function update_tilesets() {
    var _tilesets = [ts_farm_spring, ts_farm_summer, ts_farm_fall, ts_farm_winter];
    var _props_tilesets = [ts_props_exterior_spring, ts_props_exterior_summer, ts_props_exterior_fall, ts_props_exterior_winter];
    var _trees_tilesets = [ts_trees_spring, ts_trees_summer, ts_trees_fall, ts_trees_winter];
    
    var _bg_layer = layer_get_id("Tiles_background");
    var _details_layer = layer_get_id("Tiles_details");
    var _props_layer = layer_get_id("Tiles_seasonal_props");
    var _trees_layer = layer_get_id("Tiles_trees");
    var _trees_top_layer = layer_get_id("Tiles_trees_top");
    
    if (_bg_layer != -1) tilemap_tileset(layer_tilemap_get_id(_bg_layer), _tilesets[global.season_index]);
    
    var _room = room_get_name(room);
    
    if (_details_layer != -1) {
        if (_room == "farm" || _room == "forest") {
            tilemap_tileset(layer_tilemap_get_id(_details_layer), (_room == "farm") ? _tilesets[global.season_index] : _props_tilesets[global.season_index]);
        }
    }
    
    if (_props_layer != -1) tilemap_tileset(layer_tilemap_get_id(_props_layer), _props_tilesets[global.season_index]);
    
    if (_trees_layer != -1) {
        if (_room != "forest" && _room != "town") {
            tilemap_tileset(layer_tilemap_get_id(_trees_layer), _trees_tilesets[global.season_index]);
            if (_trees_top_layer != -1) tilemap_tileset(layer_tilemap_get_id(_trees_top_layer), _trees_tilesets[global.season_index]);
        }
    }
}

global.season_list = ["spring", "summer", "fall", "winter"];
global.season_index = 0;
global.season = global.season_list[global.season_index];
global.season_names = { spring: "Primavera", summer: "Verano", fall: "Otono", winter: "Invierno" };
global.day_names = ["Lun.", "Mar.", "Mie.", "Jue.", "Vie.", "Sab.", "Dom."];
global.weather_today = "sunny";
global.force_rain_tomorrow = false;
global.thunder_timer = -1;
global.pending_farm_event = "";
global.pending_farm_event_enemies = [];
global.farm_event_scheduled_day = -1;
global.farm_event_type = "";
global.lightning_flash = 0;

gx = 0;
gy = 0;
show_selector = false;
selector_color = c_white;
selector_w = 1;
selector_h = 1;

notifications = ds_list_create();

global.room_drops = {};
global.next_drop_uid = 0;
global.room_states = {};
global.save_dir = "saves";
if (!directory_exists(global.save_dir)) directory_create(global.save_dir);
global.save_file_path = "";
global.pending_player_room_name = "";
global.pending_player_x = 0;
global.pending_player_y = 0;
global.pending_player_dir = DIR.DOWN;
global.farm_populated = false;
global.road_to_cave_populated = false;
global.forest_needs_repopulate = true;
global.graveyard_needs_repopulate = true;
global.forest_days_since_rare = 0;
global.forest_days_since_rare_insect = 0;

// --- TOWN PROGRESSION ---
global.town_stage = TownStage.INITIAL;
global.town_donations = {};            // {req_key: donated_qty, ...}
global.town_construction_day = 0;      // global.day cuando empezo construccion
global.town_construction_duration = 0; // duracion en dias
scr_update_shop_availability();
global.forest_insects                = [];
global.forest_wild_animals           = [];
global.forest_enemies                = [];

room_change_pending = false; // client: waiting for ROOM_SNAPSHOT, suppress duplicate sends

sleep_menu_open = false;
sleep_menu_selection = 0;
bed_overlap_previous = false;
// Multiplayer sleep coordination
host_wants_sleep   = false;  // host clicked "Si" but waiting for client
client_wants_sleep = false;  // host received client SLEEP_REQUEST
sent_sleep_request = false;  // client: already sent SLEEP_REQUEST to host
sleep_prompt_sent  = false;  // host: SLEEP_PROMPT was sent, waiting for SLEEP_RESPONSE
sleep_prompt_open      = false;  // client: host-initiated sleep prompt
sleep_prompt_selection = 0;

// Variables para el resumen de ventas
shipping_summary_open = false;
shipping_summary_pending_close = false;
shipping_summary_data = { items: [], total: 0 };
shipping_summary_scroll = 0; // Por si hay muchos items

// Debug Console / Chat Window
chat_open = false;
chat_text = "";
chat_history = []; // Optional: to store previous commands

// Pause Menu
pause_menu_open = false;
pause_menu_selection = 0; // 0=Continuar, 1=Menu Principal, 2=Salir

current_room_name = room_get_name(room);
pending_loaded_game = undefined;
load_needs_apply = false; // Menu handles it

// Fade variables for day start
fade_alpha = 1.0;
fade_speed = 1.0 / (room_speed * 1.5); // 1.5 seconds fade duration
is_fading_in = true;

minigame_difficulty = 0; // 0: Easy, 1: Moderate, 2: Hard, 3: Extreme

// Mine prompt
global.sound_clips = [];

mine_prompt_open = false;
mine_prompt_type = "";
mine_prompt_selection = 0;

// Collection Catalog
collection_menu_open = false;
collection_category = 0;
collection_page = 0;
