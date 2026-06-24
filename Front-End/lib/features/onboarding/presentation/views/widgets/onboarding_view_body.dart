import 'package:colormate_app/features/onboarding/data/onboarding_data.dart';
import 'package:colormate_app/features/onboarding/presentation/views/widgets/onboarding_indicator.dart';
import 'package:colormate_app/features/onboarding/presentation/views/widgets/onboarding_item.dart';
import 'package:colormate_app/features/onboarding/presentation/views/widgets/onboarding_navigation_button.dart';
import 'package:colormate_app/features/onboarding/presentation/views/widgets/skip_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  late PageController pageController;
  int currentPage = 0;

  bool get lastPage => currentPage == onboardingData.length - 1;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemBuilder:
                  (context, index) =>
                      OnboardingItem(model: onboardingData[index]),
            ),
            if (!lastPage)
              Positioned(top: 0, right: 0, child: SkipTextButton()),
            Positioned(
              top: 650.h,
              left: 0,
              right: 0,
              child: OnboardingIndicator(currentPage: currentPage),
            ),
            Positioned(
              bottom: 20.h,
              right: 10.w,
              child: OnboardingNavigationButton(
                currentIndex: currentPage,
                pageController: pageController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
