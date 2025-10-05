# Image Assets

This directory contains visual assets for the Snake Xenzia game.

## Required Images

Currently, the game uses programmatic rendering for all game elements.

### Optional Assets (Future Enhancement)

1. **snake_pixel.png** - Snake segment sprite
2. **apple_pixel.png** - Food/apple sprite
3. **logo.png** - App logo for splash screen
4. **icon_*.png** - Various UI icons

## Current Implementation

The game currently renders all graphics programmatically using Flutter's Canvas API:
- Snake segments are drawn as colored rectangles
- Food is rendered as circles or squares
- Walls are drawn as solid blocks
- UI uses text and basic shapes

## Adding Custom Graphics

If you want to add custom pixel art:

1. Create 8x8 or 16x16 pixel sprites
2. Use PNG format with transparency
3. Follow retro pixel art style
4. Place files in this directory
5. Update widget code to load images

---

**Note**: Image assets are optional. The game works perfectly with programmatic rendering.
