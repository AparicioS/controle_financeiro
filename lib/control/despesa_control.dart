import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/categoria.dart';
import 'package:controle_financeiro/model/despesa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DespesaControl {
  final User? _currentUser = FirebaseAuth.instance.currentUser;  
  final List<Categoria> _categoriaList =[];  
  static final _categoriaController = StreamController<List<Categoria>>.broadcast();  
  Stream<List<Categoria>> get categoriaStream => _categoriaController.stream;

  DespesaControl(){
    setCategorias();
  }  

  Future<void> setCategorias() async {
    Categoria otros =Categoria();
    otros.id = '0' ;
    otros.nome = 'Outros' ;
    await FirebaseFirestore.instance.collection('Categoria').get().then((value) {  
      if(value.size > 0){
      _categoriaList.addAll(value.docs.map((doc) => Categoria.fromDoc(doc)).toList());
      _categoriaList.add(otros);
      _categoriaController.add(_categoriaList);  
      }    
    });
  }

  Future<String>cadastrarDespesa(despesa)  async {
    if (_currentUser == null) {
      return 'Falha';
    }    
    despesa.usuario  = despesa.usuario??_currentUser.uid;
    
    return FirebaseFirestore.instance
        .collection('Projeto')
        .doc(despesa.projeto)
        .collection('despesa')
        .doc()
        .set(despesa.toMap())
        .then((value) => 'Sucesso')
        .catchError((erro) => 'Falha');
  }

  Future<String>cadastrarDespesaFromMap(despesaMap)  async {
    if (_currentUser == null) {
      return 'Falha';
    }
    Despesa despesa = Despesa.fromMap(despesaMap);
    
    return FirebaseFirestore.instance
        .collection('Projeto')
        .doc(despesa.projeto)
        .collection('despesa')
        .doc()
        .set(despesa.toMap())
        .then((value) => 'Sucesso')
        .catchError((erro) => 'Falha');
  }

}

Future<String> uploadImagem(ref,imageFile) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
            String nome = imageFile.path.split('/').last;
            await storage.ref(ref).child(nome).putFile(imageFile); 
    return nome;
}  