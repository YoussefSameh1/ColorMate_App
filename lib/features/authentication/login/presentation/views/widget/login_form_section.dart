import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/buttons/social_auth_buttons.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:colormate_app/core/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:colormate_app/core/routing/routes.dart';
import 'package:go_router/go_router.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordObscured,
    this.errorMessage,
    this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final String? errorMessage;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                style: const TextStyle(color: AppColors.error, fontSize: 14),
              ),
            ),
          const SizedBox(height: 30),
          PrimaryShadowButton(
            text: 'Login',
            onPressed: onSubmit ?? () {},
            height: 50,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: AppTextStyles.regular10().copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
              GestureDetector(
                onTap: () => GoRouter.of(context).push(Routes.signupView),
                child: Text(
                  'Sign up',
                  style: AppTextStyles.bold10().copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SocialAuthButtons(iconSize: 44, spacing: 16),
        ],
      ),
    );
  }
}
