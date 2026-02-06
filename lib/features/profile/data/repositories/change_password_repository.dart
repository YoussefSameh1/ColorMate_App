abstract class ChangePasswordRepository {
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
