import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_comum/minhas_cores.dart';
import 'package:flutter_gymapp/componentes/decoracao_campo_autenticacao.dart';
import 'package:flutter_gymapp/models/exercicio_modelo.dart';
import 'package:flutter_gymapp/models/sentimento_modelo.dart';
import 'package:flutter_gymapp/servicos/exercicio_servico.dart';
import 'package:flutter_gymapp/servicos/sentimento_servico.dart';
import 'package:uuid/uuid.dart';

//! funcao para chamar outra funcao do flutter para deixar organizado
//! precisa do BuildContext para abrir elementos do material
//! quando for passando o exercicio que é algo opcional, quer dizer que vai está editando e nao criando
mostrarAdicionarEditarExercicioModal(BuildContext context,
    {ExercicioModelo? exercicio}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: MinhasCores.azulEscuro,
      isDismissible: false, //! isDismissible diz se pode fechar clicando fora
      isScrollControlled: true, //! pode dar scroll
      //! borderRadius para evitar problemas quando se coloca um container dentro
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        //! passa exercicioModelo para o modal
        return ExercicioModal(exercicioModelo: exercicio);
      });
}

class ExercicioModal extends StatefulWidget {
  //! quando for passando o exercicioModelo que é algo opcional, quer dizer que vai está editando e nao criando
  final ExercicioModelo? exercicioModelo;
  //! passa exercicioModelo para o construtor
  const ExercicioModal({super.key, this.exercicioModelo});

  @override
  State<ExercicioModal> createState() => _ExercicioModalState();
}

class _ExercicioModalState extends State<ExercicioModal> {
//! controlador dos campos do formulario
  final TextEditingController _nomeCrtl = TextEditingController();
  final TextEditingController _treinoCtrl = TextEditingController();
  final TextEditingController _anotacoesCrtl = TextEditingController();
  final TextEditingController _sentindoCrtl = TextEditingController();

  bool isCarregando = false;

  final ExercicioServico _exercicioServico = ExercicioServico();
  final SentimentoServico _sentimentoServico = SentimentoServico();

  //! cria um initState para poder alimentar os valores inicias dos campos de texto do formulario
  @override
  void initState() {
    // TODO: implement initState

    //! se estiver EDITANDO
    if (widget.exercicioModelo != null) {
      _nomeCrtl.text = widget.exercicioModelo!.nome;
      _treinoCtrl.text = widget.exercicioModelo!.treino;
      _anotacoesCrtl.text = widget.exercicioModelo!.comoFazer;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      //! define o tamanho do modal
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              //! a coluna vai ocupar o minimo de espaço possivel
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //! USANDO FLEXIBLE
                    Flexible(
                      child: Text(
                        (widget.exercicioModelo != null)
                            ? 'Editar ${widget.exercicioModelo!.nome}'
                            : 'Adicionar Exercícios',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ))
                  ],
                ),
                const Divider(),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomeCrtl,
                        decoration: getAuthenticationInputDecoration(
                            'Qual o nome do exercício?',
                            icon: const Icon(
                              Icons.abc,
                              color: Colors.white,
                              size: 32,
                            )),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _treinoCtrl,
                        decoration: getAuthenticationInputDecoration(
                            'Qual treino pertence?',
                            icon: const Icon(
                              Icons.list_alt_rounded,
                              color: Colors.white,
                              size: 32,
                            )),
                      ),
                      const Text(
                        'Para agrupar use o mesmo nome',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _anotacoesCrtl,
                        decoration: getAuthenticationInputDecoration(
                          'Quais anotações você tem?',
                          icon: const Icon(
                            Icons.notes_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        maxLines: null,
                      ),
                      //! OCULTA O CAMPO DE TEXTO
                      Visibility(
                        visible: (widget.exercicioModelo == null),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _sentindoCrtl,
                              decoration: getAuthenticationInputDecoration(
                                'Como você está se sentindo?',
                                icon: const Icon(
                                  Icons.emoji_emotions_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              maxLines: null,
                            ),
                            const Text(
                              'Opcional',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  enviarClicado();
                },
                child: (isCarregando)
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: MinhasCores.azulEscuro,
                        ),
                      )
                    : Text(
                        (widget.exercicioModelo != null)
                            ? 'Editar exercício'
                            : 'Criar exercício',
                      ))
          ],
        ),
      ),
    );
  }

  enviarClicado() {
    setState(() {
      isCarregando = true;
    });

    String nome = _nomeCrtl.text;
    String treino = _treinoCtrl.text;
    String anotacoes = _anotacoesCrtl.text;
    String sentindo = _sentindoCrtl.text;

    ExercicioModelo exercicio = ExercicioModelo(
      id: const Uuid().v1(),
      nome: nome,
      treino: treino,
      comoFazer: anotacoes,
    );

    //! MANTEM O ID DO EXERCICIO PARA NO CASO DE EDICAO
    if (widget.exercicioModelo != null) {
      exercicio.id = widget.exercicioModelo!.id;
    }

    //! adiciona um exercicio ao banco
    _exercicioServico.adicionarExercicio(exercicio).then((value) {
      //! trata se a pessoa preencheu o sentimento ou não
      if (sentindo != '') {
        SentimentoModelo sentimento = SentimentoModelo(
          id: const Uuid().v1(),
          sentindo: sentindo,
          data: DateTime.now().toString(),
        );

        _sentimentoServico
            .adicionarSentimento(
                idExercicio: exercicio.id, sentimentoModelo: sentimento)
            .then((value) {
          Navigator.pop(context); //!fecha o modal

          //! seta isCarregando para false
          // setState(() {
          //   isCarregando = false;
          // });
        });
      } else {
        Navigator.pop(context); //!fecha o modal
      }
    });
  }
}
