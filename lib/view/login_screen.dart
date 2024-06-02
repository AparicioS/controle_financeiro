import 'package:controle_financeiro/control/auth_control.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  bool isPossuiCadastro = true;
  bool isVisibilityS= false;
  bool isVisibilityCS= false;
  // ignore: non_constant_identifier_names
  final _FormKey = GlobalKey<FormState>();
  final TextEditingController _ctrlNome = TextEditingController();
  final TextEditingController _ctrlEmail = TextEditingController();
  final TextEditingController _ctrlSenha = TextEditingController();
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
              TextButton(onPressed: _entrarGoogle,
              child:const Text('conta google')),
              Visibility(visible:!isPossuiCadastro, child:TextFormField(controller: _ctrlNome ,decoration: getInputDecoration('Nome:'),validator: (String?value) => value!.isNotEmpty? null :'campo obrigatorio',),),
              const SizedBox(height: 16),
              TextFormField(controller: _ctrlEmail ,decoration: getInputDecoration('Email'),validator:(String? value) => value!.isNotEmpty? null :'campo obrigatorio',),
              const SizedBox(height: 16),
              TextFormField(controller: _ctrlSenha ,decoration: InputDecoration(
                  hintText: 'Senha:',
                  fillColor: Cor.textoBotaoAzul(),
                  filled: true,
                  suffixIcon: IconButton( 
                    onPressed: () {
                      setState(() {
                        isVisibilityS = !isVisibilityS;
                      });
                    },
                    icon:Icon( isVisibilityS ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                ),obscureText: !isVisibilityS,validator: (String? value) => value!.isNotEmpty? null :'campo obrigatorio',),
              const SizedBox(height: 16),
              Visibility(visible:!isPossuiCadastro, child:TextFormField(decoration:InputDecoration(
                  hintText: 'Confirmar senha:',
                  fillColor: Cor.textoBotaoAzul(),
                  filled: true,
                  suffixIcon: IconButton( 
                    onPressed: () {
                      setState(() {
                        isVisibilityCS = !isVisibilityCS;
                      });
                    },
                    icon:Icon( isVisibilityCS ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                ),obscureText: !isVisibilityCS,validator: (String? value) => value!.isNotEmpty? _validaSenha(value) :'campo obrigatorio'),),
              const SizedBox(height: 16),
              BotaoRodape(onPressed:isPossuiCadastro ? _entrar :_cadastrar,
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

  void _cadastrar() {
    if(_FormKey.currentState!.validate()){
      _authControl.cadastrarEmail(nome: _ctrlNome.text, email: _ctrlEmail.text, senha: _ctrlSenha.text).then((value) => value == null? null :printSnackBar(context: context, texto: value,));
    }
  }
  void _entrar() {
    if(_FormKey.currentState!.validate()){
      _authControl.entrarEmail( email: _ctrlEmail.text, senha: _ctrlSenha.text).then((value) => value == null ? null :printSnackBar(context: context, texto: value,));
    }
  }
  
  void _entrarGoogle() {
      _authControl.entrarGoogle().then((value) => value == null ? null :printSnackBar(context: context, texto: value,));
  }

  String? _validaSenha(String? value) {
    return value == _ctrlSenha.text ?null:'Senha não confere';   
  }

}