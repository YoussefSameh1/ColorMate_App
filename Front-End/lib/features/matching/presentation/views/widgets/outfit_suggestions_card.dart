import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitSuggestionsCard extends StatelessWidget {
  // ✅ Accept real suggestions list from API
  final List<String> suggestions;

  const OutfitSuggestionsCard({super.key, required this.suggestions});

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
          // ✅ Render each suggestion from the API dynamically
          ...suggestions.map(
            (suggestion) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: SuggestionItem(suggestion: suggestion),
            ),
          ),
        ],
      ),
    );
  }
}