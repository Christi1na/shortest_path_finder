import '../entities/path_task.dart';
import '../entities/position.dart';

class ShortestPathFinder {
  static const List<(int, int)> _directions = [
    (0, -1),
    (0, 1),
    (-1, 0),
    (1, 0),
    (-1, -1),
    (1, -1),
    (-1, 1),
    (1, 1),
  ];

  List<Position>? findPath({
    required PathTask task,
  }) {
    final start = task.start;
    final end = task.end;

    if (start == end) {
      return [start];
    }

    final queue = <Position>[start];
    var queueIndex = 0;

    final previous = <Position, Position?>{
      start: null,
    };

    while (queueIndex < queue.length) {
      final current = queue[queueIndex++];

      for (final direction in _directions) {
        final (dx, dy) = direction;

        final x = current.x + dx;
        final y = current.y + dy;

        if (!_isInside(task, x, y)) {
          continue;
        }

        if (task.field[y][x] == 'X') {
          continue;
        }

        final next = Position(x: x, y: y);

        if (previous.containsKey(next)) {
          continue;
        }

        previous[next] = current;

        if (next == end) {
          return _reconstructPath(previous, end);
        }

        queue.add(next);
      }
    }

    return null;
  }

  bool _isInside(PathTask task, int x, int y) {
    return x >= 0 &&
        x < task.width &&
        y >= 0 &&
        y < task.height;
  }

  List<Position> _reconstructPath(
    Map<Position, Position?> previous,
    Position end,
  ) {
    final path = <Position>[];

    Position? current = end;

    while (current != null) {
      path.add(current);
      current = previous[current];
    }

    return path.reversed.toList();
  }
}