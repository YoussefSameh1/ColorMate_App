import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/custom_pin_theme.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:colormate_app/features/authentication/verify_email/view_model/verify_email_cubit.dart';
import 'package:colormate_app/features/authentication/verify_email/view_model/verify_email_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailViewBody extends StatefulWidget {
  const VerifyEmailViewBody({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailViewBody> createState() => _VerifyEmailViewBodyState();
}

class _VerifyEmailViewBodyState extends State<VerifyEmailViewBody> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        if (state.isVerified) {
          context.go(Routes.loginView);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/icons/flight.png', height: 160.h),
              const SizedBox(height: 5),
              Text(
                'Verify your email',
                style: AppTextStyles.bold32().copyWith(
                  color: AppColors.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 38,
                  vertical: 20,
                ),
                child: Text(
                  'Please enter the verification code we sent to your email address to complete the verification process.',
                  style: AppTextStyles.regular16(),
                  textAlign: TextAlign.center,
                ),
              ),
              if (widget.email.isNotEmpty)
                Text(
                  widget.email,
                  style: AppTextStyles.medium16().copyWith(
                    color: AppColors.primary,
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Pinput(
                  controller: otpController,
                  length: 6,
                  defaultPinTheme: CustomPinTheme.defaultPinTheme,
                  focusedPinTheme: CustomPinTheme.focusedPinTheme,
                  separatorBuilder: (index) => SizedBox(width: 8.w),
                  onCompleted: (value) {
                    if (widget.email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Email is missing. Please register again.',
                          ),
                        ),
                      );
                      return;
                    }

                    context.read<VerifyEmailCubit>().verifyOtp(
                      email: widget.email,
                      code: value,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              PrimaryShadowButton(
                text: 'Verify OTP',
                isLoading: state.isVerifying,
                onPressed: () {
                  final otp = otpController.text.trim();
                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 6-digit OTP.'),
                      ),
                    );
                    return;
                  }

                  if (widget.email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Email is missing. Please register again.',
                        ),
                      ),
                    );
                    return;
                  }

                  context.read<VerifyEmailCubit>().verifyOtp(
                    email: widget.email,
                    code: otp,
                  );
                },
              ),
              const SizedBox(height: 20),
              SecondaryButton(
                text: state.isResending ? 'resending...' : 'resend code',
                onPressed: state.isResending
                    ? null
                    : () {
                        if (widget.email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Email is missing. Please register again.',
                              ),
                            ),
                          );
                          return;
                        }

                        context.read<VerifyEmailCubit>().resendOtp(
                          email: widget.email,
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}
