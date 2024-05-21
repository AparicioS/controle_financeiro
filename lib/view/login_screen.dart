import 'package:controle_financeiro/control/auth_control.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  bool isPossuiCadastro = true;
  // ignore: non_constant_identifier_names
  final _FormKey = GlobalKey<FormState>();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final AuthControl _authControl = AuthControl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Cor.backgrud(),body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key:_FormKey ,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text('NSA',style: TextStyle(fontSize: 48,fontWeight: FontWeight.bold, color:Cor.botaoCinza()),textAlign: TextAlign.center),
              Text('Automação industrial',style: TextStyle(fontSize: 36,color:Cor.botaoCinza()),textAlign: TextAlign.center,),
              Image.asset('assets/logo.png',height: 128,color: Cor.botaoCinza(),),
              TextButton(onPressed: () { 
                GoogleSignIn().signIn().then((value) {
                  // ignore: avoid_print
                  print(value);
                  return printSnackBar(context: context, texto:value!.id.toString());
                });
               },
              child:const Text('conta google')),
              Visibility(visible:!isPossuiCadastro, child:TextFormField(controller: _controllerNome ,decoration: getInputDecoration('Nome:'),validator: (String?value) => value!.isNotEmpty? null :'campo obrigatorio',),),
              const SizedBox(height: 16),
              TextFormField(controller: _controllerEmail ,decoration: getInputDecoration('Email'),validator:(String? value) => value!.isNotEmpty? _validaEmail(value) :'campo obrigatorio',),
              const SizedBox(height: 16),
              TextFormField(controller: _controllerSenha ,decoration: getInputDecoration('Senha:'),obscureText: true,validator: (String? value) => value!.isNotEmpty? null :'campo obrigatorio',),
              const SizedBox(height: 16),
              Visibility(visible:!isPossuiCadastro, child:TextFormField(decoration: getInputDecoration('Confirmar senha:'),obscureText: true,validator: (String? value) => value!.isNotEmpty? _validaSenha(value) :'campo obrigatorio'),),
              const SizedBox(height: 16),
              BotaoRodape(onPressed:_submitData,
                          child: Text(isPossuiCadastro ?'Entrar':'Cadastrar',style: TextStyle(color: Cor.textoBotaoAzul())),
                          ),
              const SizedBox(height: 16),
              TextButton(onPressed: () { setState(() {
                isPossuiCadastro = !isPossuiCadastro;
              }); },
              child:Text(isPossuiCadastro ?'cadastrar':'entrar')),
            ],
          ),
        ),
      ),
    ),);
  }  

  void _submitData() {
    if(_FormKey.currentState!.validate()){
      _authControl.cadastroEmail(nome: _controllerNome.text, email: _controllerEmail.text, senha: _controllerSenha.text);
    }else{

    }
  }
  

  String? _validaEmail(String? value) {
    return !value!.contains('@')?'e-mail invalido':null;  
  }
  

  String? _validaSenha(String? value) {
    return value == _controllerSenha.text ?null:'Senha não confere';   
  }

}