import 'package:colormate_app/core/widget/buttons/custom_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.onTap,
    this.backgroundColor = const Color(0xFFEBEBEB),
    this.iconColor = Colors.black, // Specific override for Back Button
  });

  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CustomCircleButton(
      icon: Icons.arrow_back_ios_new_rounded,
      size: 40,
      iconSize: 18.sp,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      onTap: onTap ?? () => context.pop(),
    );
  }
}
