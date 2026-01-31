import 'package:colormate_app/features/authentication/verify_email/widget/Verify_Email_View_Body.dart';
import 'package:colormate_app/core/widget/buttons/custom_back_button.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

          child: const CustomBackButton(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const VerifyEmailViewBody(),
    );
  }
}
