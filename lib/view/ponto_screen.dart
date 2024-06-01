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
  late String? _projeto = '';

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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container( 
                                  width: width*0.9,
                                    height: height*0.06,                               
                                  padding: const EdgeInsets.fromLTRB(20, 5,20, 5),
                                  child: Center(
                                    child: Text('Projeto: $_projeto',style: const TextStyle(fontSize: 20,),
                                    textAlign: TextAlign.right,)),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 1,
                                  child: Container(
                                    width: width*0.50,
                                    height: height*0.065,
                                    padding: const EdgeInsets.fromLTRB(20, 5,20, 5),
                                    child: DropdownButton<String>(
                                      dropdownColor: Cor.backgrud(),
                                      underline: const Icon(Icons.autorenew_sharp),
                                      // icon: const Visibility (visible:false, child: Icon(Icons.arrow_downward)),    
                                      iconSize: 0.0,          
                                      padding: const EdgeInsets.fromLTRB(100, 5,5, 5),
                                      onChanged: (value) {
                                        _ctrlPonto.setProjeto(value!).then((e) {
                                          if(e){
                                            setState(() {
                                              _projetoId =value;
                                              _projeto = _projectList.firstWhere((element) => element.id == _projetoId,).nome;
                                            });
                                          }
                                        });
                                      },
                                      items: _projectList.map((project) {
                                        return DropdownMenuItem<String>(
                                          value: project.id,
                                          child: Text(project.nome),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                            timeHistory[index].getPonto(),style: TextStyle(color:timeHistory[index].isDeslocamento ?Cor.erro():Cor.texto() ),);
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
                                  child: Center(child: Text('Horas trabalhadas:${_ctrlPonto.getTotal()} - Horas Pagas:${_ctrlPonto.getTotal()} - Saldo:${_ctrlPonto.getTotal()}'))),
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
            left: 20,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BotaoRodape(
                    width: width * 0.30,
                  onPressed: () {
                    _ctrlPonto.setDeslocamento(context);
                  },
                  child: StreamBuilder<String>(
                    stream: _ctrlPonto.botaoPontoStream,
                    initialData: 'Deslocamento',
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(color: Cor.textoBotaoCinza()),
                      );
                    },
                  ),
                ),
                  SizedBox(
                    width: width * 0.20,
                  ),
                BotaoRodape(
                    width: width * 0.30,
                  onPressed: () {
                    _ctrlPonto.startStopTimer(_projetoId);
                  },
                  child: StreamBuilder<String>(
                    stream: _ctrlPonto.botaoStartStream,
                    initialData:  'Iniciar',
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(color: Cor.textoBotaoCinza()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
