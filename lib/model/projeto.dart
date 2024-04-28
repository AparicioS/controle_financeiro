
import 'package:cloud_firestore/cloud_firestore.dart';

class Projeto {
  static Projeto _instance = Projeto._();
  Projeto._();
  late String id;
  late String nome;
  late String? descricao;

  resetProjeto() {
    _instance = Projeto._();
  }

  factory Projeto() => _instance;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['nome'] = nome;
    map['descricao'] = descricao;
    return map;
  }
  
  Projeto.fromDoc(QueryDocumentSnapshot doc) {
    // ignore: unnecessary_null_comparison
    if (doc != null) {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      id = doc.id;
      nome = map['nome'];
      descricao = map['descricao'];
    }
  }
  
  Projeto.fromMap(Map<String, dynamic> map) {
    nome = map['nome'];
    descricao = map['descricao'];
    }
  
}