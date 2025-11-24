import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class FirebaseChatService {
  final _db = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages() {
    return _db.collection("messages").orderBy("timestamp").snapshots().map((
      query,
    ) {
      return query.docs.map((doc) {
        return MessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> sendMessage(MessageModel message) {
    return _db.collection("messages").add(message.toMap());
  }

  Future<void> sendImageMessage(
    String imageUrl,
    String userId,
    String senderName,
  ) {
    final msg = MessageModel(
      senderId: userId,
      senderName: senderName,
      imageUrl: imageUrl,
      text: "",
      timestamp: Timestamp.now(),
    );
    return _db.collection("messages").add(msg.toMap());
  }
}
