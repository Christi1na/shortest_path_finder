
import 'position.dart';

class PathResult {
  final String taskId;
  final List<Position> steps;

  const PathResult({
    required this.taskId,
    required this.steps,
  });

  String get path => steps
      .map((position) => '(${position.x},${position.y})')
      .join('->');
}