import 'package:cloud_firestore/cloud_firestore.dart';

class Despesa {
  late String id;
  late String usuario;
  late String projeto;
  late String categoria;
  late String? descricao;
  late String valor;
  late String? urlImage;

  Despesa.novo();

  Despesa(this.id, this.usuario, this.projeto,this.categoria,this.descricao, this.valor,this.urlImage);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['usuario'] = usuario;
    map['projeto'] = projeto;
    map['categoria'] = categoria;
    map['descricao'] = descricao;
    map['valor'] = valor;
    map['urlImage'] = urlImage;

    return map;
  }
  
  Despesa.fromDoc(QueryDocumentSnapshot doc) {
    // ignore: unnecessary_null_comparison
    if (doc != null) {
      Map<String, dynamic> map = doc.data()as Map<String, dynamic>;
      usuario = map['usuario'];
      projeto = map['projeto'];
      categoria = map['categoria'];
      descricao = map['descricao'];
      valor = map['valor'];
      urlImage = map['urlImage'];
    }
  }

  Despesa.fromMap(Map<String, dynamic> map) {
    usuario = map['usuario'];
    projeto = map['projeto'];
    categoria = map['categoria'];
    descricao = map['descricao'];
    valor = map['valor'];
    urlImage = map['urlImage'];
    }
}