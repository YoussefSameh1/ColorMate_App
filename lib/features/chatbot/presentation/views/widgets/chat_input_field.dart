import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                textFieldModel: TextFieldModel(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  hintText: 'Type your message...',
                  validator: (_) => null,
                  onFieldSubmitted: (_) => onSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            PrimaryShadowButton(
              text: 'Send',
              icon: Icons.send_rounded,
              onPressed: onSend,
              width: 100,
              height: 48,
              radius: 16,
              backgroundColor: AppColors.primary,
              textStyle: AppTextStyles.semiBold16().copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
