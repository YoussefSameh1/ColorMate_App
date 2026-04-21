import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/core/widget/loading/custom_loading_indicator.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/form_edit_profile.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileUIBuilder extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final VoidCallback onSavePressed;
  final VoidCallback onImagePickerTap;
  final bool isPasswordObscured;

  const ProfileUIBuilder({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.usernameController,
    required this.onSavePressed,
    required this.onImagePickerTap,
    required this.isPasswordObscured,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String? imagePath;
        String? profileImageUrl;

        if (state is ProfileImageSelected) {
          imagePath = state.imagePath;
          profileImageUrl = state.currentProfile.profileImage;
        } else if (state is ProfileLoaded) {
          profileImageUrl = state.userProfile.profileImage;
        }

        final bool isLoading =
            state is ProfileLoading || state is ProfileImagePicking;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(title: 'Edit Profile'),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    ProfileImagePicker(
                      imagePath: imagePath,
                      imageUrl: profileImageUrl,
                      isLoading: isLoading,
                      onTap: onImagePickerTap,
                    ),

                    const SizedBox(height: 20),

                    FormEditProfile(
                      formKey: formKey,
                      emailController: emailController,
                      phoneController: phoneController,
                      passwordController: passwordController,
                      isPasswordObscured: isPasswordObscured,
                      usernameController: usernameController,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.push(Routes.changePasswordView);
                        },
                        child: Text(
                          'change password',
                          style: AppTextStyles.regular18().copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    isLoading
                        ? const CustomLoadingIndicator(
                          message: 'Saving changes...',
                        )
                        : PrimaryShadowButton(
                          text: 'Save Changes',
                          onPressed: onSavePressed,
                        ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
