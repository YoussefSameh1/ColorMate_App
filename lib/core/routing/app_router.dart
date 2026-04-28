import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/main_layout.dart';
import 'package:colormate_app/features/authentication/login/presentation/views/login_view.dart';
import 'package:colormate_app/features/games/color_collector_game/presentation/views/color_collector_game_view.dart';
import 'package:colormate_app/features/games/color_the_picture_game/presentation/views/color_the_picture_game_view.dart';
import 'package:colormate_app/features/games/find_the_object_game/presentation/views/find_the_object_game.dart';
import 'package:colormate_app/features/games/memory_match_game/presentation/views/memory_match_game_view.dart';
import 'package:colormate_app/features/games/presentation/views/game_selection_view.dart';
import 'package:colormate_app/features/games/sequence_game/presentation/views/sequence_game_view.dart';
import 'package:colormate_app/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:colormate_app/features/chatbot/data/services/gemini_service.dart';
import 'package:colormate_app/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:colormate_app/features/chatbot/presentation/views/chatbot_view.dart';
import 'package:colormate_app/features/fruits/presentation/views/fruit_intro_view.dart';
import 'package:colormate_app/features/fruits/presentation/views/fruit_result_view.dart';
import 'package:colormate_app/features/image_correction/di/image_correction_di.dart';
import 'package:colormate_app/features/home/presentation/views/home_view.dart';
import 'package:colormate_app/features/matching/presentation/views/matching_view.dart';
import 'package:colormate_app/features/image_correction/presentation/views/image_correction_view.dart';
import 'package:colormate_app/features/object&color_detection/di/object_and_color_detection_di.dart';
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
import 'package:colormate_app/features/authentication/signup/presentation/views/signup_view.dart';
import 'package:colormate_app/features/authentication/verify_email/presentation/views/verify_email_view.dart';

import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
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
        path: Routes.objectAndColorDetectionView,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => buildObjectAndColorDetectionCubit(),
            child: const ObjectAndColorDetectionView(),
          );
        },
      ),
      GoRoute(
        path: Routes.imageCorrectionView,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => buildObjectAndColorDetectionCubit()),
              BlocProvider(create: (_) => buildImageCorrectionCubit()),
            ],
            child: const ImageCorrectionView(),
          );
        },
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
            (context, state) => slideTransitionPage(
              child: VerifyEmailView(
                email: state.uri.queryParameters['email'] ?? '',
              ),
            ),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (_) => ProfileCubit(ProfileRepositoryImpl()),
            child: MainLayout(child: child),
          );
        },
        routes: [
          GoRoute(
            path: Routes.homeView,
            pageBuilder:
                (context, state) =>
                    slideTransitionPage(child: const HomeView()),
          ),
          GoRoute(
            path: Routes.chatbotView,
            pageBuilder:
                (context, state) => slideTransitionPage(
                  child: BlocProvider(
                    create:
                        (_) => ChatbotCubit(
                          ChatbotRepositoryImpl(
                            GeminiService(apiKey: kGeminiApiKey),
                          ),
                        ),
                    child: const ChatbotView(),
                  ),
                ),
          ),
          GoRoute(
            path: Routes.profileView,
            pageBuilder:
                (context, state) =>
                    slideTransitionPage(child: const ProfileView()),
          ),
        ],
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
        builder: (context, state) {
          final imagePath = state.extra as String;

          return FruitResultView(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: Routes.matchingView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const MatchingView()),
      ),
      GoRoute(
        path: Routes.gameSelectionView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const GameSelectionView()),
      ),
      GoRoute(
        path: Routes.colorCollectorGameView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const ColorCollectorGameView()),
      ),
      GoRoute(
        path: Routes.memoryMatchGameView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const MemoryMatchGameView()),
      ),
      GoRoute(
        path: Routes.colorThePictureGameView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const ColorThePictureGameView()),
      ),
      GoRoute(
        path: Routes.sequenceGameView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const SequenceGameView()),
      ),
      GoRoute(
        path: Routes.findTheObjectGameView,
        pageBuilder:
            (context, state) =>
                slideTransitionPage(child: const FindTheObjectGameView()),
      ),
    ],
  );
}
