import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gymapp/componentes/adicionar_editar_exercicio_modal.dart';
import 'package:flutter_gymapp/componentes/inicio_lista_widget.dart';
import 'package:flutter_gymapp/models/exercicio_modelo.dart';
import 'package:flutter_gymapp/servicos/autenticacao_servico.dart';
import 'package:flutter_gymapp/servicos/exercicio_servico.dart';

class InicioTela extends StatefulWidget {
  //! recebendo os dados do usuário logado
  final User user;

  //! inicializo o construtor com o valor recebido
  const InicioTela({super.key, required this.user});

  @override
  State<InicioTela> createState() => _InicioTelaState();
}

class _InicioTelaState extends State<InicioTela> {
//! instancia os servicos
  ExercicioServico servico = ExercicioServico();
  bool isDecrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text('Meus exercícios'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isDecrescente = !isDecrescente;
                  });
                },
                icon: const Icon(Icons.sort_by_alpha_rounded))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              //! mesmo estando no mesmo arquivo, como esta em widget diferentes
              //! precisa adicionar widget antes do atributo que quero acessar widget.user.displayName
              UserAccountsDrawerHeader(
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  accountName: Text((widget.user.displayName != null)
                      ? widget.user.displayName!
                      : ''),
                  accountEmail: Text(widget.user.email!)),

              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Quer saber como esse app foi feito?'),
                dense: true,
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Deslogar'),
                onTap: () {
                  AutenticacaoServico().deslogar();
                },
                dense: true,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            mostrarAdicionarEditarExercicioModal(context);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: StreamBuilder(
              stream: servico.conectarStreamExercicio(isDecrescente),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<ExercicioModelo> listaExercicios = [];

                    for (var doc in snapshot.data!.docs) {
                      listaExercicios.add(ExercicioModelo.fromMap(doc.data()));
                    }

                    return ListView(
                      children: List.generate(listaExercicios.length, (index) {
                        ExercicioModelo exercicioModelo =
                            listaExercicios[index];
                        //!MODULARIZADO A EXIBIÇÃO DA LISTA DE SERVIÇOS
                        return InicioItemLista(
                            exercicioModelo: exercicioModelo, servico: servico);
                      }),
                    );
                  } else {
                    //! sem nada cadastrado
                    return const Center(
                      child: Text(
                        'Ainda nenhum exercício.\nVamos adicionar?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }
                }
              }),
        ));
  }
}
