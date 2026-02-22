import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/validation/validation.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/custom_form_section.dart';
import 'package:flutter/material.dart';

class FormEditProfile extends StatelessWidget {
  const FormEditProfile({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordObscured,
    this.errorMessage,
    required this.usernameController,
    this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
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
          CustomFormSection(
            label: 'Full Name',
            isRequired: true,
            textFieldModel: TextFieldModel(
              controller: usernameController,
              keyboardType: TextInputType.name,
              hintText: 'mariam naeem',
              validator: Validation.validateFullName,
              prefixIcon: Icon(Icons.person, color: AppColors.primary),
              icon: Icons.person,
            ),
          ),
          const SizedBox(height: 20),
          CustomFormSection(
            label: 'Email Address',
            isRequired: true,
            textFieldModel: TextFieldModel(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'mariam@example.com',
              validator: Validation.emailValidation,
              prefixIcon: const Icon(Icons.email, color: AppColors.primary),
              icon: Icons.email,
            ),
          ),
          const SizedBox(height: 20),
          CustomFormSection(
            label: 'Password',
            isRequired: false,
            textFieldModel: TextFieldModel(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: '*************',
              validator: Validation.validatePassword,
              prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
              icon: Icons.lock,
              obscureText: isPasswordObscured,
            ),
          ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
