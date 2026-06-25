part of 'chatbot_cubit.dart';

class ChatbotState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatbotState({
    required this.messages,
    required this.isLoading,
    this.errorMessage,
  });

  factory ChatbotState.initial() {
    return ChatbotState(
      messages: [
        ChatMessageModel(
          text:
              'Hello! I am ColorMate\'s chatbot. Ask me anything about color blindness, test results, or daily tips.',
          role: ChatRole.bot,
          createdAt: DateTime.now(),
        ),
      ],
      isLoading: false,
    );
  }

  ChatbotState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
