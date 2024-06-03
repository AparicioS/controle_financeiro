
import 'package:controle_financeiro/control/auth_control.dart';
import 'package:controle_financeiro/view/despesa_screen.dart';
import 'package:controle_financeiro/view/layout.dart';
import 'package:controle_financeiro/view/ponto_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  
  /* metodo para controle de conexão para teste de persistencia off-line*/
  AuthControl ctrl =AuthControl();
  /*---------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    late double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Controle Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Cor.botaoAzul(),background: Cor.backgrud()),
      ),
      home: DefaultTabController(
        length: 2, // Número de abas
        child: Scaffold(
          drawer: Drawer(width: width*0.6, child: ListView(children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child:_currentUser!.photoURL !=null? Image.network(_currentUser.photoURL!,height: 80,):Image.asset('assets/logo.png',height: 80,)),
              accountName: Text(_currentUser.displayName.toString()), 
              accountEmail: Text(_currentUser.email.toString()),decoration: BoxDecoration(color: Cor.botaoCinza()),) ,
            ListTile(leading:const Icon(Icons.logout),title: const Text('sair'),dense: true, onTap:() =>  AuthControl().sair(),),
            
  /* metodo para controle de conexão para teste de persistencia off-line*/
            ListTile(title: Text( ctrl.isOnline ?'online':'off'),dense: true, onTap:() =>  ctrl.disableNetwork().then((value) => setState(() {
              ctrl.isOnline = value;
            })),),
  /*-------------------------------------------------------------------- */
            ],),
          ),
          appBar: AppBar(
            title: const Text('Controle Financeiro'),
            bottom: const TabBar(labelStyle: TextStyle(fontSize: 20),
              indicator: BoxDecoration(color: Color.fromRGBO(41,57,152,1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    )),
              labelColor: Color.fromRGBO(255, 255, 255, 1),
              tabs: [
                Tab(child: Center(widthFactor: 200,child: Text('Ponto')),),
                Tab(child: Center(widthFactor: 200,child: Text('Despesas')),),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // Conteúdo da primeira aba
              PontoScreen(),
              // Conteúdo da segunda aba
              DespesaScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
