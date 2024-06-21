import 'package:flutter/material.dart';
import 'package:flutter_gymapp/componentes/adicionar_editar_sentimento_modal.dart';
import 'package:flutter_gymapp/models/exercicio_modelo.dart';
import 'package:flutter_gymapp/models/sentimento_modelo.dart';
import 'package:flutter_gymapp/servicos/sentimento_servico.dart';

//digitando "stl" já é um snipet para criar um StatelessWidget
class ExercicioTela extends StatelessWidget {
  //! recebendo dados do exercicio
  final ExercicioModelo exercicioModelo;

  //! inicializo o construtor com o valor recebido
  ExercicioTela({super.key, required this.exercicioModelo});

  // Instanciando os models criados com dados mocados
  // final ExercicioModelo exercicioModelo = ExercicioModelo(
  //     id: 'EX001',
  //     nome: 'Remanda Baixa Supinada',
  //     treino: 'Treino A',
  //     comoFazer: 'Segura a barra e puxa');

  // final List<SentimentoModelo> listaSentimentos = [
  //   // SentimentoModelo(
  //   //     id: 'SE001', sentimento: 'Pouca ativação hoje', data: '2024/06/19'),
  //   // SentimentoModelo(
  //   //     id: 'SE001',
  //   //     sentimento: 'Já senti alguma ativação',
  //   //     data: '2024/06/18'),
  // ];

  //! Instancia
  final SentimentoServico _sentimentoServico = SentimentoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                exercicioModelo.nome,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white),
              ),
              Text(
                exercicioModelo.treino,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              )
            ],
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 102, 190, 222),
          // backgroundColor: const Color(
          //   0xFF0A6D92,
          // ), //! 0xFF no inicio serve para substituir o # do hexadecimal
          elevation: 0, //! REMOVE SOMBRAS de widgets no FLUTTER
          toolbarHeight: 72, //! altera a altura da toolbar
          //! altera as bordas do toolbar
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            mostrarAdicionarEditarSentimentoDialog(context,
                idExercicio: exercicioModelo.id)
          },
          child: const Icon(Icons.add),
        ),

        //! CORPO DA TELA CERCADO COM PADDING
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8),

          //! COLUNA
          child: ListView(
            children: [
              //! Botões sempre sao criados com ElevatedButton
              SizedBox(
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onPressed: () => {},
                      child: const Text('Enviar foto'),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        onPressed: () => {},
                        child: const Text('Tirar foto'))
                  ],
                ),
              ),
              const SizedBox(height: 8),
              //! SizedBox passando height é UMA FORMA DE FAZER ESPAÇAMENTO SEM O USO DO PADDING
              const Text(
                'Como fazer?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              //! SizedBox passando height é UMA FORMA DE FAZER ESPAÇAMENTO SEM O USO DO PADDING//! UMA FORMA DE FAZER ESPAÇAMENTO SEM O USO DO PADDING
              Text(exercicioModelo.comoFazer),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(color: Colors.black),
              ),
              const Text(
                'Como estou me sentindo?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              StreamBuilder(
                stream: _sentimentoServico.conectarStreamSentimento(
                    idExercicio: exercicioModelo.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      final List<SentimentoModelo> listaSentimentos = [
                        // SentimentoModelo(
                        //     id: 'SE001', sentimento: 'Pouca ativação hoje', data: '2024/06/19'),
                        // SentimentoModelo(
                        //     id: 'SE001',
                        //     sentimento: 'Já senti alguma ativação',
                        //     data: '2024/06/18'),
                      ];

                      for (var doc in snapshot.data!.docs) {
                        listaSentimentos
                            .add(SentimentoModelo.fromMap(doc.data()));
                      }

                      return //! SizedBox passando height é UMA FORMA DE FAZER ESPAÇAMENTO SEM O USO DO PADDING
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            List.generate(listaSentimentos.length, (index) {
                          SentimentoModelo sentimentoAgora =
                              listaSentimentos[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(sentimentoAgora.sentindo),
                            subtitle: Text(sentimentoAgora.data),
                            leading: const Icon(Icons.double_arrow),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => {
                                    mostrarAdicionarEditarSentimentoDialog(
                                        context,
                                        idExercicio: exercicioModelo.id,
                                        sentimentoModelo: sentimentoAgora)
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _sentimentoServico.removerSentimento(
                                        exercicioId: exercicioModelo.id,
                                        sentimentoId: sentimentoAgora.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    } else {
                      return const Text('Nenhuma anotação de sentimento');
                    }
                  }
                },
              )
            ],
          ),
        ));
  }
}
