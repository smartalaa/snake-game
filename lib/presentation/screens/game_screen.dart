import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/core/constants/app_colors.dart';
import 'package:snake_xenzia/core/constants/app_text_styles.dart';
import 'package:snake_xenzia/data/models/snake_segment.dart';
import 'package:snake_xenzia/domain/blocs/snake_game_bloc.dart';
import 'package:snake_xenzia/presentation/widgets/snake_board.dart';

/// The main game screen where Snake Xenzia is played
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus for keyboard input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<SnakeGameBloc, SnakeGameState>(
          listener: (context, state) {
            if (state is SnakeGameOver) {
              _showGameOverDialog(context, state);
            }
          },
          builder: (context, state) {
            return RawKeyboardListener(
              focusNode: _focusNode,
              onKey: (event) => _handleKeyboard(context, event),
              child: GestureDetector(
                onTap: () {
                  // Resume game if paused
                  if (state is SnakeGamePaused) {
                    context.read<SnakeGameBloc>().add(const ResumeGameEvent());
                  }
                },
                onVerticalDragEnd: (details) => _handleVerticalSwipe(context, details),
                onHorizontalDragEnd: (details) => _handleHorizontalSwipe(context, details),
                child: Container(
                  color: state is SnakeGameRunning 
                      ? state.settings.theme.colors.background
                      : Colors.black,
                  child: Column(
                    children: [
                      // Score Header
                      _buildScoreHeader(context, state),

                      // Game Board
                      Expanded(
                        child: Center(
                          child: const SnakeBoardWidget(),
                        ),
                      ),

                      // Controls
                      _buildControlHints(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, SnakeGameState state) {
    Color textColor = Colors.white;
    String scoreText = 'Score: 0';
    String levelText = 'Level: 1';

    if (state is SnakeGameRunning) {
      textColor = state.settings.theme.colors.text;
      scoreText = 'Score: ${state.score}';
      levelText = 'Level: ${state.level}';
    } else if (state is SnakeGamePaused) {
      textColor = state.settings.theme.colors.text;
      scoreText = 'Score: ${state.score}';
      levelText = 'Level: ${state.level}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: textColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            scoreText,
            style: AppTextStyles.score.colored(textColor),
          ),
          Text(
            levelText,
            style: AppTextStyles.levelIndicator.colored(textColor),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  state is SnakeGamePaused ? Icons.play_arrow : Icons.pause,
                  color: textColor,
                ),
                onPressed: () {
                  if (state is SnakeGameRunning) {
                    context.read<SnakeGameBloc>().add(const PauseGameEvent());
                  } else if (state is SnakeGamePaused) {
                    context.read<SnakeGameBloc>().add(const ResumeGameEvent());
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: () {
                  _showExitDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlHints(BuildContext context, SnakeGameState state) {
    Color textColor = Colors.white70;
    
    if (state is SnakeGameRunning || state is SnakeGamePaused) {
      if (state is SnakeGameRunning) {
        textColor = state.settings.theme.colors.textSecondary;
      } else if (state is SnakeGamePaused) {
        textColor = state.settings.theme.colors.textSecondary;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: textColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Text(
        'Swipe or use arrow keys (↑ ↓ ← →) to move • Tap to pause/resume',
        style: AppTextStyles.caption.colored(textColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _handleVerticalSwipe(BuildContext context, DragEndDetails details) {
    final state = context.read<SnakeGameBloc>().state;
    if (state is! SnakeGameRunning) return;

    if (details.primaryVelocity! < -50) {
      // Swipe up
      context.read<SnakeGameBloc>().add(const ChangeDirectionEvent(Direction.up));
    } else if (details.primaryVelocity! > 50) {
      // Swipe down
      context.read<SnakeGameBloc>().add(const ChangeDirectionEvent(Direction.down));
    }
  }

  void _handleHorizontalSwipe(BuildContext context, DragEndDetails details) {
    final state = context.read<SnakeGameBloc>().state;
    if (state is! SnakeGameRunning) return;

    if (details.primaryVelocity! < -50) {
      // Swipe left
      context.read<SnakeGameBloc>().add(const ChangeDirectionEvent(Direction.left));
    } else if (details.primaryVelocity! > 50) {
      // Swipe right
      context.read<SnakeGameBloc>().add(const ChangeDirectionEvent(Direction.right));
    }
  }

  void _handleKeyboard(BuildContext context, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;

    final state = context.read<SnakeGameBloc>().state;
    if (state is! SnakeGameRunning) return;

    Direction? direction;
    
    if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.keyW) {
      direction = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.keyS) {
      direction = Direction.down;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.keyA) {
      direction = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.keyD) {
      direction = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.space) {
      // Pause on space
      context.read<SnakeGameBloc>().add(const PauseGameEvent());
      return;
    }

    if (direction != null) {
      context.read<SnakeGameBloc>().add(ChangeDirectionEvent(direction));
    }
  }

  void _showGameOverDialog(BuildContext context, SnakeGameOver state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF9FD849), width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.videogame_asset_off, color: Color(0xFFE94560)),
            SizedBox(width: 8),
            Text(
              'Game Over',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Final Score: ${state.finalScore}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Snake Length: ${state.snakeLength}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Level Reached: ${state.level}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            if (state.isHighScore) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 32),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '🎉 New High Score!',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Main Menu',
              style: TextStyle(color: Color(0xFF9FD849)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9FD849),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SnakeGameBloc>().add(const RestartGameEvent());
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF9FD849), width: 2),
        ),
        title: const Text(
          'Exit Game?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your current progress will be lost.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9FD849)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE94560),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
