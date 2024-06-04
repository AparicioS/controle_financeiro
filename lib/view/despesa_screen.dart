import 'dart:io';

import 'package:controle_financeiro/control/despesa_control.dart';
import 'package:controle_financeiro/control/projeto_control.dart';
import 'package:controle_financeiro/model/categoria.dart';
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

class _DespesaScreenState extends State<DespesaScreen> with AutomaticKeepAliveClientMixin {
    @override
  bool get wantKeepAlive => true;
  // ignore: non_constant_identifier_names
  final _FormKey = GlobalKey<FormState>();
  final TextEditingController _ctrlDescricao = TextEditingController();
  final TextEditingController _ctrlValor = TextEditingController();
  final Map<String, dynamic> _despesaMap = <String, dynamic>{};

  late String _projeto = '';
  // ignore: avoid_init_to_null
  late File? _imageFile = null;
  bool _isProgress = false;
  late ProjetoControl _ctrlProjeto;
  late DespesaControl _ctrlDespesa;
  // static List<Categoria> _categoryList=[];

  @override
  void initState() {
    _ctrlProjeto = ProjetoControl();
    _ctrlDespesa = DespesaControl();
    // buscarCategoria().then((value) => _categoryList = value);    
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
    return _despesaMap['categoria'] != '0' ? null:'Descrição obrigatoria para categoria Outros';   
  }
  
  Future<void> _submitData() async {
    if(_FormKey.currentState!.validate()){
      setState(() => _isProgress = true);
        _despesaMap['valor'] = _ctrlValor.text;
        _despesaMap['descricao'] = _ctrlDescricao.text;
      if (_imageFile != null) {
        try {
            String ref = _projeto;
            _despesaMap['image'] = await uploadImagem(ref,_imageFile);
            DespesaControl().cadastrarDespesaFromMap(_despesaMap).then((value) {
              _FormKey.currentState!.reset();
              _ctrlDescricao.clear();
              _ctrlValor.clear();
              _imageFile = null;
              _despesaMap.clear();
              setState(() => _isProgress = false);
            });
        //_despesa.urlImage ='$ref/$nome';
        } on FirebaseException  {
          setState(() => _isProgress = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              StreamBuilder<List<Projeto>>(
                stream: _ctrlProjeto.projetoStream,
                builder: (context, snapshot) {
                  final List<Projeto> projectList = snapshot.data??[];
                  return DropdownButtonFormField<String>(
                    validator: (value) => value == null ?'selecione um Projeto':null,
                    onChanged: (value) {
                      setState(() {
                        if(value != null){
                          _despesaMap['projeto'] = value;
                          _projeto = projectList.firstWhere((element) => element.id == value,).nome;
                        }
                      });
                    },
                    items: projectList.map((project) {
                      return DropdownMenuItem<String>(
                        value: project.id,
                        child: Text(project.nome),
                      );
                    }).toList(),
                    decoration: getInputDecoration('Projeto'), 
                  );
                }
              ),
              SizedBox(height: height*0.01),
              StreamBuilder<List<Categoria>>(
                stream: _ctrlDespesa.categoriaStream,
                builder: (context, snapshot) {
                  final List<Categoria> categoryList = snapshot.data??[];
                  return DropdownButtonFormField<String>(
                    validator: (value) => value == null ?'selecione uma Categoria':null,
                    onChanged: (value) {
                      setState(() {
                        _despesaMap['categoria'] = value;
                      });
                    },
                    items: categoryList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.nome),
                      );
                    }).toList(),
                    decoration: getInputDecoration('Categoria'),
                  );
                }
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
                child: _imageFile == null ? TextFormField(enabled: false,
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
                    width: width * 0.2,
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
