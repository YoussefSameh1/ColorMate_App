import 'package:colormate_app/core/services/storage_service.dart';
import 'package:colormate_app/core/utils/app_router.dart';
import 'package:colormate_app/core/utils/assets_data.dart';
import 'package:colormate_app/home_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  double opacity = 0;
  double scale = 0.5;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        opacity = 1;
        scale = 1;
      });
    });

    navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(seconds: 1),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
          child: Image.asset(AssetsData.logo),
        ),
      ),
    );
  }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final storageService = await StorageService.getInstance();
      final isOnboardingSeen = await storageService.hasSeenOnboarding();

      if (isOnboardingSeen) {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeTest()),
            );
      } else {
        context.go(AppRouter.kOnboardingView);
      }
    });
  }
}
