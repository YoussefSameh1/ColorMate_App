import 'package:colormate_app/core/model/text_field_model/text_field_model.dart';
import 'package:colormate_app/core/widget/custom_text_form_field.dart';
import 'package:colormate_app/features/authentication/signup/ui/validator/signup_validators.dart';
import 'package:flutter/material.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordObscured = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.star, color: Colors.white),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Create New Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: usernameController,
                    keyboardType: TextInputType.name,
                    hintText: 'Enter your name',
                    validator: SignupValidators.validateUsername,
                    labelText: 'Name',
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                    validator: SignupValidators.validateEmail,
                    labelText: 'Email Address',
                    icon: Icons.email,
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Enter your password',
                    validator: SignupValidators.validatePassword,
                    labelText: 'Password',
                    icon: Icons.lock,
                    obscureText: isPasswordObscured,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'confirm your password',
                    validator: (value) =>
                        SignupValidators.validateConfirmPassword(
                          value,
                          passwordController.text,
                        ),
                    labelText: 'Confirm Password',
                    icon: Icons.lock,
                    obscureText: isPasswordObscured,
                  ),
                ),
                const SizedBox(height: 20),

                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'login',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.email, size: 30),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.facebook, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
