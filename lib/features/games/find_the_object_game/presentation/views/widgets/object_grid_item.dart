import 'package:colormate_app/features/games/find_the_object_game/data/models/game_object_model.dart';
import 'package:flutter/material.dart';

class ObjectGridItem extends StatelessWidget {
  final GameObjectModel object;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;

  const ObjectGridItem({
    super.key,
    required this.object,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.maxWidth;

        double emojiSize = size * 0.35;
        double textSize = size * 0.10;
        double iconSize = size * 0.18;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.15),
              border: Border.all(
                color: isCorrect
                    ? Colors.green
                    : isWrong
                        ? Colors.red
                        : Colors.grey.shade300,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  object.emoji,
                  style: TextStyle(fontSize: emojiSize),
                ),
                SizedBox(height: size * 0.05),
                Text(
                  object.name,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isCorrect)
                  Icon(Icons.check_circle,
                      color: Colors.green, size: iconSize),
                if (isWrong)
                  Icon(Icons.cancel, color: Colors.red, size: iconSize),
              ],
            ),
          ),
        );
      },
    );
  }
}