import 'package:equatable/equatable.dart';

/// Represents a position on the game grid
class Position extends Equatable {
  /// X coordinate (column)
  final int x;
  
  /// Y coordinate (row)
  final int y;

  const Position(this.x, this.y);

  /// Create a new position with updated coordinates
  Position copyWith({int? x, int? y}) {
    return Position(
      x ?? this.x,
      y ?? this.y,
    );
  }

  /// Add another position to this position
  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  /// Subtract another position from this position
  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }

  /// Check if this position is equal to another
  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => 'Position($x, $y)';

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
  };

  /// Create from JSON
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      json['x'] as int,
      json['y'] as int,
    );
  }
}

/// Represents a segment of the snake's body
class SnakeSegment extends Equatable {
  /// Position of this segment on the grid
  final Position position;
  
  /// Direction this segment is facing (for rendering)
  final Direction? direction;

  const SnakeSegment({
    required this.position,
    this.direction,
  });

  /// Create a copy with updated values
  SnakeSegment copyWith({
    Position? position,
    Direction? direction,
  }) {
    return SnakeSegment(
      position: position ?? this.position,
      direction: direction ?? this.direction,
    );
  }

  @override
  List<Object?> get props => [position, direction];

  @override
  String toString() => 'SnakeSegment(position: $position, direction: $direction)';

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'position': position.toJson(),
    'direction': direction?.index,
  };

  /// Create from JSON
  factory SnakeSegment.fromJson(Map<String, dynamic> json) {
    return SnakeSegment(
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      direction: json['direction'] != null 
          ? Direction.values[json['direction'] as int]
          : null,
    );
  }
}

/// Possible directions for snake movement
enum Direction {
  up,
  down,
  left,
  right;

  /// Get the position delta for this direction
  Position get delta {
    switch (this) {
      case Direction.up:
        return const Position(0, -1);
      case Direction.down:
        return const Position(0, 1);
      case Direction.left:
        return const Position(-1, 0);
      case Direction.right:
        return const Position(1, 0);
    }
  }

  /// Check if this direction is opposite to another
  bool isOpposite(Direction other) {
    return (this == Direction.up && other == Direction.down) ||
           (this == Direction.down && other == Direction.up) ||
           (this == Direction.left && other == Direction.right) ||
           (this == Direction.right && other == Direction.left);
  }

  /// Get the opposite direction
  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }

  /// Turn left relative to current direction
  Direction turnLeft() {
    switch (this) {
      case Direction.up:
        return Direction.left;
      case Direction.left:
        return Direction.down;
      case Direction.down:
        return Direction.right;
      case Direction.right:
        return Direction.up;
    }
  }

  /// Turn right relative to current direction
  Direction turnRight() {
    switch (this) {
      case Direction.up:
        return Direction.right;
      case Direction.right:
        return Direction.down;
      case Direction.down:
        return Direction.left;
      case Direction.left:
        return Direction.up;
    }
  }
}
