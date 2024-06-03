
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/projeto.dart';

class ProjetoControl {
  ProjetoControl(){
    setProjetos();
  }
  final List<Projeto> _projectList =[];
  
  static final _projetoController = StreamController<List<Projeto>>.broadcast();
  
  Stream<List<Projeto>> get projetoStream => _projetoController.stream;

  Future<void> setProjetos() async {
    await FirebaseFirestore.instance.collection('Projeto').get().then((value) {  
      if(value.size > 0){
      _projectList.addAll(value.docs.map((doc) => Projeto.fromDoc(doc)).toList());
      _projetoController.add(_projectList);  
      }    
    });
  }

}
