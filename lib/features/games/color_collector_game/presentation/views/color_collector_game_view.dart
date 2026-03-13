import 'dart:async';
import 'dart:math';
import 'package:colormate_app/features/games/color_collector_game/data/game_data.dart';
import 'package:colormate_app/features/games/color_collector_game/data/models/falling_object_model.dart';
import 'package:colormate_app/features/games/color_collector_game/presentation/views/widgets/basket_widget.dart';
import 'package:colormate_app/features/games/color_collector_game/presentation/views/widgets/falling_object_widget.dart';
import 'package:colormate_app/features/games/color_collector_game/presentation/views/widgets/start_game_overlay.dart';
import 'package:colormate_app/features/games/presentation/views/widgets/advanced_game_appbar.dart';
import 'package:flutter/material.dart';

class ColorCollectorGameView extends StatefulWidget {
  const ColorCollectorGameView({super.key});

  @override
  State<ColorCollectorGameView> createState() => _ColorCollectorGameViewState();
}

class _ColorCollectorGameViewState extends State<ColorCollectorGameView>
    with TickerProviderStateMixin {
  List<FallingObject> fallingObjects = [];

  Timer? spawnTimer;
  Timer? updateTimer;

  int score = 0;
  int missed = 0;
  int objectCounter = 0;

  bool isGameRunning = false;

  late AnimationController scoreController;

  @override
  void initState() {
    super.initState();

    scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    spawnTimer?.cancel();
    updateTimer?.cancel();
    scoreController.dispose();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      missed = 0;
      fallingObjects.clear();
      isGameRunning = true;
    });

    spawnTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) => spawnObject(),
    );

    updateTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => updateObjects(),
    );
  }

  void stopGame() {
    spawnTimer?.cancel();
    updateTimer?.cancel();

    setState(() {
      isGameRunning = false;
    });
  }

  void spawnObject() {
    final random = Random();
    final template = objectTemplates[random.nextInt(objectTemplates.length)];

    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      fallingObjects.add(
        FallingObject(
          emoji: template['emoji'],
          name: template['name'],
          colorName: template['colorName'],
          color: template['color'],
          x: random.nextDouble() * (screenWidth - 80),
          y: -80,
          id: 'obj_${objectCounter++}',
        ),
      );
    });
  }

  void updateObjects() {
    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      fallingObjects.removeWhere((obj) {
        if (obj.y > screenHeight - 150 && !obj.isDragging) {
          missed++;

          if (missed >= 10) {
            stopGame();
            showGameOverDialog();
          }

          return true;
        }
        return false;
      });

      for (var obj in fallingObjects) {
        if (!obj.isDragging) {
          obj.y += 3;
        }
      }
    });
  }

  void checkDrop(String objectId, String basketColor) {
    final obj = fallingObjects.firstWhere((o) => o.id == objectId);

    setState(() {
      fallingObjects.removeWhere((o) => o.id == objectId);

      if (obj.colorName == basketColor) {
        score += 10;

        scoreController.forward(from: 0);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Correct! ${obj.emoji} is $basketColor'),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        missed++;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✗ ${obj.emoji} is ${obj.colorName}, not $basketColor',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1000),
          ),
        );

        if (missed >= 10) {
          stopGame();
          showGameOverDialog();
        }
      }
    });
  }

  /// GAME OVER DIALOG
  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Score: $score",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("Missed: $missed"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdvancedGameAppBar(
        title: 'Color Collector Game',
        subtitle: 'Score',
        hint: 'Missed',
        subtitleValue: score,
        hintValue: missed,
        isColorCollectorGame: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            ...fallingObjects.map((obj) {
              return FallingObjectWidget(
                object: obj,
                onDragStart: () {
                  setState(() {
                    obj.isDragging = true;
                  });
                },
                onDragEnd: () {
                  setState(() {
                    obj.isDragging = false;

                    if (!fallingObjects.contains(obj)) return;

                    fallingObjects.remove(obj);
                    missed++;

                    if (missed >= 10) {
                      stopGame();
                      showGameOverDialog();
                    }
                  });
                },
              );
            }),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140,
                color: Colors.brown.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      baskets.map((basket) {
                        return BasketWidget(
                          basket: basket,
                          onAccept: (id) => checkDrop(id, basket['colorName']),
                        );
                      }).toList(),
                ),
              ),
            ),
            if (!isGameRunning) StartGameOverlay(onStart: startGame),
          ],
        ),
      ),
    );
  }
}
