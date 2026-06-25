enum ChatRole { user, bot }

class ChatMessageModel {
  final String text;
  final ChatRole role;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.text,
    required this.role,
    required this.createdAt,
  });

  bool get isUser => role == ChatRole.user;
}
