import 'package:controle_financeiro/control/ponto_control.dart';
import 'package:controle_financeiro/model/ponto.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:flutter/material.dart';
import '../control/timer_logic.dart';

class PontoScreen extends StatefulWidget {
  const PontoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PontoScreenState createState() => _PontoScreenState();
}

class _PontoScreenState extends State<PontoScreen> {
  late TimerLogic _timerLogic;
  late PontoControl _ctrlPonto;

  @override
  void initState() {
    super.initState();
    _timerLogic = TimerLogic();
    _ctrlPonto = PontoControl();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      padding: const EdgeInsets.all(1),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<Ponto>>(
                      stream: _ctrlPonto.timeHistoryStream,
                      initialData: const [],
                      builder: (context, snapshot) {
                        final List<Ponto> timeHistory = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ponto:'),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.70,
                              child: ListView.builder(
                                itemCount: timeHistory.length,
                                itemBuilder: (context, index) {
                                  return Text(timeHistory[index].getPonto()+'total'+timeHistory[index].getDuracaoToString());
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
              /*
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _timerLogic.resetTimer,
                    child: const Text('Resetar'),
                  ),
                ],
              ),
              */
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: BotaoRodape(
              onPressed: () {
                _timerLogic.startStopTimer();
                _ctrlPonto.startStopTimer();
              },
              child: StreamBuilder<bool>(
                stream: _timerLogic.isRunningStream,
                initialData: false,
                builder: (context, snapshot) {
                  //return Icon(snapshot.data == true ? Icons.pause : Icons.play_arrow);
                    return Text(snapshot.data == true ? 'Pausar' : 'Iniciar',style: TextStyle(color: Cor.textoBotaoAzul()),);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
