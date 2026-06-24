import 'dart:math';
import 'package:colormate_app/features/games/memory_match_game/data/game_data.dart';
import 'package:colormate_app/features/games/memory_match_game/data/models/card_model.dart';
import 'package:flutter/material.dart';

class MemoryGameProvider extends ChangeNotifier {
  List<CardModel> cards = [];
  List<int> flippedIndices = [];

  bool canFlip = true;

  int moves = 0;
  int matches = 0;

  void setupGame() {
    cards.clear();
    int id = 0;

    for (var data in cardData) {
      cards.add(
        CardModel(
          emoji: data['emoji'],
          colorName: '',
          color: data['color'],
          id: id++,
        ),
      );

      cards.add(
        CardModel(
          emoji: '',
          colorName: data['colorName'],
          color: data['color'],
          id: id++,
        ),
      );
    }

    cards.shuffle(Random());

    moves = 0;
    matches = 0;
    flippedIndices.clear();
    canFlip = true;

    notifyListeners();
  }

  void flipCard(int index, BuildContext context) {
    if (!canFlip ||
        cards[index].isFlipped ||
        cards[index].isMatched ||
        flippedIndices.length >= 2) {
      return;
    }

    cards[index].isFlipped = true;
    flippedIndices.add(index);

    notifyListeners();

    if (flippedIndices.length == 2) {
      moves++;
      canFlip = false;

      checkMatch(context);
    }
  }

  void checkMatch(BuildContext context) {
    final index1 = flippedIndices[0];
    final index2 = flippedIndices[1];

    final card1 = cards[index1];
    final card2 = cards[index2];

    if (card1.color == card2.color &&
        ((card1.emoji.isNotEmpty && card2.colorName.isNotEmpty) ||
            (card1.colorName.isNotEmpty && card2.emoji.isNotEmpty))) {
      Future.delayed(const Duration(milliseconds: 500), () {
        cards[index1].isMatched = true;
        cards[index2].isMatched = true;

        matches++;
        flippedIndices.clear();
        canFlip = true;

        notifyListeners();

        if (matches == cardData.length) {
          Future.delayed(const Duration(milliseconds: 400), () {
            showWinDialog(context);
          });
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 900), () {
        cards[index1].isFlipped = false;
        cards[index2].isFlipped = false;

        flippedIndices.clear();
        canFlip = true;

        notifyListeners();
      });
    }
  }

  void showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
            title: const Text('🎉 Congratulations!'),
            content: Text('You matched all colors in $moves moves!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  setupGame();
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
    );
  }
}
