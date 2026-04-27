abstract class ChangePasswordRepository {
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
