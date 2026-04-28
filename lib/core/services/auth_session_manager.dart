import 'package:dio/dio.dart';

import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';

class AuthSessionException implements Exception {
  const AuthSessionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthSessionManager {
  AuthSessionManager({
    AuthApiService? authApiService,
    SimpleAuthStorage? storage,
  }) : _authApi = authApiService ?? AuthApiService(),
       _storage = storage ?? SimpleAuthStorage();

  final AuthApiService _authApi;
  final SimpleAuthStorage _storage;

  Future<void> init() async {
    await _storage.init();
  }

  Future<String> getValidAccessToken() async {
    final token = _storage.getSavedToken();
    if (token == null || token.isEmpty) {
      throw const AuthSessionException('Unauthorized: please login again.');
    }

    if (!_storage.isTokenExpired()) {
      return token;
    }

    final refreshed = await _tryRefresh(accessToken: token);
    if (refreshed == null || refreshed.isEmpty) {
      await clearSession();
      throw const AuthSessionException('Unauthorized: please login again.');
    }

    return refreshed;
  }

  Future<String?> _tryRefresh({String? accessToken}) async {
    try {
      final refreshToken = _storage.getSavedRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return null;

      final resp = await _authApi.refreshToken(
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      if (resp.token.isEmpty) return null;

      await _storage.saveSession(
        token: resp.token,
        refreshToken: resp.refreshToken ?? refreshToken,
        tokenExpiry: resp.expiresOn,
        refreshTokenExpiry: resp.refreshTokenExpiration,
      );

      return resp.token;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    await _storage.init();
    await _storage.clearCredentials();
  }
}
