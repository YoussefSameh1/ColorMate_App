import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/features/chatbot/data/models/chat_message_model.dart';
import 'package:colormate_app/features/chatbot/presentation/views/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final ScrollController scrollController;

  const MessagesList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < messages.length) {
          return ChatBubble(message: messages[index]);
        }

        return const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
