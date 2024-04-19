import 'package:controle_financeiro/produto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'timer_logic.dart';
import 'package:image_picker/image_picker.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late TimerLogic _timerLogic;
  late Produto produto;

  @override
  void initState() {
    super.initState();
    _timerLogic = TimerLogic();
    produto = Produto.novo();
  }
// No início do arquivo, antes da classe MenuScreen

List<String> projectList = [
  'Cafe/Lanche',
  'Almoço',
  'Jantar',
  'Extra',
];
String selectedProject = 'Extra';
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
            // Parte inferior (80% da tela)
Expanded(
  child: Container(
    color: Colors.white, // Cor de fundo opcional para os 80% restantes
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown menu de projetos
        DropdownButton<String>(
          hint: const Text('Categoria'),
          value: selectedProject,
          onChanged: (newValue) {
            setState(() {
              selectedProject = newValue!;
            });
          },
          items: projectList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Campo de entrada para o valor
        TextFormField(              
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
              ],
              initialValue: produto.valor.toString(),
              onSaved: (valor) => produto.valor= valor!,
              validator: (valor) {
                if (valor!.isEmpty) {
                  return 'campo obrigatorio';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Valor:"),
            ),
        const SizedBox(height: 16),
ElevatedButton(
  onPressed: () async {
    // Escolher arquivo da galeria
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // Abrir a câmera para tirar uma foto (descomente para ativar)
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Aqui você pode fazer o que quiser com o arquivo selecionado
      // Por exemplo, exibir a imagem selecionada
      // File imageFile = File(pickedFile.path);
      // Exibir a imagem em um widget Image
      // Image(image: FileImage(imageFile));
      // Ou fazer upload do arquivo para um servidor, etc.
    }
  },
  child: const Text('Anexar Arquivo ou Foto'),
),

        ElevatedButton(
          onPressed: () {
            // Implemente a lógica para salvar/enviar os dados
          },
          child: const Text('Enviar'),
        ),
      ],
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
