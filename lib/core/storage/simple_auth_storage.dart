import 'package:shared_preferences/shared_preferences.dart';

class SimpleAuthStorage {
  static const String _emailKey = 'saved_email';
  static const String _passwordKey = 'saved_password';
  static const String _tokenKey = 'auth_token';

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
    String password, {
    String? token,
  }) async {
    await _ensureInitialized();
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_passwordKey, password);
    if (token != null) {
      await _prefs.setString(_tokenKey, token);
    }
  }

  String? getSavedEmail() {
    if (!_isInitialized) return null;
    return _prefs.getString(_emailKey);
  }

  String? getSavedPassword() {
    if (!_isInitialized) return null;
    return _prefs.getString(_passwordKey);
  }

  String? getSavedToken() {
    if (!_isInitialized) return null;
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearCredentials() async {
    await _ensureInitialized();
    await _prefs.remove(_emailKey);
    await _prefs.remove(_passwordKey);
    await _prefs.remove(_tokenKey);
  }

  Future<bool> hasCredentials() async {
    await _ensureInitialized();
    return _prefs.containsKey(_emailKey) && _prefs.containsKey(_passwordKey);
  }
}
