import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreCircle extends StatelessWidget {
  final double score;

  const ScoreCircle({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kPrimaryColor, width: 2.w),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // ✅ Show as integer (85, not 85.0)
              score.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            // ✅ Score is out of 100 not 10
            const Text("/100", style: TextStyle(color: kPrimaryColor)),
          ],
        ),
      ),
    );
  }
}