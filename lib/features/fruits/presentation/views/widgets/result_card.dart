import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultCard extends StatelessWidget {
  final String status;
  final double spoiledPercent;

  const ResultCard({
    super.key,
    required this.status,
    required this.spoiledPercent,
  });

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

          Text(
            'Status: $status',
            style: Styles.testQuestionTextStyle,
          ),

          SizedBox(height: 6.h),

          Text(
            'Spoiled area ${spoiledPercent.toStringAsFixed(0)}%',
            style: Styles.testQuestionTextStyle,
          ),
        ],
      ),
    );
  }
}