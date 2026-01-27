import 'package:flutter/material.dart';

class ColorTheme {
  ColorTheme._();
  static final ColorTheme _instance = ColorTheme._();
  factory ColorTheme() => _instance;

  // Primary Colors
  final Color primaryYellow = const Color(0xFFFFC300);
  final Color primaryBlue = const Color(0xFF003566);
  final Color navyBlue = const Color(0xFF001D3D);

  final Color backgroundWhite = const Color(0xFFFFFFFF);
  final Color backgroundLightGray = const Color(0xFFEBEBEB);
  final Color offWhite = const Color(0xFFFAFAFA);
  final Color disabledButton = const Color(0xFFACACAC);
  final Color otpBG = const Color(0xFFFBFBFB);

  // Gray Shades
  final Color grayLight = const Color(0xFFB9B6B6);
  final Color grayMedium = const Color(0xFF898989);
  final Color grayVeryLight = const Color(0xFFE4E1E1);
  final Color grayDarker = const Color(0xFF585858);
  final Color grayDark = const Color(0xFF6B6B6B);

  // White Shades
  final Color whiteColor = const Color(0xFFFFFFFF);

  // Error Colors
  final Color errorColor = const Color(0xFFD32F2F);

  final Color blackColor = const Color(0xFF000814);
}
