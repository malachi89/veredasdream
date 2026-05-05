# Plan: Add Falling Leaf Particles to Forest

## Objective
Add a falling leaves particle effect to the `forest` room using the `sprite_leaf_particle`.

## Key Files & Context
- `sprites/sprite_leaf_particle`: The sprite to be used for the particles.
- `rooms/forest/forest.yy`: The room where the effect will be active.

## Implementation Steps
1. **Create `obj_forest_particles`**:
   - Create a new directory `objects/obj_forest_particles`.
   - **Create Event**: Initialize the particle system and particle type.
     - Use `sprite_leaf_particle`.
     - Set properties: gravity (falling down), speed, direction, life, and maybe a slight rotation/wiggle for realism.
     - Set colors (different shades of green/yellow/brown if desired, or keep original).
   - **Step Event**: Update the particle emitter position to follow the camera view, ensuring leaves fall over the entire visible area.
   - **CleanUp Event**: Destroy the particle system and type to prevent memory leaks.
2. **Update Forest Room**:
   - Add an instance of `obj_forest_particles` to the `Instances` layer in `rooms/forest/forest.yy`.
3. **Register New Object**:
   - Update `Veredas Dream.yyp` to include the new object.

## Verification & Testing
- Enter the forest room and verify that leaves are falling.
- Check for any performance issues or memory leaks (by monitoring instance counts/memory if possible).
- Verify that the particles follow the camera as the player moves.
