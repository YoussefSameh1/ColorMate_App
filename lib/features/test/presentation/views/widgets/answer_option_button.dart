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
      width: 200.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kPrimaryColor, width: 3.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          option,
          style: Styles.testQuestionTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
