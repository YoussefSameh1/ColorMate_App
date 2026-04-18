import 'package:colormate_app/features/fruits/presentation/views/widgets/fruit_result_view_body.dart';
import 'package:flutter/material.dart';

class FruitResultView extends StatelessWidget {
  final String imagePath;

  const FruitResultView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FruitResultViewBody(imagePath: imagePath));
  }
}
