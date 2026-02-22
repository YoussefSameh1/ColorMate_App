import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryShadowButton extends StatelessWidget {
  const PrimaryShadowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width = 343,
    this.height = 56,
    this.backgroundColor,
    this.radius,
    this.textStyle,
    this.isLoading = false,
  });

  final String text;
  final IconData? icon;
  final TextStyle? textStyle;
  final double? radius;
  final VoidCallback onPressed;
  final double width;
  final Color? backgroundColor;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final baseColor = backgroundColor ?? AppColors.primary;

    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 20),
        gradient: LinearGradient(
          colors: [
            // Top: Blend of Base Color + White overlay
            Color.alphaBlend(AppColors.white.withOpacity(0.1), baseColor),
            // Bottom: Pure Base Color
            baseColor,
          ],
          stops: const [0.0, 0.2],
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          overlayColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 20),
          ),
          padding: const EdgeInsets.all(8),
        ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        child:
            isLoading
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: AppColors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style:
                          textStyle ??
                          AppTextStyles.semiBold16().copyWith(
                            color: AppColors.white,
                          ),
                    ),
                  ],
                ),
      ),
    );
  }
}
