import 'dart:math';

import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/custom_pin_theme.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/custom_back_button.dart';
import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailViewBody extends StatelessWidget {
  const VerifyEmailViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        Image.asset('assets/icons/flight.png', height: 150.h),
        SizedBox(height: 30),
        Text('Verify Your Email', style: AppTextStyles.bold25()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            'Please enter the verification code we sent to your email address to complete the verification process.',
            style: AppTextStyles.regular18(),
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Pinput(
            length: 6,
            defaultPinTheme: CustomPinTheme.defaultPinTheme,
            focusedPinTheme: CustomPinTheme.focusedPinTheme,
            separatorBuilder: (index) => SizedBox(width: 8.w), // Gap 8px
            onCompleted: (value) => print('Completed: $value'),
          ),
        ),
        SizedBox(height: 40),
        SecondaryButton(text: 'resend code', onPressed: () {}),
      ],
    );
  }
}
