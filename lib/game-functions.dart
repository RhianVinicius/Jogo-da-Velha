import "dart:io";
import "dart:math";
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
    "rival-choice": rivalChoice,
    "rival-type": opponent
  };
}


Map<String, dynamic> runGame(List<List<String>> matrix, Map<String, dynamic> playersInfo) {
  Map<String, dynamic> currentGameInfo = {};

  currentGameInfo["current-signal"] = "X";
  currentGameInfo["current-player"] = playersInfo["player-choice"] == "X" ? playersInfo["player-name"] : playersInfo["rival-name"];
  currentGameInfo["generate-answer"] = currentGameInfo["current-player"] == playersInfo["rival-name"] && playersInfo["rival-type"] == "computer";

  int turn = 1;
  List<List<String>> currentMatrix = matrix;
  while (true) {
    String currentPlayer = currentGameInfo["current-player"];
    String currentSignal = currentGameInfo["current-signal"];
    bool generateAnswer = currentGameInfo["generate-answer"];

    printBoard(currentMatrix);

    print("Turno $turn\n");

    print("Vez de - ${currentPlayer} -");
    String boardChoice = generateAnswer ? generateBoardChoice(currentMatrix, currentSignal) : askBoardChoice(currentMatrix, currentSignal);

    currentMatrix = boardUpdate(currentMatrix, boardChoice, currentSignal);
    // função para verificar se algum jogador venceu 
    if (turn == 9) return {"matrix": currentMatrix, "winner": playersInfo["player-name"]}; // Apenas um teste para saber como seria se o jogo caso o mesmo acabasse no turno 9
    turn++;

    currentGameInfo = switchTurn(playersInfo, currentSignal);
  }
}


List<List<String>> boardUpdate(List<List<String>> matrix, String boardChoice, String currentSignal) {
  print("\nValor vindo de generate board: $boardChoice\n");
  for (List<String> line in matrix) {
    int cont = 0;

    for (String value in line) {
      if (value == boardChoice) {
        line[cont] = currentSignal;
        return matrix;
      }

      cont++;
    }
  }
  throw Exception("Erro na função \"boardUpdate\": valor informado não consta na matriz");
}


String askBoardChoice(List<List<String>> matrix, String currentSignal) {
  print("Em que posicão deseja jogar? [$currentSignal]");

  while (true) {
    stdout.write("> ");
    String? input = stdin.readLineSync();
    
    for (List<String> line in matrix) for (String value in line) if (input == value) return input!;
    print("\nOpção inválida!\nTente novamente\n");
  }
}


String generateBoardChoice(List<List<String>> matrix, String currentSignal) {
  List<String> possibleValues = [];

  for (List<String> line in matrix) for (String value in line) if (value != "X" && value != "C") possibleValues.add(value);

  Random random = new Random();
  return possibleValues[int.parse(random.nextInt(possibleValues.length).toString())];
}


Map<String, dynamic> switchTurn(Map<String, dynamic> playersInfo, String currentSignal) {
  String newCurrentPlayer = "N/A", newCurrentSignal = "N/A";
  bool generateAnswer = false;

  if (currentSignal == "X") {
    newCurrentSignal = "C";
    newCurrentPlayer = playersInfo["player-choice"] == "C" ? playersInfo["player-name"] : playersInfo["rival-name"];
  } else {
    newCurrentSignal = "X";
    newCurrentPlayer = playersInfo["player-choice"] == "X" ? playersInfo["player-name"] : playersInfo["rival-name"];
  }

  generateAnswer = newCurrentPlayer == playersInfo["rival-name"] && playersInfo["rival-type"] == "computer";

  return {
    "current-signal": newCurrentSignal,
    "current-player": newCurrentPlayer,
    "generate-answer": generateAnswer,
  };
}

