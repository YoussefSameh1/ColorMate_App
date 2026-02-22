import 'package:colormate_app/features/profile/data/repositories/change_password_repository.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      
    
      // await _apiService.post(
      //   '/user/change-password',
      //   data: {
      //     'old_password': oldPassword,
      //     'new_password': newPassword,
      //   },
      // );

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}
