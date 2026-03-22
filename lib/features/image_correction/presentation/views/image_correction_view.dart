import 'package:colormate_app/features/image_correction/presentation/views/widgets/image_corection_body.dart';
import 'package:flutter/material.dart';

class ImageCorrectionView extends StatelessWidget {
  const ImageCorrectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Correction')),
      body: const ImageCorrectionBody(),
    );
  }
}
