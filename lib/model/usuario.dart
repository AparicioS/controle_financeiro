
import 'package:cloud_firestore/cloud_firestore.dart';

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
   
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['nome'] = nome;
    map['email'] = email;
    return map;
  }
  
  fromDoc(QueryDocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    id = doc.id;
    nome = map['nome'];
    email = map['email'];
  }

  @override
  String toString() {
    return 'id:$id\nnome:$nome\nemail:$email';
  }
}
