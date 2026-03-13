class Routes {
  // Singleton instance
  static final Routes _instance = Routes._internal();

  // Private constructor
  Routes._internal();

  // Factory constructor to return the same instance
  factory Routes() {
    return _instance;
  }

  // Static route constants

  static const String splashView = '/splash_view';
  static const String onboardingView = '/onboarding';
  static const String loginView = '/login_view';
  static const String signupView = '/signup_View';
  static const String verifyEmailView = '/verify_email_view';
  static const String testIntroView = '/test_intro_view';
  static const String testView = '/test_view';
  static const String testResultView = '/test_result_view';
  static const String gameSelectionView = '/game_selection_view';
  static const String colorCollectorGameView = '/color_collector_game_view';
  static const String memoryMatchGameView = '/memory_match_game_view';
  static const String colorThePictureGameView = '/color_the_picture_game_view';
  static const String sequenceGameView = '/sequence_game_view';
  static const String findTheObjectGameView = '/find_the_object_game_view';
}
