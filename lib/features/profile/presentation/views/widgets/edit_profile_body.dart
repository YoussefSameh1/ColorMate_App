import 'package:colormate_app/core/widget/bottom_sheets/custom_image_source_bottom_sheet.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/profile_listener.dart';
import 'package:colormate_app/features/profile/presentation/views/widgets/profile_ui_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordObscured = true;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (bottomSheetContext) => CustomImageSourceBottomSheet(
            onCameraSelected: profileCubit.pickImageFromCamera,
            onGallerySelected: profileCubit.pickImageFromGallery,
          ),
    );
  }

  void _saveChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateUserProfile(
        fullName: usernameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        password:
            passwordController.text.isNotEmpty ? passwordController.text : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileListener(
      usernameController: usernameController,
      emailController: emailController,
      phoneController: phoneController,
      child: ProfileUIBuilder(
        formKey: _formKey,
        emailController: emailController,
        phoneController: phoneController,
        passwordController: passwordController,
        usernameController: usernameController,
        isPasswordObscured: isPasswordObscured,
        onImagePickerTap: () => _showImageSourceBottomSheet(context),
        onSavePressed: () => _saveChanges(context),
      ),
    );
  }
}
