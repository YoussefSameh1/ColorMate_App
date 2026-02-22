import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/validation/validation.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:colormate_app/core/widget/labels/custom_field_label.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    super.key,
    required this.formKey,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CustomFieldLabel(label: 'Current Password'),
          const SizedBox(height: 12),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: oldPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your current password',
              icon: Icons.lock,
              obscureText: true,
              validator: Validation.validatePassword,
            ),
          ),
          const SizedBox(height: 28),
          CustomFieldLabel(label: 'New Password'),
          const SizedBox(height: 12),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: newPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your new password',
              icon: Icons.lock,
              obscureText: true,
              validator: Validation.validatePassword,
            ),
          ),
          const SizedBox(height: 28),
          CustomFieldLabel(label: 'Confirm Password'),
          const SizedBox(height: 12),
          CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Confirm your new password',
              icon: Icons.lock,
              obscureText: true,
              validator:
                  (value) => Validation.validateConfirmPassword(
                    value,
                    newPasswordController,
                  ),
            ),
          ),
          const SizedBox(height: 40),
          PrimaryShadowButton(
            text: 'Save Changes',
            onPressed: isSubmitting ? () {} : onSubmit,
            isLoading: isSubmitting,
          ),
        ],
      ),
    );
  }
}
