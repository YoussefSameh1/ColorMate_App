import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/features/authentication/signup/presentation/view/widget/signup_form_section.dart';
import 'package:flutter/material.dart';


class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordObscured = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: AppColors.white),
              ),
              const SizedBox(height: 30),
              const Text(
                'Create New Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 30),
              SignupFormSection(
                formKey: _formKey,
                emailController: emailController,
                usernameController: usernameController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                isPasswordObscured: isPasswordObscured,
                errorMessage: errorMessage,
                onSubmit: () {
                  if (!_formKey.currentState!.validate()) return;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
