import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/features/authentication/login/presentation/views/login_view.dart';
import 'package:colormate_app/features/authentication/login/presentation/views/login_success_test_view.dart';

import 'package:colormate_app/features/authentication/signup/presentation/views/signup_view.dart';
import 'package:colormate_app/features/authentication/verify_email/presentation/views/verify_email_view.dart';

import 'package:go_router/go_router.dart';

import 'animation_route.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.loginView,
    routes: [
      GoRoute(
        path: Routes.signupView,

        pageBuilder: (context, state) =>
            slideTransitionPage(child: const SignupView(), key: state.pageKey),
      ),

      GoRoute(
        path: Routes.loginView,
        pageBuilder: (context, state) =>
            slideTransitionPage(child: const LoginView(), key: state.pageKey),
      ),
      GoRoute(
        path: Routes.verifyEmailView,
        pageBuilder: (context, state) => slideTransitionPage(
          child: VerifyEmailView(
            email: state.uri.queryParameters['email'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: Routes.loginSuccessTestView,
        pageBuilder: (context, state) => slideTransitionPage(
          child: const LoginSuccessTestView(),
          key: state.pageKey,
        ),
      ),
    ],
  );
}
