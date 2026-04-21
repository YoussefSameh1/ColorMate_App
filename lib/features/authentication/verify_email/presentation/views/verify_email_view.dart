import 'package:colormate_app/core/widget/buttons/custom_back_button.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/verify_email/presentation/views/widget/verify_email_view_body.dart';
import 'package:colormate_app/features/authentication/verify_email/view_model/verify_email_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: CustomBackButton(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (_) => VerifyEmailCubit(AuthApiService()),
        child: VerifyEmailViewBody(email: email),
      ),
    );
  }
}
