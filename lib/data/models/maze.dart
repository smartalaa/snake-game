import 'package:snake_xenzia/core/constants/game_constants.dart';
import 'package:snake_xenzia/data/models/score_record.dart';
import 'package:snake_xenzia/data/models/snake_segment.dart';

/// Represents a maze layout with wall positions
class Maze {
  /// Type of maze
  final MazeType type;
  
  /// Set of wall positions
  final Set<Position> walls;
  
  /// Whether the maze has wrap-around edges
  final bool hasWrapAround;

  const Maze({
    required this.type,
    required this.walls,
    required this.hasWrapAround,
  });

  /// Check if a position is a wall
  bool isWall(Position position) => walls.contains(position);

  /// Check if a position is valid (within bounds and not a wall)
  bool isValidPosition(Position position) {
    if (hasWrapAround) {
      // In wrap-around mode, positions wrap at edges
      return !isWall(_normalizePosition(position));
    }
    
    // Check bounds
    if (position.x < 0 || position.x >= GameConstants.gridColumns ||
        position.y < 0 || position.y >= GameConstants.gridRows) {
      return false;
    }
    
    return !isWall(position);
  }

  /// Normalize position for wrap-around
  Position _normalizePosition(Position position) {
    int x = position.x % GameConstants.gridColumns;
    int y = position.y % GameConstants.gridRows;
    
    // Handle negative wrapping
    if (x < 0) x += GameConstants.gridColumns;
    if (y < 0) y += GameConstants.gridRows;
    
    return Position(x, y);
  }

  /// Get the actual position after applying wrap-around
  Position getWrappedPosition(Position position) {
    if (!hasWrapAround) return position;
    return _normalizePosition(position);
  }
}

/// Factory for creating different maze types
class MazeFactory {
  MazeFactory._();

  /// Create a maze based on type
  static Maze create(MazeType type) {
    switch (type) {
      case MazeType.noMaze:
        return _createNoMaze();
      case MazeType.box:
        return _createBoxMaze();
      case MazeType.tunnel:
        return _createTunnelMaze();
      case MazeType.mill:
        return _createMillMaze();
      case MazeType.rails:
        return _createRailsMaze();
      case MazeType.apartment:
        return _createApartmentMaze();
    }
  }

  /// No maze - wrap-around mode
  static Maze _createNoMaze() {
    return const Maze(
      type: MazeType.noMaze,
      walls: {},
      hasWrapAround: true,
    );
  }

  /// Box maze - simple outer walls
  static Maze _createBoxMaze() {
    final Set<Position> walls = {};
    final cols = GameConstants.gridColumns;
    final rows = GameConstants.gridRows;

    // Top and bottom walls
    for (int x = 0; x < cols; x++) {
      walls.add(Position(x, 0));
      walls.add(Position(x, rows - 1));
    }

    // Left and right walls
    for (int y = 0; y < rows; y++) {
      walls.add(Position(0, y));
      walls.add(Position(cols - 1, y));
    }

    return Maze(
      type: MazeType.box,
      walls: walls,
      hasWrapAround: false,
    );
  }

  /// Tunnel maze - horizontal corridors
  static Maze _createTunnelMaze() {
    final Set<Position> walls = {};
    final cols = GameConstants.gridColumns;
    final rows = GameConstants.gridRows;

    // Outer walls
    for (int x = 0; x < cols; x++) {
      walls.add(Position(x, 0));
      walls.add(Position(x, rows - 1));
    }
    for (int y = 0; y < rows; y++) {
      walls.add(Position(0, y));
      walls.add(Position(cols - 1, y));
    }

    // Horizontal corridors
    for (int x = 3; x < cols - 3; x++) {
      walls.add(Position(x, rows ~/ 3));
      walls.add(Position(x, (rows * 2) ~/ 3));
    }

    return Maze(
      type: MazeType.tunnel,
      walls: walls,
      hasWrapAround: false,
    );
  }

  /// Mill maze - rotating windmill pattern
  static Maze _createMillMaze() {
    final Set<Position> walls = {};
    final cols = GameConstants.gridColumns;
    final rows = GameConstants.gridRows;

    // Outer walls
    for (int x = 0; x < cols; x++) {
      walls.add(Position(x, 0));
      walls.add(Position(x, rows - 1));
    }
    for (int y = 0; y < rows; y++) {
      walls.add(Position(0, y));
      walls.add(Position(cols - 1, y));
    }

    // Center point
    final centerX = cols ~/ 2;
    final centerY = rows ~/ 2;

    // Four arms extending from center
    for (int i = 2; i < cols ~/ 2 - 2; i++) {
      walls.add(Position(centerX, centerY - i)); // Up
      walls.add(Position(centerX + i, centerY)); // Right
      walls.add(Position(centerX, centerY + i)); // Down
      walls.add(Position(centerX - i, centerY)); // Left
    }

    return Maze(
      type: MazeType.mill,
      walls: walls,
      hasWrapAround: false,
    );
  }

  /// Rails maze - railroad track pattern
  static Maze _createRailsMaze() {
    final Set<Position> walls = {};
    final cols = GameConstants.gridColumns;
    final rows = GameConstants.gridRows;

    // Outer walls
    for (int x = 0; x < cols; x++) {
      walls.add(Position(x, 0));
      walls.add(Position(x, rows - 1));
    }
    for (int y = 0; y < rows; y++) {
      walls.add(Position(0, y));
      walls.add(Position(cols - 1, y));
    }

    // Vertical rails
    final rail1X = cols ~/ 3;
    final rail2X = (cols * 2) ~/ 3;

    for (int y = 2; y < rows - 2; y++) {
      if (y % 4 != 0) { // Gaps for crossing
        walls.add(Position(rail1X, y));
        walls.add(Position(rail2X, y));
      }
    }

    // Horizontal crossties
    for (int y = 5; y < rows - 5; y += 6) {
      for (int x = rail1X + 1; x < rail2X; x++) {
        if (x % 2 == 0) {
          walls.add(Position(x, y));
        }
      }
    }

    return Maze(
      type: MazeType.rails,
      walls: walls,
      hasWrapAround: false,
    );
  }

  /// Apartment maze - room-based layout
  static Maze _createApartmentMaze() {
    final Set<Position> walls = {};
    final cols = GameConstants.gridColumns;
    final rows = GameConstants.gridRows;

    // Outer walls
    for (int x = 0; x < cols; x++) {
      walls.add(Position(x, 0));
      walls.add(Position(x, rows - 1));
    }
    for (int y = 0; y < rows; y++) {
      walls.add(Position(0, y));
      walls.add(Position(cols - 1, y));
    }

    // Vertical divider
    final midX = cols ~/ 2;
    for (int y = 3; y < rows - 3; y++) {
      if (y < rows ~/ 2 - 2 || y > rows ~/ 2 + 2) { // Doorway
        walls.add(Position(midX, y));
      }
    }

    // Horizontal dividers
    final midY = rows ~/ 2;
    for (int x = 2; x < midX - 2; x++) {
      walls.add(Position(x, midY));
    }
    for (int x = midX + 2; x < cols - 2; x++) {
      walls.add(Position(x, midY));
    }

    return Maze(
      type: MazeType.apartment,
      walls: walls,
      hasWrapAround: false,
    );
  }
}
