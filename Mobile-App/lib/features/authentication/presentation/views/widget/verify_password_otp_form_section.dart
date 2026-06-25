import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/theme/custom_pin_theme.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:colormate_app/features/authentication/presentation/cubit/verify_password_otp_cubit.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:colormate_app/core/theme/app_colors.dart';

class VerifyPasswordOtpFormSection extends StatefulWidget {
  final String email;

  const VerifyPasswordOtpFormSection({super.key, required this.email});

  @override
  State<VerifyPasswordOtpFormSection> createState() =>
      _VerifyPasswordOtpFormSectionState();
}

class _VerifyPasswordOtpFormSectionState
    extends State<VerifyPasswordOtpFormSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyPasswordOtpCubit, VerifyPasswordOtpState>(
      listener: (context, state) {
        if (state is VerifyPasswordOtpSuccess) {
          _showSuccessDialog(context, state.resetToken);
        }

        if (state is VerifyPasswordOtpResendSuccess) {
          _showSnackBar(context, state.message);
        }

        if (state is VerifyPasswordOtpError) {
          _showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        final isVerifying = state is VerifyPasswordOtpLoading;
        final isResending = state is VerifyPasswordOtpResendLoading;

        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/icons/flight.png', height: 160.h),
                const SizedBox(height: 5),
                Text(
                  'Verify Password OTP',
                  style: AppTextStyles.bold32().copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 38,
                    vertical: 20,
                  ),
                  child: Text(
                    'Please enter the OTP code we sent to your email address to continue resetting your password.',
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
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: CustomPinTheme.defaultPinTheme,
                    focusedPinTheme: CustomPinTheme.focusedPinTheme,
                    separatorBuilder: (index) => SizedBox(width: 8.w),
                    onCompleted: _submitOtp,
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryShadowButton(
                  text: 'Verify OTP',
                  isLoading: isVerifying,
                  onPressed: () {
                    final otp = _otpController.text.trim();
                    if (!_isValidOtp(otp)) {
                      _showSnackBar(
                        context,
                        'Please enter a valid 6-digit OTP.',
                      );
                      return;
                    }
                    _submitOtp(otp);
                  },
                ),
                const SizedBox(height: 20),
                SecondaryButton(
                  text: isResending ? 'resending...' : 'resend OTP',
                  onPressed:
                      isResending
                          ? null
                          : () {
                            if (!_hasEmail) {
                              _showSnackBar(
                                context,
                                'Email is missing. Please go back and try again.',
                              );
                              return;
                            }

                            context.read<VerifyPasswordOtpCubit>().resendOtp(
                              email: widget.email,
                            );
                          },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitOtp(String value) {
    if (!_hasEmail) {
      _showSnackBar(context, 'Email is missing. Please go back and try again.');
      return;
    }

    context.read<VerifyPasswordOtpCubit>().verifyOtp(
      email: widget.email,
      otpCode: value,
    );
  }

  bool get _hasEmail => widget.email.trim().isNotEmpty;

  bool _isValidOtp(String value) => value.length == 6;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog(BuildContext context, String resetToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'OTP verified successfully',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your reset token is ready. Continue to set a new password.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B3F2B),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    GoRouter.of(context).push(
                      '${Routes.resetPasswordView}?email=${Uri.encodeComponent(_emailController.text.trim())}&resetToken=${Uri.encodeComponent(resetToken)}',
                    );
                  },
                  child: const Text(
                    'Go to Reset Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
