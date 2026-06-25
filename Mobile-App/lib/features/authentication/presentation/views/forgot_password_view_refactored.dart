import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colormate_app/features/authentication/presentation/cubit/forgot_password_cubit.dart';
import 'widget/forgot_password_view_body.dart';
import 'package:colormate_app/features/authentication/auth_data/services/forgot_password_service.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(ForgotPasswordService()),
      child: const ForgotPasswordViewBody(),
    );
  }
}
