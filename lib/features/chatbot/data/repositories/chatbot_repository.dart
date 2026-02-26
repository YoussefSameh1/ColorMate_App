import 'package:colormate_app/features/chatbot/data/models/chat_message_model.dart';

abstract class ChatbotRepository {
  Future<ChatMessageModel> sendMessage({
    required String userMessage,
    required List<ChatMessageModel> history,
  });
}
