import 'package:colormate_app/core/storage/simple_auth_storage.dart';
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
      super(const ProfileInitial());

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

      // ✅ Read saved test result from SharedPreferences
      final storage = SimpleAuthStorage();
      await storage.init();

      final savedDate = storage.getSavedLastTestDate();
      final savedType = storage.getSavedColorblindnessType();
      final savedDescription = storage.getSavedTestDescription();

      // ✅ Merge: prefer API values if they exist, fall back to locally saved ones
      final mergedProfile = userProfile.copyWith(
        lastTestDate: userProfile.lastTestDate ?? savedDate,
        colorblindnessType: userProfile.colorblindnessType ?? savedType,
        testDescription: userProfile.testDescription ?? savedDescription,
      );

      _safeEmit(ProfileLoaded(userProfile: mergedProfile));
    } catch (e) {
      print('PROFILE FETCH ERROR: ${e.toString()}');
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
      // ignore: avoid_print
      print('PROFILE IMAGE PICK ERROR: ${e.toString()}');
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
      // ignore: avoid_print
      print('PROFILE IMAGE CAMERA ERROR: ${e.toString()}');
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
      // ignore: avoid_print
      print('PROFILE UPDATE ERROR: ${e.toString()}');
      _safeEmit(
        ProfileError(message: 'Failed to update profile: ${e.toString()}'),
      );

      await fetchUserProfile();
    }
  }

  Future<void> deleteAccount() async {
    _safeEmit(const ProfileDeletionInProgress());

    try {
      final message = await _repository.deleteAccount();
      _safeEmit(ProfileDeletionSuccess(message: message));
    } catch (e) {
      _safeEmit(ProfileError(message: e.toString()));
    }
  }

  void clearSelectedImage() {
    _selectedImagePath = null;
    fetchUserProfile();
  }
}
