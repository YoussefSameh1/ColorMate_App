import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/validation/validation.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/buttons/social_auth_buttons.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupFormSection extends StatelessWidget {
  const SignupFormSection({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordObscured,
    required this.isLoading,
    this.errorMessage,
    this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordObscured;
  final bool isLoading;
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
              controller: firstNameController,
              keyboardType: TextInputType.name,
              hintText: 'Enter your first name',
              validator: (value) =>
                  Validation.validateEmptyText('First name', value),
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: lastNameController,
              keyboardType: TextInputType.name,
              hintText: 'Enter your last name',
              validator: (value) =>
                  Validation.validateEmptyText('Last name', value),
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: usernameController,
              keyboardType: TextInputType.name,
              hintText: 'Enter your username',
              validator: Validation.validateUserName,
              labelText: 'Username',
              prefixIcon: Icon(Icons.person, color: AppColors.primary),
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter your email',
              validator: Validation.emailValidation,
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email, color: AppColors.primary),
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
              labelText: 'Password',
              icon: Icons.lock,
              obscureText: isPasswordObscured,
              prefixIcon: Icon(Icons.lock, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'confirm your password',
              validator: (value) =>
                  Validation.validateConfirmPassword(value, passwordController),
              prefixIcon: Icon(Icons.lock, color: AppColors.primary),
              labelText: 'Confirm Password',
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
            text: 'Sign Up',
            onPressed: onSubmit ?? () {},
            height: 50,
            isLoading: isLoading,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: AppTextStyles.regular10().copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
              GestureDetector(
                onTap: () => GoRouter.of(context).push(Routes.loginView),
                child: Text(
                  'Log In',
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
