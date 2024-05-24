
class Usuario {
  static Usuario _instance = Usuario._();
  Usuario._();
  String? id;
  String? nome;
  String? email;

  resetUsuario() {
    _instance = Usuario._();
  }

  factory Usuario() => _instance;

  caregaUsuarioLitUser(currentUser) {
        id = currentUser.uid;
        nome = currentUser.displayName;
        email = currentUser.email;
  }

  @override
  String toString() {
    return 'id:$id\nnome:$nome\nemail:$email';
  }
}
