import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/custom_back_button.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/change_password_body.dart';
import 'package:flutter/material.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: const CustomBackButton(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Change Password',
          style: AppTextStyles.bold20().copyWith(color: AppColors.primary),
        ),
      ),
      body: const ChangePasswordBody(),
    );
  }
}
