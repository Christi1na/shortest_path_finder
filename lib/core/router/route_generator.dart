import 'package:go_router/go_router.dart';

import 'package:shortest_path_finder/core/router/app_routes.dart';
import 'package:shortest_path_finder/features/shortest_path/presentation/screens/home_screen.dart';
import 'package:shortest_path_finder/features/shortest_path/presentation/screens/process_screen.dart';
import 'package:shortest_path_finder/features/shortest_path/presentation/screens/results_screen.dart';
import 'package:shortest_path_finder/features/shortest_path/presentation/screens/result_details_screen.dart';

import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_task.dart';
import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/shortest_path/domain/repositories/path_repository.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.process,
      name: 'process',
      builder: (context, state) => const ProcessScreen(),
    ),
    GoRoute(
      path: AppRoutes.results,
      name: 'results',
      builder: (context, state) {
        final extra = state.extra as ResultsRouteData;

        return ResultsScreen(
          tasks: extra.tasks,
          results: extra.results,
          submissionResults: extra.submissionResults,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.resultDetails,
      name: 'resultDetails',
      builder: (context, state) {
        final extra = state.extra as ResultDetailsRouteData;

        return ResultDetailsScreen(
          task: extra.task,
          result: extra.result,
        );
      },
    ),
  ],
);

class ResultsRouteData {
  final List<PathTask> tasks;
  final List<PathResult> results;
  final List<SubmissionResult> submissionResults;

  const ResultsRouteData({
    required this.tasks,
    required this.results,
    required this.submissionResults,
  });
}

class ResultDetailsRouteData {
  final PathTask task;
  final PathResult result;

  const ResultDetailsRouteData({
    required this.task,
    required this.result,
  });
}