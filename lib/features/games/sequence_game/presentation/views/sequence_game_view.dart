import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/games/presentation/views/widgets/advanced_game_appbar.dart';
import 'package:colormate_app/features/games/sequence_game/presentation/views/widgets/color_button_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../provider/sequence_game_provider.dart';

class SequenceGameView extends StatelessWidget {
  const SequenceGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SequenceGameProvider(),
      child: const _GameBody(),
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody();

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<SequenceGameProvider>(context);

    return Scaffold(
      appBar: AdvancedGameAppBar(
        title: 'Sequence Game',
        subtitle: 'level',
        hint: 'score',
        subtitleValue: game.currentLevel,
        hintValue: game.score,
        isColorCollectorGame: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kAccentColor, kSecondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      game.isPlaying
                          ? (game.isPlayerTurn
                              ? 'Your turn! Repeat the sequence'
                              : 'Watch the sequence...')
                          : 'Press Start to Play!',
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (game.isPlayerTurn)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          '${game.playerSequence.length}/${game.sequence.length}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(30),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: game.colors.length,
                  itemBuilder: (context, index) {
                    final colorIndex = game.buttonOrder[index];
                    final colorButton = game.colors[colorIndex];

                    return ColorButtonTile(
                      colorButton: colorButton,
                      isHighlighted: game.highlightedIndex == colorIndex,
                      canTap: game.isPlayerTurn && game.isPlaying,
                      onTap: () async {
                        bool isGameOver = await game.playerTap(colorIndex);

                        if (isGameOver) {
                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Game Over!'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Level Reached: ${game.currentLevel}',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Score: ${game.score}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        GoRouter.of(context).pop();
                                        game.startGame();
                                      },
                                      child: const Text('Play Again'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        GoRouter.of(context).pop();
                                        GoRouter.of(context).pop();
                                      },
                                      child: const Text('Back to Menu'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              if (!game.isPlaying)
                ElevatedButton(
                  onPressed: game.startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('START GAME'),
                ),

              const SizedBox(height: 30),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: kPrimaryColor, width: 2),
                ),
                child: const Text(
                  '💡 Watch the color pattern, then repeat it!\nEach level adds one more color.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryColor,fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
