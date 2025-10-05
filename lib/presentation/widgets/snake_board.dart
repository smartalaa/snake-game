import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/core/constants/game_constants.dart';
import 'package:snake_xenzia/core/constants/app_colors.dart';
import 'package:snake_xenzia/data/models/snake_segment.dart';
import 'package:snake_xenzia/data/models/maze.dart';
import 'package:snake_xenzia/domain/blocs/snake_game_bloc.dart';

/// Widget that renders the snake game board using CustomPainter
class SnakeBoardWidget extends StatelessWidget {
  const SnakeBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SnakeGameBloc, SnakeGameState>(
      builder: (context, state) {
        if (state is SnakeGameInitial) {
          return const Center(
            child: Text(
              'Press Start to Begin',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        if (state is SnakeGamePaused) {
          return Stack(
            children: [
              CustomPaint(
                painter: GameBoardPainter(
                  snake: state.snake,
                  food: state.foodPosition,
                  maze: state.maze,
                  colors: state.settings.theme.colors,
                ),
                size: Size(
                  GameConstants.gridColumns * GameConstants.cellSize,
                  GameConstants.gridRows * GameConstants.cellSize,
                ),
              ),
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pause_circle_outline, size: 64, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'PAUSED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to continue',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        if (state is SnakeGameRunning) {
          return CustomPaint(
            painter: GameBoardPainter(
              snake: state.snake,
              food: state.foodPosition,
              maze: state.maze,
              colors: state.settings.theme.colors,
            ),
            size: Size(
              GameConstants.gridColumns * GameConstants.cellSize,
              GameConstants.gridRows * GameConstants.cellSize,
            ),
          );
        }

        return const Center(
          child: Text(
            'Game Over',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      },
    );
  }
}

/// Custom painter for rendering the game board
class GameBoardPainter extends CustomPainter {
  final List<SnakeSegment> snake;
  final Position food;
  final Maze maze;
  final dynamic colors;

  GameBoardPainter({
    required this.snake,
    required this.food,
    required this.maze,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = GameConstants.cellSize.toDouble();

    // Draw background
    final backgroundPaint = Paint()..color = colors.background;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Draw grid lines (optional, subtle)
    _drawGrid(canvas, size, cellSize);

    // Draw maze walls
    _drawWalls(canvas, cellSize);

    // Draw food
    _drawFood(canvas, cellSize);

    // Draw snake
    _drawSnake(canvas, cellSize);
  }

  void _drawGrid(Canvas canvas, Size size, double cellSize) {
    final gridPaint = Paint()
      ..color = colors.grid.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Vertical lines
    for (int i = 0; i <= GameConstants.gridColumns; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        gridPaint,
      );
    }

    // Horizontal lines
    for (int i = 0; i <= GameConstants.gridRows; i++) {
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        gridPaint,
      );
    }
  }

  void _drawWalls(Canvas canvas, double cellSize) {
    final wallPaint = Paint()
      ..color = colors.wall
      ..style = PaintingStyle.fill;

    for (final wall in maze.walls) {
      canvas.drawRect(
        Rect.fromLTWH(
          wall.x * cellSize,
          wall.y * cellSize,
          cellSize,
          cellSize,
        ),
        wallPaint,
      );

      // Add a border to walls for 3D effect
      final borderPaint = Paint()
        ..color = colors.wall.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawRect(
        Rect.fromLTWH(
          wall.x * cellSize,
          wall.y * cellSize,
          cellSize,
          cellSize,
        ),
        borderPaint,
      );
    }
  }

  void _drawFood(Canvas canvas, double cellSize) {
    final foodPaint = Paint()
      ..color = colors.food
      ..style = PaintingStyle.fill;

    // Draw food as a circle
    canvas.drawCircle(
      Offset(
        food.x * cellSize + cellSize / 2,
        food.y * cellSize + cellSize / 2,
      ),
      cellSize / 2 - 2,
      foodPaint,
    );

    // Add glow effect
    final glowPaint = Paint()
      ..color = colors.food.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(
      Offset(
        food.x * cellSize + cellSize / 2,
        food.y * cellSize + cellSize / 2,
      ),
      cellSize / 2,
      glowPaint,
    );
  }

  void _drawSnake(Canvas canvas, double cellSize) {
    for (int i = 0; i < snake.length; i++) {
      final segment = snake[i];
      final isHead = i == 0;
      
      final segmentPaint = Paint()
        ..color = isHead ? colors.snakeHead : colors.snakeBody
        ..style = PaintingStyle.fill;

      // Draw rounded rectangle for snake segments
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            segment.position.x * cellSize + 1,
            segment.position.y * cellSize + 1,
            cellSize - 2,
            cellSize - 2,
          ),
          const Radius.circular(3),
        ),
        segmentPaint,
      );

      // Add highlight to head
      if (isHead) {
        final highlightPaint = Paint()
          ..color = colors.snakeHead.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              segment.position.x * cellSize + 2,
              segment.position.y * cellSize + 2,
              cellSize - 4,
              cellSize - 4,
            ),
            const Radius.circular(2),
          ),
          highlightPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GameBoardPainter oldDelegate) {
    return oldDelegate.snake != snake ||
        oldDelegate.food != food ||
        oldDelegate.maze != maze;
  }
}
