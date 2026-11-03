import 'package:shortest_path_finder/features/shortest_path/domain/entities/position.dart';

class PositionModel extends Position {
  const PositionModel({
    required super.x,
    required super.y,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      x: json['x'] as int,
      y: json['y'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}