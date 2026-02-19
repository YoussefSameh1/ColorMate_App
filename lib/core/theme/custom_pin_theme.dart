import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'text_style.dart';

class CustomPinTheme {
  /// Default state for the OTP box
  static PinTheme get defaultPinTheme {
    return PinTheme(
      width: 40.w,
      height: 40.w,
      textStyle: AppTextStyles.semiBold24().copyWith(color: AppColors.black),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary,width: 3),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }

  /// Focused state (Primary Border)
  static PinTheme get focusedPinTheme {
    final defaultTheme = defaultPinTheme;
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 3),
      ),
    );
  }
}
