import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/features/games/data/models/game_card_model.dart';
import 'package:flutter/material.dart';

final List<GameCardModel> games = [
  GameCardModel(
    title: 'Color Collector',
    description:
        'Catch falling objects and put each one in the correct basket!',
    icon: Icons.catching_pokemon,
    color: Colors.green,
    emoji: '🏀',
    route: Routes.colorCollectorGameView,
  ),
  GameCardModel(
    title: 'Memory Match',
    description: 'Match objects with their color names!',
    icon: Icons.psychology,
    color: Colors.indigo,
    emoji: '🃏',
    route: Routes.memoryMatchGameView,
  ),
  GameCardModel(
    title: 'Color the Picture',
    description: 'Paint the picture with correct colors!',
    icon: Icons.brush,
    color: Colors.pink,
    emoji: '🎨',
    route: Routes.colorThePictureGameView,
  ),
  GameCardModel(
    title: 'Sequence Game',
    description: 'Remember and repeat the color sequence!',
    icon: Icons.lightbulb,
    color: Colors.deepOrange,
    emoji: '🧠',
    route: Routes.sequenceGameView,
  ),
  GameCardModel(
    title: 'Find the Object',
    description: 'Find objects by their color and name!',
    icon: Icons.search,
    color: Colors.purple,
    emoji: '🔍',
    route: Routes.findTheObjectGameView,
  ),
];
