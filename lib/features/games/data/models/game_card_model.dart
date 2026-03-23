import 'package:flutter/material.dart';

class GameCardModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String emoji;
  final String route;

  GameCardModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.emoji,
    required this.route,
  });
}
