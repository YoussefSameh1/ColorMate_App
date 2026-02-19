import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/scan_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Fresh quality result',
            style: Styles.buttonTextStyle.copyWith(color: kPrimaryColor),
          ),
          SizedBox(height: 30.h),
          Text('Status: not fresh', style: Styles.testQuestionTextStyle),
          SizedBox(height: 6.h),
          Text('Spoiled area 25%', style: Styles.testQuestionTextStyle),
          SizedBox(height: 30.h),
          ScanButton(),
        ],
      ),
    );
  }
}
