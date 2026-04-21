import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitSuggestionsCard extends StatelessWidget {
  const OutfitSuggestionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 1.5.w),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Outfit Suggestions",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Refine your look with these tips.",
            style: TextStyle(color: kPrimaryColor),
          ),
          SizedBox(height: 20.h),
          SuggestionItem(
            title: "Add a pop of color",
            description:
                "Consider a scarf or accessory in complementary yellow to brighten your look.",
          ),
          SizedBox(height: 20.h),
          SuggestionItem(
            title: "Refine your silhouette",
            description:
                "Try a belt to cinch the waist and create a more defined shape.",
          ),
        ],
      ),
    );
  }
}
