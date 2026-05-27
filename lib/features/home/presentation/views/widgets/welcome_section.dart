import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;

    final userName = switch (profileState) {
      ProfileLoaded(:final userProfile) => userProfile.firstName.isNotEmpty
          ? userProfile.firstName
          : userProfile.name,
      ProfileUpdateSuccess(:final userProfile) =>
        userProfile.firstName.isNotEmpty
            ? userProfile.firstName
            : userProfile.name,
      _ => null,
    };

    return Padding(
      padding: EdgeInsets.only(right: 24.w, left: 24.w, top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, ${userName ?? 'there'} 👋',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Let's explore something creative today!",
            style: TextStyle(fontSize: 14.sp, color: kSubTitleColor),
          ),
          SizedBox(height: 20.h),
          Text(
            'Features',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}