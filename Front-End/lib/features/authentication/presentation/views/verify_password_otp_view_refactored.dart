import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colormate_app/features/authentication/auth_data/services/verify_password_otp_service.dart';
import 'package:colormate_app/features/authentication/presentation/cubit/verify_password_otp_cubit.dart';

import 'widget/verify_password_otp_view_body.dart';

class VerifyPasswordOtpView extends StatelessWidget {
  final String email;

  const VerifyPasswordOtpView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyPasswordOtpCubit(VerifyPasswordOtpService()),
      child: VerifyPasswordOtpViewBody(email: email),
    );
  }
}
