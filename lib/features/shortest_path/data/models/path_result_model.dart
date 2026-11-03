import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_result.dart';

class PathResultModel extends PathResult {
  const PathResultModel({
    required super.taskId,
    required super.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': taskId,
      'result': {
        'steps': steps.map((position) {
          return {
            'x': position.x.toString(),
            'y': position.y.toString(),
          };
        }).toList(),
        'path': path,
      },
    };
  }
}