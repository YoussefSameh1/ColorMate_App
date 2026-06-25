import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ColorPreviewBox extends StatelessWidget {
  const ColorPreviewBox({
    super.key,
    required this.color,
    required this.isLoading,
  });

  final Color? color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child:
          isLoading
              ? const Padding(
                padding: EdgeInsets.all(6),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : null,
    );
  }
}
