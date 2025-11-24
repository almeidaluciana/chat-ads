import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_result.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AuthResult> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(success: true, userId: credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      String message = "Ocorreu um erro. Tente novamente.";
      if (e.code == 'network-request-failed') {
        message = "Sem conexão com a internet.";
      } else if (e.code == 'user-not-found') {
        message = "Usuário não encontrado.";
      } else if (e.code == 'wrong-password') {
        message = "Senha incorreta.";
      }

      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(success: false, message: "Ocorreu um erro inesperado.");
    }
  }

  Future<AuthResult> register(
    String email,
    String password,
    String nome,
    String? fotoUrl,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateDisplayName(nome);
        if (fotoUrl != null) {
          await user.updatePhotoURL(fotoUrl);
        }
        await user.reload();
      }

      // Salvar no Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'nome': nome,
        'email': email,
        'fotoUrl': fotoUrl ?? '',
        'uid': credential.user!.uid,
      });

      return AuthResult(success: true, userId: credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      String message = "Ocorreu um erro. Tente novamente.";
      if (e.code == 'network-request-failed') {
        message = "Sem conexão com a internet.";
      } else if (e.code == 'email-already-in-use') {
        message = "Este e-mail já está cadastrado.";
      } else if (e.code == 'invalid-email') {
        message = "E-mail inválido.";
      } else if (e.code == 'weak-password') {
        message = "Senha muito fraca.";
      }

      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(success: false, message: "Ocorreu um erro inesperado.");
    }
  }

  User? get currentUser => _auth.currentUser;
}
