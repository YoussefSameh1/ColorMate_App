// test_result_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestResultButton extends StatelessWidget {
  const TestResultButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        minimumSize: Size(double.infinity, 50.h),
        elevation: 0,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),  // prevents text clipping on small screens
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp,             // reduced from 20.sp — fits long strings like "Learn More About..."
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}