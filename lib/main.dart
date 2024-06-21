import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gymapp/telas/autenticacao_tela.dart';
import 'package:flutter_gymapp/telas/inicio_tela.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //! Avisa ao flutter que é uma função asincrona

  //! Inicializa o firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // home: ExercicioTela() //importa a tela de exercicios
        home: RoteadorTela() //importa a tela de exercicios
        );
  }
}

//! Cria um roetador de tela para verificar se o usuario está logado
//! o strem fica monitorando alteracoes no firebase
class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //! passando os dados do usuario para a tela inicial
            return InicioTela(
              user: snapshot.data!,
            );
          } else {
            return const AutenticacaoTela();
          }
        });
  }
}
