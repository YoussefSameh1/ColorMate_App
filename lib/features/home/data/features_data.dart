import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/features/home/data/models/feature_model.dart';
import 'package:flutter/material.dart';

final List<FeatureModel> features = [
  FeatureModel(
    title: 'Test',
    icon: Icons.shield_outlined,
    color: Colors.grey,
    bgColor: AppColors.testColor,
    route: Routes.testIntroView,
  ),
  FeatureModel(
    title: 'Detect Image',
    icon: Icons.camera_alt_outlined,
    color: Colors.blue,
    bgColor: AppColors.detectImageColor,
    route: Routes.objectAndColorDetectionView,
  ),
  FeatureModel(
    title: 'Filter Image',
    icon: Icons.image_outlined,
    color: Colors.pink,
    bgColor: AppColors.filterImageColor,
    route: Routes.imageCorrectionView,
  ),
  FeatureModel(
    title: 'Rate Outfit',
    icon: Icons.star_border,
    color: Colors.purple,
    bgColor: AppColors.rateOutfitColor,
    route: Routes.matchingView,
  ),
  FeatureModel(
    title: 'Scan Fruit',
    icon: Icons.apple_outlined,
    color: Colors.teal,
    bgColor: AppColors.scanFruitColor,
    route: Routes.fruitIntroView,
  ),
  FeatureModel(
    title: 'Gaming',
    icon: Icons.games_outlined,
    color: Colors.red,
    bgColor: AppColors.gamingColor,
    route: Routes.fruitIntroView,
  ),
];
