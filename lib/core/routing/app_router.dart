import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/features/authentication/login/ui/login_view.dart';
import 'package:colormate_app/features/authentication/signup/ui/signup_View.dart';
import 'package:colormate_app/features/authentication/verify_email/verify_email_view.dart';
import 'package:colormate_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:colormate_app/features/splash/presentation/views/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'animation_route.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashView,
    routes: [
      GoRoute(
        path: Routes.splashView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: const SplashView(),
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: Routes.onboardingView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: const OnboardingView(),
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: Routes.signupView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: const SignupView(),
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: Routes.loginView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: const LoginView(),
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: Routes.verifyEmailView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const VerifyEmailView()),
      ),
    ],
  );
}
