import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile();
  Future<void> updateUserProfile(UserProfileModel profile);
  Future<String?> updateProfilePicture(String imagePath);
}
