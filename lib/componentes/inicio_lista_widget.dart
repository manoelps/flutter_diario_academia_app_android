import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_comum/minhas_cores.dart';
import 'package:flutter_gymapp/componentes/adicionar_editar_exercicio_modal.dart';
import 'package:flutter_gymapp/models/exercicio_modelo.dart';
import 'package:flutter_gymapp/servicos/exercicio_servico.dart';

import '../telas/exercicio_tela.dart';

class InicioItemLista extends StatelessWidget {
  final ExercicioModelo exercicioModelo;
  final ExercicioServico servico;
  const InicioItemLista(
      {super.key, required this.exercicioModelo, required this.servico});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        //! Navegando entre telas e passando informações entre elas
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExercicioTela(
                exercicioModelo: exercicioModelo,
              ),
            ))
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black.withAlpha(125),
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        height: 90,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: MinhasCores.azulEscuro,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                height: 30,
                width: 150,
                child: Center(
                  child: Text(
                    exercicioModelo.treino,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          exercicioModelo.nome,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: MinhasCores.azulEscuro,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        //!  mainAxisSize: MainAxisSize.min CORRIGE O PROBLEMA DE NO TRAILING NAO ACEITAR LISTA DE ITENS POR PADRAO
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              //! EDITANDO: CHAMANDO O MODAL E PASSANDO O EXERCICIO
                              mostrarAdicionarEditarExercicioModal(
                                context,
                                exercicio: exercicioModelo,
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              //! CRIA um snackBar
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Deseja remover ${exercicioModelo.nome}?',
                                ),
                                action: SnackBarAction(
                                    label: 'REMOVER',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      //! deletar: PASSANDO O EXERCICIO PARA REMOVER
                                      servico.removerExercicio(
                                          idExercicio: exercicioModelo.id);
                                    }),
                              );

                              //! CHAMA um snackBar
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 150,
                          child: Text(
                            exercicioModelo.comoFazer,
                            overflow: TextOverflow.ellipsis,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return ListTile(
    //     title: Text(exercicioModelo.nome),
    //     subtitle: Text(exercicioModelo.treino),
    //     trailing: Row(
    //       //!  mainAxisSize: MainAxisSize.min CORRIGE O PROBLEMA DE NO TRAILING NAO ACEITAR LISTA DE ITENS POR PADRAO
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         IconButton(
    //           icon: const Icon(Icons.edit),
    //           onPressed: () {
    //             //! EDITANDO: CHAMANDO O MODAL E PASSANDO O EXERCICIO
    //             mostrarModalInicio(
    //               context,
    //               exercicio: exercicioModelo,
    //             );
    //           },
    //         ),
    //         IconButton(
    //           onPressed: () {
    //             //! CRIA um snackBar
    //             SnackBar snackBar = SnackBar(
    //               backgroundColor: Colors.red,
    //               content: Text(
    //                 'Deseja remover ${exercicioModelo.nome}?',
    //               ),
    //               action: SnackBarAction(
    //                   label: 'REMOVER',
    //                   textColor: Colors.white,
    //                   onPressed: () {
    //                     //! deletar: PASSANDO O EXERCICIO PARA REMOVER
    //                     servico.removerExercicio(
    //                         idExercicio: exercicioModelo.id);
    //                   }),
    //             );

    //             //! CHAMA um snackBar
    //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //           },
    //           icon: const Icon(Icons.delete),
    //         )
    //       ],
    //     ),
    //     onTap: () => {
    //           //! Navegando entre telas e passando informações entre elas
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => ExercicioTela(
    //                   exercicioModelo: exercicioModelo,
    //                 ),
    //               ))
    //         });
  }
}
