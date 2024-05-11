
import 'package:controle_financeiro/view/despesa_screen.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:controle_financeiro/view/ponto_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Cor.botaoAzul(),background: Cor.backgrud()),
      ),
      home: DefaultTabController(
        length: 2, // Número de abas
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Controle Financeiro'),
            bottom: const TabBar(labelStyle: TextStyle(fontSize: 20),
              indicator: BoxDecoration(color: Color.fromRGBO(41,57,152,1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    )),
              labelColor: Color.fromRGBO(255, 255, 255, 1),
              tabs: [
                Tab(child: Center(widthFactor: 200,child: Text('Ponto')),),
                Tab(child: Center(widthFactor: 200,child: Text('Despesas')),),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // Conteúdo da primeira aba
              PontoScreen(),
              // Conteúdo da segunda aba
              DespesaScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
