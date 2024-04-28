
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

  caregaUsuarioLitUser(litUser) {
    litUser.when(
      (user) {
        id = user.uid;
        nome = user.displayName;
        email = user.email;
      },
      empty: () {},
      initializing: () {},
    );
  }

  @override
  String toString() {
    return 'id:$id\nnome:$nome\nemail:$email';
  }
}
