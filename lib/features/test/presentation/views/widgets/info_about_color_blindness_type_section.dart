import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoAboutColorBlindnessTypeSection extends StatelessWidget {
  const InfoAboutColorBlindnessTypeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 20.h),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 2.w),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Understanding Your Result:',
            style: Styles.testQuestionTextStyle,
          ),
          SizedBox(height: 10.h),
          Text(
            'Deuteranomaly',
            style: Styles.testQuestionTextStyle,
          ),
          SizedBox(height: 8.h),
          Text(
            'Deuteranomaly is a common type of red-green color blindness where the green-sensitive cones in your eyes detect too much red light. This shifts the perception of greens towards red.\nIndividuals with moderate Deuteranomaly may find it challenging to differentiate various shades of green, brown, and some grays. Traffic lights might appear differently, but often with enough contrast to be discernible.\nThis condition is congenital and affects more men than women. It does not typically worsen over time and does not impact overall eye health.',
            style: Styles.testResultTextStyle,
          ),
        ],
      ),
    );
  }
}
