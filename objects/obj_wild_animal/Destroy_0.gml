for (var i = array_length(global.forest_wild_animals) - 1; i >= 0; i--) {
    var _d = global.forest_wild_animals[i];
    if (_d.key == animal_key && _d.x == x && _d.y == y) {
        array_delete(global.forest_wild_animals, i, 1);
        break;
    }
}
