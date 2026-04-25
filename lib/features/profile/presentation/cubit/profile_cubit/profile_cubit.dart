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

  void _safeEmit(ProfileState state) {
    if (!isClosed) emit(state);
  }

  String? get selectedImagePath => _selectedImagePath;

  void syncProfile(UserProfileModel profile) {
    _safeEmit(ProfileLoaded(userProfile: profile));
  }

  Future<void> fetchUserProfile() async {
    _safeEmit(const ProfileLoading());

    try {
      final userProfile = await _repository.getUserProfile();
      _safeEmit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      _safeEmit(ProfileError(message: e.toString()));
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

      _safeEmit(const ProfileImagePicking());
      final String? imagePath =
          await _imagePickerService.pickImageFromGallery();

      if (imagePath != null && currentProfile != null) {
        _selectedImagePath = imagePath;
        _safeEmit(
          ProfileImageSelected(
            imagePath: imagePath,
            currentProfile: currentProfile,
          ),
        );
      } else {
        await fetchUserProfile();
      }
    } catch (e) {
      _safeEmit(ProfileError(message: 'Failed to pick image: ${e.toString()}'));
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

      _safeEmit(const ProfileImagePicking());
      final String? imagePath = await _imagePickerService.pickImageFromCamera();

      if (imagePath != null && currentProfile != null) {
        _selectedImagePath = imagePath;
        _safeEmit(
          ProfileImageSelected(
            imagePath: imagePath,
            currentProfile: currentProfile,
          ),
        );
      } else {
        await fetchUserProfile();
      }
    } catch (e) {
      _safeEmit(ProfileError(message: 'Failed to take photo: ${e.toString()}'));
      await fetchUserProfile();
    }
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    String? password,
  }) async {
    try {
      _safeEmit(const ProfileLoading());

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

      if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
        final uploadedImageUrl = await _repository.updateProfilePicture(
          _selectedImagePath!,
        );
        imageUrl = uploadedImageUrl ?? imageUrl;
      }

      final nameParts = fullName.trim().split(RegExp(r'\s+'));
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName =
          nameParts.length > 1
              ? nameParts.sublist(1).join(' ')
              : currentProfile.lastName;

      final updatedProfile = currentProfile.copyWith(
        firstName: firstName,
        lastName: lastName,
        name: fullName,
        email: email,
        phoneNumber: phoneNumber,
        profileImage: imageUrl,
      );

      await _repository.updateUserProfile(updatedProfile);
      final refreshedProfile = await _repository.getUserProfile();
      _selectedImagePath = null;
      _safeEmit(ProfileUpdateSuccess(userProfile: refreshedProfile));
    } catch (e) {
      _safeEmit(
        ProfileError(message: 'Failed to update profile: ${e.toString()}'),
      );

      await fetchUserProfile();
    }
  }

  void clearSelectedImage() {
    _selectedImagePath = null;
    fetchUserProfile();
  }
}
