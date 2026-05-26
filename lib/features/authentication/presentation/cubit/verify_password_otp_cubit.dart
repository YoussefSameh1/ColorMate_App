import 'package:colormate_app/features/authentication/auth_data/services/verify_password_otp_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_password_otp_state.dart';

class VerifyPasswordOtpCubit extends Cubit<VerifyPasswordOtpState> {
  final VerifyPasswordOtpService _service;

  VerifyPasswordOtpCubit(this._service) : super(VerifyPasswordOtpInitial());

  Future<void> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    emit(VerifyPasswordOtpLoading());
    try {
      final resetToken = await _service.verifyOtp(
        email: email,
        otpCode: otpCode,
      );
      emit(
        VerifyPasswordOtpSuccess(
          message: 'OTP verified successfully.',
          resetToken: resetToken,
        ),
      );
    } on DioException catch (e) {
      emit(VerifyPasswordOtpError(message: _extractErrorMessage(e)));
    } catch (e) {
      emit(
        VerifyPasswordOtpError(
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(VerifyPasswordOtpResendLoading());
    try {
      final message = await _service.resendOtp(email: email);
      emit(VerifyPasswordOtpResendSuccess(message: message));
    } on DioException catch (e) {
      emit(VerifyPasswordOtpError(message: _extractErrorMessage(e)));
    } catch (e) {
      emit(
        VerifyPasswordOtpError(
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  String _extractErrorMessage(DioException e) {
    final responseData = e.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message =
          responseData['message'] ??
          responseData['title'] ??
          responseData['detail'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData;
    }

    return switch (e.type) {
      DioExceptionType.connectionTimeout =>
        'Connection timed out. Check your internet.',
      DioExceptionType.receiveTimeout => 'Server took too long to respond.',
      DioExceptionType.badResponse => 'Server error: ${e.response?.statusCode}',
      DioExceptionType.connectionError => 'No internet connection.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}
