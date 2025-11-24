import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';
import 'widgets/message_list.dart';
import 'widgets/chat_input_bar.dart';
import '../theme/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatController();
  }

  Future<void> _confirmLogout() async {
    final bool? sair = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sair"),
        backgroundColor: Colors.white,
        content: const Text("Deseja realmente sair do app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              side: const BorderSide(color: AppColors.background, width: 1.5),
              foregroundColor: AppColors.darkText,
            ),
            child: const Text("Cancelar"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.bubbleOther,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Sair"),
          ),
        ],
      ),
    );

    if (sair == true) {
      await controller.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text("Chat ADS", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: MessageList(controller: controller)),
          ChatInputBar(controller: controller),
        ],
      ),
    );
  }
}
