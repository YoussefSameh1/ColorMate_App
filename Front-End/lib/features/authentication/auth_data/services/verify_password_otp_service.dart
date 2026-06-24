import 'package:dio/dio.dart';

class VerifyPasswordOtpService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://colormate.runasp.net/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _dio.post(
      'Users/VerifyPasswordOtp',
      data: {'email': email, 'otpCode': otpCode},
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    final resetToken = _extractValue(response.data, [
      'resetToken',
      'reset_token',
      'token',
    ]);
    if (resetToken != null && resetToken.isNotEmpty) {
      return resetToken;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'resetToken was not returned by the server.',
    );
  }

  Future<String> resendOtp({required String email}) async {
    final response = await _dio.post(
      'Users/ResendPasswordOtp',
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
        'A new OTP has been sent to your email.';
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

  String? _extractValue(dynamic data, List<String> keys) {
    if (data is Map<String, dynamic>) {
      for (final key in keys) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }
}
