
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/projeto.dart';

  
List<Projeto> buscarDespesasPorProjetoUsuario(String usuario) {
    List<Projeto> projetos = [];
    FirebaseFirestore.instance.collection('Projeto')
        .doc()
        .collection('despesa').where("usuario"==usuario).get().then((value) {
      projetos.addAll(value.docs.map((doc) => Projeto.fromDoc(doc)).toList());
      return projetos;
    }).asStream();
    return projetos;
  } 
  
Future<List<Projeto>> buscarProjeto() async{
    List<Projeto> projetos = [];
    // ignore: await_only_futures
    await FirebaseFirestore.instance.collection('Projeto').get().then((value) {      
      projetos.addAll(value.docs.map((doc) => Projeto.fromDoc(doc)).toList());
      return projetos;
    }).asStream();
    return projetos;
  }  