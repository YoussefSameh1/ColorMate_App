import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:colormate_app/features/authentication/auth_data/models/login_request_model.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/login/view_model/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authApiService) : super(LoginState.initial());

  final AuthApiService _authApiService;

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
