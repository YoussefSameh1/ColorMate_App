import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/verify_email/view_model/verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit(this._authApiService) : super(VerifyEmailState.initial());

  final AuthApiService _authApiService;

  Future<void> verifyOtp({required String email, required String code}) async {
    emit(
      state.copyWith(
        isVerifying: true,
        isVerified: false,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final successMessage = await _authApiService.verifyEmailOtp(
        email: email,
        code: code,
      );
      emit(
        state.copyWith(
          isVerifying: false,
          isVerified: true,
          successMessage: successMessage,
        ),
      );
    } on AuthApiException catch (error) {
      emit(
        state.copyWith(
          isVerifying: false,
          isVerified: false,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isVerifying: false,
          isVerified: false,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(
      state.copyWith(
        isResending: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final successMessage = await _authApiService.resendOtp(email: email);
      emit(state.copyWith(isResending: false, successMessage: successMessage));
    } on AuthApiException catch (error) {
      emit(state.copyWith(isResending: false, errorMessage: error.message));
    } catch (error) {
      emit(
        state.copyWith(
          isResending: false,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
