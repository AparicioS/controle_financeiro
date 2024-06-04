import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/ponto.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PontoControl {
  final List<Ponto> _historico = [];
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isRunning = false;//getPonto().isStart();
  bool _isDeslocamento = false;
  String _botaoPonto = 'Deslocamento';
  String _botaoStart = '';
  String _projetoId = '';
  String _horas = '0:00';

  static final _timeHistoryController = StreamController<List<Ponto>>.broadcast();
  static final _totalController = StreamController<String>.broadcast();
  static final _botaoPontoController = StreamController<String>.broadcast();
  static final _botaoStartController = StreamController<String>.broadcast();
  static final _isRunningController = StreamController<bool>.broadcast();

  Stream<List<Ponto>> get timeHistoryStream => _timeHistoryController.stream;
  Stream<String> get totalStream => _totalController.stream;
  Stream<String> get botaoPontoStream => _botaoPontoController.stream;
  Stream<String> get botaoStartStream => _botaoStartController.stream;
  Stream<bool> get isRunningStream => _isRunningController.stream;

  void setDeslocamento(context) {
    if(getPonto().isStart()){
      printSnackBar(context: context, texto: 'Finalise a atividade antes de alterar para $_botaoPonto');
    }else{
      _setAtividade();
    }
  }

  void _setAtividade(){
    if(_botaoPonto != 'Ponto'){
        _botaoPonto = 'Ponto';
        _botaoStart = 'Sair';
        _isDeslocamento = true;
    }else{
        _botaoPonto = 'Deslocamento';
        _botaoStart = 'Iniciar';
        _isDeslocamento = false;
    }
    _botaoPontoController.add(_botaoPonto);
    _botaoStartController.add(_botaoStart);

  }
  

  void startStopTimer(String? projetoId) {
    if (_currentUser != null) {
      Ponto ponto = getPonto();
      if(ponto.isStart()){
        ponto.setSaida();
        _isRunning = false;
      }else{     
        ponto.usuario  = _currentUser.uid;
        ponto.setEntrada();
        ponto.projeto = projetoId!;
        _isRunning = true;
        _historico.add(ponto);
      } 
      cadastrarPonto(ponto);
      _totalController.add(getTotal());
      _timeHistoryController.add(_historico);
      _isRunningController.add(_isRunning);
      _setTextoBtnStart();
    }    
  }
  
  _setTextoBtnStart(){    
    if(_botaoPonto != 'Ponto'){
      _botaoStart = _isRunning?'Parar':'Iniciar';
    }else{
      _botaoStart = _isRunning?'Chegar':'Sair';
    } 
    _botaoStartController.add(_botaoStart);   
  }

  Future<bool> setProjeto(String? value) async {
    if(getPonto().isStart()){
      return false;
    }else if(value !=null){
      _projetoId = value;
      await buscarPonto();
      await buscarHorasPagas();
      _isRunning = getPonto().isStart();
      _isRunningController.add(_isRunning);
      _timeHistoryController.add(_historico);
      if(_isDeslocamento = getPonto().isDeslocamento){
        _setAtividade();
      }
        _setTextoBtnStart();
    }
    return true;
  }

  String getTotal(){  
  late Duration  total = const Duration(hours: 0, minutes: 0, seconds: 0);
    for (Ponto item in _historico) {      
    total += item.getDuracao();
    }
    return Ponto.novo().formatDuration(total.toString());
  }

  String getHorasPagas() {
    return _horas;
  }

  String getSaldo(){  
    late Duration  total = const Duration(hours: 0, minutes: 0, seconds: 0);
    late Duration  pagas = parseDuration(_horas); 
    for (Ponto item in _historico) {      
    total += item.getDuracao();
    }
    total = total -pagas;
    return Ponto.novo().formatDuration(total.toString());
  }

  Ponto getPonto() {
    for (Ponto item in _historico) {
      if (item.isStart()) {
        return item;
      }
    }
    Ponto novo =Ponto.novo();
    novo.isDeslocamento = _isDeslocamento;
    return novo;    
  }

  /* metodos de comunicação com FirebaseFirestore */

  cadastrarPonto(Ponto ponto) async {
    // ignore: unnecessary_null_comparison
    if (_currentUser == null) {
      return 'Falha ';
    }
    return FirebaseFirestore.instance
        .collection('Projeto')
        .doc(ponto.projeto)
        .collection('Ponto')
        .doc(ponto.id)
        .set(ponto.toMap())
        .then((value) {
          return 'Sucesso ';
        })
        .catchError((erro) => 'Falha ');
  }

  Future<List<Ponto>> buscarPonto() async {
    _historico.clear();
    await FirebaseFirestore.instance
        .collection('Projeto')
        .doc(_projetoId)
        .collection('Ponto')
        .where("usuario", isEqualTo: _currentUser?.uid.toString())
        .get()
        .then((value) {
          return _historico.addAll(value.docs.map((doc) {
            return Ponto.fromDoc(doc);
          }).toList());
    // ignore: invalid_return_type_for_catch_error, avoid_print
    }).catchError((erro) {
    });
    return _historico;
  }
  
  Future<Duration> buscarHorasPagas() async {
    Duration horas = const Duration(hours: 0, minutes: 0);
    if(_projetoId.isEmpty){
      return horas;
    }
    await FirebaseFirestore.instance
        .collection('Projeto')
        .doc(_projetoId)
        .collection('Horas')
        .where("usuario", isEqualTo: _currentUser?.uid.toString())
        .get()
        .then((value) {
        for (var docSnapshot in value.docs) {
            Map<String, dynamic> map = docSnapshot.data();
            horas += parseDuration(map['horas']);
          }
    });
    _horas = Ponto.novo().formatDuration(horas.toString());
    return horas;
  }
  
  Duration parseDuration(String s) {
    List<String> parts = s.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }
}
