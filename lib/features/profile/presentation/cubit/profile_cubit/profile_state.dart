part of 'profile_cubit.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserProfileModel userProfile;

  const ProfileLoaded({required this.userProfile});
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});
}

class ProfileImageSelected extends ProfileState {
  final String imagePath;
  final UserProfileModel currentProfile;

  const ProfileImageSelected({
    required this.imagePath,
    required this.currentProfile,
  });
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfileModel userProfile;

  const ProfileUpdateSuccess({required this.userProfile});
}

class ProfileImagePicking extends ProfileState {
  const ProfileImagePicking();
}

class ProfileDeletionInProgress extends ProfileState {
  const ProfileDeletionInProgress();
}

class ProfileDeletionSuccess extends ProfileState {
  final String message;

  const ProfileDeletionSuccess({required this.message});
}
