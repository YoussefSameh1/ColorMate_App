import 'package:colormate_app/features/authentication/auth_data/services/forgot_password_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordService _service;

  ForgotPasswordCubit(this._service) : super(ForgotPasswordInitial());

  Future<void> sendResetLink(String email) async {
    emit(ForgotPasswordLoading());
    try {
      final message = await _service.sendResetOtp(email);
      emit(ForgotPasswordSuccess(message));
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      emit(ForgotPasswordError(message));
    } catch (e) {
      emit(ForgotPasswordError('Something went wrong. Please try again.'));
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
