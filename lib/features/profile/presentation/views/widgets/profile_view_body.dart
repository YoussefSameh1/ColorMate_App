import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/custom_container_profile_info.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/custom_container_test_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Delete account?'),
                            content: const Text(
                              'This action will permanently delete your account and sign you out.',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.pop(dialogContext, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed:
                                    () => Navigator.pop(dialogContext, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete == true && context.mounted) {
                        context.read<ProfileCubit>().deleteAccount();
                      }
                    },
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Delete Account'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
