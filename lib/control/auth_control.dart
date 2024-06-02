library firebase_auth_utility;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_financeiro/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthControl  {  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isOnline = true;

  Future<String?> cadastrarEmail({required String nome,required String email,required String senha}) async{
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);
      await userCredential.user!.updateDisplayName(nome);
      Usuario().caregaUsuarioLitUser(_firebaseAuth.currentUser);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  
  Future<String?> entrarEmail({required String email,required String senha}) async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
      Usuario().caregaUsuarioLitUser(_firebaseAuth.currentUser);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  
  Future<String?> entrarGoogle() async{
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken,idToken: googleAuth?.idToken,);
      await _firebaseAuth.signInWithCredential(credential);
      Usuario().caregaUsuarioLitUser(_firebaseAuth.currentUser);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sair() async{
    return _firebaseAuth.signOut();
  }  
  Future<bool> disableNetwork() async{
    if(!isOnline){
      return FirebaseFirestore.instance.enableNetwork().then((value) => true);
    }
    return FirebaseFirestore.instance.disableNetwork().then((value) => false);
  }  

}
