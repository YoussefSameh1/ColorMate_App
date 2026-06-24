import 'dart:ui';

class CardModel {
  final String emoji;
  final String colorName;
  final Color color;
  bool isFlipped;
  bool isMatched;
  final int id;

  CardModel({
    required this.emoji,
    required this.colorName,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
    required this.id,
  });
}
