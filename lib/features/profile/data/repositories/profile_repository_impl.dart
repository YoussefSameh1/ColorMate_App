import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:colormate_app/features/profile/data/repositories/profile_repository.dart';

// import 'package:colormate_app/core/networking/api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  // final ApiService _apiService;
  // ProfileRepositoryImpl(this._apiService);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      // final response = await _apiService.get('/user/profile');
      // return UserProfileModel.fromJson(response.data);

      
      //  Mock data
      await Future.delayed(const Duration(milliseconds: 300));
      return UserProfileModel(
        name: 'Mariam Naeem',
        email: 'mariam@gmail.com',
        profileImage: null,
        lastTestDate: 'October 26, 2023',
        colorblindnessType: 'Mild Protanopia',
        testDescription:
            'Initial screening indicated a mild form of red-green color deficiency.',
      );
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      // String? imageUrl = profile.profileImage;
      // if (profile.profileImage != null &&
      //     (profile.profileImage!.startsWith('/') ||
      //      profile.profileImage!.startsWith('file://'))) {

      //   imageUrl = await _uploadImageToServer(profile.profileImage!);
      // }

      // final updatedProfile = profile.copyWith(profileImage: imageUrl);
      // await _apiService.put(
      //   '/user/profile',
      //   data: {
      //     'name': updatedProfile.name,
      //     'email': updatedProfile.email,
      //     'profile_image': updatedProfile.profileImage,
      //   },
      // );

      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Future<String> _uploadImageToServer(String imagePath) async {
  //   try {

  //     final cleanPath = imagePath.replaceFirst('file://', '');
  //     final File imageFile = File(cleanPath);
  //

  //     if (!await imageFile.exists()) {
  //       throw Exception('Image file not found at: $cleanPath');
  //     }
  //

  //     final formData = FormData.fromMap({
  //       'image': await MultipartFile.fromFile(
  //         imageFile.path,
  //         filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //       ),
  //     });
  //
  //
  //     final response = await _apiService.post('/upload/profile-image', data: formData);
  //

  //     if (response.data['success'] == true && response.data['image_url'] != null) {
  //       return response.data['image_url'];
  //     } else {
  //       throw Exception('Invalid response from server');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to upload image: $e');
  //   }
  // }
}
