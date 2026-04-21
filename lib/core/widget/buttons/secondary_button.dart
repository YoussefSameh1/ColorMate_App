import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.width = 164,
    this.height = 48,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    // Styles based on State
    final borderColor =
        isEnabled ? AppColors.primary : AppColors.buttonDisabled;

    final textColor = isEnabled ? AppColors.primary : AppColors.greyDark;

    final shadowColor = isEnabled ? AppColors.shadow : AppColors.shadowLight;

    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: AppTextStyles.medium16().copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
