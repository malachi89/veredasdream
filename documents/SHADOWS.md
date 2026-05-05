# Lazy Shadow System

This project uses a "Lazy Shadow" method for simple top-down depth. It works by drawing a semi-transparent black version of the object's sprite slightly offset from its actual position before drawing the object itself.

## How it works

In the **Draw Event** of an object, we use `draw_sprite_ext()` to render the shadow first, followed by the actual sprite.

### GML Example

```gml
// 1. Draw shadow (tinted black, semi-transparent, offset)
draw_sprite_ext(sprite_index, image_index, x + offset_x, y + offset_y, image_xscale, image_yscale, image_angle, c_black, 0.4);

// 2. Draw the object itself
draw_self(); // or draw_sprite(...)
```

## Implementation Details

### Rocks (`obj_rock`)
- **Offset**: `x + 1`, `y + 0.5`
- **Alpha**: `0.4`
- **Reasoning**: Subtle offset for stationary environment objects.

### Animals (`obj_farm_animal`, `obj_wild_animal`)
- **Offset**: `x + 1.2`, `y + 1`
- **Alpha**: `0.4`
- **Reasoning**: Slightly larger offset to give a sense of being "taller" or more detached from the ground while moving.

### Player & NPCs (`obj_player`, `obj_remote_player`, `obj_npc`)
- **Offset**: `x + 1.2`, `y + 0.2`
- **Alpha**: `0.4`
- **Reasoning**: Specific offset to ground humanoid characters, providing depth whether walking or standing.

## Advantages
- **Performance**: Extremely cheap to calculate; no complex surfaces or shaders required.
- **Dynamic**: Automatically matches the current animation frame (`image_index`) and scale (`image_xscale`).
- **Simplicity**: Easy to adjust the "light direction" globally by changing the offset values.
