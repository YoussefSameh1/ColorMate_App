import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/authentication/login/view_model/login_cubit.dart';
import 'package:colormate_app/features/authentication/login/presentation/views/widget/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(AuthApiService()),
        child: const LoginViewBody(),
      ),
    );
  }
}
