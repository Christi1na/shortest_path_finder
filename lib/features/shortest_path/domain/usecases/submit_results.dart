import '../entities/path_result.dart';
import '../repositories/path_repository.dart';

class SubmitResults {
  final PathRepository repository;

  SubmitResults(this.repository);

  Future<List<SubmissionResult>> call({
    required String apiUrl,
    required List<PathResult> results,
  }) {
    return repository.submitResults(apiUrl, results);
  }
}