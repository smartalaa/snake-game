/// Sound asset references for the Snake Xenzia game
/// All sounds are monophonic to maintain retro feel
class AppSounds {
  AppSounds._();

  // Base path for sound assets
  static const String _basePath = 'assets/sounds/';

  /// Sound played when snake eats food
  static const String eat = '${_basePath}eat.wav';
  
  /// Sound played when snake crashes (game over)
  static const String crash = '${_basePath}crash.wav';
  
  /// Sound played when navigating menus
  static const String menuClick = '${_basePath}menu_click.wav';
  
  /// Sound played when selecting an option
  static const String select = '${_basePath}select.wav';
  
  /// Sound played when snake moves (optional, can be disabled)
  static const String move = '${_basePath}move.wav';
  
  /// Sound played when completing a level
  static const String levelComplete = '${_basePath}level_complete.wav';
  
  /// Sound played when earning an achievement
  static const String achievement = '${_basePath}achievement.wav';
  
  /// Sound played when setting a new high score
  static const String highScore = '${_basePath}high_score.wav';
  
  /// List of all sound assets for preloading
  static const List<String> allSounds = [
    eat,
    crash,
    menuClick,
    select,
    move,
    levelComplete,
    achievement,
    highScore,
  ];
}
