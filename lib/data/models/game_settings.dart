import 'package:equatable/equatable.dart';
import 'package:snake_xenzia/core/constants/app_colors.dart';
import 'package:snake_xenzia/data/models/score_record.dart';

/// Game settings and preferences
class GameSettings extends Equatable {
  /// Current game theme
  final GameTheme theme;
  
  /// Current difficulty level (1-10)
  final int difficultyLevel;
  
  /// Selected maze type
  final MazeType mazeType;
  
  /// Whether sound effects are enabled
  final bool soundEnabled;
  
  /// Sound volume (0.0 to 1.0)
  final double soundVolume;
  
  /// Control scheme
  final ControlScheme controlScheme;
  
  /// Whether to show grid lines
  final bool showGrid;
  
  /// Whether to vibrate on events
  final bool vibrationEnabled;
  
  /// Player name for high scores
  final String playerName;

  const GameSettings({
    this.theme = GameTheme.backlight,
    this.difficultyLevel = 1,
    this.mazeType = MazeType.noMaze,
    this.soundEnabled = true,
    this.soundVolume = 0.7,
    this.controlScheme = ControlScheme.swipe,
    this.showGrid = false,
    this.vibrationEnabled = true,
    this.playerName = 'Player',
  });

  /// Create a copy with updated values
  GameSettings copyWith({
    GameTheme? theme,
    int? difficultyLevel,
    MazeType? mazeType,
    bool? soundEnabled,
    double? soundVolume,
    ControlScheme? controlScheme,
    bool? showGrid,
    bool? vibrationEnabled,
    String? playerName,
  }) {
    return GameSettings(
      theme: theme ?? this.theme,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      mazeType: mazeType ?? this.mazeType,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      controlScheme: controlScheme ?? this.controlScheme,
      showGrid: showGrid ?? this.showGrid,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      playerName: playerName ?? this.playerName,
    );
  }

  @override
  List<Object?> get props => [
        theme,
        difficultyLevel,
        mazeType,
        soundEnabled,
        soundVolume,
        controlScheme,
        showGrid,
        vibrationEnabled,
        playerName,
      ];

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'theme': theme.index,
        'difficultyLevel': difficultyLevel,
        'mazeType': mazeType.index,
        'soundEnabled': soundEnabled,
        'soundVolume': soundVolume,
        'controlScheme': controlScheme.index,
        'showGrid': showGrid,
        'vibrationEnabled': vibrationEnabled,
        'playerName': playerName,
      };

  /// Create from JSON
  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      theme: GameTheme.values[json['theme'] as int? ?? 0],
      difficultyLevel: json['difficultyLevel'] as int? ?? 1,
      mazeType: MazeType.values[json['mazeType'] as int? ?? 0],
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 0.7,
      controlScheme: ControlScheme.values[json['controlScheme'] as int? ?? 0],
      showGrid: json['showGrid'] as bool? ?? false,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      playerName: json['playerName'] as String? ?? 'Player',
    );
  }
}

/// Available control schemes
enum ControlScheme {
  /// Swipe gestures to change direction
  swipe,
  
  /// Tap left/right screen halves to turn
  screenTaps,
  
  /// Use volume buttons to control
  volumeButtons,
  
  /// Use keyboard arrow keys
  keyboard;

  /// Get display name for the control scheme
  String get displayName {
    switch (this) {
      case ControlScheme.swipe:
        return 'Swipe';
      case ControlScheme.screenTaps:
        return 'Screen Taps';
      case ControlScheme.volumeButtons:
        return 'Volume Buttons';
      case ControlScheme.keyboard:
        return 'Keyboard';
    }
  }

  /// Get description for the control scheme
  String get description {
    switch (this) {
      case ControlScheme.swipe:
        return 'Swipe in any direction to move';
      case ControlScheme.screenTaps:
        return 'Tap left/right to turn';
      case ControlScheme.volumeButtons:
        return 'Use volume up/down to turn';
      case ControlScheme.keyboard:
        return 'Use arrow keys or WASD';
    }
  }

  /// Icon for the control scheme
  String get icon {
    switch (this) {
      case ControlScheme.swipe:
        return '👆';
      case ControlScheme.screenTaps:
        return '👇';
      case ControlScheme.volumeButtons:
        return '🔊';
      case ControlScheme.keyboard:
        return '⌨️';
    }
  }
}
