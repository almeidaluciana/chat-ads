import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CloudinaryService {
  final String cloudName = "doxebahsj";
  final String uploadPreset =
      "flutter_unsigned"; //identifica o tipo de um arquivo (por exemplo, "image/png" ou "image/jpeg") baseado na extensão do arquivo

  Future<String> uploadImage(File file) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    ); // Endpoint do Cloudinary para upload de imagens.
    final mimeType = lookupMimeType(
      file.path,
    )!.split('/'); // Detecta o tio de arquivo

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] =
          uploadPreset // Envia o preset que libera o upload
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ), // adiciona o arquivo ao corpo da requisição com seu tipo correto.
      );

    final response = await request.send(); // envia a imagem para o Cloudinary
    final respStr = await response.stream
        .bytesToString(); // lê a resposta do servidor como string JSON.

    // Extrai a URL segura da resposta JSON
    final match = RegExp(r'"secure_url":"(.*?)"').firstMatch(respStr);
    final imageUrl = match != null ? match[1]! : "";
    return imageUrl;
  }
}
