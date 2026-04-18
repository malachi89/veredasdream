NPC System Implementation Plan
Overview

Implement a scalable NPC system using sprites located in sprites/npc. The system must support 20 unique NPCs, each with distinct identities (names, visual variation) and be extensible for future dialogue integration.

Objectives
Create 20 NPC instances with unique Mexican names
Use existing NPC sprite variations (color/type)
Implement shared animation system (idle + walk)
Build a reusable and extensible data structure
Prepare integration points for future dialogue system
Asset Structure

Sprites

Path: sprites/npc/
Contains:
Multiple NPC variations (color/type)
Shared animation layout (same as player)

Objects

obj_npc (already created placeholder)
Will be the base object for all NPC instances
NPC Data Model

Each NPC must be defined using a structured format:

{
  name: string,
  sprite_idle: asset,
  sprite_walk: asset,
  dialog_id: string (or -1 as placeholder)
}
Required Fields
name → Unique identifier (Mexican names)
dialog_id → placeholder on a next plan we create dialogs for the NPCs
NPC Name List (20)

Must include "Miraculos".

Miraculos
José
María
Juan
Lupita
Carlos
Ana
Pedro
Sofía
Diego
Carmen
Luis
Fernanda
Jorge
Elena
Raúl
Patricia
Miguel
Rosa
Andrés
Animation System

All NPCs share the same animation layout as the player.

Idle Animation (frames_idle = 4)
Direction	Frame Range
DOWN	0 – 3
UP	4 – 7
RIGHT	8 – 11
LEFT	12 – 15
Walk Animation (frames_walk = 6)
Direction	Frame Range
DOWN	0 – 5
UP	6 – 11
RIGHT	12 – 17
LEFT	18 – 23