import 'package:colormate_app/core/widget/loaders.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileListener extends StatelessWidget {
  final Widget child;
  final TextEditingController usernameController;
  final TextEditingController emailController;

  const ProfileListener({
    super.key,
    required this.child,
    required this.usernameController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          Loaders.success(
            context,
            title: 'Success!',
            message: 'Your profile has been updated successfully',
          );
        } else if (state is ProfileError) {
          Loaders.error(context, title: 'Oops!', message: state.message);
        } else if (state is ProfileLoaded) {
          if (usernameController.text.isEmpty) {
            usernameController.text = state.userProfile.name;
            emailController.text = state.userProfile.email;
          }
        }
      },
      child: child,
    );
  }
}
