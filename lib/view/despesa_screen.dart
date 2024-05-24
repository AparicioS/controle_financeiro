import 'dart:io';

import 'package:controle_financeiro/control/despesa_control.dart';
import 'package:controle_financeiro/control/projeto_control.dart';
import 'package:controle_financeiro/model/categoria.dart';
import 'package:controle_financeiro/model/despesa.dart';
import 'package:controle_financeiro/model/projeto.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final TextEditingController _ctrlDescricao = TextEditingController();
  final TextEditingController _ctrlValor = TextEditingController();
  late Despesa _despesa;
  // ignore: avoid_init_to_null
  late XFile? _imageFile = null;
  bool _isProgress = false;
  static List<Projeto> _projectList =[];
  static List<Categoria> _categoryList=[];
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      setState(() => _isProgress = true);
        _FormKey.currentState!.save();
        _despesa.valor = _ctrlValor.text;
        _despesa.descricao = _ctrlDescricao.text;
      if (_imageFile != null) {
        String ref =_imageFile!.path;
        //_storage.ref(ref).putFile(_imageFile as File);
        _despesa.urlImage =_imageFile!.path;
      }
      
      DespesaControl().cadastrarDespesa(_despesa).then((value) {
        _despesa = Despesa.novo();
        _FormKey.currentState!.reset();
        _ctrlDescricao.clear();
        _ctrlValor.clear();
        setState(() => _isProgress = false);
      });
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
                onSaved: (value) {
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
                decoration: getInputDecoration('Projeto'), onChanged: (String? value) {  },
              ),
              SizedBox(height: height*0.01),
              DropdownButtonFormField<String>(
                validator: (value) => value == null ?'selecione uma Categoria':null,
                onSaved: (value) {
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
                decoration: getInputDecoration('Categoria'), onChanged: (String? value) {  },
              ),
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: _ctrlValor,
                validator: (value) => value == '' ?'informe um valor':null,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: getInputDecoration('Valor'),
              ),
              SizedBox(height: height*0.01),
              TextFormField(controller: _ctrlDescricao,
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
                    // ignore: dead_code
                    child: _isProgress ? CircularProgressIndicator(color: Cor.botaoAzul(),):Text(
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
