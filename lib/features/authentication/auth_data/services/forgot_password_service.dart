import 'package:dio/dio.dart';

class ForgotPasswordService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://colormate.runasp.net/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String> sendResetOtp(String email) async {
    final response = await _dio.post(
      'Users/ForgotPassword',
      data: {'email': email},
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    return _extractMessage(response.data) ??
        'An OTP has been sent to your email.';
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['title'] ?? data['detail'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }
}
