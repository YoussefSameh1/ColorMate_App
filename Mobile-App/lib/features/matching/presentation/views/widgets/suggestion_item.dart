import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuggestionItem extends StatelessWidget {
  // ✅ Single string — API returns complete sentences like
  // "Your outfit looks great together."
  final String suggestion;

  const SuggestionItem({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: kPrimaryColor),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            suggestion,
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}