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
  static const String fruitIntroView = '/fruit_intro_view';
  static const String fruitResultView = '/fruit_result_view';
  static const String matchingView = '/matching_view';
  static const String profileView = '/profile_view';
  static const String editProfileView = '/edit_profile_view';
  static const String changePasswordView = '/change_password_view';
}
