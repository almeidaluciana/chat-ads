import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../controllers/chat_controller.dart';

class ChatInputBar extends StatefulWidget {
  final ChatController controller;

  const ChatInputBar({super.key, required this.controller});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: AppColors.background,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: msgController,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Mensagem",
                  filled: true,
                  fillColor: AppColors.bubbleOther,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: widget.controller.sendLocation,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: widget.controller.pickImageFromCamera,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                // garante círculo perfeito
              ),
              onPressed: () {
                widget.controller.sendMessage(msgController.text);
                msgController.clear();
              },
              child: const Icon(Icons.send, color: AppColors.bubbleOther),
            ),
          ],
        ),
      ),
    );
  }
}
