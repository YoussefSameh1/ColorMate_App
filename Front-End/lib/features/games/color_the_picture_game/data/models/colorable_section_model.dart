import 'dart:ui';

class ColorableSectionModel {
  final String name;
  final String correctColor;
  String? currentColor;
  final List<Offset> points;

  ColorableSectionModel({
    required this.name,
    required this.correctColor,
    this.currentColor,
    required this.points,
  });
}
