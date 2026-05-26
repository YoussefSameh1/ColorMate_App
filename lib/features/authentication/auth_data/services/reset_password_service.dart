import 'package:dio/dio.dart';

class ResetPasswordService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://colormate.runasp.net/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _dio.post(
      'Users/ResetPassword',
      data: {
        'email': email,
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }
}
