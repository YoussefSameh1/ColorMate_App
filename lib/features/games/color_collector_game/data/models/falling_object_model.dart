import 'dart:ui';

class FallingObject {
  final String emoji;
  final String name;
  final String colorName;
  final Color color;
  double x;
  double y;
  final String id;
  bool isDragging;

  FallingObject({
    required this.emoji,
    required this.name,
    required this.colorName,
    required this.color,
    required this.x,
    required this.y,
    required this.id,
    this.isDragging = false,
  });
}
