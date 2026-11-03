
import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/features/shortest_path/domain/algorithms/shortest_path_finder.dart';
import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_task.dart';
import 'package:shortest_path_finder/features/shortest_path/domain/entities/position.dart';

void main() {
  late ShortestPathFinder finder;

  setUp(() {
    finder = ShortestPathFinder();
  });

  test('finds path for first API task', () {
    final task = PathTask(
      id: '1',
      field: [
        '.X.',
        '.X.',
        '...',
      ],
      start: const Position(x: 2, y: 1),
      end: const Position(x: 0, y: 2),
    );

    final result = finder.findPath(task: task);

    expect(result, isNotNull);
    expect(result!.length - 1, 2);
    expect(result.first, task.start);
    expect(result.last, task.end);
  });
}