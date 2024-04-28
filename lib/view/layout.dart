import 'package:flutter/material.dart';

class Cor {
  static Color backgrud([double opacity = 1]) =>  Color.fromRGBO(245, 245, 245, opacity);
  static Color botaoCinza([double opacity = 1]) =>  Color.fromRGBO(70,92,102, opacity);
  static Color botaoAzul([double opacity = 1]) => Color.fromRGBO(41,57,152, opacity);
  static Color textoBotaoCinza([double opacity = 1]) =>  Color.fromRGBO(255,255,255, opacity);
  static Color textoBotaoAzul([double opacity = 1]) =>  Color.fromRGBO(255,255,255, opacity);
  static Color textoAzul([double opacity = 1]) => Color.fromRGBO(0, 0, 250, opacity);
  static Color texto([double opacity = 1]) => Color.fromRGBO(0, 0, 0, opacity);
  static Color erro([double opacity = 1]) =>  Color.fromRGBO(178, 34, 34, opacity);
  static Color sucesso([double opacity = 1]) => Color.fromRGBO(0, 0, 255, opacity);
  static Color titulo([double opacity = 1]) =>  Color.fromRGBO(36, 9, 205, opacity);
  static Color cabecario([double opacity = 1]) => Color.fromRGBO(113, 194, 74, opacity);
}
//ColorScheme layoutColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple,background: Cor.backgrud(), )
class BotaoRodape extends TextButton {
  // ignore: use_super_parameters
  BotaoRodape({super.key, onPressed, child})
      : super(
            onPressed: onPressed,
            child: Container(
                width: 120,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Cor.botaoCinza(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    )),
                child: child));
}

/*
class ScaffoldLayout extends Scaffold {
  ScaffoldLayout({Widget body, acoes, floatingActionButton})
      : super(
            appBar: AppBar(
              backgroundColor: Cor.cabecario(),
              title: Center(
                child: Text('Diagnostico Bovino',
                    style: TextStyle(color: Cor.titulo(), fontSize: 30)),
              ),
              actions: acoes,
            ),
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('imagens/fundoHome.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(5),
                child: body),
            floatingActionButton: floatingActionButton);
}

class BotaoRodape extends TextButton {
  BotaoRodape({onLongPress, onPressed, child})
      : super(
            style: TextButton.styleFrom(primary: Colors.white),
            onLongPress: onLongPress,
            onPressed: onPressed,
            child: Container(
                width: 120,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Cor.botaoAzul(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                child: child));
}

class AcaoTopo extends Container {
  AcaoTopo({onPressed, icone, texto})
      : super(
          height: 30,
          child: Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
                style: TextButton.styleFrom(primary: Cor.botaoAzul()),
                label: Text(texto,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Cor.botaoAzul())),
                icon: Icon(icone),
                onPressed: onPressed),
          ),
        );
}
*/