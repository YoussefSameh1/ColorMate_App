import 'package:colormate_app/features/games/memory_match_game/data/models/card_model.dart';
import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const MemoryCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color:
              card.isMatched
                  ? Colors.green.shade200
                  : card.isFlipped
                  ? Colors.white
                  : Colors.indigo.shade300,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: card.isMatched ? Colors.green : Colors.indigo.shade700,
            width: 3,
          ),
        ),
        child: Center(
          child:
              card.isMatched
                  ? const Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Colors.green,
                  )
                  : card.isFlipped
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (card.emoji.isNotEmpty)
                        Text(card.emoji, style: const TextStyle(fontSize: 50)),
                      if (card.colorName.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: card.color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: card.color, width: 2),
                          ),
                          child: Text(
                            card.colorName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  )
                  : const Text(
                    '?',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
