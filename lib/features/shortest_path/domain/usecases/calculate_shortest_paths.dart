import '../algorithms/shortest_path_finder.dart';
import '../entities/path_result.dart';
import '../entities/path_task.dart';

class CalculateShortestPaths {
  final ShortestPathFinder pathFinder;

  CalculateShortestPaths(this.pathFinder);

  List<PathResult> call(
    List<PathTask> tasks, {
    void Function(double progress)? onProgress,
  }) {
    final results = <PathResult>[];

    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];

      final steps = pathFinder.findPath(task: task);

      results.add(
        PathResult(
          taskId: task.id,
          steps: steps ?? [],
        ),
      );

      onProgress?.call((i + 1) / tasks.length);
    }

    return results;
  }
}