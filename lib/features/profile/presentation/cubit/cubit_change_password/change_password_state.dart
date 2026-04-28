part of 'change_password_cubit.dart';

abstract class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordSubmitting extends ChangePasswordState {
  const ChangePasswordSubmitting();
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  const ChangePasswordSuccess({required this.message});
}

class ChangePasswordFailure extends ChangePasswordState {
  final String message;

  const ChangePasswordFailure({required this.message});
}
