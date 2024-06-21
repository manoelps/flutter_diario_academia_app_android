import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_comum/meu_snackbar.dart';
import 'package:flutter_gymapp/_comum/minhas_cores.dart';
import 'package:flutter_gymapp/componentes/decoracao_campo_autenticacao.dart';
import 'package:flutter_gymapp/servicos/autenticacao_servico.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  //! cria uma chave para ser o controlador do formulario para referenciar ao widget form
  final _formKey = GlobalKey<FormState>();

  //! Criado controlador para acessar cada campo do formulario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  //! Instancia o serviço de comunicacao com o firebase
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      //! body: Center(child: Image.asset("assets/logo.png", height: 128,)), orma de centralizar algo direto na tela exemplo para uma tela de  loading
      body: Stack(
        //! Stack empinha os elementos "um atrás do outro"
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.azulTopoGradiente,
                  MinhasCores.azulBaixoGradiente
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              //! atribui uma key para ser o controlador do formulario
              key: _formKey,
              child: Center(
                //! SingleChildScrollView - gera um scroll na tela
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: 128,
                      ),
                      const Text(
                        'GymApp',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getAuthenticationInputDecoration('E-mail'),
                        validator: (String? value) {
                          if (value == null) {
                            return 'O e-mail não pode ser vazio';
                          }
                          if (value.length < 5) {
                            return 'O e-mail é muito curto';
                          }
                          if (!value.contains('@')) {
                            return 'O e-mail não é válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getAuthenticationInputDecoration('Senha'),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {
                            return 'A Senha não pode ser vazia';
                          }
                          if (value.length < 5) {
                            return 'A Senha é muito curta';
                          }
                          if (!queroEntrar &&
                              value != _confirmarSenhaController.text) {
                            return 'As senhas digitadas não são iguais';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                          visible: !queroEntrar,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _confirmarSenhaController,
                                decoration: getAuthenticationInputDecoration(
                                    'Confirme a Senha'),
                                obscureText: true,
                                validator: (String? value) {
                                  if (value == null) {
                                    return 'A Confirmação da Senha não pode ser vazia';
                                  }
                                  if (value.length < 5) {
                                    return 'A Confirmação da Senha é muito curta';
                                  }
                                  if (!queroEntrar &&
                                      value != _senhaController.text) {
                                    return 'As senhas digitadas não são iguais';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nomeController,
                                decoration:
                                    getAuthenticationInputDecoration('Nome'),
                                validator: (String? value) {
                                  if (value == null) {
                                    return 'O nome não pode ser vazio';
                                  }
                                  if (value.length < 3) {
                                    return 'O nome é muito curto';
                                  }
                                  return null;
                                },
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          botaoPrincipalClicado(),
                        },
                        child: Text((queroEntrar) ? 'Entrar' : 'Cadastrar'),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () => {
                          setState(() {
                            queroEntrar = !queroEntrar;
                          })
                        },
                        child: Text((queroEntrar)
                            ? 'Ainda não tem uma conta? Cadastre-se!'
                            : 'Já tem uma conta? Entre!'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String senha = _senhaController.text;
      String nome = _nomeController.text;

      if (queroEntrar) {
        //logando

        _autenticacaoServico
            .logarUsuarios(email: email, senha: senha)
            .then((String? erro) {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
          }
        });
      } else {
        //cadastrando
        _autenticacaoServico
            .cadastrarUsuario(
              email: email,
              senha: senha,
              nome: nome,
            )
            .then(
              (String? erro) => {
                // voltou com erro
                if (erro != null)
                  {
                    mostrarSnackBar(context: context, texto: erro),
                  }
                // else
                //   {
                //     // Deu certo
                //     mostrarSnackBar(
                //         context: context,
                //         texto: 'Cadastrado efetuado com sucesso!',
                //         isError: false)
                //   }
              },
            );
      }
    } else {
      print('INVALIDO');
    }
  }
}
