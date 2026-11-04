import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_repository.dart';
import '../../domain/usecases/calculate_shortest_paths.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/submit_results.dart';

part 'shortest_path_event.dart';
part 'shortest_path_state.dart';

class ShortestPathBloc
    extends Bloc<ShortestPathEvent, ShortestPathState> {
  final GetTasks getTasks;
  final CalculateShortestPaths calculateShortestPaths;
  final SubmitResults submitResults;

  ShortestPathBloc({
    required this.getTasks,
    required this.calculateShortestPaths,
    required this.submitResults,
  }) : super(ShortestPathInitial()) {
    on<StartCalculation>(_onStartCalculation);
    on<SubmitPathResults>(_onSubmitPathResults);
  }

  Future<void> _onStartCalculation(
    StartCalculation event,
    Emitter<ShortestPathState> emit,
  ) async {
    emit(ShortestPathLoading());

    try {
      final tasks = await getTasks(event.apiUrl);

      if (tasks.isEmpty) {
        emit(
          ShortestPathError(
            message: 'No tasks received from server',
          ),
        );
        return;
      }

      emit(
        ShortestPathCalculating(
          progress: 0,
          tasks: tasks,
        ),
      );

      final results = await calculateShortestPaths(
        tasks,
        onProgress: (progress) {
          emit(
            ShortestPathCalculating(
              progress: progress,
              tasks: tasks,
            ),
          );
        },
      );

      emit(
        ShortestPathReady(
          apiUrl: event.apiUrl,
          tasks: tasks,
          results: results,
        ),
      );
    } catch (e) {
      emit(
        ShortestPathError(
          message: _mapError(e),
        ),
      );
    }
  }

  Future<void> _onSubmitPathResults(
    SubmitPathResults event,
    Emitter<ShortestPathState> emit,
  ) async {
    final currentState = state;
    if (currentState is ShortestPathSubmitting) return;

    late final String apiUrl;
    late final List<PathTask> tasks;
    late final List<PathResult> results;

    if (currentState is ShortestPathReady) {
      apiUrl = currentState.apiUrl;
      tasks = currentState.tasks;
      results = currentState.results;
    } else if (currentState is ShortestPathError &&
        currentState.apiUrl != null &&
        currentState.tasks != null &&
        currentState.results != null) {
      apiUrl = currentState.apiUrl!;
      tasks = currentState.tasks!;
      results = currentState.results!;
    } else {
      return;
    }

    emit(
      ShortestPathSubmitting(
        apiUrl: apiUrl,
        tasks: tasks,
        results: results,
      ),
    );

    try {
      final submissionResults = await submitResults(
        apiUrl: apiUrl,
        results: results,
      );

      emit(
        ShortestPathCompleted(
          tasks: tasks,
          results: results,
          submissionResults: submissionResults,
        ),
      );
    } catch (e) {
      emit(
        ShortestPathError(
          message: _mapError(e),
          apiUrl: apiUrl,
          tasks: tasks,
          results: results,
        ),
      );
    }
  }

  String _mapError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
