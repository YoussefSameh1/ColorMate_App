import 'package:colormate_app/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = 'homeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomeViewBody();
  }
}