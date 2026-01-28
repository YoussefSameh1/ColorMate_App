import 'package:colormate_app/features/authentication/signup/ui/widget/Signup_View_Body.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SignupViewBody(),
    );
  }
}
