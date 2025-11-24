import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_chat_service.dart';
import '../services/cloudinary_service.dart';
import '../models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ChatController {
  final FirebaseChatService _chatService = FirebaseChatService();
  final CloudinaryService _cloudinary = CloudinaryService();
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final picker = ImagePicker();

  Stream<List<MessageModel>> getMessages() => _chatService.getMessages();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final message = MessageModel(
      senderId: user!.uid,
      senderName: user!.displayName ?? 'Usuário',
      profileUrl: user!.photoURL,
      text: text,
      timestamp: Timestamp.now(),
    );
    await _chatService.sendMessage(message);
  }

  Future<void> pickImageFromCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      await _uploadAndSend(File(picked.path));
    }
  }

  Future<void> _uploadAndSend(File file) async {
    final imageUrl = await _cloudinary.uploadImage(file);
    if (imageUrl.isNotEmpty) {
      final message = MessageModel(
        senderId: user!.uid,
        senderName: user!.displayName ?? 'Usuário',
        profileUrl: user!.photoURL,
        imageUrl: imageUrl,
        text: "", // texto vazio, pois é só imagem
        timestamp: Timestamp.now(),
      );
      await _chatService.sendMessage(message);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Serviço de localização desativado.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão permanentemente negada.');
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // distância mínima em metros para atualizar a posição
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Future<String> getGoogleMapsLink() async {
    Position position = await getCurrentLocation();
    double lat = position.latitude;
    double lng = position.longitude;
    // Formato padrão do Google Maps
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    return googleMapsUrl;
  }

  Future<void> sendLocation() async {
    String mapsLink = await getGoogleMapsLink();
    final message = MessageModel(
      senderId: user!.uid,
      senderName: user!.displayName ?? 'Usuário',
      profileUrl: user!.photoURL,
      text: mapsLink,
      timestamp: Timestamp.now(),
    );
    await _chatService.sendMessage(message);
  }
}
