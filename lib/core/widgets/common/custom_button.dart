import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onTap, this.color});

  /// Optional back action or icon color
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.pop(),
      child: Container(
        width: 40.w, // Fixed Width: 40
        height: 40.w, // Fixed Height: 40
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB), // Background: #EBEBEB
          borderRadius: BorderRadius.circular(31), // Radius: 31px (Circular)
        ),
        // Alignment to perfectly center the icon instead of raw padding
        // because icons like 'arrow_back_ios' have internal padding
        alignment: Alignment.center,
        child: Padding(
          // Adjusting padding slightly to visually center the arrow
          // (Without this iOS arrow looks too far to the right)
          padding: const EdgeInsets.only(right: 2.0),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp, // Closest match to Figma ~14.4px height spec
            color: color ?? Colors.black, // Default arrow color
            weight: 2.0, // matches the "border-width: 2px" look
          ),
        ),
      ),
    );
  }
}