import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  //! Atributo de instancia para conexao com o firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //! Criado metodo para a comunicação com firebase auth e criar o usuario
  //! Future<String?> indica que o retorno da funcao será asincrono
  Future<String?> cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      //! adicionando o nome
      await userCredential.user!.updateDisplayName(nome);

      var teste = userCredential.user;

      print(teste);
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      // TODO
      if (e.code == 'email-already-in-use') {
        return ('O usuário já está cadastrado!');
      }

      return "erro desconhecido";
    }
  }

  //! Metodo para logar o usuário

  Future<String?> logarUsuarios(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //! metodo para deslogar o usuario
  Future<void> deslogar() async {
    return _firebaseAuth.signOut();
  }
}
