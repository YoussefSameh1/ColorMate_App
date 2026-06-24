import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/features/chatbot/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          border:
              isUser
                  ? null
                  : Border.all(
                    color: AppColors.kAccentColor.withValues(alpha: 0.4),
                  ),
        ),
        child: Text(
          message.text,
          style: AppTextStyles.medium16().copyWith(
            color: isUser ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
