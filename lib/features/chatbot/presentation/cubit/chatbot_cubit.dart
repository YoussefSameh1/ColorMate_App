import 'package:colormate_app/features/chatbot/data/models/chat_message_model.dart';
import 'package:colormate_app/features/chatbot/data/repositories/chatbot_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final ChatbotRepository _chatbotRepository;

  ChatbotCubit(this._chatbotRepository) : super(ChatbotState.initial());

  Future<void> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty || state.isLoading) {
      return;
    }

    final userMessage = ChatMessageModel(
      text: trimmedMessage,
      role: ChatRole.user,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];

    if (!_isColorBlindnessQuestion(trimmedMessage)) {
      final restrictedReply = ChatMessageModel(
        text:
            'I can only help with color blindness topics (types, tests, symptoms, daily tips, and accessibility advice). Please ask me about that.',
        role: ChatRole.bot,
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [...updatedMessages, restrictedReply],
          isLoading: false,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        messages: updatedMessages,
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final botMessage = await _chatbotRepository.sendMessage(
        userMessage: trimmedMessage,
        history: updatedMessages,
      );

      emit(
        state.copyWith(
          messages: [...updatedMessages, botMessage],
          isLoading: false,
        ),
      );
    } catch (e) {
      final fallbackMessage = ChatMessageModel(
        text: _buildFallbackReply(trimmedMessage, e),
        role: ChatRole.bot,
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [...updatedMessages, fallbackMessage],
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  String _mapErrorToMessage(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('api key') ||
        message.contains('permission_denied') ||
        message.contains('unauthenticated') ||
        message.contains('403')) {
      return 'Gemini API key is invalid or restricted. Please check your key settings.';
    }

    if (message.contains('quota') || message.contains('429')) {
      return 'Gemini quota limit reached. Please try again later.';
    }

    if (message.contains('model') && message.contains('not found')) {
      return 'Gemini model is unavailable right now. Please try again in a moment.';
    }

    if (message.contains('socket') ||
        message.contains('network') ||
        message.contains('timed out')) {
      return 'Network issue while connecting to Gemini. Check your internet and try again.';
    }

    return 'Could not get a reply now. Please try again.';
  }

  String _buildFallbackReply(String userMessage, Object error) {
    final mappedError = _mapErrorToMessage(error);

    return '''
$mappedError

Temporary offline guidance about color blindness:
- Protanopia/Protanomaly: reduced sensitivity to red shades.
- Deuteranopia/Deuteranomaly: reduced sensitivity to green shades (most common).
- Tritanopia/Tritanomaly: reduced sensitivity to blue-yellow range.

Practical tips:
- Increase contrast in apps/sites and avoid color-only cues.
- Use labels/icons with colors (not colors alone).
- For Ishihara-like tests, retest in good lighting and compare with clinical exam if needed.

If you want, ask me a specific question (symptoms, Ishihara result, or daily adaptation) and I will answer from local guidance until Gemini is available again.
''';
  }

  bool _isColorBlindnessQuestion(String text) {
    final normalized = _normalizeForTopicCheck(text);

    const directKeywords = [
      'color blind',
      'colour blind',
      'colorblind',
      'colourblind',
      'color blindness',
      'colour blindness',
      'protanopia',
      'protanomaly',
      'deuteranopia',
      'deuteranomaly',
      'tritanopia',
      'tritanomaly',
      'achromatopsia',
      'daltonism',
      'ishihara',
      'red green',
      'blue yellow',
      'عمى الالوان',
      'عمى الالوان',
      'عمى لون',
      'تمييز الالوان',
      'نقص الالوان',
      'ضعف الالوان',
      'ايشيهارا',
      'بروتانوبيا',
      'بروتانومالي',
      'ديوترانوبيا',
      'ديوترانومالي',
      'تريتانوبيا',
      'تريتانومالي',
      'عمى احمر اخضر',
      'عمى ازرق اصفر',
    ];

    if (directKeywords.any(normalized.contains)) {
      return true;
    }

    const visionTerms = [
      'color',
      'colour',
      'colors',
      'colours',
      'vision',
      'see colors',
      'الوان',
      'لون',
      'رؤية',
      'نظر',
      'التمييز',
    ];

    const conditionTerms = [
      'blind',
      'deficiency',
      'defect',
      'test',
      'symptom',
      'diagnosis',
      'ishihara',
      'عمى',
      'نقص',
      'اختبار',
      'اعراض',
      'أعراض',
      'تشخيص',
      'مرض',
    ];

    final hasVisionTerm = visionTerms.any(normalized.contains);
    final hasConditionTerm = conditionTerms.any(normalized.contains);

    return hasVisionTerm && hasConditionTerm;
  }

  String _normalizeForTopicCheck(String text) {
    return text
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'[^\p{L}\p{N}\s-]', unicode: true), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
