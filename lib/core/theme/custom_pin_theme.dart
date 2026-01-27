import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'colors.dart';
import 'text_style.dart';

class CustomPinTheme {
  /// Default state for the OTP box
  static PinTheme get defaultPinTheme {
    return PinTheme(
      width: 74.w,
      height: 72.w,
      textStyle: AppTextStyles.semiBold24().copyWith(
        color: ColorTheme().blackColor,
      ),
      decoration: BoxDecoration(
        color: ColorTheme().otpBG, // Background #FBFBFB
        borderRadius: BorderRadius.circular(20), // Radius 20px
        border: Border.all(color: Colors.transparent), // No border initially
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }

  /// Focused state (Blue Border)
  static PinTheme get focusedPinTheme {
    final defaultTheme = defaultPinTheme;
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: ColorTheme().primaryBlue, width: 1),
      ),
    );
  }
}
