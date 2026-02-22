import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/widget/snackbars/custom_snackbar_content.dart';
import 'package:flutter/material.dart';

class Loaders {
  
  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  
  static void success(
    BuildContext context, {
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      duration: duration,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_rounded,
    );
  }


  static void error(
    BuildContext context, {
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      duration: duration,
      backgroundColor: AppColors.error,
      icon: Icons.error_rounded,
    );
  }

  
  static void warning(
    BuildContext context, {
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      duration: duration,
      backgroundColor: const Color(0xFFF59E0B),
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required int duration,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: duration),
          content: CustomSnackBarContent(
            title: title,
            message: message,
            icon: icon,
            backgroundColor: backgroundColor,
          ),
        ),
      );
  }
}
