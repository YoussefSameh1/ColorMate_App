import 'package:colormate_app/features/games/memory_match_game/presentation/views/widgets/memory_card.dart';
import 'package:colormate_app/features/games/presentation/views/widgets/advanced_game_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/memory_game_provider.dart';

class MemoryMatchGameView extends StatelessWidget {
  const MemoryMatchGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryGameProvider()..setupGame(),
      child: const _MemoryGameBody(),
    );
  }
}

class _MemoryGameBody extends StatelessWidget {
  const _MemoryGameBody();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<MemoryGameProvider>();

    return Scaffold(
      appBar: AdvancedGameAppBar(
        title: 'Memory Match Game',
        subtitle: 'Moves',
        hint: 'Matches',
        subtitleValue: game.moves,
        hintValue: game.matches,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: game.cards.length,
              itemBuilder: (context, index) {
                return MemoryCard(
                  card: game.cards[index],
                  onTap: () => game.flipCard(index, context),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () => game.setupGame(),
              icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
              label: const Text('New Game', style: TextStyle(fontSize: 20, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
