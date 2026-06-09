// color_blindness_type_section.dart
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorBlindnessTypeSection extends StatelessWidget {
  const ColorBlindnessTypeSection({super.key, required this.diagnosis});

  final String diagnosis;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),   // removed horizontal margin — parent already has 16.w padding
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 2.w),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            diagnosis,
            style: Styles.buttonTextStyle.copyWith(color: kPrimaryColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Text(
            'Color Vision Test Result',
            style: Styles.testQuestionTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}