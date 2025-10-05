part of 'snake_game_bloc.dart';

/// Base class for all snake game states
abstract class SnakeGameState extends Equatable {
  const SnakeGameState();

  @override
  List<Object?> get props => [];
}

/// Initial state before game starts
class SnakeGameInitial extends SnakeGameState {
  const SnakeGameInitial();
}

/// State when game is actively running
class SnakeGameRunning extends SnakeGameState {
  final List<SnakeSegment> snake;
  final Direction direction;
  final Position foodPosition;
  final int score;
  final int level;
  final Maze maze;
  final GameSettings settings;
  final bool isCampaign;
  final int currentMazeIndex;
  final int foodEatenInMaze;

  const SnakeGameRunning({
    required this.snake,
    required this.direction,
    required this.foodPosition,
    required this.score,
    required this.level,
    required this.maze,
    required this.settings,
    this.isCampaign = false,
    this.currentMazeIndex = 0,
    this.foodEatenInMaze = 0,
  });

  SnakeGameRunning copyWith({
    List<SnakeSegment>? snake,
    Direction? direction,
    Position? foodPosition,
    int? score,
    int? level,
    Maze? maze,
    GameSettings? settings,
    bool? isCampaign,
    int? currentMazeIndex,
    int? foodEatenInMaze,
  }) {
    return SnakeGameRunning(
      snake: snake ?? this.snake,
      direction: direction ?? this.direction,
      foodPosition: foodPosition ?? this.foodPosition,
      score: score ?? this.score,
      level: level ?? this.level,
      maze: maze ?? this.maze,
      settings: settings ?? this.settings,
      isCampaign: isCampaign ?? this.isCampaign,
      currentMazeIndex: currentMazeIndex ?? this.currentMazeIndex,
      foodEatenInMaze: foodEatenInMaze ?? this.foodEatenInMaze,
    );
  }

  @override
  List<Object?> get props => [
        snake,
        direction,
        foodPosition,
        score,
        level,
        maze,
        settings,
        isCampaign,
        currentMazeIndex,
        foodEatenInMaze,
      ];
}

/// State when game is paused
class SnakeGamePaused extends SnakeGameState {
  final List<SnakeSegment> snake;
  final Direction direction;
  final Position foodPosition;
  final int score;
  final int level;
  final Maze maze;
  final GameSettings settings;
  final bool isCampaign;
  final int currentMazeIndex;
  final int foodEatenInMaze;

  const SnakeGamePaused({
    required this.snake,
    required this.direction,
    required this.foodPosition,
    required this.score,
    required this.level,
    required this.maze,
    required this.settings,
    this.isCampaign = false,
    this.currentMazeIndex = 0,
    this.foodEatenInMaze = 0,
  });

  @override
  List<Object?> get props => [
        snake,
        direction,
        foodPosition,
        score,
        level,
        maze,
        settings,
        isCampaign,
        currentMazeIndex,
        foodEatenInMaze,
      ];
}

/// State when game is over
class SnakeGameOver extends SnakeGameState {
  final int finalScore;
  final int snakeLength;
  final int level;
  final bool isHighScore;

  const SnakeGameOver({
    required this.finalScore,
    required this.snakeLength,
    required this.level,
    this.isHighScore = false,
  });

  @override
  List<Object?> get props => [finalScore, snakeLength, level, isHighScore];
}

/// State when an error occurs
class SnakeGameError extends SnakeGameState {
  final String message;

  const SnakeGameError(this.message);

  @override
  List<Object?> get props => [message];
}
