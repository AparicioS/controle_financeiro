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
    late double height = MediaQuery.of(context).size.height;
    late double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.80,
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
                          children: [
                            Container(
                              margin:
                              EdgeInsets.only(left: 30, right: 20,top: height *0.01),
                              padding: EdgeInsets.all(height *0.01),
                              decoration: BoxDecoration(
                                color: Cor.textoBotaoAzul(),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(child: Text('Histórico',style: TextStyle(fontSize: 20,),)),
                                  SizedBox(
                                    width: width *0.90,
                                    height: height *0.60,
                                    child: ListView.builder(
                                      itemCount: timeHistory.length,
                                      itemBuilder: (context, index) {
                                        return Text(
                                            timeHistory[index].getPonto());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height *0.01),
                            SizedBox(
                              height: height *0.04,
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 30, right: 20),
                                  decoration: BoxDecoration(
                                    color: Cor.textoBotaoAzul(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(child: Text('Saldo total:${_ctrlPonto.getTotal()}'))),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
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
                  return Text(
                    snapshot.data == true ? 'Pausar' : 'Iniciar',
                    style: TextStyle(color: Cor.textoBotaoCinza()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
