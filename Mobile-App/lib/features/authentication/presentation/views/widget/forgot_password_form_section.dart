import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/features/authentication/presentation/cubit/forgot_password_cubit.dart';

class ForgotPasswordFormSection extends StatefulWidget {
  const ForgotPasswordFormSection({super.key});

  @override
  State<ForgotPasswordFormSection> createState() =>
      _ForgotPasswordFormSectionState();
}

class _ForgotPasswordFormSectionState extends State<ForgotPasswordFormSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email Address',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF6B3F2B),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF6B3F2B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF6B3F2B),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 24),
          BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                _showSuccessDialog(context);
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ForgotPasswordLoading;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B3F2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<ForgotPasswordCubit>().sendResetLink(
                                _emailController.text.trim(),
                              );
                            }
                          },
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Send OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
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
                  'OTP Sent!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Check your email inbox for the OTP. It expires after 10 minutes, then you can resend it if needed.',
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
                    Future.delayed(const Duration(milliseconds: 300), () {
                      GoRouter.of(context).push(
                        '${Routes.verifyPasswordOtpView}?email=${Uri.encodeComponent(_emailController.text.trim())}',
                      );
                    });
                  },
                  child: const Text(
                    'Go to Verify OTP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
