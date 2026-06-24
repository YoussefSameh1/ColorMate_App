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
    required this.isRememberMe,
    required this.isLoading,
    required this.onRememberMeChanged,
    this.onSubmit,
    this.onGooglePressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final bool isRememberMe;
  final bool isLoading;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback? onSubmit;
  final VoidCallback? onGooglePressed;

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
              keyboardType: TextInputType.text,
              hintText: 'Enter your email or username',
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
              validator:
                  (value) =>
                      Validation.validateEmptyText('Email or username', value),
              labelText: 'Email or Username',
              icon: Icons.email,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your password',
              validator:
                  (value) => Validation.validateEmptyText('Password', value),
              prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
              labelText: 'Password',
              icon: Icons.lock,
              obscureText: isPasswordObscured,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    onChanged: (value) {
                      if (value != null) {
                        onRememberMeChanged(value);
                      }
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              GestureDetector(
                onTap:
                    () => GoRouter.of(context).push(Routes.forgotPasswordView),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.bold10().copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          PrimaryShadowButton(
            text: 'Login',
            onPressed: onSubmit ?? () {},
            height: 50,
            isLoading: isLoading,
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
          SocialAuthButtons(
            iconSize: 44,
            spacing: 16,
            onGooglePressed: onGooglePressed,
          ),
        ],
      ),
    );
  }
}
