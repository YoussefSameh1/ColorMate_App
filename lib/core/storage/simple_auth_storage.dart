import 'package:shared_preferences/shared_preferences.dart';

class SimpleAuthStorage {
  static const String _emailKey = 'saved_email';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _refreshTokenExpiryKey = 'refresh_token_expiry';

  static const String _lastTestDateKey = 'last_test_date';
  static const String _colorblindnessTypeKey = 'colorblindness_type';
  static const String _testDescriptionKey = 'test_description';

  static final SimpleAuthStorage _instance = SimpleAuthStorage._internal();

  SimpleAuthStorage._internal();

  factory SimpleAuthStorage() => _instance;

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<void> saveCredentials(
    String email,
    String _password, {
    String? token,
    String? refreshToken,
    String? tokenExpiry,
    String? refreshTokenExpiry,
  }) async {
    // Kept for backward compatibility with existing call sites.
    // Password is intentionally ignored to avoid persisting secrets.
    await saveSession(
      email: email,
      token: token,
      refreshToken: refreshToken,
      tokenExpiry: tokenExpiry,
      refreshTokenExpiry: refreshTokenExpiry,
    );
  }

  Future<void> saveSession({
    String? email,
    String? token,
    String? refreshToken,
    String? tokenExpiry,
    String? refreshTokenExpiry,
  }) async {
    await _ensureInitialized();
    if (email != null) {
      await _prefs.setString(_emailKey, email);
    }

    if (token != null) {
      await _prefs.setString(_tokenKey, token);
    }

    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }

    if (tokenExpiry != null) {
      await _prefs.setString(_tokenExpiryKey, tokenExpiry);
    }

    if (refreshTokenExpiry != null) {
      await _prefs.setString(_refreshTokenExpiryKey, refreshTokenExpiry);
    }
  }

  String? getSavedEmail() {
    if (!_isInitialized) return null;
    return _prefs.getString(_emailKey);
  }

  String? getSavedToken() {
    if (!_isInitialized) return null;
    return _prefs.getString(_tokenKey);
  }

  String? getSavedRefreshToken() {
    if (!_isInitialized) return null;
    return _prefs.getString(_refreshTokenKey);
  }

  String? getSavedTokenExpiry() {
    if (!_isInitialized) return null;
    return _prefs.getString(_tokenExpiryKey);
  }

  String? getSavedRefreshTokenExpiry() {
    if (!_isInitialized) return null;
    return _prefs.getString(_refreshTokenExpiryKey);
  }

  Future<void> clearCredentials() async {
    await _ensureInitialized();
    await _prefs.remove(_emailKey);
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_tokenExpiryKey);
    await _prefs.remove(_refreshTokenExpiryKey);
  }

  Future<bool> hasCredentials() async {
    await _ensureInitialized();
    final token = _prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<bool> hasSession() async {
    return hasCredentials();
  }

  bool isTokenExpired({Duration skew = const Duration(seconds: 30)}) {
    if (!_isInitialized) return true;
    final rawExpiry = _prefs.getString(_tokenExpiryKey);
    if (rawExpiry == null || rawExpiry.isEmpty) {
      return false;
    }

    final expiry = DateTime.tryParse(rawExpiry);
    if (expiry == null) {
      return false;
    }

    return DateTime.now().toUtc().isAfter(expiry.toUtc().subtract(skew));
  }


  Future<void> saveTestResult({
    required String diagnosis,
    required String testDate,
    required String testDescription,
  }) async {
    await _ensureInitialized();
    await _prefs.setString(_lastTestDateKey, testDate);
    await _prefs.setString(_colorblindnessTypeKey, diagnosis);
    await _prefs.setString(_testDescriptionKey, testDescription);
  }

  String? getSavedLastTestDate() {
    if (!_isInitialized) return null;
    return _prefs.getString(_lastTestDateKey);
  }

  String? getSavedColorblindnessType() {
    if (!_isInitialized) return null;
    return _prefs.getString(_colorblindnessTypeKey);
  }

  String? getSavedTestDescription() {
    if (!_isInitialized) return null;
    return _prefs.getString(_testDescriptionKey);
  }
}
