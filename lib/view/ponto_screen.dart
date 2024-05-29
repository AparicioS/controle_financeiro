import 'package:controle_financeiro/control/ponto_control.dart';
import 'package:controle_financeiro/control/projeto_control.dart';
import 'package:controle_financeiro/model/ponto.dart';
import 'package:controle_financeiro/model/projeto.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:flutter/material.dart';

class PontoScreen extends StatefulWidget {
  const PontoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PontoScreenState createState() => _PontoScreenState();
}

class _PontoScreenState extends State<PontoScreen> {
  late PontoControl _ctrlPonto;
  static List<Projeto> _projectList =[];
  late String? _projetoId = '1';

  @override
  void initState() {
    super.initState();
    _ctrlPonto = PontoControl();
    buscarProjeto().then((value) => _projectList =value);
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
                    Container(
                       margin:const EdgeInsets.only(left: 30, right: 20),
                       decoration: BoxDecoration(
                        color: Cor.textoBotaoAzul(),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                          ),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Projeto:',style: TextStyle(fontSize: 20,)),
                          DropdownButton<String>(                      
                            padding: const EdgeInsets.fromLTRB(100, 5,40, 5),
                            value: _projetoId,
                            onChanged: (value) {
                              setState(() {
                                _projetoId =value;
                              });
                            },
                            items: _projectList.map((project) {
                              return DropdownMenuItem<String>(
                                value: project.id,
                                child: Text(project.nome),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
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
                                    height: height *0.50,
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
                _ctrlPonto.startStopTimer(_projetoId);
              },
              child: StreamBuilder<bool>(
                stream: _ctrlPonto.isRunningStream,
                initialData: false,
                builder: (context, snapshot) {
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
