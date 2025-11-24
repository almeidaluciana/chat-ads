import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/message_model.dart';
import '../../theme/colors.dart';
import 'chat_image.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const MessageBubble({super.key, required this.message, required this.isMine});

  bool get isUrlMessage {
    final text = message.text ?? '';
    return text.contains("https://");
  }

  Future<void> _openUrl(String urlText) async {
    final uri = Uri.parse(urlText);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.profileUrl != null)
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(message.profileUrl!),
                ),
              if (message.profileUrl != null) const SizedBox(width: 6),
              Text(
                message.senderName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isMine ? AppColors.bubbleMine : AppColors.bubbleOther,
              borderRadius: BorderRadius.circular(12),
            ),
            child: message.imageUrl != null && message.imageUrl!.isNotEmpty
                ? ChatImage(imageUrl: message.imageUrl!)
                : (isUrlMessage
                      ? GestureDetector(
                          onTap: () {
                            final link = message.text!.split(" ").last.trim();
                            _openUrl(link);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              message.text!,
                              style: const TextStyle(color: AppColors.link),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(message.text ?? ""),
                        )),
          ),
        ],
      ),
    );
  }
}
