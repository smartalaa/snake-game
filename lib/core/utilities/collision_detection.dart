import 'dart:math';
import 'package:snake_xenzia/core/constants/game_constants.dart';
import 'package:snake_xenzia/data/models/snake_segment.dart';
import 'package:snake_xenzia/data/models/maze.dart';

/// Utility class for collision detection in the game
class CollisionDetection {
  CollisionDetection._();

  /// Check if snake head collides with its own body
  static bool checkSelfCollision(List<SnakeSegment> snake) {
    if (snake.length < 2) return false;
    
    final head = snake.first.position;
    
    // Check if head position matches any body segment (skip the head itself)
    for (int i = 1; i < snake.length; i++) {
      if (snake[i].position == head) {
        return true;
      }
    }
    
    return false;
  }

  /// Check if position collides with snake body
  static bool checkPositionCollision(Position position, List<SnakeSegment> snake) {
    return snake.any((segment) => segment.position == position);
  }

  /// Check if snake head collides with maze walls
  static bool checkWallCollision(Position head, Maze maze) {
    return maze.isWall(head);
  }

  /// Check if snake head is out of bounds (for non-wrap mazes)
  static bool checkBoundsCollision(Position head) {
    return head.x < 0 ||
           head.x >= GameConstants.gridColumns ||
           head.y < 0 ||
           head.y >= GameConstants.gridRows;
  }

  /// Check if position is valid for food placement
  static bool isValidFoodPosition(
    Position position,
    List<SnakeSegment> snake,
    Maze maze,
  ) {
    // Cannot be on snake
    if (checkPositionCollision(position, snake)) {
      return false;
    }

    // Cannot be on wall
    if (maze.isWall(position)) {
      return false;
    }

    // Must be within bounds
    if (!maze.hasWrapAround && checkBoundsCollision(position)) {
      return false;
    }

    return true;
  }

  /// Get all valid positions for food placement
  static List<Position> getValidFoodPositions(
    List<SnakeSegment> snake,
    Maze maze,
  ) {
    final validPositions = <Position>[];
    
    for (int y = 0; y < GameConstants.gridRows; y++) {
      for (int x = 0; x < GameConstants.gridColumns; x++) {
        final position = Position(x, y);
        if (isValidFoodPosition(position, snake, maze)) {
          validPositions.add(position);
        }
      }
    }
    
    return validPositions;
  }

  /// Check for any collision (self, wall, or bounds)
  static bool checkAnyCollision(
    Position head,
    List<SnakeSegment> snake,
    Maze maze,
  ) {
    // Check self collision
    if (checkPositionCollision(head, snake.skip(1).toList())) {
      return true;
    }

    // Check wall collision
    if (checkWallCollision(head, maze)) {
      return true;
    }

    // Check bounds collision (only for non-wrap mazes)
    if (!maze.hasWrapAround && checkBoundsCollision(head)) {
      return true;
    }

    return false;
  }
}

/// Utility class for random number generation
class RandomGenerator {
  static final Random _random = Random();

  /// Get a random integer between min (inclusive) and max (exclusive)
  static int nextInt(int max) => _random.nextInt(max);

  /// Get a random integer between min (inclusive) and max (inclusive)
  static int nextIntInRange(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Get a random double between 0.0 (inclusive) and 1.0 (exclusive)
  static double nextDouble() => _random.nextDouble();

  /// Get a random boolean
  static bool nextBool() => _random.nextBool();

  /// Get a random element from a list
  static T randomElement<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError('Cannot get random element from empty list');
    }
    return list[nextInt(list.length)];
  }

  /// Get a random position on the grid
  static Position randomPosition() {
    return Position(
      nextInt(GameConstants.gridColumns),
      nextInt(GameConstants.gridRows),
    );
  }

  /// Get a random valid food position
  static Position? randomFoodPosition(
    List<SnakeSegment> snake,
    Maze maze,
  ) {
    final validPositions = CollisionDetection.getValidFoodPositions(snake, maze);
    
    if (validPositions.isEmpty) {
      return null; // No valid positions available
    }
    
    return randomElement(validPositions);
  }

  /// Shuffle a list
  static List<T> shuffle<T>(List<T> list) {
    final shuffled = List<T>.from(list);
    shuffled.shuffle(_random);
    return shuffled;
  }
}
