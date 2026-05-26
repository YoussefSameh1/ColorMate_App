part of 'reset_password_cubit.dart';

abstract class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  ResetPasswordSuccess(this.message);
}

final class ResetPasswordError extends ResetPasswordState {
  final String message;
  ResetPasswordError(this.message);
}
