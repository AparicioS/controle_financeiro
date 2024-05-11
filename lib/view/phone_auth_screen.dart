import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  late FirebaseAuth _auth;
  //late String _verificationId = '';
  late String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  Future<void> _verifyPhoneNumber() async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      // Navegar para a tela do menu principal após a autenticação
      // Navigator.pushReplacementNamed(context, '/menu');
    }

    verificationFailed(FirebaseAuthException authException) {
      // ignore: avoid_print
      print('Erro ao verificar o número de telefone: ${authException.message}');
      // Exibir mensagem de erro ao usuário, se necessário
    }

    codeSent(String verificationId, int? forceResendingToken) async {
      // ignore: avoid_print
      print('Código de verificação enviado para $_phoneNumber');
      //_verificationId = verificationId;
      // Navegar para a tela de entrada do código de verificação
      // Navigator.pushNamed(context, '/verify');
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // ignore: avoid_print
      print('Tempo limite de recuperação automática do código atingido');
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticação por Telefone'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  _phoneNumber = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  _phoneNumber = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Número de Telefone',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                child: const Text('Autenticar Número'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
