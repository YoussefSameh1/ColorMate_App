part of 'verify_password_otp_cubit.dart';

abstract class VerifyPasswordOtpState {}

class VerifyPasswordOtpInitial extends VerifyPasswordOtpState {}

class VerifyPasswordOtpLoading extends VerifyPasswordOtpState {}

class VerifyPasswordOtpSuccess extends VerifyPasswordOtpState {
  final String message;
  final String resetToken;

  VerifyPasswordOtpSuccess({required this.message, required this.resetToken});
}

class VerifyPasswordOtpResendLoading extends VerifyPasswordOtpState {}

class VerifyPasswordOtpResendSuccess extends VerifyPasswordOtpState {
  final String message;

  VerifyPasswordOtpResendSuccess({required this.message});
}

class VerifyPasswordOtpError extends VerifyPasswordOtpState {
  final String message;

  VerifyPasswordOtpError({required this.message});
}
