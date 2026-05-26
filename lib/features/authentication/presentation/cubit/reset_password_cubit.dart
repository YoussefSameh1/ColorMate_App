import 'package:colormate_app/features/authentication/auth_data/services/reset_password_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordService _service;

  ResetPasswordCubit(this._service) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await _service.resetPassword(
        email: email,
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(ResetPasswordSuccess('Password has been reset successfully.'));
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      emit(ResetPasswordError(message));
    } catch (e) {
      emit(ResetPasswordError('Something went wrong. Please try again.'));
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
