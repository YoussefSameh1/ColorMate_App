import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.onTap,
   
  });

  final VoidCallback? onTap;
 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.pop(),
      child: Icon(
        Icons.arrow_back,
        size: 30.sp,
        color:AppColors.primaryDark,

      ),
    );
  }
}
