import 'package:colormate_app/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:colormate_app/features/chatbot/presentation/views/widgets/chat_input_field.dart';
import 'package:colormate_app/features/chatbot/presentation/views/widgets/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text;
    _messageController.clear();
    context.read<ChatbotCubit>().sendMessage(message);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatbotCubit, ChatbotState>(
            builder: (context, state) {
              _scrollToBottom();
              return MessagesList(
                messages: state.messages,
                isLoading: state.isLoading,
                scrollController: _scrollController,
              );
            },
          ),
        ),
        const Divider(height: 1),
        ChatInputField(controller: _messageController, onSend: _sendMessage),
      ],
    );
  }
}
