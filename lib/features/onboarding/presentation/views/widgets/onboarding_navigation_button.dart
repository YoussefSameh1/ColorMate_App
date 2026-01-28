import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/onboarding/data/models/onboarding_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingNavigationButton extends StatelessWidget {
  const OnboardingNavigationButton({
    super.key,
    required this.currentIndex,
    required this.pageController,
  });

  final int currentIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentIndex == onboardingData.length - 1) {
          // go to home page
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        height: 60.h,
        width: 60.h,
        decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
        child: const Icon(
          Icons.arrow_forward,
          color: kSecondaryColor,
          size: 34,
        ),
      ),
    );
  }
}
