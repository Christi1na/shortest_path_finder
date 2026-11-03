import 'package:shortest_path_finder/features/shortest_path/domain/entities/path_task.dart';
import 'position_model.dart';

class PathTaskModel extends PathTask {
  const PathTaskModel({
    required super.id,
    required super.field,
    required super.start,
    required super.end,
  });

  factory PathTaskModel.fromJson(Map<String, dynamic> json) {
    return PathTaskModel(
      id: json['id'] as String,
      field: List<String>.from(json['field'] as List),
      start: PositionModel.fromJson(
        json['start'] as Map<String, dynamic>,
      ),
      end: PositionModel.fromJson(
        json['end'] as Map<String, dynamic>,
      ),
    );
  }
}