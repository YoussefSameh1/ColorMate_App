import 'package:colormate_app/features/authentication/signup/ui/signup_View.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const ColorMateApp());
}

class ColorMateApp extends StatelessWidget {
  const ColorMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorMate App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const SignupView(),
    );
  }
}
