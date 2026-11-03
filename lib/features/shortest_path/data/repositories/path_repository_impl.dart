
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_repository.dart';
import '../datasources/path_remote_data_source.dart';
import '../models/path_result_model.dart';
// import '../models/path_task_model.dart';

class PathRepositoryImpl implements PathRepository {
  final PathRemoteDataSource remoteDataSource;

  PathRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PathTask>> getTasks() async {
    return remoteDataSource.getTasks();
  }

  @override
  Future<List<SubmissionResult>> submitResults(
    List<PathResult> results,
  ) async {
    final models = results.map((result) {
      return PathResultModel(
        taskId: result.taskId,
        steps: result.steps,
      );
    }).toList();

    return remoteDataSource.submitResults(models);
  }
}