import 'package:colormate_app/features/chatbot/data/models/chat_message_model.dart';
import 'package:colormate_app/features/chatbot/data/repositories/chatbot_repository.dart';
import 'package:colormate_app/features/chatbot/data/services/gemini_service.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final GeminiService _geminiService;

  ChatbotRepositoryImpl(this._geminiService);

  @override
  Future<ChatMessageModel> sendMessage({
    required String userMessage,
    required List<ChatMessageModel> history,
  }) async {
    final reply = await _geminiService.generateColorBlindnessReply(
      userMessage: userMessage,
      history: history,
    );

    return ChatMessageModel(
      text: reply,
      role: ChatRole.bot,
      createdAt: DateTime.now(),
    );
  }
}
