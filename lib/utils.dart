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


String notNullInput() {
  while (true) {
    stdout.write("> ");
    String? input = stdin.readLineSync();

    if (input == null || input.isEmpty) {
      printErro("Algum valor deve ser informado");
      continue;
    }
    return input;
  }
}

String askCharactersInput(List<String> characters) {
  while (true) {
    stdout.write("> ");
    String? input = stdin.readLineSync();

    if (input == null || input.isEmpty) {
      printErro("Algum valor deve ser informado");
      continue;
    }

    for (String character in characters) if (character.toUpperCase()[0] == input.toUpperCase()[0]) return input.toUpperCase()[0];
    
    printErro('Valor inválido');
  }
}