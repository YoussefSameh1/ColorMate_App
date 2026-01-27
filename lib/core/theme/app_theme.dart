import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData themeDataFunc() {
  return ThemeData(
    scaffoldBackgroundColor: ColorTheme().whiteColor,
    primaryColor: ColorTheme().primaryBlue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorTheme().primaryBlue,
      brightness: Brightness.light,
      onPrimary: ColorTheme().whiteColor,
      secondary: ColorTheme().primaryYellow,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorTheme().primaryBlue,
      foregroundColor: ColorTheme().whiteColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorTheme().whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorTheme().primaryBlue,
      foregroundColor: ColorTheme().whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorTheme().primaryBlue,
        foregroundColor: ColorTheme().whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),
    //textTheme: GoogleFonts.changaTextTheme(),
    useMaterial3: true,
  );
}
