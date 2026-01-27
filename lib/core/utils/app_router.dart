import 'package:colormate_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:colormate_app/features/splash/presentation/views/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {

  static const kOnboardingView = '/onboarding';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),

      GoRoute(path: kOnboardingView, builder: (context, state) => const OnboardingView()),
    ],
  );
}