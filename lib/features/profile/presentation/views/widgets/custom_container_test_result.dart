import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainerTestResult extends StatelessWidget {
  final UserProfileModel userProfile;

  const CustomContainerTestResult({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Test Result', style: AppTextStyles.semiBold17()),
        SizedBox(height: 10.h),
        Container(
          width: 342.w,
          // height: 201.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  userProfile.lastTestDate ?? 'N/A',
                  style: AppTextStyles.semiBold16().copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  userProfile.colorblindnessType ?? 'N/A',
                  style: AppTextStyles.regular16().copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  userProfile.testDescription ??
                      'No test description available.',
                  style: AppTextStyles.regular16().copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
