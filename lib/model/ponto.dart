import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Ponto {
  late String id;
  late String projeto;
  late String usuario;
  late String? entrada = '';
  late String? saida = '';

  Ponto.novo();

  Ponto(
      {required this.id,
      required this.projeto,
      required this.usuario,
      this.entrada,
      this.saida});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['projeto'] = projeto;
    map['usuario'] = usuario;
    map['entrada'] = entrada;
    map['saida'] = saida;
    return map;
  }

  Ponto.fromDoc(QueryDocumentSnapshot doc) {
    // ignore: unnecessary_null_comparison
    if (doc != null) {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      id = doc.id;
      projeto = map['projeto'];
      usuario = map['usuario'];
      entrada = map['entrada'];
      saida = map['saida'];
    }
  }

  Ponto.fromMap(Map<String, dynamic> map) {
    projeto = map['projeto'];
    usuario = map['usuario'];
    entrada = map['entrada'];
    saida = map['saida'];
  }

  setEntrada() {
    entrada = DateFormat('dd/MM HH:mm').format(DateTime.now());
  }

  setSaida() {
    saida = DateFormat('dd/MM HH:mm').format(DateTime.now());
  }

  bool isStart() {
    return (entrada!.isNotEmpty && saida!.isEmpty);
  }

  DateTime getEntrada() {
    return DateFormat('dd/MM HH:mm').parse(entrada!);
  }

  DateTime getSaida() {
    return DateFormat('dd/MM HH:mm').parse(saida!);
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
    return '$entrada - $saida';
  }

  String formatDuration(String duration) {    
    List<String> parts = duration.split(':');
    return parts.sublist(0, parts.length - 1).join(':');
  }
}
