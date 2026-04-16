import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/outfit_score_card.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/outfit_suggestions_card.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/upload_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchingViewBody extends StatelessWidget {
  const MatchingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(title: 'Color Matching Assistant', isTitleLong: true),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                UploadImageCard(),
                SizedBox(height: 20.h),
                OutfitScoreCard(score: 8.5),
                SizedBox(height: 20.h),
                OutfitSuggestionsCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
