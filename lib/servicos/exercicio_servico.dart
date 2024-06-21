import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gymapp/models/exercicio_modelo.dart';

class ExercicioServico {
  //! id do usuario
  String userId;
  //! obtendo o id do usuario direto do firebase
  ExercicioServico() : userId = FirebaseAuth.instance.currentUser!.uid;

  //! Atributo de instancia para conexao com o firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarExercicio(ExercicioModelo exercicioModelo) async {
    return await _firestore
        .collection(userId)
        .doc(exercicioModelo.id)
        .set(exercicioModelo.toMap());
  }

  // Future<void> adicionarSentimento(
  //     String idExercicio, SentimentoModelo sentimentoModelo) async {
  //   return await _firestore
  //       .collection(userId)
  //       .doc(idExercicio)
  //       .collection('sentimentos')
  //       .doc(sentimentoModelo.id)
  //       .set(sentimentoModelo.toMap());
  // }

  //! ESTUDAR assincronismo do dart stream
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamExercicio(
      bool isDecrescente) {
    //! pega uma alteração que ocorre no firestore com ORDENAÇÃO
    return _firestore
        .collection(userId)
        .orderBy('treino', descending: isDecrescente)
        .snapshots();
  }

  //! DELETANDO
  Future<void> removerExercicio({required String idExercicio}) {
    return _firestore.collection(userId).doc(idExercicio).delete();
  }
}
