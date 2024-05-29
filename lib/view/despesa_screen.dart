import 'dart:io';

import 'package:controle_financeiro/control/despesa_control.dart';
import 'package:controle_financeiro/control/projeto_control.dart';
import 'package:controle_financeiro/model/categoria.dart';
import 'package:controle_financeiro/model/despesa.dart';
import 'package:controle_financeiro/model/projeto.dart';
import 'package:controle_financeiro/view/layout.dart';
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
  late File? _imageFile = null;
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
    
    if(pickedFile!= null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  String? _validaDescricao() {
    return _despesa.categoria != '0' ? null:'Descrição obrigatoria para categoria Outros';   
  }
  
  Future<void> _submitData() async {
    if(_FormKey.currentState!.validate()){
      setState(() => _isProgress = true);
        _FormKey.currentState!.save();
        _despesa.valor = _ctrlValor.text;
        _despesa.descricao = _ctrlDescricao.text;
      if (_imageFile != null) {
        try {
            String ref = _projectList.firstWhere((element) => element.id ==_despesa.projeto,).nome;
            String nome = '${_imageFile.hashCode}.jpg';
            await _storage.ref(ref).child(nome).putFile(_imageFile!);
            final imageUrl = await _storage.ref(ref).child(nome).getDownloadURL();      
            DespesaControl().cadastrarDespesa(_despesa).then((value) {
              _despesa = Despesa.novo();
              _FormKey.currentState!.reset();
              _ctrlDescricao.clear();
              _ctrlValor.clear();
              setState(() => _isProgress = false);
            });
            _despesa.urlImage = imageUrl;
        //_despesa.urlImage ='$ref/$nome';
        } on FirebaseException  {
          setState(() => _isProgress = false);
        }
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
                controller: _ctrlValor,
                validator: (value) => value!.isEmpty ?'informe um valor':null,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: getInputDecoration('Valor'),
              ),
              SizedBox(height: height*0.01),
              TextFormField(controller: _ctrlDescricao,
                validator: (String? value) => value!.isEmpty? _validaDescricao() :null,
                decoration: getInputDecoration('Descrição'),
              ),
              SizedBox(height: height*0.05),
              SizedBox(height:height*0.3 ,
                child: _imageFile ==null ?TextFormField(enabled: false,
                validator: (value) => value!.isEmpty ?'envie uma imagem do comprovante':null,
                decoration: const InputDecoration(hintText: 'Comprovate',),) 
                :Image.file(_imageFile!,height: height*0.3,)),
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
