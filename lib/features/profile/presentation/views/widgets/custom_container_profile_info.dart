import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainerProfileInfo extends StatelessWidget {
  static const String _baseUrl = 'http://colormate.runasp.net';

  final UserProfileModel userProfile;
  final VoidCallback? onEditPressed;

  const CustomContainerProfileInfo({
    super.key,
    required this.userProfile,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedImageUrl = _resolveImageUrl(userProfile.profileImage);

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
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child:
                resolvedImageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : ClipOval(
                      child: Image.network(
                        resolvedImageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 50);
                        },
                      ),
                    ),
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

  String? _resolveImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;

    final trimmed = rawUrl.trim().replaceAll('\\', '/');
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    final normalized = trimmed.replaceFirst(RegExp(r'^/+'), '');

    // return '$_baseUrl/$normalized';
    return Uri.parse('$_baseUrl/$normalized').toString();
   
  }
}
