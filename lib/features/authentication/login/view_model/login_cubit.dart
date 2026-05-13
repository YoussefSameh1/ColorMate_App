import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/models/login_request_model.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/login/view_model/login_state.dart';
import 'package:colormate_app/features/authentication/auth_data/services/GoogleAuthService.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authApiService) : super(LoginState.initial());

  final AuthApiService _authApiService;
  static const String _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  Future<void> login({
    required String userNameOrEmail,
    required String password,
    required bool remmberMe,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = LoginRequestModel(
      userNameOrEmail: userNameOrEmail,
      password: password,
      remmberMe: remmberMe,
    );

    try {
      final response = await _authApiService.login(request);
      if (!response.isAuthenticated || response.token.isEmpty) {
        throw const AuthApiException('Login failed. Please try again.');
      }

      final preview =
          response.token.isEmpty
              ? 'EMPTY'
              : response.token.substring(
                0,
                response.token.length < 20 ? response.token.length : 20,
              );

      print('📝 Saving credentials with token: $preview...');
      await SimpleAuthStorage().saveSession(
        email: userNameOrEmail,
        token: response.token,
        refreshToken: response.refreshToken,
        tokenExpiry: response.expiresOn,
        refreshTokenExpiry: response.refreshTokenExpiration,
      );
      print('✓ Credentials saved');

      emit(state.copyWith(isLoading: false, successMessage: response.message));
    } on AuthApiException catch (error) {
      print('✗ Login error: ${error.message}');
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    } on PlatformException catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: _mapGooglePlatformError(error),
        ),
      );
    } catch (error) {
      print('✗ Unexpected error: $error');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final idToken = await GoogleAuthService.handleSignIn();

      if (idToken == null || idToken.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Google sign-in was cancelled or failed.',
          ),
        );
        return;
      }

      final response = await _authApiService.loginWithGoogle(idToken: idToken);

      if (!response.isAuthenticated || response.token.isEmpty) {
        throw const AuthApiException('Google login failed. Please try again.');
      }

      await SimpleAuthStorage().saveSession(
        token: response.token,
        refreshToken: response.refreshToken,
        tokenExpiry: response.expiresOn,
        refreshTokenExpiry: response.refreshTokenExpiration,
      );

      emit(state.copyWith(isLoading: false, successMessage: response.message));
    } on AuthApiException catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  String _mapGooglePlatformError(PlatformException error) {
    final details = (error.details ?? '').toString().toLowerCase();
    final message = (error.message ?? '').toLowerCase();

    if (details.contains('api10') ||
        details.contains('api: 10') ||
        message.contains('api10') ||
        message.contains('api: 10')) {
      return 'Google Sign-In is not configured correctly for this Android build yet.';
    }

    if (error.code == 'sign_in_canceled') {
      return 'Google sign-in was cancelled.';
    }

    if (error.code == 'network_error') {
      return 'Network issue during Google sign-in. Please try again.';
    }

    return 'Google sign-in failed. Please try again.';
  }

  Future<void> autoLogin() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final storage = SimpleAuthStorage();
      await storage.init();
      final token = storage.getSavedToken();

      if (token != null && token.isNotEmpty) {
        if (!storage.isTokenExpired()) {
          emit(
            state.copyWith(
              isLoading: false,
              successMessage: 'Auto-login successful.',
            ),
          );
          return;
        }

        final refreshToken = storage.getSavedRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          print(
            '[AUTH][AUTO] Access token expired. Trying refresh. old=${_tokenPreview(token)}',
          );

          final refreshed = await _authApiService.refreshToken(
            refreshToken: refreshToken,
            accessToken: token,
          );

          if (refreshed.isAuthenticated && refreshed.token.isNotEmpty) {
            print(
              '[AUTH][AUTO] Refresh succeeded. new=${_tokenPreview(refreshed.token)}',
            );

            await storage.saveSession(
              token: refreshed.token,
              refreshToken: refreshed.refreshToken ?? refreshToken,
              tokenExpiry: refreshed.expiresOn,
              refreshTokenExpiry: refreshed.refreshTokenExpiration,
            );

            emit(
              state.copyWith(
                isLoading: false,
                successMessage: 'Auto-login successful.',
              ),
            );
            return;
          }
        }

        await storage.clearCredentials();
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Session expired. Please login again.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'No saved session found.',
        ),
      );
    } on AuthApiException catch (error) {
      await SimpleAuthStorage().clearCredentials();
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    } catch (error) {
      await SimpleAuthStorage().clearCredentials();
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  String _tokenPreview(String? token) {
    if (token == null || token.isEmpty) {
      return 'EMPTY';
    }

    final normalized = token.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );
    final previewLength = normalized.length < 20 ? normalized.length : 20;
    return '${normalized.substring(0, previewLength)}...';
  }
}
