import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:flutter/material.dart';

class UploadPlaceholder extends StatelessWidget {
  const UploadPlaceholder({super.key, required this.onChoosePhoto});

  final VoidCallback onChoosePhoto;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 36,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Upload Image',
                    style: AppTextStyles.bold18().copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Pick a photo from the gallery or camera to run object detection.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular10().copyWith(
                        color: AppColors.primary,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 220,
                    child: PrimaryShadowButton(
                      text: 'Choose Photo',
                      height: 46,
                      width: 220,
                      radius: 18,
                      textStyle: AppTextStyles.medium16().copyWith(
                        color: AppColors.white,
                      ),
                      onPressed: onChoosePhoto,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
