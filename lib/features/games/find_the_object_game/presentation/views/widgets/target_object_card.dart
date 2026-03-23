import 'package:colormate_app/features/games/find_the_object_game/data/models/game_object_model.dart';
import 'package:flutter/material.dart';

class TargetObjectCard extends StatelessWidget {
  final GameObjectModel targetObject;

  const TargetObjectCard({super.key, required this.targetObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Find the',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: targetObject.color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: targetObject.color, width: 3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  targetObject.colorName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color:
                        targetObject.color.computeLuminance() > 0.5
                            ? Colors.black
                            : targetObject.color,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Object',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Icon(Icons.circle, color: targetObject.color, size: 60),
        ],
      ),
    );
  }
}
