/// Game configuration constants for Snake Xenzia
class GameConstants {
  GameConstants._();

  // Grid configuration
  /// Number of columns in the game grid
  static const int gridColumns = 20;
  
  /// Number of rows in the game grid
  static const int gridRows = 30;
  
  /// Cell size in logical pixels
  static const double cellSize = 12.0;

  // Speed/Difficulty levels (1-10)
  /// Minimum difficulty level
  static const int minLevel = 1;
  
  /// Maximum difficulty level
  static const int maxLevel = 10;
  
  /// Base movement speed in milliseconds (level 1)
  static const int baseSpeed = 500;
  
  /// Speed decrease per level (gets faster)
  static const int speedDecrement = 40;
  
  /// Calculate movement speed for a given level
  static int getSpeedForLevel(int level) {
    if (level < minLevel || level > maxLevel) {
      throw ArgumentError('Level must be between $minLevel and $maxLevel');
    }
    return baseSpeed - (speedDecrement * (level - 1));
  }
  
  /// Points multiplier per level
  static int getPointsMultiplier(int level) {
    return level;
  }
  
  /// Base points for eating food
  static const int basePoints = 10;

  // Campaign mode configuration
  /// Number of food items to eat per maze in campaign mode
  static const int foodPerMaze = 20;
  
  /// Bonus points for completing a maze
  static const int mazeCompletionBonus = 100;

  // Snake configuration
  /// Initial snake length
  static const int initialSnakeLength = 3;
  
  /// Maximum snake length (optional limit)
  static const int maxSnakeLength = gridColumns * gridRows - 1;

  // Control configuration
  /// Gesture swipe threshold in pixels
  static const double swipeThreshold = 50.0;
  
  /// Minimum swipe velocity
  static const double minSwipeVelocity = 100.0;

  // UI configuration
  /// Border width for game elements
  static const double borderWidth = 2.0;
  
  /// Corner radius for rounded elements
  static const double cornerRadius = 4.0;
  
  /// Animation duration for transitions
  static const Duration animationDuration = Duration(milliseconds: 200);
  
  /// Splash screen duration
  static const Duration splashDuration = Duration(seconds: 2);

  // Storage keys
  /// Key for storing high scores
  static const String highScoresKey = 'high_scores';
  
  /// Key for storing achievements
  static const String achievementsKey = 'achievements';
  
  /// Key for storing settings
  static const String settingsKey = 'game_settings';
  
  /// Key for storing current game state
  static const String gameStateKey = 'current_game';

  // Achievement thresholds
  /// Score threshold for "Getting Started" achievement
  static const int achievementScoreNovice = 100;
  
  /// Score threshold for "Skilled Player" achievement
  static const int achievementScoreSkilled = 500;
  
  /// Score threshold for "Expert" achievement
  static const int achievementScoreExpert = 1000;
  
  /// Score threshold for "Master" achievement
  static const int achievementScoreMaster = 2500;
  
  /// Snake length for "Long Snake" achievement
  static const int achievementLengthLong = 20;
  
  /// Snake length for "Very Long Snake" achievement
  static const int achievementLengthVeryLong = 50;
  
  /// Snake length for "Maximum Snake" achievement
  static const int achievementLengthMax = 100;
  
  /// Games played for "Persistent" achievement
  static const int achievementGamesPersistent = 50;
  
  /// Games played for "Dedicated" achievement
  static const int achievementGamesDedicated = 100;

  // Maze types count
  /// Number of available mazes
  static const int mazeCount = 6; // 5 mazes + no maze option
}
