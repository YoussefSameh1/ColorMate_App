import 'package:colormate_app/core/widget/bottom_nav/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
