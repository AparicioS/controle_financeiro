import 'package:controle_financeiro/model/despesa.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DespesaScreen extends StatefulWidget {
  const DespesaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DespesaScreenState createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  late Despesa _despesa;
  late XFile? _imageFile;

  final List<String> _projectList = [
    'Projeto 1',
    'Projeto 2',
    'Projeto 3',
  ];

  final List<String> _categoryList = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
  ];

  @override
  void initState() {
    super.initState();
    _despesa = Despesa.novo();
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _submitData() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            onChanged: (value) {
              setState(() {
                _despesa.projeto = value!;
              });
            },
            items: _projectList.map((project) {
              return DropdownMenuItem<String>(
                value: project,
                child: Text(project),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Projeto',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            onChanged: (value) {
              setState(() {
                _despesa.categoria = value!;
              });
            },
            items: _categoryList.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Categoria',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              _despesa.valor = value;
            },
            decoration: const InputDecoration(
              labelText: 'Valor',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            onChanged: (value) {
              _despesa.descricao = value;
            },
            decoration: const InputDecoration(
              labelText: 'Descrição',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _selectImage,
            child: const Text('Tirar Foto'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitData,
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
