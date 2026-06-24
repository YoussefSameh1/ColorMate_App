import 'package:flutter/material.dart';

class FeatureModel {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;

  FeatureModel({
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.route,
  });
}
