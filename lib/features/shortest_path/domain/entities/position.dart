
class Position {
  final int x;
  final int y;

  const Position({
    required this.x,
    required this.y,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}