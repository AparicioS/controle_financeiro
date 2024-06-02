import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Ponto {
  late String id = DateFormat('yyyyMMddHHmm').format(DateTime.now());
  late String projeto;
  late String usuario =  FirebaseAuth.instance.currentUser!.uid;
  late String? inicio = '';
  late String? fim = '';
  late bool isDeslocamento = false;

  Ponto.novo();

  Ponto(
      {required this.id,
      required this.projeto,
      required this.usuario,
      this.inicio,
      this.fim});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['projeto'] = projeto;
    map['usuario'] = usuario;
    map['inicio'] = inicio;
    map['fim'] = fim;
    map['isDeslocamento'] = isDeslocamento;
    return map;
  }

  Ponto.fromDoc(QueryDocumentSnapshot doc) {
    // ignore: unnecessary_null_comparison
    if (doc != null) {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      id = doc.id;
      projeto = map['projeto'];
      usuario = map['usuario'];
      inicio = map['inicio'];
      fim = map['fim'];
      isDeslocamento = map['isDeslocamento'];
    }
  }

  Ponto.fromMap(Map<String, dynamic> map) {
    projeto = map['projeto'];
    usuario = map['usuario'];
    inicio = map['inicio'];
    fim = map['fim'];
    isDeslocamento = map['isDeslocamento'];
  }

  setEntrada() {
    inicio = DateFormat('dd/MM HH:mm').format(DateTime.now());
  }

  setSaida() {
    fim = DateFormat('dd/MM HH:mm').format(DateTime.now());
  }

  bool isStart() {
    return (inicio!.isNotEmpty && fim!.isEmpty);
  }

  DateTime getEntrada() {
    return DateFormat('dd/MM HH:mm').parse(inicio!);
  }

  DateTime getSaida() {
    return DateFormat('dd/MM HH:mm').parse(fim!);
  }

  Duration getDuracao() {
    if(isStart()){
      return const Duration(hours: 0, minutes: 0, seconds: 0);
    }
    return getSaida().difference(getEntrada());
  }
  
  String getDuracaoToString() {
    return formatDuration(getDuracao().toString());
  }

  getPonto() {
    if(fim!.isEmpty){
      return inicio;
    }
    return '$inicio - $fim   saldo:${getDuracaoToString()} h';
  }

  String formatDuration(String duration) {    
    List<String> parts = duration.split(':');
    return parts.sublist(0, parts.length - 1).join(':');
  }
}
