import "dart:io";

void printErro(String mensagem) {
  print("\nErro: $mensagem\nTente novamente\n");
}

void printMenu(List<String> opcoes) {
  print("");

  int cont = 1;
  for (String opcao in opcoes) {
    print("$cont - ${opcao}");
    cont++;
  }

  print("");
}

int validMenu(int min, int max) {
  String? input;

  while (true) {
    stdout.write("> ");
    input = stdin.readLineSync();
    int saida = 0;

    if (input == null || input.isEmpty) {
      printErro("Alguma opção deve ser escolhida");
      continue;
    }

    try {
      saida = int.parse(input);
    } catch (e) {
      printErro("Um número deve ser digitado");
      continue;
    }

    if (saida >= min && saida <= max) {
      return saida;
    } else {
      printErro("Opção inválida");
      continue;
    }
  }
}