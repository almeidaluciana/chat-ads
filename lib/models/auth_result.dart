class AuthResult {
  final bool success;
  final String? message;
  final String? userId;

  AuthResult({this.userId, required this.success, this.message});
}
