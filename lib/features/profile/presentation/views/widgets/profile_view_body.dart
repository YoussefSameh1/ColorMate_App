import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/custom_container_profile_info.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/custom_container_test_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileViewBody extends StatelessWidget {
  final UserProfileModel userProfile;
  final VoidCallback? onEditPressed;
  final bool isLoading;

  const ProfileViewBody({
    super.key,
    required this.userProfile,
    this.onEditPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomAppBar(
            title: 'My Profile',
            onBackPressed: () => context.go(Routes.homeView),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomContainerProfileInfo(
                  userProfile: userProfile,
                  onEditPressed: onEditPressed,
                ),
                const SizedBox(height: 20),
                CustomContainerTestResult(userProfile: userProfile),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
