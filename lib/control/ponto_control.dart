import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/ponto.dart';
import 'package:controle_financeiro/model/projeto.dart';
import 'package:controle_financeiro/model/usuario.dart';

class PontoControl {
  late final List<Ponto> _historico = [];
  bool _isRunning = false;

  static final _timeHistoryController = StreamController<List<Ponto>>.broadcast();
  static final _totalController = StreamController<String>.broadcast();
  static final _isRunningController = StreamController<bool>.broadcast();

  Stream<List<Ponto>> get timeHistoryStream => _timeHistoryController.stream;
  Stream<String> get totalStream => _totalController.stream;
  Stream<bool> get isRunningStream => _isRunningController.stream;

  String getSaldoTotal(){
    var total='';
    return total;
  }

  void startStopTimer(String? projetoId) {
    Ponto ponto = getPonto();
    if(ponto.isStart()){
      ponto.setSaida();
    }else{      
      ponto.setEntrada();
      _historico.add(ponto);
    } 
    _totalController.add(getTotal());
    _timeHistoryController.add(_historico);
    
    _isRunning = !_isRunning;
    _isRunningController.add(_isRunning);
  }
  
  String getTotal(){  
  late Duration  total = const Duration(hours: 0, minutes: 0, seconds: 0);
    for (Ponto item in _historico) {      
    total += item.getDuracao();
    }
    return Ponto.novo().formatDuration(total.toString());
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
