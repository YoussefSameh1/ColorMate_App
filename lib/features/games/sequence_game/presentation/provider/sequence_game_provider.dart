import 'dart:async';
import 'dart:math';
import 'package:colormate_app/features/games/sequence_game/data/models/color_button_model.dart';
import 'package:flutter/material.dart';

class SequenceGameProvider extends ChangeNotifier {
  final List<ColorButtonModel> colors = [
    ColorButtonModel(name: 'Red', color: Colors.red, icon: Icons.favorite),
    ColorButtonModel(name: 'Blue', color: Colors.blue, icon: Icons.water_drop),
    ColorButtonModel(name: 'Green', color: Colors.green, icon: Icons.eco),
    ColorButtonModel(
      name: 'Yellow',
      color: Colors.yellow,
      icon: Icons.wb_sunny,
    ),
  ];

  List<int> sequence = [];
  List<int> playerSequence = [];

  int currentLevel = 1;
  int score = 0;

  bool isPlaying = false;
  bool isPlayerTurn = false;
  bool isProcessingTap = false;

  int? highlightedIndex;

  List<int> buttonOrder = [0, 1, 2, 3];

  void startGame() {
    sequence.clear();
    playerSequence.clear();

    currentLevel = 1;
    score = 0;

    isPlaying = true;

    notifyListeners();

    nextLevel();
  }

  void nextLevel() {
    playerSequence.clear();
    isPlayerTurn = false;
    isProcessingTap = false;

    currentLevel = sequence.length + 1;

    shuffleButtons();

    sequence.add(Random().nextInt(colors.length));

    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1000), () {
      playSequence();
    });
  }

  void shuffleButtons() {
    buttonOrder.shuffle();
  }

  Future<void> playSequence() async {
    for (int i = 0; i < sequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));

      highlightedIndex = sequence[i];
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 400));

      highlightedIndex = null;
      notifyListeners();
    }

    isPlayerTurn = true;
    notifyListeners();
  }

  Future<bool> playerTap(int index) async {
    if (!isPlayerTurn || !isPlaying || isProcessingTap)
      return false; // Add isProcessingTap check

    isProcessingTap = true; // Lock taps
    playerSequence.add(index);

    highlightedIndex = index;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    highlightedIndex = null;
    isProcessingTap = false; // Unlock taps
    notifyListeners();

    if (playerSequence.last != sequence[playerSequence.length - 1]) {
      gameOver();
      return true;
    }

    if (playerSequence.length == sequence.length) {
      score += 10 * currentLevel;
      isPlayerTurn = false;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 1500));
      nextLevel();
    }

    return false;
  }

  void gameOver() {
    isPlaying = false;
    isPlayerTurn = false;
    isProcessingTap = false;
    notifyListeners();
  }
}
