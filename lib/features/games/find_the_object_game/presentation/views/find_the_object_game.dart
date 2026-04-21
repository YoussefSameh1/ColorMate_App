import 'dart:math';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/games/find_the_object_game/data/game_objects.dart';
import 'package:colormate_app/features/games/find_the_object_game/data/models/game_object_model.dart';
import 'package:colormate_app/features/games/presentation/views/widgets/advanced_game_appbar.dart';
import 'package:flutter/material.dart';
import 'widgets/object_grid_item.dart';
import 'widgets/target_object_card.dart';

class FindTheObjectGameView extends StatefulWidget {
  const FindTheObjectGameView({super.key});

  @override
  State<FindTheObjectGameView> createState() => _FindTheObjectGameViewState();
}

class _FindTheObjectGameViewState extends State<FindTheObjectGameView> {
  late List<GameObjectModel> currentObjects;
  late GameObjectModel targetObject;

  int score = 0;
  int level = 1;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    setupNewRound();
  }

  void setupNewRound() {
    int objectCount = min(4 + (level ~/ 3), 8);

    allObjects.shuffle();
    currentObjects = allObjects.take(objectCount).toList();
    targetObject = currentObjects[Random().nextInt(currentObjects.length)];

    selectedIndex = null;
    setState(() {});
  }

  void checkAnswer(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (currentObjects[index] == targetObject) {
      score += 10;
      level++;

      if (level > 14) {
        Future.delayed(const Duration(milliseconds: 700), () {
          endGame();
        });
        return;
      }

      Future.delayed(const Duration(seconds: 1), () {
        setupNewRound();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Try again! Look for the ${targetObject.colorName} ${targetObject.name}',
          ),
          backgroundColor: Colors.red,
        ),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          selectedIndex = null;
        });
      });
    }
  }

  void endGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Finished 🎉'),
          content: Text('Your final score is $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    score = 0;
    level = 1;
    setupNewRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdvancedGameAppBar(
        title: 'Find the Object Game',
        subtitle: 'score',
        hint: 'level',
        subtitleValue: score,
        hintValue: level,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          TargetObjectCard(targetObject: targetObject),

          const SizedBox(height: 40),

          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: currentObjects.length <= 4 ? 2 : 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: currentObjects.length,
              itemBuilder: (context, index) {
                final obj = currentObjects[index];

                return ObjectGridItem(
                  object: obj,
                  isSelected: selectedIndex == index,
                  isCorrect: selectedIndex == index && obj == targetObject,
                  isWrong: selectedIndex == index && obj != targetObject,
                  onTap:
                      selectedIndex == null ? () => checkAnswer(index) : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: resetGame,
              icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
              label: const Text(
                'Reset Game',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
