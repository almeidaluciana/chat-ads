import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/auth_controller.dart';
import '../services/cloudinary_service.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final nomeController = TextEditingController();
  final AuthController controller = AuthController();
  final CloudinaryService cloudinary = CloudinaryService();
  final ImagePicker picker = ImagePicker();

  File? _localImage;
  String? _uploadedUrl; // URL do Cloudinary
  bool _isLoading = false;

  // Pega imagem da galeria
  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _localImage = File(picked.path);
      });
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);

    String? fotoUrl = _uploadedUrl;

    // Se houver imagem local, faz upload
    if (_localImage != null) {
      fotoUrl = await cloudinary.uploadImage(_localImage!);
    }

    final result = await controller.register(
      emailController.text.trim(),
      senhaController.text.trim(),
      nomeController.text.trim(),
      fotoUrl,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      Navigator.pushReplacementNamed(context, '/chat');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? "Erro ao cadastrar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _localImage != null
                      ? FileImage(_localImage!)
                      : (_uploadedUrl != null && _uploadedUrl!.isNotEmpty
                            ? NetworkImage(_uploadedUrl!) as ImageProvider
                            : null),
                  child:
                      _localImage == null &&
                          (_uploadedUrl == null || _uploadedUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: nomeController, label: "Nome"),
              const SizedBox(height: 10),
              CustomTextField(
                controller: emailController,
                label: "Email",
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: senhaController,
                label: "Senha",
                obscure: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Cadastrar",
                loading: _isLoading,
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
