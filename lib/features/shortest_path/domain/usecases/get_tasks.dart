import '../entities/path_task.dart';
import '../repositories/path_repository.dart';

class GetTasks {
  final PathRepository repository;

  GetTasks(this.repository);

  Future<List<PathTask>> call(String apiUrl) {
    return repository.getTasks(apiUrl);
  }
}