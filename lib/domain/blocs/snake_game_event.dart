part of 'snake_game_bloc.dart';

/// Base class for all snake game events
abstract class SnakeGameEvent extends Equatable {
  const SnakeGameEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start a new game
class StartGameEvent extends SnakeGameEvent {
  final GameSettings settings;
  final bool isCampaign;

  const StartGameEvent({
    required this.settings,
    this.isCampaign = false,
  });

  @override
  List<Object?> get props => [settings, isCampaign];
}

/// Event to pause the game
class PauseGameEvent extends SnakeGameEvent {
  const PauseGameEvent();
}

/// Event to resume the game
class ResumeGameEvent extends SnakeGameEvent {
  const ResumeGameEvent();
}

/// Event to change snake direction
class ChangeDirectionEvent extends SnakeGameEvent {
  final Direction direction;

  const ChangeDirectionEvent(this.direction);

  @override
  List<Object?> get props => [direction];
}

/// Event to update game frame (game tick)
class UpdateFrameEvent extends SnakeGameEvent {
  const UpdateFrameEvent();
}

/// Event when game ends
class GameOverEvent extends SnakeGameEvent {
  const GameOverEvent();
}

/// Event when campaign mode is successfully completed
class CampaignCompleteEvent extends SnakeGameEvent {
  final List<SnakeSegment> finalSnake;
  final int finalScore;
  final int mazesCleared;

  const CampaignCompleteEvent({
    required this.finalSnake,
    required this.finalScore,
    required this.mazesCleared,
  });

  @override
  List<Object?> get props => [finalSnake, finalScore, mazesCleared];
}

/// Event to restart the game
class RestartGameEvent extends SnakeGameEvent {
  const RestartGameEvent();
}
