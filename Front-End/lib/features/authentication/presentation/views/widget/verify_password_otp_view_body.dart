import 'package:colormate_app/core/widget/buttons/custom_back_button.dart';
import 'package:flutter/material.dart';

import 'verify_password_otp_form_section.dart';

class VerifyPasswordOtpViewBody extends StatelessWidget {
  final String email;

  const VerifyPasswordOtpViewBody({super.key, required this.email});

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
      body: VerifyPasswordOtpFormSection(email: email),
    );
  }
}
