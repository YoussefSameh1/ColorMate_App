import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/chatbot/presentation/views/widgets/chat_body.dart';
import 'package:flutter/material.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          CustomAppBar(title: 'Smart Chatbot'),
          Expanded(child: ChatBody()),
        ],
      ),
    );
  }
}
