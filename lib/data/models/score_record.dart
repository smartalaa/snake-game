import 'package:equatable/equatable.dart';

/// Represents a high score record
class ScoreRecord extends Equatable {
  /// Player name or identifier
  final String playerName;
  
  /// Final score achieved
  final int score;
  
  /// Difficulty level the score was achieved on
  final int level;
  
  /// Maze type used
  final MazeType mazeType;
  
  /// Timestamp when the score was achieved
  final DateTime timestamp;
  
  /// Final snake length
  final int snakeLength;
  
  /// Whether this was a campaign mode game
  final bool isCampaign;

  const ScoreRecord({
    required this.playerName,
    required this.score,
    required this.level,
    required this.mazeType,
    required this.timestamp,
    required this.snakeLength,
    this.isCampaign = false,
  });

  /// Create a copy with updated values
  ScoreRecord copyWith({
    String? playerName,
    int? score,
    int? level,
    MazeType? mazeType,
    DateTime? timestamp,
    int? snakeLength,
    bool? isCampaign,
  }) {
    return ScoreRecord(
      playerName: playerName ?? this.playerName,
      score: score ?? this.score,
      level: level ?? this.level,
      mazeType: mazeType ?? this.mazeType,
      timestamp: timestamp ?? this.timestamp,
      snakeLength: snakeLength ?? this.snakeLength,
      isCampaign: isCampaign ?? this.isCampaign,
    );
  }

  @override
  List<Object?> get props => [
        playerName,
        score,
        level,
        mazeType,
        timestamp,
        snakeLength,
        isCampaign,
      ];

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'score': score,
        'level': level,
        'mazeType': mazeType.index,
        'timestamp': timestamp.toIso8601String(),
        'snakeLength': snakeLength,
        'isCampaign': isCampaign,
      };

  /// Create from JSON
  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      level: json['level'] as int,
      mazeType: MazeType.values[json['mazeType'] as int],
      timestamp: DateTime.parse(json['timestamp'] as String),
      snakeLength: json['snakeLength'] as int,
      isCampaign: json['isCampaign'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'ScoreRecord($playerName: $score points, level $level, ${mazeType.displayName})';
}

/// Available maze types in the game
enum MazeType {
  noMaze,
  box,
  tunnel,
  mill,
  rails,
  apartment;

  /// Get display name for the maze
  String get displayName {
    switch (this) {
      case MazeType.noMaze:
        return 'No Maze';
      case MazeType.box:
        return 'Box';
      case MazeType.tunnel:
        return 'Tunnel';
      case MazeType.mill:
        return 'Mill';
      case MazeType.rails:
        return 'Rails';
      case MazeType.apartment:
        return 'Apartment';
    }
  }

  /// Get description for the maze
  String get description {
    switch (this) {
      case MazeType.noMaze:
        return 'Classic mode with wrap-around edges';
      case MazeType.box:
        return 'Simple box with outer walls';
      case MazeType.tunnel:
        return 'Corridor-style obstacles';
      case MazeType.mill:
        return 'Rotating windmill pattern';
      case MazeType.rails:
        return 'Railroad track obstacles';
      case MazeType.apartment:
        return 'Room-based layout';
    }
  }

  /// Check if this maze has wrap-around enabled
  bool get hasWrapAround => this == MazeType.noMaze;

  /// Icon emoji for the maze
  String get icon {
    switch (this) {
      case MazeType.noMaze:
        return '🌐';
      case MazeType.box:
        return '📦';
      case MazeType.tunnel:
        return '🚇';
      case MazeType.mill:
        return '🌀';
      case MazeType.rails:
        return '🛤️';
      case MazeType.apartment:
        return '🏢';
    }
  }
}
