import 'package:colormate_app/features/games/sequence_game/data/models/color_button_model.dart';
import 'package:flutter/material.dart';

class ColorButtonTile extends StatelessWidget {
  final ColorButtonModel colorButton;
  final bool isHighlighted;
  final bool canTap;
  final VoidCallback? onTap;

  const ColorButtonTile({
    super.key,
    required this.colorButton,
    required this.isHighlighted,
    required this.canTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:
              isHighlighted
                  ? colorButton.color
                  : colorButton.color.withOpacity(canTap ? 0.7 : 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHighlighted ? Colors.white : colorButton.color,
            width: isHighlighted ? 5 : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: colorButton.color.withOpacity(isHighlighted ? 0.6 : 0.3),
              blurRadius: isHighlighted ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(colorButton.icon, size: 60, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              colorButton.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
