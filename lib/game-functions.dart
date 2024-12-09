import "dart:io";
import "utils.dart";


void printBoard(Map matriz) {

  int cont = 1, subCont = 1;
  print("");
  for (var entry in matriz.entries) {
    if (cont != 3) {
      stdout.write(" ${entry.value} │");
    } else {
      print(" ${entry.value} ");
    }
    cont++;

    if (cont == 4 && subCont != 3) {
      print("―" * 11);
      cont = 1;
      subCont++;
    } 
  }
  print("");
}


Map<String, String> askPlayersInfo({String signalChoice = "computer"}) {
  print("\nVamos conhecer os jogadores\n");
  print("Qual o seu nome?");
  String playerName = notNullInput();
  String? rivalName;
  String? playerChoice;

  if (signalChoice == "player") {
    print("Qual o nome do seu oponente?");
    rivalName = notNullInput();
  } else if (signalChoice == "computer") {
    rivalName = "PCzão Zero-bala ";
  } else {
    throw ArgumentError("O parâmetro informado está INCORRETO\nos parâmetros possíveis são: \"computer\" ou \"player\'");
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