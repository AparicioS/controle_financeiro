import 'package:flutter/material.dart';

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
    map['anexo'] = usuario;
    map['projeto'] = projeto;
    map['categoria'] = categoria;
    map['descricao'] = descricao;
    map['valor'] = valor;
    map['urlImage'] = urlImage;

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
  Despesa.fromMap(Map<String, dynamic> map) {
    usuario = map['usuario'];
    projeto = map['projeto'];
    categoria = map['categoria'];
    descricao = map['descricao'];
    valor = map['valor'];
    urlImage = map['urlImage'];
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