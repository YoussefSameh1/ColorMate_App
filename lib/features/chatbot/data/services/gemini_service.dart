import 'package:colormate_app/features/chatbot/data/models/chat_message_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  final String _apiKey;

  GeminiService({required String apiKey}) : _apiKey = apiKey.trim();

  Future<String> generateColorBlindnessReply({
    required String userMessage,
    required List<ChatMessageModel> history,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Gemini API key is missing. Add GEMINI_API_KEY to the .env file.',
      );
    }

    final contextMessages = history.take(
      history.length > 8 ? 8 : history.length,
    );
    final historyText = contextMessages
        .map(
          (message) =>
              '${message.isUser ? 'User' : 'Assistant'}: ${message.text}',
        )
        .join('\n');

    final prompt = '''
Conversation History:
$historyText

Current User Question:
$userMessage
''';

    try {
      final response = await Gemini.instance.prompt(
        parts: [Part.text('$_systemPrompt\n\n$prompt')],
      );
      final text = response?.output?.trim();

      if (text != null && text.isNotEmpty) {
        return text;
      }

      throw Exception('Failed to generate response from Gemini.');
    } catch (e) {
      final errorText = e.toString();
      final normalized = errorText.toLowerCase();

      if (normalized.contains('429') ||
          normalized.contains('quota') ||
          normalized.contains('permission_denied') ||
          normalized.contains('unauthenticated') ||
          normalized.contains('api key') ||
          normalized.contains('403')) {
        throw Exception(errorText);
      }

      throw Exception(errorText);
    }
  }

  static const String _systemPrompt = '''
You are ColorMate assistant.
Your scope is ONLY color-vision deficiency (color blindness):
- Definitions and types (Protanopia, Deuteranopia, Tritanopia, etc.)
- Test result interpretation (Ishihara-style guidance)
- Daily adaptation tips (education, UI accessibility, lifestyle)
- Color-safe design recommendations and contrast advice
- Myth-busting and supportive explanation in simple language

Rules:
1) If user asks outside color blindness, politely refuse and redirect to color blindness.
2) Keep answers concise, practical, and medically safe.
3) Never provide diagnosis claims; suggest consulting an eye-care professional when needed.
4) Use supportive tone and simple wording.
''';
}
