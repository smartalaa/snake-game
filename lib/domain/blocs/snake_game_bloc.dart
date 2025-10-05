import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/core/constants/game_constants.dart';
import 'package:snake_xenzia/core/services/audio_service.dart';
import 'package:snake_xenzia/core/utilities/collision_detection.dart';
import 'package:snake_xenzia/data/models/achievement.dart';
import 'package:snake_xenzia/data/models/game_settings.dart';
import 'package:snake_xenzia/data/models/maze.dart';
import 'package:snake_xenzia/data/models/score_record.dart';
import 'package:snake_xenzia/data/models/snake_segment.dart';
import 'package:snake_xenzia/data/repositories/achievement_repository.dart';
import 'package:snake_xenzia/data/repositories/score_repository.dart';

part 'snake_game_event.dart';
part 'snake_game_state.dart';

/// BLoC for managing the snake game logic and state
class SnakeGameBloc extends Bloc<SnakeGameEvent, SnakeGameState> {
  final ScoreRepository _scoreRepository;
  final AchievementRepository _achievementRepository;
  final AudioService _audioService;
  
  Timer? _gameTimer;

  SnakeGameBloc({
    required ScoreRepository scoreRepository,
    required AchievementRepository achievementRepository,
    required AudioService audioService,
  })  : _scoreRepository = scoreRepository,
        _achievementRepository = achievementRepository,
        _audioService = audioService,
        super(const SnakeGameInitial()) {
    on<StartGameEvent>(_onStartGame);
    on<PauseGameEvent>(_onPauseGame);
    on<ResumeGameEvent>(_onResumeGame);
    on<ChangeDirectionEvent>(_onChangeDirection);
    on<UpdateFrameEvent>(_onUpdateFrame);
    on<GameOverEvent>(_onGameOver);
    on<RestartGameEvent>(_onRestartGame);
  }

  /// Handle start game event
  Future<void> _onStartGame(
    StartGameEvent event,
    Emitter<SnakeGameState> emit,
  ) async {
    final maze = MazeFactory.create(event.settings.mazeType);
    final initialSnake = _createInitialSnake(maze);
    final food = RandomGenerator.randomFoodPosition(initialSnake, maze);

    if (food == null) {
      emit(const SnakeGameError('Failed to generate food position'));
      return;
    }

    emit(SnakeGameRunning(
      snake: initialSnake,
      direction: Direction.right,
      foodPosition: food,
      score: 0,
      level: event.settings.difficultyLevel,
      maze: maze,
      settings: event.settings,
      isCampaign: event.isCampaign,
      currentMazeIndex: 0,
      foodEatenInMaze: 0,
    ));

    _startGameLoop(event.settings.difficultyLevel);
  }

  /// Handle pause game event
  void _onPauseGame(
    PauseGameEvent event,
    Emitter<SnakeGameState> emit,
  ) {
    _gameTimer?.cancel();
    
    if (state is SnakeGameRunning) {
      final runningState = state as SnakeGameRunning;
      emit(SnakeGamePaused(
        snake: runningState.snake,
        direction: runningState.direction,
        foodPosition: runningState.foodPosition,
        score: runningState.score,
        level: runningState.level,
        maze: runningState.maze,
        settings: runningState.settings,
        isCampaign: runningState.isCampaign,
        currentMazeIndex: runningState.currentMazeIndex,
        foodEatenInMaze: runningState.foodEatenInMaze,
      ));
    }
  }

  /// Handle resume game event
  void _onResumeGame(
    ResumeGameEvent event,
    Emitter<SnakeGameState> emit,
  ) {
    if (state is SnakeGamePaused) {
      final pausedState = state as SnakeGamePaused;
      emit(SnakeGameRunning(
        snake: pausedState.snake,
        direction: pausedState.direction,
        foodPosition: pausedState.foodPosition,
        score: pausedState.score,
        level: pausedState.level,
        maze: pausedState.maze,
        settings: pausedState.settings,
        isCampaign: pausedState.isCampaign,
        currentMazeIndex: pausedState.currentMazeIndex,
        foodEatenInMaze: pausedState.foodEatenInMaze,
      ));
      
      _startGameLoop(pausedState.level);
    }
  }

  /// Handle direction change event
  void _onChangeDirection(
    ChangeDirectionEvent event,
    Emitter<SnakeGameState> emit,
  ) {
    if (state is! SnakeGameRunning) return;
    
    final runningState = state as SnakeGameRunning;
    
    // Prevent reversing direction
    if (event.direction.isOpposite(runningState.direction)) {
      return;
    }
    
    emit(runningState.copyWith(direction: event.direction));
  }

