import 'package:colormate_app/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {

  const HomeView({super.key});

  static const routeName = 'homeView';

  @override
  Widget build(BuildContext context) {
    return HomeViewBody();
  }
}
