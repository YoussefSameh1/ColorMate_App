import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:colormate_app/features/authentication/auth_data/models/signup_request_model.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/signup/view_model/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._authApiService) : super(SignupState.initial());

  final AuthApiService _authApiService;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
    String profilePictureUrl = '',
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final request = SignupRequestModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      profilePictureUrl: profilePictureUrl,
      userName: userName,
      password: password,
      confirmPassword: confirmPassword,
    );

    try {
      final successMessage = await _authApiService.register(request);
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          successMessage: successMessage,
        ),
      );
    } on AuthApiException catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
