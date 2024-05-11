
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/categoria.dart';
import 'package:controle_financeiro/model/despesa.dart';
import 'package:controle_financeiro/model/usuario.dart';

class DespesaControl {
  static cadastrarDespesa(despesa) {
    if (Usuario().id == null) {
      return 'Falha ';
    }
    despesa.id ??= (getIndex(despesa.projeto) +1).toString();
    
    return FirebaseFirestore.instance
        .collection('projetos')
        .doc(despesa.projeto)
        .collection('despesa')
        .doc(despesa.id)
        .set(despesa.toMap())
        .then((value) => 'Sucesso ')
        .catchError((erro) => 'Falha ');
  }

  static List<Despesa> buscarDespesasPorProjeto(String projeto) {
    List<Despesa> despesas = [];
    FirebaseFirestore.instance.collection('projetos')
        .doc(projeto)
        .collection('despesa').get().then((value) {
      despesas.addAll(value.docs.map((doc) => Despesa.fromDoc(doc)).toList());
      return despesas;
    }).asStream();
    return despesas;
  }

    static List<Despesa> buscarDespesasPorProjetoUsuario(String usuario) {
    List<Despesa> despesas = [];
    FirebaseFirestore.instance.collection('projetos')
        .doc()
        .collection('despesa').where("usuario"==usuario).get().then((value) {
      despesas.addAll(value.docs.map((doc) => Despesa.fromDoc(doc)).toList());
      return despesas;
    }).asStream();
    return despesas;
  }  

  static getIndex(String projeto){
        return FirebaseFirestore.instance.collection('projetos')
        .doc(projeto)
        .collection('despesa').count();          
  }

}  
Future<List<Categoria>> buscarCategoria() async{
    List<Categoria> projetos = [];
    // ignore: await_only_futures
    await FirebaseFirestore.instance.collection('Categoria').get().then((value) {      
      projetos.addAll(value.docs.map((doc) => Categoria.fromDoc(doc)).toList());
      return projetos;
    }).asStream();
    return projetos;
  }  