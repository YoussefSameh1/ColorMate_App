// result_card.dart
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultCard extends StatelessWidget {
  final String status;
  final double spoiledPercent;
  final double confidence;

  const ResultCard({
    super.key,
    required this.status,
    required this.spoiledPercent,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final isRotten = status == 'Not Fresh';
    final statusColor = isRotten ? Colors.red : Colors.green;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),  // responsive padding
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Fresh Quality Result',
            style: Styles.buttonTextStyle.copyWith(color: kPrimaryColor),
          ),
          SizedBox(height: 16.h),
          Text(
            status,
            style: Styles.testQuestionTextStyle.copyWith(color: statusColor),
          ),
          SizedBox(height: 6.h),
          Text(
            'Spoiled area: ${spoiledPercent.toStringAsFixed(1)}%',
            style: Styles.testQuestionTextStyle,
          ),
        ],
      ),
    );
  }
}