  /// Handle frame update event (game tick)
  Future<void> _onUpdateFrame(
    UpdateFrameEvent event,
    Emitter<SnakeGameState> emit,
  ) async {
    if (state is! SnakeGameRunning) return;
    
    final runningState = state as SnakeGameRunning;
    final newHead = _calculateNewHeadPosition(
      runningState.snake.first.position,
      runningState.direction,
      runningState.maze,
    );

    // Check collisions
    if (CollisionDetection.checkAnyCollision(
      newHead,
      runningState.snake,
      runningState.maze,
    )) {
      add(const GameOverEvent());
      return;
    }

    // Check if food eaten
    final foodEaten = newHead == runningState.foodPosition;
    final newSnake = _updateSnake(
      runningState.snake,
      newHead,
      runningState.direction,
      foodEaten,
    );

    if (foodEaten) {
      await _audioService.playEat();
      
      final points = GameConstants.basePoints *
          GameConstants.getPointsMultiplier(runningState.level);
      final newScore = runningState.score + points;
      final newFoodEaten = runningState.foodEatenInMaze + 1;

      // Check for achievements
      await _achievementRepository.checkScoreAchievements(newScore);
      await _achievementRepository.checkLengthAchievements(newSnake.length);

      // Generate new food
      final newFood = RandomGenerator.randomFoodPosition(newSnake, runningState.maze);
      
      if (newFood == null) {
        // Win condition - no more space
        add(const GameOverEvent());
        return;
      }

      // Check for campaign mode progression
      if (runningState.isCampaign &&
          newFoodEaten >= GameConstants.foodPerMaze) {
        _handleCampaignProgression(emit, runningState, newSnake, newScore);
        return;
      }

      emit(runningState.copyWith(
        snake: newSnake,
        foodPosition: newFood,
        score: newScore,
        foodEatenInMaze: newFoodEaten,
      ));
    } else {
      emit(runningState.copyWith(snake: newSnake));
    }
  }

  /// Handle game over event
  Future<void> _onGameOver(
    GameOverEvent event,
    Emitter<SnakeGameState> emit,
  ) async {
    _gameTimer?.cancel();
    await _audioService.playCrash();

    if (state is SnakeGameRunning) {
      final runningState = state as SnakeGameRunning;
      
      // Save score
      final scoreRecord = ScoreRecord(
        playerName: runningState.settings.playerName,
        score: runningState.score,
        level: runningState.level,
        mazeType: runningState.settings.mazeType,
        timestamp: DateTime.now(),
        snakeLength: runningState.snake.length,
        isCampaign: runningState.isCampaign,
      );
      
      await _scoreRepository.addScore(scoreRecord);
      
      // Check achievements
      await _achievementRepository.checkGamesPlayedAchievements();
      if (runningState.level == GameConstants.maxLevel) {
        await _achievementRepository.checkDifficultyAchievement(runningState.level);
      }

      final isHighScore = _scoreRepository.isNewHighScore(scoreRecord);
      if (isHighScore) {
        await _audioService.playHighScore();
      }

      emit(SnakeGameOver(
        finalScore: runningState.score,
        snakeLength: runningState.snake.length,
        level: runningState.level,
        isHighScore: isHighScore,
      ));
    }
  }

  /// Handle restart game event
  void _onRestartGame(
    RestartGameEvent event,
    Emitter<SnakeGameState> emit,
  ) {
    _gameTimer?.cancel();
    emit(const SnakeGameInitial());
  }

  /// Create initial snake
  List<SnakeSegment> _createInitialSnake(Maze maze) {
    final startX = GameConstants.gridColumns ~/ 2;
    final startY = GameConstants.gridRows ~/ 2;
    
    return List.generate(
      GameConstants.initialSnakeLength,
      (index) => SnakeSegment(
        position: Position(startX - index, startY),
        direction: Direction.right,
      ),
    );
  }

  /// Calculate new head position
  Position _calculateNewHeadPosition(
    Position currentHead,
    Direction direction,
    Maze maze,
  ) {
    final newPosition = currentHead + direction.delta;
    return maze.getWrappedPosition(newPosition);
  }

  /// Update snake segments
  List<SnakeSegment> _updateSnake(
    List<SnakeSegment> snake,
    Position newHead,
    Direction direction,
    bool grow,
  ) {
    final newSnake = <SnakeSegment>[
      SnakeSegment(position: newHead, direction: direction),
      ...snake,
    ];

    if (!grow && newSnake.isNotEmpty) {
      newSnake.removeLast();
    }

    return newSnake;
  }

  /// Handle campaign mode progression
  void _handleCampaignProgression(
    Emitter<SnakeGameState> emit,
    SnakeGameRunning state,
    List<SnakeSegment> snake,
    int score,
  ) {
    final nextMazeIndex = state.currentMazeIndex + 1;
    
    if (nextMazeIndex >= GameConstants.mazeCount) {
      // Campaign complete
      _achievementRepository.unlockAchievement(Achievements.campaignComplete.id);
      _audioService.playLevelComplete();
      add(const GameOverEvent());
      return;
    }

    // Move to next maze
    final mazes = MazeType.values;
    final nextMaze = MazeFactory.create(mazes[nextMazeIndex]);
    final newFood = RandomGenerator.randomFoodPosition(snake, nextMaze);

    if (newFood == null) {
      add(const GameOverEvent());
      return;
    }

    _audioService.playLevelComplete();
    
    emit(state.copyWith(
      maze: nextMaze,
      currentMazeIndex: nextMazeIndex,
      foodEatenInMaze: 0,
      foodPosition: newFood,
      score: score + GameConstants.mazeCompletionBonus,
    ));
  }

  /// Start the game loop timer
  void _startGameLoop(int level) {
    _gameTimer?.cancel();
    
    final speed = GameConstants.getSpeedForLevel(level);
    _gameTimer = Timer.periodic(
      Duration(milliseconds: speed),
      (_) => add(const UpdateFrameEvent()),
    );
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
