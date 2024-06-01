import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/categoria.dart';
import 'package:controle_financeiro/model/despesa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DespesaControl {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<String>cadastrarDespesa(despesa)  async {
    if (_currentUser == null) {
      return 'Falha';
    }
    if(despesa.id == 0){
      despesa.id= await getIndex(despesa.projeto);
    }    
    despesa.usuario  = despesa.usuario??_currentUser.uid;
    
    return FirebaseFirestore.instance
        .collection('Projeto')
        .doc(despesa.projeto)
        .collection('despesa')
        .doc(despesa.id.toString())
        .set(despesa.toMap())
        .then((value) => 'Sucesso')
        .catchError((erro) => 'Falha');
  }
  Future<String>cadastrarDespesaFromMap(despesaMap)  async {
    if (_currentUser == null) {
      return 'Falha';
    }
    Despesa despesa = Despesa.fromMap(despesaMap);
    //String id =  await getIndex(despesa.projeto);
    
    return FirebaseFirestore.instance
        .collection('Projeto')
        .doc(despesa.projeto)
        .collection('despesa')
        .doc()
        .set(despesa.toMap())
        .then((value) => 'Sucesso')
        .catchError((erro) => 'Falha');
  }

  static List<Despesa> buscarDespesasPorProjeto(String projeto) {
    List<Despesa> despesas = [];
    FirebaseFirestore.instance.collection('Projeto')
        .doc(projeto)
        .collection('despesa').get().then((value) {
      despesas.addAll(value.docs.map((doc) => Despesa.fromDoc(doc)).toList());
      return despesas;
    }).asStream();
    return despesas;
  }

    static List<Despesa> buscarDespesasPorProjetoUsuario(String usuario) {
    List<Despesa> despesas = [];
    FirebaseFirestore.instance.collection('Projeto')
        .doc()
        .collection('despesa').where("usuario"==usuario).get().then((value) {
      despesas.addAll(value.docs.map((doc) => Despesa.fromDoc(doc)).toList());
      return despesas;
    }).asStream();
    return despesas;
  }  

  Future<String>getIndex(String projeto) async {
    int idx = 0;
    await FirebaseFirestore.instance.collection('Projeto')
        .doc(projeto)
        .collection('despesa').count().get().then(
          (res) {
            return idx = res.count! +1;
          },
    );    
    return idx.toString();
  }
  
}

  
Stream<QuerySnapshot<Map<String, dynamic>>>  buscarCategoriaDinamica() {
    return FirebaseFirestore.instance.collection('Categoria').snapshots();
}  
  
Future<List<Categoria>> buscarCategoria() async{
    Categoria otros =Categoria();
    otros.id = '0' ;
    otros.nome = 'Outros' ;
    List<Categoria> categorias = [];
    categorias.add(otros);
    // ignore: await_only_futures
    await FirebaseFirestore.instance.collection('Categoria').get().then((value) {      
      categorias.addAll(value.docs.map((doc) => Categoria.fromDoc(doc)).toList());
      return categorias;
    }).asStream();
    return categorias;
}  
  
Future<int> getIndex(String projeto)  async{
    int idx = 0;
    // ignore: await_only_futures
    await FirebaseFirestore.instance.collection('Projeto')
        .doc(projeto)
        .collection('despesa').get().then((value) {  
          idx = value.size;    
      return idx;
    }).asStream();
    return idx;
}  

Future<String> uploadImagem(ref,imageFile) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
            String nome = imageFile.path.split('/').last;
            await storage.ref(ref).child(nome).putFile(imageFile); 
    return nome;
}  