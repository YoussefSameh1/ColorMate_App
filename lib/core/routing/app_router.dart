import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/authentication/login/presentation/views/login_view.dart';
import 'package:colormate_app/features/authentication/signup/presentation/view/signup_View.dart';

import 'package:colormate_app/features/authentication/verify_email/verify_email_view.dart';
import 'package:colormate_app/features/fruits/presentation/views/fruit_intro_view.dart';
import 'package:colormate_app/features/fruits/presentation/views/fruit_result_view.dart';
import 'package:colormate_app/features/matching/presentation/views/matching_view.dart';
import 'package:colormate_app/features/image_correction/presentation/views/image_correction_view.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/object_and_color_detection_view.dart';
import 'package:colormate_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:colormate_app/features/profile/data/repositories/change_password_repository_impl.dart';
import 'package:colormate_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:colormate_app/features/profile/presentation/cubit/cubit_change_password/change_password_cubit.dart';
import 'package:colormate_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:colormate_app/features/profile/presentation/views/change_password_view.dart';
import 'package:colormate_app/features/profile/presentation/views/edit_profile_view.dart';
import 'package:colormate_app/features/profile/presentation/views/profile_view.dart';
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
      GoRoute(
        path: Routes.editProfileView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: BlocProvider(
                create: (context) => ProfileCubit(ProfileRepositoryImpl()),
                child: const EditProfileView(),
              ),
            ),
      ),
      GoRoute(
        path: Routes.changePasswordView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: BlocProvider(
                create:
                    (context) =>
                        ChangePasswordCubit(ChangePasswordRepositoryImpl()),
                child: const ChangePasswordView(),
              ),
            ),
      ),
      GoRoute(
        path: Routes.profileView,
        pageBuilder:
            (context, state) => slideTransitionPage(
              child: BlocProvider(
                create: (_) => ProfileCubit(ProfileRepositoryImpl()),
                child: const ProfileView(),
              ),
            ),
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
        path: Routes.objectAndColorDetectionView,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => ImagePickerCubit(ImagePickerService()),
            child: const ObjectAndColorDetectionView(),
          );
        },
      ),
      GoRoute(
        path: Routes.imageCorrectionView,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => ImagePickerCubit(ImagePickerService()),
            child: const ImageCorrectionView(),
          );
        },
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
      GoRoute(
        path: Routes.matchingView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const MatchingView()),
      ),
    ],
  );
}
