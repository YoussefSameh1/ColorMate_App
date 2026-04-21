import 'package:colormate_app/core/widget/loaders.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/profile/presentation/cubit/cubit_change_password/change_password_cubit.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/change_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitChangePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          Loaders.success(
            context,
            title: 'Success',
            message: 'Password changed successfully!',
          );
        } else if (state is ChangePasswordFailure) {
          Loaders.error(context, title: 'Error', message: state.message);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(title: 'Change Password'),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                builder: (context, state) {
                  final isSubmitting = state is ChangePasswordSubmitting;

                  return ChangePasswordForm(
                    formKey: _formKey,
                    oldPasswordController: _oldPasswordController,
                    newPasswordController: _newPasswordController,
                    confirmPasswordController: _confirmPasswordController,
                    isSubmitting: isSubmitting,
                    onSubmit: _submitChangePassword,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
