import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/ponto.dart';
import 'package:controle_financeiro/model/projeto.dart';
import 'package:controle_financeiro/model/usuario.dart';

class PontoControl {
  late final List<Ponto> _historico = [];

  static final _timeHistoryController = StreamController<List<Ponto>>.broadcast();

  Stream<List<Ponto>> get timeHistoryStream => _timeHistoryController.stream;

  void startStopTimer() {
    Ponto ponto = getPonto();
    if(ponto.isStart()){
      ponto.setSaida();
    }else{      
      ponto.setEntrada();
      _historico.add(ponto);
    }

    _timeHistoryController.add(_historico);
  }

  Ponto getPonto() {
    for (Ponto item in _historico) {
      if (item.isStart()) {
        return item;
      }
    }
    return Ponto.novo();    
  }
  static cadastrarPonto(Ponto ponto) {
    // ignore: unnecessary_null_comparison
    if (Usuario().id == null) {
      return 'Falha ';
    }
    return FirebaseFirestore.instance
        .collection('Ponto')
        .doc(Usuario().id)
        .collection(Projeto().id)
        .doc(ponto.id)
        .set(ponto.toMap())
        .then((value) => 'Sucesso ')
        .catchError((erro) => 'Falha ');
  }

  static Future<List<Ponto>> buscarPonto() async {
    List<Ponto> listPonto = [];
    await FirebaseFirestore.instance
        .collection('Ponto')
        .doc(Usuario().id)
        .collection(Projeto().id)
        .get()
        .then((value) {
      listPonto.addAll(value.docs.map((doc) => Ponto.fromDoc(doc)).toList());
    });
    return listPonto;
  }
}
