var _best_i    = -1;
var _best_dist = infinity;
for (var i = 0; i < array_length(global.forest_enemies); i++) {
    var _d = global.forest_enemies[i];
    if (_d.key == enemy_key) {
        var _dist = point_distance(x, y, _d.x, _d.y);
        if (_dist < _best_dist) {
            _best_dist = _dist;
            _best_i    = i;
        }
    }
}
if (_best_i != -1) array_delete(global.forest_enemies, _best_i, 1);
