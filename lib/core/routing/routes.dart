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

  static const String loginView = '/login_view';
  static const String signupView = '/signup_View';
  static const String verifyEmailView = '/verify_email_view';
}
