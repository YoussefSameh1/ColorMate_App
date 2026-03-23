import 'package:colormate_app/core/theme/custom_pin_theme.dart';
import 'package:colormate_app/core/theme/text_style.dart';

import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailViewBody extends StatelessWidget {
  const VerifyEmailViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          SizedBox(height: 40),
          Image.asset('assets/icons/flight.png', height: 160.h),
          SizedBox(height: 5),
          Text(
            'Verify your email',
            style: AppTextStyles.bold32().copyWith(color: AppColors.primary),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
            child: Text(
              'Please enter the verification code we sent to your email address to complete the verification process.',
              style: AppTextStyles.regular16(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Pinput(
              length: 6,
              defaultPinTheme: CustomPinTheme.defaultPinTheme,
              focusedPinTheme: CustomPinTheme.focusedPinTheme,
              separatorBuilder: (index) => SizedBox(width: 8.w), // Gap 8px
              onCompleted: (value) => print('Completed: $value'),
            ),
          ),
          SizedBox(height: 140),
          SecondaryButton(text: 'resend code', onPressed: () {}),
        ],
      ),
    );
  }
}
