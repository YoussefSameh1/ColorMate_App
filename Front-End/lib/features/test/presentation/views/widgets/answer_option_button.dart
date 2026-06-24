// answer_option_button.dart
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerOptionButton extends StatelessWidget {
  const AnswerOptionButton({super.key, required this.option});

  final String option;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,    // was 200.w — now fills grid cell properly
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kPrimaryColor, width: 2.w),  // reduced from 3.w
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),  // prevents text clipping
          child: Text(
            option,
            style: Styles.testQuestionTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,    // explicit responsive font size
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}