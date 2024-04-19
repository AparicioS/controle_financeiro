import 'package:flutter/material.dart';
import 'timer_logic.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late TimerLogic _timerLogic;

  @override
  void initState() {
    super.initState();
    _timerLogic = TimerLogic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Controle Financeiro'),
        ),
        body: Column(
          children: [
            // Parte superior (20% da tela)
// Parte superior (20% da tela)
Container(
  height: MediaQuery.of(context).size.height * 0.20, // 20% da altura da tela
  color: Colors.grey[300],
  padding: const EdgeInsets.all(5),
  child: Row(
    children: [
      // Coluna da esquerda (para textos)
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto do contador
            StreamBuilder<String>(
              stream: _timerLogic.currentTimeStream,
              initialData: '',
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            const SizedBox(height: 10),
            // Histórico de tempo
            StreamBuilder<List<String>>(
              stream: _timerLogic.timeHistoryStream,
              initialData: const [],
              builder: (context, snapshot) {
                final List<String> timeHistory = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ponto:'),
                    SizedBox(
                      height: 40, // Altura do contêiner de histórico
                      child: ListView.builder(
                        itemCount: timeHistory.length,
                        itemBuilder: (context, index) {
                          return Text(timeHistory[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      const SizedBox(width: 10),
      // Coluna da direita (para botões)
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _timerLogic.startStopTimer();
            },
            child: StreamBuilder<bool>(
              stream: _timerLogic.isRunningStream,
              initialData: false,
              builder: (context, snapshot) {
                return Text(snapshot.data == true ? 'Pausar' : 'Iniciar');
              },
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: _timerLogic.resetTimer,
            child: const Text('Resetar'),
          ),
        ],
      ),
    ],
  ),
),

            // Parte inferior (80% da tela)
            Expanded(
              child: Container(
                color: Colors.white, // Cor de fundo opcional para os 80% restantes
                // Conteúdo vazio para os 80% restantes
              ),
            ),
          ],
        ),
      ),
    );
  }
}
