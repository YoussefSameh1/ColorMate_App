import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingKey = 'has_seen_onboarding';

  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> hasSeenOnboarding() async {
    return _prefs?.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    await _prefs?.setBool(_onboardingKey, true);
  }

  // Clear onboarding status (for testing)
  Future<void> clearOnboarding() async {
    await _prefs?.remove(_onboardingKey);
  }
}
