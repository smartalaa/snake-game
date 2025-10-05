import 'package:audioplayers/audioplayers.dart';
import 'package:snake_xenzia/core/constants/app_sounds.dart';

/// Service for managing audio playback
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;
  double _volume = 0.7;

  /// Initialize the audio service
  Future<void> initialize() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setVolume(_volume);
  }

  /// Enable or disable sound
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Set volume (0.0 to 1.0)
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _player.setVolume(_volume);
  }

  /// Play a sound effect
  Future<void> playSound(String soundPath) async {
    if (!_soundEnabled) return;

    try {
      await _player.stop();
      await _player.play(AssetSource(soundPath));
    } catch (e) {
      // Silently fail if sound cannot be played
      // In production, you might want to log this
    }
  }

  /// Play eat sound
  Future<void> playEat() async {
    await playSound(AppSounds.eat.replaceAll('assets/', ''));
  }

  /// Play crash sound
  Future<void> playCrash() async {
    await playSound(AppSounds.crash.replaceAll('assets/', ''));
  }

  /// Play menu click sound
  Future<void> playMenuClick() async {
    await playSound(AppSounds.menuClick.replaceAll('assets/', ''));
  }

  /// Play select sound
  Future<void> playSelect() async {
    await playSound(AppSounds.select.replaceAll('assets/', ''));
  }

  /// Play move sound
  Future<void> playMove() async {
    await playSound(AppSounds.move.replaceAll('assets/', ''));
  }

  /// Play level complete sound
  Future<void> playLevelComplete() async {
    await playSound(AppSounds.levelComplete.replaceAll('assets/', ''));
  }

  /// Play achievement sound
  Future<void> playAchievement() async {
    await playSound(AppSounds.achievement.replaceAll('assets/', ''));
  }

  /// Play high score sound
  Future<void> playHighScore() async {
    await playSound(AppSounds.highScore.replaceAll('assets/', ''));
  }

  /// Stop all sounds
  Future<void> stopAll() async {
    await _player.stop();
  }

  /// Dispose the audio player
  Future<void> dispose() async {
    await _player.dispose();
  }
}
