import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:colormate_app/core/validation/validation.dart';
import 'package:colormate_app/features/authentication/signup/ui/signup_View.dart';
import 'package:colormate_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordObscured = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
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
                  'Login to Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(height: 30),

                CustomTextFormField(
                  
                  textFieldModel: TextFieldModel(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                    validator: Validation.emailValidation,
                    labelText: 'Email Address',
                    icon: Icons.email,
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Enter your password',
                    validator: Validation.validatePassword,
                    prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                    labelText: 'Password',
                    icon: Icons.lock,
                    obscureText: isPasswordObscured,
                  ),
                ),
                const SizedBox(height: 20),

                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error, width: 1),
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: AppColors.error, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 30),

                PrimaryShadowButton(
                  text: 'Login',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                  },
                  height: 50,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => GoRouter.of(context).push(Routes.signupView),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/icons/google_icon.png',
                        width: 44,
                        height: 44,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/icons/facebook_icon.png',
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
