import 'package:flutter/material.dart';
import '../timer_logic.dart';

class PontoScreen extends StatefulWidget {
  const PontoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PontoScreenState createState() => _PontoScreenState();
}

class _PontoScreenState extends State<PontoScreen> {
  late TimerLogic _timerLogic;

  @override
  void initState() {
    super.initState();
    _timerLogic = TimerLogic();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      color: Colors.grey[300],
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
                              height: MediaQuery.of(context).size.height * 0.70,
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
            child: FloatingActionButton(
              onPressed: () {
                _timerLogic.startStopTimer();
              },
              child: StreamBuilder<bool>(
                stream: _timerLogic.isRunningStream,
                initialData: false,
                builder: (context, snapshot) {
                  //return Icon(snapshot.data == true ? Icons.pause : Icons.play_arrow);
                    return Text(snapshot.data == true ? 'Pausar' : 'Iniciar');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
