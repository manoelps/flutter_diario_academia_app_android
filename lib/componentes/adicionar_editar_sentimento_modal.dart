import 'package:flutter/material.dart';
import 'package:flutter_gymapp/models/sentimento_modelo.dart';
import 'package:flutter_gymapp/servicos/sentimento_servico.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> mostrarAdicionarEditarSentimentoDialog(
  BuildContext context, {
  required String idExercicio,
  SentimentoModelo? sentimentoModelo,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        TextEditingController sentimentoController = TextEditingController();

        if (sentimentoModelo != null) {
          sentimentoController.text = sentimentoModelo.sentindo;
        }

        return AlertDialog(
          title: const Text('Como você está se sentindo?'),
          content: TextFormField(
            controller: sentimentoController,
            decoration: const InputDecoration(
              label: Text("Conte seu sentimento"),
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                SentimentoModelo sentimento = SentimentoModelo(
                  id: const Uuid().v1(),
                  sentindo: sentimentoController.text,
                  data: DateTime.now().toString(),
                );

                //! Atribui o ID do sentimento para que seja possivel editar
                if (sentimentoModelo != null) {
                  sentimento.id = sentimentoModelo.id;
                }

                SentimentoServico()
                    .adicionarSentimento(
                        idExercicio: idExercicio, sentimentoModelo: sentimento)
                    .then((value) {
                  Navigator.pop(context, sentimentoModelo);
                });
              },
              child: Text((sentimentoModelo != null)
                  ? 'Editar sentimento'
                  : 'Criar Sentimento'),
            )
          ],
        );
      });
}
