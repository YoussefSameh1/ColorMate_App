import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/theme/app_colors.dart';

import 'package:colormate_app/core/storage/simple_auth_storage.dart';

import 'package:colormate_app/features/authentication/login/presentation/views/widget/login_form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:colormate_app/features/authentication/login/view_model/login_cubit.dart';
import 'package:colormate_app/features/authentication/login/view_model/login_state.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordObscured = true;
  bool isRememberMe = true;

  @override
  void initState() {
    super.initState();
    _autoLoginIfSavedCredentialsExist();
  }

  Future<void> _autoLoginIfSavedCredentialsExist() async {
    final storage = SimpleAuthStorage();
    await storage.init();

    if (!mounted) return;

    final hasCredentials = await storage.hasCredentials();
    if (hasCredentials) {
      context.read<LoginCubit>().autoLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
          context.go(Routes.homeView);
        }

        if (state.errorMessage != null) {
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
                    'Login to Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginFormSection(
                    formKey: _formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                    isPasswordObscured: isPasswordObscured,
                    isRememberMe: isRememberMe,
                    errorMessage: state.errorMessage,
                    isLoading: state.isLoading,
                    onRememberMeChanged: (value) {
                      setState(() => isRememberMe = value);
                    },
                    onSubmit: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<LoginCubit>().login(
                        userNameOrEmail: emailController.text.trim(),
                        password: passwordController.text,
                        remmberMe: isRememberMe,
                      );
                    },
                    onGooglePressed: () {
                      if (state.isLoading) return;
                      context.read<LoginCubit>().loginWithGoogle();
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
