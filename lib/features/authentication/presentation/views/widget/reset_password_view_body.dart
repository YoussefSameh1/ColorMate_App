import 'package:flutter/material.dart';
import 'reset_password_form_section.dart';

class ResetPasswordViewBody extends StatelessWidget {
  final String? email;
  final String? resetToken;

  const ResetPasswordViewBody({super.key, this.email, this.resetToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6B3F2B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Color(0xFF6B3F2B),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B3F2B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: Color(0xFF6B3F2B),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create New Password',
                style: TextStyle(
                  color: const Color(0xFF6B3F2B),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Use the verified code from the previous step to create a new secure password.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ResetPasswordFormSection(email: email, resetToken: resetToken),
            ],
          ),
        ),
      ),
    );
  }
}
