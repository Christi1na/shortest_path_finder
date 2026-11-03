
import 'position.dart';

class PathTask {
  final String id;

  final List<String> field;

  final Position start;
  final Position end;

  const PathTask({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  int get height => field.length;

  int get width => field.isEmpty ? 0 : field.first.length;
}