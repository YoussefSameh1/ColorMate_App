import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:flutter/material.dart';

class UploadPlaceholder extends StatelessWidget {
  const UploadPlaceholder({super.key, required this.onChoosePhoto});

  final VoidCallback onChoosePhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 64, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          'Upload or Select Image',
          style: AppTextStyles.bold18().copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Select an image from the gallery or capture a new one to detect objects and identify their colors.',
            textAlign: TextAlign.center,
            style: AppTextStyles.regular16().copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryShadowButton(text: 'Choose Photo', onPressed: onChoosePhoto),
      ],
    );
  }
}
