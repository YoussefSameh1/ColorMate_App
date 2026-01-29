import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/onboarding/data/models/onboarding_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({super.key, required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 15.w,
          height: 15.h,
          decoration: BoxDecoration(
            color: currentPage == index ? kAccentColor : kSecondaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
