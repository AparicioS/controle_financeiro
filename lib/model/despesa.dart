import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Despesa {
  late int id = 0;
  late String usuario;
  late String projeto;
  late String categoria;
  late String? descricao;
  late String valor;
  late String image;
  late String data;

  Despesa(this.id, this.usuario, this.projeto,this.categoria,this.image, this.valor);

  Despesa.novo();
  
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['usuario'] = usuario;
    map['projeto'] = projeto;
    map['categoria'] = categoria;
    map['descricao'] = descricao;
    map['valor'] = valor;
    map['image'] = image;
    map['data'] = data;

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
      image = map['image'];
      data = map['data'];
    }
  }

  Despesa.fromMap(Map<String, dynamic> map) {
    id = int.parse(map['id']??'0');
    usuario = map['usuario']??FirebaseAuth.instance.currentUser?.uid;
    projeto = map['projeto'];
    categoria = map['categoria'];
    descricao = map['descricao'];
    valor = map['valor'];
    image = map['image'];
    data = map['data']?? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
  }

}