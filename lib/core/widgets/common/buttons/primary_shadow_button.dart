import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';

class PrimaryShadowButton extends StatelessWidget {
  const PrimaryShadowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 343,
    this.height = 56,
    this.backgroundColor,
    this.radius,
    this.textStyle,
    this.isLoading = false,
  });

  final String text;
  final TextStyle? textStyle;
  final double? radius;
  final VoidCallback onPressed;
  final double width;
  final Color? backgroundColor;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorTheme = ColorTheme();
    final baseColor = backgroundColor ?? colorTheme.primaryBlue;

    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 20), // Radius: 20px
        color: colorTheme.primaryBlue, // Background: #003566
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Top: Blend of Base Color + #FFFFFFB2
            Color.alphaBlend(
              colorTheme.whiteColor.withValues(alpha: 0.7),
              baseColor,
            ),
            // Bottom: Pure Base Color
            baseColor,
          ],
          stops: const [0.0, 0.2],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(8), // Padding: 8px
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style:
                    textStyle ??
                    AppTextStyles.semiBold16().copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
