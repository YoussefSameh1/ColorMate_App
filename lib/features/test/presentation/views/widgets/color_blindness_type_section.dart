import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorBlindnessTypeSection extends StatelessWidget {
  const ColorBlindnessTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 2.w),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'Deuteranomaly',
            style: Styles.buttonTextStyle.copyWith(color: kPrimaryColor),
          ),
          SizedBox(height: 30.h),
          Text('Moderate', style: Styles.testQuestionTextStyle),
        ],
      ),
    );
  }
}
