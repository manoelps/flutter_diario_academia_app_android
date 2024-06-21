class ExercicioModelo {
  // atributos ou propriedades como sao chamadas no dart
  String id;
  String nome;
  String treino;
  String comoFazer;

  String? urlImagem;

  //Contrutor DART com parametro nomeado
  ExercicioModelo({
    required this.id,
    required this.nome,
    required this.treino,
    required this.comoFazer,
  });

  //Criar construtor nomeado chamado fromMap para conseguir manipular os dados (quando quer pegar dados do banco de dados)
  ExercicioModelo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nome = map['nome'],
        treino = map['treino'],
        comoFazer = map['comoFazer'],
        urlImagem = map['urlImagem'];

  //Transformando o Map em objeto (quando quer enviar os dados para o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'treino': treino,
      'comoFazer': comoFazer,
      'urlImagem': urlImagem
    };
  }
}
