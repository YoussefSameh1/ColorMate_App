import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Android Client ID
  static const String clientId =
      '164037818184-pa6un5m2okoekevlt21q69b0dah66gk6.apps.googleusercontent.com';

  // Web Client ID
  static const String serverClientId =
      '164037818184-eq8utumvsess3iajpajr22rmvn39brkj.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> initGoogleSignIn() async {
    await _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );
  }

  static Future<String?> handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      debugPrint('Google ID Token: $idToken');

      return idToken;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
    }
  }

  static Future<void> handleSignOut() async {
    await _googleSignIn.disconnect();
  }
}
