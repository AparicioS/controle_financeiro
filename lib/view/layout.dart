import 'package:flutter/material.dart';

class Cor {
  static Color backgrud([double opacity = 1]) =>Color.fromRGBO(245, 245, 245, opacity);
  static Color botaoCinza([double opacity = 1]) =>Color.fromRGBO(70, 92, 102, opacity);
  static Color botaoAzul([double opacity = 1]) =>Color.fromRGBO(41, 57, 152, opacity);
  static Color textoBotaoCinza([double opacity = 1]) => Color.fromRGBO(255, 255, 255, opacity);
  static Color textoBotaoAzul([double opacity = 1]) =>Color.fromRGBO(255, 255, 255, opacity);
  static Color textoAzul([double opacity = 1]) =>Color.fromRGBO(0, 0, 250, opacity);
  static Color texto([double opacity = 1]) => Color.fromRGBO(0, 0, 0, opacity);
  static Color erro([double opacity = 1]) =>Color.fromRGBO(178, 34, 34, opacity);
  static Color sucesso([double opacity = 1]) =>Color.fromRGBO(0, 0, 255, opacity);
  static Color titulo([double opacity = 1]) =>Color.fromRGBO(36, 9, 205, opacity);
  static Color cabecario([double opacity = 1]) =>Color.fromRGBO(113, 194, 74, opacity);
}

InputDecoration getInputDecoration(labelText){
  return InputDecoration(
                  hintText: labelText,
                  fillColor: Cor.textoBotaoAzul(),
                  filled: true
                );
}

BoxDecoration getBoxDecoration(){
  return BoxDecoration(
                  color: Cor.botaoCinza(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                );
}

printSnackBar({required BuildContext context,required String texto, bool isErro =true}){
  SnackBar snackBar = SnackBar(content: Text(texto),backgroundColor:isErro ? Cor.erro():Cor.sucesso(),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class BotaoRodape extends TextButton {
  // ignore: use_super_parameters
  BotaoRodape({super.key, onPressed, width,height,child})
      : super(
            onPressed: onPressed,
            child: Container(
                width: width??120,
                height: height??40,
                alignment: Alignment.center,
                decoration: getBoxDecoration(),
                child: child));
}
