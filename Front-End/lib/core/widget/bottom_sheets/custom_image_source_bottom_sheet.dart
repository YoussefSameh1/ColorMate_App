import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onCameraSelected;
  final VoidCallback onGallerySelected;
  final String title;
  final String subtitle;

  const CustomImageSourceBottomSheet({
    super.key,
    required this.onCameraSelected,
    required this.onGallerySelected,
    this.title = 'Choose Profile Picture',
    this.subtitle = 'Select the source for your profile image',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DragIndicator(),
          SizedBox(height: 24.h),
          _HeaderSection(title: title, subtitle: subtitle),
          SizedBox(height: 28.h),
          _ImageSourceOption(
            icon: Icons.camera_alt_rounded,
            title: 'Camera',
            subtitle: 'Take a new photo',
            onTap: () {
              Navigator.pop(context);
              onCameraSelected();
            },
          ),
          SizedBox(height: 16.h),
          _ImageSourceOption(
            icon: Icons.photo_library_rounded,
            title: 'Gallery',
            subtitle: 'Choose from your photos',
            onTap: () {
              Navigator.pop(context);
              onGallerySelected();
            },
          ),
          SizedBox(height: 16.h),
          _CancelButton(),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

class _DragIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderSection({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.semiBold20().copyWith(color: AppColors.greyDark),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: AppTextStyles.regular16().copyWith(color: AppColors.greyDark),
        ),
      ],
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.semiBold16().copyWith(
                      color: AppColors.greyDark,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.regular16().copyWith(
                      color: AppColors.greyDark,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.greyDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Cancel',
          style: AppTextStyles.medium16().copyWith(color: AppColors.greyDark),
        ),
      ),
    );
  }
}
