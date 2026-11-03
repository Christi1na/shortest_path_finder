import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_task.dart';

abstract interface class PathRepository {
  Future<List<PathTask>> getTasks();

  Future<List<SubmissionResult>> submitResults(
    List<PathResult> results,
  );
}

class SubmissionResult {
  final String taskId;
  final bool correct;

  const SubmissionResult({
    required this.taskId,
    required this.correct,
  });
}