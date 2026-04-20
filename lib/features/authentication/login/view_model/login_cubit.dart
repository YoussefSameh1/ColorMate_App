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
            serverClientId: _googleServerClientId.isEmpty
                ? null
                : _googleServerClientId,
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
      final successMessage = await _authApiService.login(request);

     
      await SimpleAuthStorage().saveCredentials(userNameOrEmail, password);

      emit(state.copyWith(isLoading: false, successMessage: successMessage));
    } on AuthApiException catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    } on PlatformException catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: _mapGooglePlatformError(error),
        ),
      );
    } catch (error) {
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

      final successMessage = await _authApiService.loginWithGoogle(
        idToken: idToken,
      );
      emit(state.copyWith(isLoading: false, successMessage: successMessage));
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
      final successMessage = await _authApiService.login(
        LoginRequestModel(
          userNameOrEmail: email,
          password: password,
          remmberMe: true,
        ),
      );

      emit(state.copyWith(isLoading: false, successMessage: successMessage));
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
