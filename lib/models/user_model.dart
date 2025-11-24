class UserModel {
  final String uid;
  final String nome;
  final String email;
  final String fotoUrl;

  UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.fotoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      nome: map['nome'],
      email: map['email'],
      fotoUrl: map['fotoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'nome': nome,
    'email': email,
    'fotoUrl': fotoUrl,
  };
}
