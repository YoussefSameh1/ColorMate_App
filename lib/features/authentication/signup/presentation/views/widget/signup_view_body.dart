import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/features/authentication/signup/presentation/views/widget/signup_form_section.dart';
import 'package:colormate_app/features/authentication/signup/view_model/signup_cubit.dart';
import 'package:colormate_app/features/authentication/signup/view_model/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'Registered successfully.'),
            ),
          );
          final encodedEmail = Uri.encodeComponent(emailController.text.trim());
          context.push('${Routes.verifyEmailView}?email=$encodedEmail');
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    height: 47,
                    width: 47,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.star, color: AppColors.white),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SignupFormSection(
                    formKey: _formKey,
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    emailController: emailController,
                    usernameController: usernameController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    isPasswordObscured: isPasswordObscured,
                    errorMessage: state.errorMessage,
                    isLoading: state.isLoading,
                    onSubmit: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<SignupCubit>().register(
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        email: emailController.text.trim(),
                        userName: usernameController.text.trim(),
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
