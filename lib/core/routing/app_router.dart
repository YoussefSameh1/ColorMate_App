import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/features/authentication/login/ui/login_view.dart';
import 'package:colormate_app/features/authentication/signup/ui/signup_View.dart';
import 'package:colormate_app/features/authentication/verify_email/verify_email_view.dart';
import 'package:colormate_app/features/fruits/presentation/views/fruit_intro_view.dart';
import 'package:colormate_app/features/fruits/presentation/views/fruit_result_view.dart';
import 'package:colormate_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:colormate_app/features/splash/presentation/views/splash_view.dart';
import 'package:colormate_app/features/test/presentation/cubit/test_cubit.dart';
import 'package:colormate_app/features/test/presentation/views/test_intro_view.dart';
import 'package:colormate_app/features/test/presentation/views/test_result_view.dart';
import 'package:colormate_app/features/test/presentation/views/test_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'animation_route.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.fruitResultView,
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
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(create: (_) => TestCubit(), child: child);
        },
        routes: [
          GoRoute(
            path: Routes.testIntroView,
            pageBuilder:
                (context, state) =>
                    slideTransitionPage(child: const TestIntroView()),
          ),
          GoRoute(
            path: Routes.testView,
            pageBuilder:
                (context, state) =>
                    slideTransitionPage(child: const TestView()),
          ),
          GoRoute(
            path: Routes.testResultView,
            pageBuilder:
                (context, state) =>
                    slideTransitionPage(child: const TestResultView()),
          ),
        ],
      ),
      GoRoute(
        path: Routes.fruitIntroView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const FruitIntroView()),
      ),
      GoRoute(
        path: Routes.fruitResultView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const FruitResultView()),
      ),
    ],
  );
}
