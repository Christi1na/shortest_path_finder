import 'package:shortest_path_finder/features/shortest_path/domain/repositories/path_repository.dart';

class SubmissionResultModel extends SubmissionResult {
  const SubmissionResultModel({
    required super.taskId,
    required super.correct,
  });

  factory SubmissionResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubmissionResultModel(
      taskId: json['id'] as String,
      correct: json['correct'] as bool,
    );
  }
}