import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/chatbot/presentation/views/widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Smart Chatbot',
            onBackPressed: () => context.go(Routes.homeView),
          ),
          const Expanded(child: ChatBody()),
        ],
      ),
    );
  }
}
