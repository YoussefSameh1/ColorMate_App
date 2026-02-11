import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:colormate_app/features/profile/data/repositories/profile_repository.dart';
import 'package:colormate_app/core/services/image_picker_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  final ImagePickerService _imagePickerService;
  String? _selectedImagePath;

  ProfileCubit(this._repository, {ImagePickerService? imagePickerService})
    : _imagePickerService = imagePickerService ?? ImagePickerService(),
      super(const ProfileInitial()) {
    fetchUserProfile();
  }

  String? get selectedImagePath => _selectedImagePath;

  Future<void> fetchUserProfile() async {
    emit(const ProfileLoading());

    try {
      final userProfile = await _repository.getUserProfile();
      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      UserProfileModel? currentProfile;
      final currentState = state;
      if (currentState is ProfileLoaded) {
        currentProfile = currentState.userProfile;
      } else if (currentState is ProfileImageSelected) {
        currentProfile = currentState.currentProfile;
      }

      emit(const ProfileImagePicking());
      final String? imagePath =
          await _imagePickerService.pickImageFromGallery();

      if (imagePath != null && currentProfile != null) {
        _selectedImagePath = imagePath;
        emit(
          ProfileImageSelected(
            imagePath: imagePath,
            currentProfile: currentProfile,
          ),
        );
      } else {
        await fetchUserProfile();
      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to pick image: ${e.toString()}'));
      await fetchUserProfile();
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      UserProfileModel? currentProfile;
      final currentState = state;
      if (currentState is ProfileLoaded) {
        currentProfile = currentState.userProfile;
      } else if (currentState is ProfileImageSelected) {
        currentProfile = currentState.currentProfile;
      }

      emit(const ProfileImagePicking());
      final String? imagePath = await _imagePickerService.pickImageFromCamera();

      if (imagePath != null && currentProfile != null) {
        _selectedImagePath = imagePath;
        emit(
          ProfileImageSelected(
            imagePath: imagePath,
            currentProfile: currentProfile,
          ),
        );
      } else {
        await fetchUserProfile();
      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to take photo: ${e.toString()}'));
      await fetchUserProfile();
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    try {
      emit(const ProfileLoading());

      UserProfileModel? currentProfile;
      final previousState = state;

      if (previousState is ProfileLoaded) {
        currentProfile = previousState.userProfile;
      } else if (previousState is ProfileImageSelected) {
        currentProfile = previousState.currentProfile;
      } else if (previousState is ProfileUpdateSuccess) {
        currentProfile = previousState.userProfile;
      }

      if (currentProfile == null) {
        currentProfile = await _repository.getUserProfile();
      }

      String? imageUrl =
          _selectedImagePath != null
              ? _selectedImagePath
              : currentProfile.profileImage;

      final updatedProfile = currentProfile.copyWith(
        name: name,
        email: email,
        profileImage: imageUrl,
      );

      await _repository.updateUserProfile(updatedProfile);
      _selectedImagePath = null;
      emit(ProfileUpdateSuccess(userProfile: updatedProfile));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(ProfileLoaded(userProfile: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: 'Failed to update profile: ${e.toString()}'));

      await fetchUserProfile();
    }
  }

  void clearSelectedImage() {
    _selectedImagePath = null;
    fetchUserProfile();
  }
}
