import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/profile/data/repositories/change_password_repository.dart';
import 'package:colormate_app/features/profile/data/services/profile_api_service.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  ChangePasswordRepositoryImpl({
    AuthApiService? authApiService,
    ProfileApiService? profileApiService,
  }) : _authApiService = authApiService ?? AuthApiService(),
       _profileApiService = profileApiService ?? ProfileApiService();

  final AuthApiService _authApiService;
  final ProfileApiService _profileApiService;

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final storage = SimpleAuthStorage();
    await storage.init();

    final token = await _resolveUsableToken(storage);
    return _profileApiService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      accessToken: token,
    );
  }

  Future<String> _resolveUsableToken(SimpleAuthStorage storage) async {
    final token = storage.getSavedToken();
    if (token == null || token.isEmpty) {
      throw const ProfileApiException('Unauthorized: please login again.');
    }

    if (!storage.isTokenExpired()) {
      return token;
    }

    final refreshedToken = await _refreshAccessToken(
      storage,
      accessToken: token,
    );
    if (refreshedToken == null || refreshedToken.isEmpty) {
      await _revokeAndClearSession(storage, accessToken: token);
      throw const ProfileApiException('Unauthorized: please login again.');
    }

    return refreshedToken;
  }

  Future<String?> _refreshAccessToken(
    SimpleAuthStorage storage, {
    String? accessToken,
  }) async {
    try {
      final refreshToken = storage.getSavedRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      final refreshed = await _authApiService.refreshToken(
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      if (refreshed.token.isEmpty) {
        return null;
      }

      await storage.saveSession(
        token: refreshed.token,
        refreshToken: refreshed.refreshToken ?? refreshToken,
        tokenExpiry: refreshed.expiresOn,
        refreshTokenExpiry: refreshed.refreshTokenExpiration,
      );

      return refreshed.token;
    } catch (_) {
      return null;
    }
  }

  Future<void> _revokeAndClearSession(
    SimpleAuthStorage storage, {
    String? accessToken,
  }) async {
    final refreshToken = storage.getSavedRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _authApiService.revokeToken(
          refreshToken: refreshToken,
          accessToken: accessToken,
        );
      } catch (_) {
        // Ignore revoke failures and continue with local cleanup.
      }
    }

    await storage.clearCredentials();
  }
}
