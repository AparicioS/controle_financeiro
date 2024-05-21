import 'package:controle_financeiro/control/despesa_control.dart';
import 'package:controle_financeiro/control/projeto_control.dart';
import 'package:controle_financeiro/model/categoria.dart';
import 'package:controle_financeiro/model/despesa.dart';
import 'package:controle_financeiro/model/projeto.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DespesaScreen extends StatefulWidget {
   const DespesaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DespesaScreenState createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  // ignore: non_constant_identifier_names
  final _FormKey = GlobalKey<FormState>();
  late Despesa _despesa;
  late XFile? _imageFile;
  List<Projeto> _projectList =[];
  List<Categoria> _categoryList=[];

  @override
  void initState() {
    _despesa = Despesa.novo();
    buscarProjeto().then((value) => _projectList =value);
    buscarCategoria().then((value) => _categoryList = value);
    super.initState();
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _submitData() {
    if(_FormKey.currentState!.validate()){
      // Implementar a lógica para enviar os dados
      // ignore: avoid_print
      print('Projeto: ${_despesa.projeto}');
      // ignore: avoid_print
      print('Categoria: ${_despesa.categoria}');
      // ignore: avoid_print
      print('Valor: ${_despesa.valor}');
      // ignore: avoid_print
      print('Descrição: ${_despesa.descricao}');
      if (_imageFile != null) {
        // ignore: avoid_print
        print('Imagem: ${_imageFile!.path}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late double height = MediaQuery.of(context).size.height;
    late double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _FormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                validator: (value) => value == null ?'selecione um Projeto':null,
                onChanged: (value) {
                  setState(() {
                    _despesa.projeto = value!;
                  });
                },
                items: _projectList.map((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.nome),
                  );
                }).toList(),
                decoration: getInputDecoration('Projeto'),
              ),
              SizedBox(height: height*0.01),
              DropdownButtonFormField<String>(
                validator: (value) => value == null ?'selecione uma Categoria':null,
                onChanged: (value) {
                  setState(() {
                    _despesa.categoria = value!;
                  });
                },
                items: _categoryList.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.nome),
                  );
                }).toList(),
                decoration: getInputDecoration('Categoria'),
              ),
              SizedBox(height: height * 0.01),
              TextFormField(
                validator: (value) => value == '' ?'informe um valor':null,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  _despesa.valor = value;
                },
                decoration: getInputDecoration('Valor'),
              ),
              SizedBox(height: height*0.01),
              TextFormField(
                onChanged: (value) {
                  _despesa.descricao = value;
                },
                decoration: getInputDecoration('Descrição'),
              ),
              SizedBox(height: height*0.05),
              Row(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BotaoRodape(
                    onPressed: _selectImage,
                    width: width * 0.30,
                    child: Text(
                      'Tirar Foto',
                      style: TextStyle(color: Cor.textoBotaoAzul()),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.15,
                  ),
                  BotaoRodape(
                    onPressed: _submitData,
                    width: width * 0.30,
                    child: Text(
                      'Enviar',
                      style: TextStyle(color: Cor.textoBotaoAzul()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height*0.01),
            ],
          ),
        ),
      ),
    );
  }
}
