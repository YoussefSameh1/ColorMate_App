import 'package:colormate_app/core/utils/app_router.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ColorMateApp());
}

class ColorMateApp extends StatelessWidget {
  const ColorMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'ColorMate App',
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: kBackgroundColor,
      )
    );
  }
}