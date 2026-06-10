import 'package:colormate_app/features/matching/presentation/views/widgets/outfit_rating_view_body.dart';
import 'package:flutter/material.dart';

class OutfitRatingView extends StatelessWidget {
  final String imagePath;

  const OutfitRatingView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OutfitRatingViewBody(imagePath: imagePath));
  }
}
