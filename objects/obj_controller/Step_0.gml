// variable persistente en el objeto
if (!variable_instance_exists(id, "season")) season = 0;

// lista de tilesets
var tilesets = [
    ts_farm_spring,
    ts_farm_summer,
    ts_farm_fall,
    ts_farm_winter
];

if (keyboard_check_pressed(ord("P")))
{
    // avanzar estación
    season = (season + 1) mod array_length(tilesets);

    // obtener layer y tilemap
    var lay_id = layer_get_id("Tiles_background"); 
    var map_id = layer_tilemap_get_id(lay_id);
    
    var lay_id_details = layer_get_id("Tiles_details"); 
    var map_id_details = layer_tilemap_get_id(lay_id_details);

    // aplicar tileset
    tilemap_tileset(map_id, tilesets[season]);
    tilemap_tileset(map_id_details, tilesets[season]);
}