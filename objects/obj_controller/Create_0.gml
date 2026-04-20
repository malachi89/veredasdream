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
global.money = 500;

time_tick_counter = 0;
time_frames_per_minute = (360 / global.time_multiplier);

function start_new_day() {
    fade_alpha = 1.0;
    is_fading_in = true;

    global.game_minute = 0;
    global.game_hour = 6;
    global.day += 1;

    if (global.day > global.days_per_season) {
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

    global.forest_needs_repopulate = true;
    scr_advance_stored_room_states(room_get_name(room));
    scr_advance_common_trees();

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

    scr_capture_current_room_state();
    show_debug_message("Nuevo dia: " + string(global.day) + " de " + global.season_names[$ global.season] + " Ano " + string(global.year));
}

function update_tilesets() {
    var _tilesets = [ts_farm_spring, ts_farm_summer, ts_farm_fall, ts_farm_winter];
    var _props_tilesets = [ts_props_exterior_spring, ts_props_exterior_summer, ts_props_exterior_fall, ts_props_exterior_winter];
    
    var _bg_layer = layer_get_id("Tiles_background");
    var _details_layer = layer_get_id("Tiles_details");
    var _props_layer = layer_get_id("Tiles_seasonal_props"); // New layer for seasonal props
    
    if (_bg_layer != -1) tilemap_tileset(layer_tilemap_get_id(_bg_layer), _tilesets[global.season_index]);
    if (_details_layer != -1) tilemap_tileset(layer_tilemap_get_id(_details_layer), _tilesets[global.season_index]);
    if (_props_layer != -1) tilemap_tileset(layer_tilemap_get_id(_props_layer), _props_tilesets[global.season_index]);
}

global.season_list = ["spring", "summer", "fall", "winter"];
global.season_index = 0;
global.season = global.season_list[global.season_index];
global.season_names = { spring: "Primavera", summer: "Verano", fall: "Otono", winter: "Invierno" };
global.day_names = ["Lun.", "Mar.", "Mie.", "Jue.", "Vie.", "Sab.", "Dom."];

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
global.save_file_path = global.save_dir + "\\savegame.json";
show_debug_message("Save path: " + global.save_file_path);
global.pending_player_room_name = "";
global.pending_player_x = 0;
global.pending_player_y = 0;
global.pending_player_dir = DIR.DOWN;
global.farm_populated = false;
global.forest_needs_repopulate = true;
global.forest_days_since_rare = 0;

sleep_menu_open = false;
sleep_menu_selection = 0;
bed_overlap_previous = false;

// Variables para el resumen de ventas
shipping_summary_open = false;
shipping_summary_data = { items: [], total: 0 };
shipping_summary_scroll = 0; // Por si hay muchos items

// Debug Console / Chat Window
chat_open = false;
chat_text = "";
chat_history = []; // Optional: to store previous commands

current_room_name = room_get_name(room);
pending_loaded_game = scr_read_save_game();
load_needs_apply = is_struct(pending_loaded_game);

// Fade variables for day start
fade_alpha = 1.0;
fade_speed = 1.0 / (room_speed * 1.5); // 1.5 seconds fade duration
is_fading_in = true;
