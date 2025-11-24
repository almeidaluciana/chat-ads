import 'package:flutter/material.dart';
import '../../controllers/chat_controller.dart';
import '../../models/message_model.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  final ChatController controller;

  const MessageList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: controller.getMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final mensagens = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: mensagens.length,
          itemBuilder: (context, index) {
            final m = mensagens[index];
            final user = controller.user;
            final isMine = user != null && m.senderId == user.uid;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: MessageBubble(message: m, isMine: isMine),
            );
          },
        );
      },
    );
  }
}
