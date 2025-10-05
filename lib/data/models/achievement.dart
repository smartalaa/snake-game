import 'package:equatable/equatable.dart';

/// Represents an achievement that can be unlocked
class Achievement extends Equatable {
  /// Unique identifier for the achievement
  final String id;
  
  /// Display name of the achievement
  final String name;
  
  /// Description of how to unlock the achievement
  final String description;
  
  /// Icon identifier or emoji for the achievement
  final String icon;
  
  /// Whether this achievement has been unlocked
  final bool isUnlocked;
  
  /// Timestamp when the achievement was unlocked
  final DateTime? unlockedAt;
  
  /// Progress towards unlocking (0.0 to 1.0)
  final double progress;
  
  /// Required value to unlock the achievement
  final int? requiredValue;
  
  /// Current value towards the requirement
  final int? currentValue;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.requiredValue,
    this.currentValue,
  });

  /// Create a copy with updated values
  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    int? requiredValue,
    int? currentValue,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      requiredValue: requiredValue ?? this.requiredValue,
      currentValue: currentValue ?? this.currentValue,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        isUnlocked,
        unlockedAt,
        progress,
        requiredValue,
        currentValue,
      ];

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'progress': progress,
        'requiredValue': requiredValue,
        'currentValue': currentValue,
      };

  /// Create from JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      requiredValue: json['requiredValue'] as int?,
      currentValue: json['currentValue'] as int?,
    );
  }

  @override
  String toString() => 'Achievement($id: $name, unlocked: $isUnlocked)';
}

/// Predefined achievements for the game
class Achievements {
  Achievements._();

  /// First game achievement
  static const Achievement firstGame = Achievement(
    id: 'first_game',
    name: 'First Steps',
    description: 'Play your first game',
    icon: '🎮',
  );

  /// Score-based achievements
  static const Achievement scoreNovice = Achievement(
    id: 'score_novice',
    name: 'Getting Started',
    description: 'Reach a score of 100',
    icon: '⭐',
    requiredValue: 100,
  );

  static const Achievement scoreSkilled = Achievement(
    id: 'score_skilled',
    name: 'Skilled Player',
    description: 'Reach a score of 500',
    icon: '🌟',
    requiredValue: 500,
  );

  static const Achievement scoreExpert = Achievement(
    id: 'score_expert',
    name: 'Expert',
    description: 'Reach a score of 1000',
    icon: '💫',
    requiredValue: 1000,
  );

  static const Achievement scoreMaster = Achievement(
    id: 'score_master',
    name: 'Master',
    description: 'Reach a score of 2500',
    icon: '👑',
    requiredValue: 2500,
  );

  /// Length-based achievements
  static const Achievement lengthLong = Achievement(
    id: 'length_long',
    name: 'Long Snake',
    description: 'Grow your snake to 20 segments',
    icon: '🐍',
    requiredValue: 20,
  );

  static const Achievement lengthVeryLong = Achievement(
    id: 'length_very_long',
    name: 'Very Long Snake',
    description: 'Grow your snake to 50 segments',
    icon: '🐉',
    requiredValue: 50,
  );

  static const Achievement lengthMax = Achievement(
    id: 'length_max',
    name: 'Maximum Snake',
    description: 'Grow your snake to 100 segments',
    icon: '🦎',
    requiredValue: 100,
  );

  /// Persistence achievements
  static const Achievement gamesPersistent = Achievement(
    id: 'games_persistent',
    name: 'Persistent',
    description: 'Play 50 games',
    icon: '🔥',
    requiredValue: 50,
  );

  static const Achievement gamesDedicated = Achievement(
    id: 'games_dedicated',
    name: 'Dedicated',
    description: 'Play 100 games',
    icon: '💪',
    requiredValue: 100,
  );

  /// Campaign achievements
  static const Achievement campaignComplete = Achievement(
    id: 'campaign_complete',
    name: 'Campaign Master',
    description: 'Complete the campaign mode',
    icon: '🏆',
  );

  /// Difficulty achievements
  static const Achievement maxDifficulty = Achievement(
    id: 'max_difficulty',
    name: 'Speed Demon',
    description: 'Win a game at difficulty level 10',
    icon: '⚡',
    requiredValue: 10,
  );

  /// All available achievements
  static List<Achievement> get all => [
        firstGame,
        scoreNovice,
        scoreSkilled,
        scoreExpert,
        scoreMaster,
        lengthLong,
        lengthVeryLong,
        lengthMax,
        gamesPersistent,
        gamesDedicated,
        campaignComplete,
        maxDifficulty,
      ];
}
