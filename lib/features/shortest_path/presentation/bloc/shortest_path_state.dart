part of 'shortest_path_bloc.dart';

sealed class ShortestPathState extends Equatable {
  const ShortestPathState();
  
  @override
  List<Object> get props => [];
}

final class ShortestPathInitial extends ShortestPathState {}

class ShortestPathLoading extends ShortestPathState {}

class ShortestPathCalculating extends ShortestPathState {
  final double progress;
  final List<PathTask> tasks;

  const ShortestPathCalculating({
    required this.progress,
    required this.tasks,
  });
}

class ShortestPathReady extends ShortestPathState {
  final String apiUrl;
  final List<PathTask> tasks;
  final List<PathResult> results;

  const ShortestPathReady({
    required this.apiUrl,
    required this.tasks,
    required this.results,
  });
}

class ShortestPathSubmitting extends ShortestPathState {
  final String apiUrl;
  final List<PathTask> tasks;
  final List<PathResult> results;

  const ShortestPathSubmitting({
    required this.apiUrl,
    required this.tasks,
    required this.results,
  });
}

class ShortestPathCompleted extends ShortestPathState {
  final List<PathTask> tasks;
  final List<PathResult> results;
  final List<SubmissionResult> submissionResults;

  const ShortestPathCompleted({
    required this.tasks,
    required this.results,
    required this.submissionResults,
  });
}

class ShortestPathError extends ShortestPathState {
  final String message;
  final List<PathTask>? tasks;
  final List<PathResult>? results;
  final String? apiUrl;

  const ShortestPathError({
    required this.message,
    this.tasks,
    this.results,
    this.apiUrl,
  });
}
