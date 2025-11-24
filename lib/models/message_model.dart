import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderName;
  final String? profileUrl;
  final String? text;
  final String? imageUrl;
  final Timestamp timestamp;

  MessageModel({
    required this.senderId,
    required this.senderName,
    this.profileUrl,
    this.text,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'profileUrl': profileUrl,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      senderName: map['senderName'] ?? 'Usuário',
      profileUrl: map['profileUrl'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      timestamp: map['timestamp'],
    );
  }
}
