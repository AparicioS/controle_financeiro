import 'package:flutter/material.dart';

class Ponto {
  late String id;
  late String usuario;
  late String data;
  late String? entrada;
  late String? saida;

  Ponto.novo();

  Ponto({required this.id, required this.usuario, required this.data,this.entrada,this.saida});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['anexo'] = usuario;
    map['data'] = data;
    map['entrada'] = entrada;
    map['saida'] = saida;

    return map;
  }
/*
  Produto.fromDoc(QueryDocumentSnapshot doc) {
    if (doc != null) {
      Map<String, dynamic> map = doc.data();
      this.id = doc.id;
      this.categoria = map['categoria'];
      this.descricao = map['descricao'];
      this.valor = map['valor'];
      this.unidade = map['unidade'];
      this.composicao = map['composicao'];
    }
  }
*/
  Ponto.fromMap(Map<String, dynamic> map) {
    usuario = map['usuario'];
    data = map['data'];
    entrada = map['entrada'];
    saida = map['saida'];
    }  /*
  static getDropdownMenuCategorias(){
        return Estabelecimento().categoria.map((doc) => DropdownMenuItem<String>(
                child: Text(doc),
                value: doc,
              ))
          .toList();
          
  }
  */
  static getDropdownMenuUnidade(){
        return ["Unidade",
			          "Lista",
			          "Fracionado"].map((doc) => DropdownMenuItem<String>(
                value: doc,
                child: Text(doc),
              ))
          .toList();
  }
}