import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/models/login_request_model.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/login/view_model/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authApiService, {GoogleSignIn? googleSignIn})
    : _googleSignIn =
          googleSignIn ??
          GoogleSignIn(
            scopes: const ['email', 'profile'],
            serverClientId:
                _googleServerClientId.isEmpty ? null : _googleServerClientId,
          ),
      super(LoginState.initial());

  final AuthApiService _authApiService;
  final GoogleSignIn _googleSignIn;

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
      final preview =
          response.token.isEmpty
              ? 'EMPTY'
              : response.token.substring(
                0,
                response.token.length < 20 ? response.token.length : 20,
              );

      print('📝 Saving credentials with token: $preview...');
      await SimpleAuthStorage().saveCredentials(
        userNameOrEmail,
        password,
        token: response.token,
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
      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();
      if (account == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Google sign-in was cancelled.',
          ),
        );
        return;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'Google idToken is missing. Set GOOGLE_SERVER_CLIENT_ID with your Web Client ID.',
          ),
        );
        return;
      }

      final response = await _authApiService.loginWithGoogle(idToken: idToken);
      final preview =
          response.token.isEmpty
              ? 'EMPTY'
              : response.token.substring(
                0,
                response.token.length < 20 ? response.token.length : 20,
              );

      print('📝 Saving credentials from Google with token: $preview...');
      await SimpleAuthStorage().saveCredentials('', '', token: response.token);
      print('✓ Google credentials saved');

      emit(state.copyWith(isLoading: false, successMessage: response.message));
    } on AuthApiException catch (error) {
      print('✗ Google login error: ${error.message}');
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    } catch (error) {
      print('✗ Google login unexpected error: $error');
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

  /// الدخول التلقائي بالبيانات المحفوظة
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
      final email = storage.getSavedEmail();
      final password = storage.getSavedPassword();
      final token = storage.getSavedToken();

      if (token != null && token.isNotEmpty) {
        // إذا كان عندنا token محفوظ، نعتبر أن المستخدم مسجل
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: 'Auto-login successful.',
          ),
        );
        return;
      }

      if (email == null || password == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No saved credentials found.',
          ),
        );
        return;
      }

      // دخول بالبيانات المحفوظة
      final response = await _authApiService.login(
        LoginRequestModel(
          userNameOrEmail: email,
          password: password,
          remmberMe: true,
        ),
      );

      await storage.saveCredentials(email, password, token: response.token);

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
}
