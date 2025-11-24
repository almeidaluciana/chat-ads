import '../services/firebase_auth_service.dart';
import '../models/auth_result.dart';

class AuthController {
  final FirebaseAuthService authService;

  AuthController({FirebaseAuthService? service})
    : authService = service ?? FirebaseAuthService();

  Future<AuthResult> login(String email, String password) {
    return authService.login(email, password);
  }

  Future<AuthResult> register(
    String email,
    String password,
    String nome,
    String? fotoUrl,
  ) {
    return authService.register(email, password, nome, fotoUrl);
  }
}
