import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/signup/presentation/views/widget/signup_view_body.dart';
import 'package:colormate_app/features/authentication/signup/view_model/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignupCubit(AuthApiService()),
        child: const SignupViewBody(),
      ),
    );
  }
}
