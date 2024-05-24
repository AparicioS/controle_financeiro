import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/usuario.dart';

class Despesa {
  late int id = 0;
  late String? usuario = Usuario().id;
  late String projeto;
  late String categoria;
  late String? descricao;
  late String valor;
  late String? urlImage;

  Despesa(this.id, this.usuario, this.projeto,this.categoria,this.descricao, this.valor);

  Despesa.novo();
  
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
      id = int.parse(doc.id);
      usuario = map['usuario'];
      projeto = map['projeto'];
      categoria = map['categoria'];
      descricao = map['descricao'];
      valor = map['valor'];
      urlImage = map['urlImage'];
    }
  }

  Despesa.fromMap(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    usuario = map['usuario'];
    projeto = map['projeto'];
    categoria = map['categoria'];
    descricao = map['descricao'];
    valor = map['valor'];
    //urlImage = map['urlImage'];
    }
    }