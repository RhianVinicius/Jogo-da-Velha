import "dart:io";
import "utils.dart";


List<List<String>> matrixGenerator({int sideLength = 3}) {
  List<List<String>> matrix = [];

  int cont = 1;
  for (int i = 0; i < sideLength; i++) {

    List<String> matrixLine = [];
    for (int i2 = 0; i2 < sideLength; i2++) {
      matrixLine.add(cont.toString());
      cont++;
    }
    matrix.add(matrixLine);
  }
  return matrix;
}


void printBoard(List matrix) {
  print("");

  int contLine = 1;
  for (List<String> matrixLine in matrix) {
    int lineLength = matrixLine.length;

    int cont = 1;
    for (String val in matrixLine) {
      if (cont != lineLength) {
        stdout.write(" $val │");
      } else {
        print(" $val ");
      }
      cont++;
    }
    if (contLine != 3) {
      print(("―――" * lineLength) + ("―" * (lineLength - 1)));
    }
    contLine++;
  }
  print("");
}


Map<String, String> askPlayersInfo({String opponent = "computer"}) {
  print("\nVamos conhecer os jogadores\n");
  print("Qual o seu nome?");
  String playerName = notNullInput();
  String? rivalName;
  String? playerChoice;

  if (opponent == "player") {
    print("Qual o nome do seu oponente?");
    rivalName = notNullInput();
  } else if (opponent == "computer") {
    rivalName = "PCzão Zero-bala";
  } else {
    throw ArgumentError("O parâmetro informado na função askPlayersInfo(), em game-functions.dart está INCORRETO\nos parâmetros possíveis são: \"computer\" ou \"player\"");
  }

  print("\n$playerName, digite \"X\" para escolher X, e \"C\" para escolher círculo");
  while (true) {
    stdout.write("> ");
    playerChoice = stdin.readLineSync();

    if (playerChoice == null || playerChoice.isEmpty) {
      printErro("Algum valor deve ser informado");
      continue;
    }
    playerChoice = playerChoice.toUpperCase().trim()[0];

    if (playerChoice != 'X' && playerChoice != 'C') {
      printErro("Deve ser digitado \"X\" ou \"C\"");
      continue;
    }
    break;
  }

  String rivalChoice;
  if (playerChoice == "C") {
    rivalChoice = "X";
  } else {
    rivalChoice = "C";
  }
  print("Certo, $rivalName vai jogar com \"$rivalChoice\"");

  return {
    "player-name": playerName,
    "rival-name": rivalName,
    "player-choice": playerChoice,
    "rival-choice": rivalChoice
  };
}