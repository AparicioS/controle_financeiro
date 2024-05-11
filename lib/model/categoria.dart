import 'package:cloud_firestore/cloud_firestore.dart' show QueryDocumentSnapshot;



class Categoria {
  static Categoria _instance = Categoria._();
  Categoria._();
  late String id;
  late String nome;
  late String? descricao;

  resetCategoria() {
    _instance = Categoria._();
  }

  factory Categoria() => _instance;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['nome'] = nome;
    map['descricao'] = descricao;
    return map;
  }
  
  Categoria.fromDoc(QueryDocumentSnapshot doc) {
    // ignore: unnecessary_null_comparison
    if (doc != null) {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      id = doc.id;
      nome = map['nome'];
      descricao = map['descricao'];
    }
  }
  
  Categoria.fromMap(Map<String, dynamic> map) {
    nome = map['nome'];
    descricao = map['descricao'];
    }  
}