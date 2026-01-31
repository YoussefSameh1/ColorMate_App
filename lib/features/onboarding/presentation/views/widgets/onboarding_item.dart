import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({super.key, required this.model});

  final OnboardingModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Image.asset(model.image, height: 250.h, width: 250.w, fit: BoxFit.fill),
          SizedBox(height: 60.h),
          Text(model.title, style: Styles.onboardingTitleStyle, textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          Text(
            model.description,
            style: Styles.onboardingDescriptionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
