import 'package:flutter/material.dart';

import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/path_grid.dart';

class ResultDetailsScreen extends StatelessWidget {
  final PathTask task;
  final PathResult result;

  const ResultDetailsScreen({
    super.key,
    required this.task,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Preview screen',
      ),
      body: SingleChildScrollView(
        child: PathGrid(
          task: task,
          result: result,
        ),
      ),
    );
  }
}