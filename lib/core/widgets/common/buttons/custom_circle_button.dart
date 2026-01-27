import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircleButton extends StatelessWidget {
  const CustomCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 40, // Default to (Back Button size)
    this.iconSize,
    this.backgroundColor = const Color(0xFFEBEBEB), // Default Light Gray
    this.iconColor = const Color(0xFF003566), // Default Blue
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double? iconSize;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: size.w,
        height: size.w, // Keep it circular based on width
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size), // Fully rounded
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: iconSize ?? (size * 0.45).sp, // Auto-scale icon if not provided
          color: iconColor,
        ),
      ),
    );
  }
}
