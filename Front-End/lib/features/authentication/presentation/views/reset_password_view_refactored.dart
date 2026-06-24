import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colormate_app/features/authentication/presentation/cubit/reset_password_cubit.dart';
import 'package:colormate_app/features/authentication/auth_data/services/reset_password_service.dart';
import 'widget/reset_password_view_body.dart';

class ResetPasswordView extends StatelessWidget {
  final String? email;
  final String? resetToken;

  const ResetPasswordView({super.key, this.email, this.resetToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(ResetPasswordService()),
      child: ResetPasswordViewBody(email: email, resetToken: resetToken),
    );
  }
}
