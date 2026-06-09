import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/score_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitScoreCard extends StatelessWidget {
  final double score;

  const OutfitScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            "Outfit Score",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          const Text(
            "Overall compatibility and aesthetic appeal.",
            textAlign: TextAlign.center,
            style: TextStyle(color: kPrimaryColor),
          ),
          SizedBox(height: 20.h),
          // ✅ Pass real score
          ScoreCircle(score: score),
        ],
      ),
    );
  }
}