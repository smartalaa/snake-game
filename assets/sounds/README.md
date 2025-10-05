# Sound Assets

This directory contains monophonic sound effects for the Snake Xenzia game.

## Required Sound Files

The following sound files need to be added to this directory:

1. **eat.wav** - Sound when snake eats food
2. **crash.wav** - Sound when game ends (collision)
3. **menu_click.wav** - Sound for menu navigation
4. **select.wav** - Sound for menu item selection
5. **move.wav** - Optional movement sound
6. **level_complete.wav** - Sound when completing a level/maze
7. **achievement.wav** - Sound when unlocking an achievement
8. **high_score.wav** - Sound when setting a new high score

## Sound Specifications

- **Format**: WAV (uncompressed)
- **Style**: Monophonic (single channel)
- **Sample Rate**: 22050 Hz or 44100 Hz
- **Bit Depth**: 8-bit or 16-bit
- **Duration**: 0.1 - 1.0 seconds (short and punchy)
- **Aesthetic**: Retro phone ringtone style

## Creating Placeholder Sounds

For development/testing, you can:

1. Use online tools like [Bfxr](https://www.bfxr.net/) to generate retro sounds
2. Record simple beep sounds
3. Use royalty-free sound libraries
4. Generate tones programmatically

## Temporary Solution

The app will work without sound files - the AudioService handles missing files gracefully.
Sounds will simply not play if files are missing.

## Adding Custom Sounds

1. Place your WAV files in this directory
2. Ensure filenames match exactly (case-sensitive)
3. Run `flutter pub get` to update assets
4. Test in the app

---

**Note**: Sound files are not included in the repository. You need to add them yourself or the game will run silently.
