import 'package:flutter/material.dart';

class ChatImage extends StatelessWidget {
  final String imageUrl;
  final double width;

  const ChatImage({super.key, required this.imageUrl, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,

        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return SizedBox(
            width: width,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: width,
            child: const Center(child: Icon(Icons.error, color: Colors.red)),
          );
        },
      ),
    );
  }
}
