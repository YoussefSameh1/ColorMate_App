import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoAboutColorBlindnessTypeSection extends StatelessWidget {
  const InfoAboutColorBlindnessTypeSection({
    super.key,
    required this.diagnosis,
    required this.correctAnswerCount,
    required this.protanAnswerCount,
    required this.deutanAnswerCount,
  });

  final String diagnosis;
  final int correctAnswerCount;
  final int protanAnswerCount;
  final int deutanAnswerCount;

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
          Text('Your Results:', style: Styles.testQuestionTextStyle),
          SizedBox(height: 10.h),

          _buildScoreRow('Correct Answers', correctAnswerCount),
          _buildScoreRow('Protan Score', protanAnswerCount),
          _buildScoreRow('Deutan Score', deutanAnswerCount),

          SizedBox(height: 12.h),

          Text('Diagnosis: $diagnosis', style: Styles.testQuestionTextStyle),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Styles.testResultTextStyle),
          Text('$value', style: Styles.testResultTextStyle),
        ],
      ),
    );
  }
}
