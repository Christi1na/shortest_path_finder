import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/route_generator.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_repository.dart';
import '../widgets/custom_app_bar.dart';

class ResultsScreen extends StatelessWidget {
  final List<PathTask> tasks;
  final List<PathResult> results;
  final List<SubmissionResult> submissionResults;

  const ResultsScreen({
    super.key,
    required this.tasks,
    required this.results,
    required this.submissionResults,
  });

  @override
  Widget build(BuildContext context) {
    final tasksById = {
      for (final task in tasks) task.id: task,
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Result list screen',
      ),
      body: ListView.separated(
        itemCount: results.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color.fromARGB(255, 194, 193, 193),),
        itemBuilder: (context, index) {
          final result = results[index];
          final task = tasksById[result.taskId];

          final item = GestureDetector(
            onTap: task == null
                ? null
                : () {
                    context.push(
                      AppRoutes.resultDetails,
                      extra: ResultDetailsRouteData(
                        task: task,
                        result: result,
                      ),
                    );
                  },
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  result.steps.isEmpty ? 'No path found' : result.path,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );

          if (index == results.length - 1) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                item,
                const Divider(
                  height: 1,
                  color: Color.fromARGB(255, 194, 193, 193),
                ),
              ],
            );
          }

          return item;
        },
      ),
    );
  }
}