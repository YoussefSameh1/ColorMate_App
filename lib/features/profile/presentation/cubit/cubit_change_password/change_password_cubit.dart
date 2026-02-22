import 'package:colormate_app/features/profile/data/repositories/change_password_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepository _repository;

  ChangePasswordCubit(this._repository) : super(const ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordSubmitting());

    try {
      await _repository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      emit(const ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }
}
