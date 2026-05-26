import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/loaders.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileDeletionSuccess) {
            Loaders.success(
              context,
              title: 'Deleted',
              message: state.message,
            );
            context.go(Routes.loginView);
            return;
          }

          if (state is ProfileError) {
            Loaders.error(context, title: 'Oops!', message: state.message);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileDeletionInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              return ProfileViewBody(
                userProfile: state.userProfile,
                isLoading: false,
                onEditPressed: () async {
                  final updatedProfile = await context.push<UserProfileModel?>(
                    Routes.editProfileView,
                  );
                  if (!mounted) return;
                  if (updatedProfile != null) {
                    context.read<ProfileCubit>().syncProfile(updatedProfile);
                  }
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
