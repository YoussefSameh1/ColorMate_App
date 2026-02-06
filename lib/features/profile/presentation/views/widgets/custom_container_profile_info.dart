import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainerProfileInfo extends StatelessWidget {
  final UserProfileModel userProfile;
  final VoidCallback? onEditPressed;

  const CustomContainerProfileInfo({
    super.key,
    required this.userProfile,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                userProfile.profileImage != null
                    ? AssetImage(userProfile.profileImage!)
                    : const AssetImage('assets/images/image_profile.png'),
          ),
          Text(
            userProfile.name,
            style: AppTextStyles.bold25().copyWith(color: AppColors.primary),
          ),
          Text(
            userProfile.email,
            style: AppTextStyles.regular16().copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 20.h),
          SecondaryButton(
            text: 'Edit Profile',
            onPressed: onEditPressed ?? () {},
            height: 40.h,
            width: 262.w,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
