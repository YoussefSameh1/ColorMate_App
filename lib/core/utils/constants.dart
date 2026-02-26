import 'package:flutter/painting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const kPoppinsFont = 'Poppins';
const kBackgroundColor = Color(0xFFFFFFFF);
const kPrimaryColor = Color(0xFF543310);
const kSecondaryColor = Color(0xFFf0e4d3);
const kSubTitleColor = Color(0xFF74512d);
const kAccentColor = Color(0xFFaf8f6f);

String get kGeminiApiKey {
  final gemini = dotenv.env['GEMINI_API_KEY']?.trim();
  if (gemini != null && gemini.isNotEmpty) {
    return gemini;
  }

  final google = dotenv.env['GOOGLE_API_KEY']?.trim();
  if (google != null && google.isNotEmpty) {
    return google;
  }

  final generic = dotenv.env['API_KEY']?.trim();
  if (generic != null && generic.isNotEmpty) {
    return generic;
  }

  return '';
}
