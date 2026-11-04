import 'package:flutter/material.dart';

import '../../domain/entities/path_task.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/position.dart';

class PathGrid extends StatelessWidget {
  final PathTask task;
  final PathResult result;

  const PathGrid({
    super.key,
    required this.task,
    required this.result,
  });

  static const Color startColor = Color(0xFF64FFDA);
  static const Color endColor = Color(0xFF009688);
  static const Color blockedColor = Color(0xFF000000);
  static const Color pathColor = Color(0xFF4CAF50);
  static const Color emptyColor = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final pathPositions = result.steps.toSet();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;

            final cellSize = availableWidth / task.width;

            return SizedBox(
              width: availableWidth,
              height: cellSize * task.height,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: task.width * task.height,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: task.width,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final x = index % task.width;
                  final y = index ~/ task.width;

                  final position = Position(x: x, y: y);

                  final isStart = position == task.start;
                  final isEnd = position == task.end;
                  final isBlocked = task.field[y][x] == 'X';
                  final isPath = pathPositions.contains(position);

                  final color = _getCellColor(
                    isStart: isStart,
                    isEnd: isEnd,
                    isBlocked: isBlocked,
                    isPath: isPath,
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: Colors.black,
                        width: 0.7,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '($x,$y)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isBlocked
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isBlocked || isEnd
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        Text(
          result.path.replaceAll(',', '.').replaceAll('->', ' -> '),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getCellColor({
    required bool isStart,
    required bool isEnd,
    required bool isBlocked,
    required bool isPath,
  }) {
    if (isStart) return startColor;
    if (isEnd) return endColor;
    if (isBlocked) return blockedColor;
    if (isPath) return pathColor;

    return emptyColor;
  }
}