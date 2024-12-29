import "dart:io";
import "dart:math";
import "utils.dart";

const x = '\x1B[1;32m\u00D7\x1B[m';
const c = '\x1B[1;36m\u25CB\x1B[m';

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
  for (List<String> line in matrix) {
    int lineLength = line.length;

    stdout.write(" " * 10);

    int cont = 1;
    for (String val in line) {
      if (cont != lineLength) {
        stdout.write(" $val \x1B[1;90m│\x1B[m");
      } else {
        print(" $val ");
        stdout.write(" " * 10);
      }
      cont++;
    }
    if (contLine != 3) {
      print(("\x1B[1;90m―――\x1B[m" * lineLength) + ("\x1B[1;90m―\x1B[m" * (lineLength - 1)));
    }
    contLine++;
  }
  print("");
}


Future<Map<String, String>> askPlayersInfo({String opponent = "computer"}) async {
  printLine(colorCode: "1;33");
  print("Vamos conhecer os jogadores");

  print("\nQual o nome do " + returnColoredString("Jogador 1", "4") + "?");
  String playerName = notNullInput();
  String rivalName;
  String? playerChoice;

  if (opponent == "player") {
    print("\nQual o nome do " + returnColoredString("Jogador 2", "4") + "?");
    rivalName = notNullInput();
  } else if (opponent == "computer") {
    rivalName = "Computador";
  } else {
    throw ArgumentError("O parâmetro informado na função askPlayersInfo(), em game-functions.dart está INCORRETO\nos parâmetros possíveis são: \"computer\" ou \"player\"");
  }

  print("\n${returnColoredString(playerName, "4")}, quer jogar com \u00D7 ou com \u25CB? [X/C]");
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

    playerName = playerChoice == "X" ? returnColoredString(playerName, "4;32") : returnColoredString(playerName, "4;36");
    rivalName = playerChoice == "X" ? returnColoredString(rivalName, "4;36") : returnColoredString(rivalName, "4;32");
    playerChoice = playerChoice == "X" ? x : c;

    break;
  }

  String rivalChoice;
  if (playerChoice == c) {
    rivalChoice = x;
  } else {
    rivalChoice = c;
  }

  print("\nCerto, ${returnColoredString(rivalName, "4")} vai jogar com $rivalChoice");

  await wait(1, milliseconds: 500);

  return {
    "player-name": playerName,
    "rival-name": rivalName,
    "player-choice": playerChoice,
    "rival-choice": rivalChoice,
    "rival-type": opponent
  };
}


Future<Map<String, dynamic>> runGame(List<List<String>> matrix, Map<String, dynamic> playersInfo) async {
  Map<String, dynamic> currentGameInfo = {};

  currentGameInfo["current-signal"] = x;
  currentGameInfo["current-player"] = playersInfo["player-choice"] == x ? playersInfo["player-name"] : playersInfo["rival-name"];
  currentGameInfo["generate-answer"] = currentGameInfo["current-player"] == playersInfo["rival-name"] && playersInfo["rival-type"] == "computer";

  int turn = 1;
  List<List<String>> currentMatrix = matrix;
  while (true) {
    String currentPlayer = currentGameInfo["current-player"];
    String currentSignal = currentGameInfo["current-signal"];
    bool generateAnswer = currentGameInfo["generate-answer"];

    print("");
    printLine(colorCode: "1;33");
    print("             Turno $turn");
    printLine(colorCode: "1;33");
    printBoard(currentMatrix);
    printLine(colorCode: "1;33");

    
    print("Vez de ${currentPlayer}   [$currentSignal]");

    String boardChoice = "N/A";
    if (generateAnswer) {
      boardChoice = generateBoardChoice(currentMatrix, currentSignal);

      await wait(1);

      print("> $boardChoice");
      
      await wait(2);

    } else boardChoice = askBoardChoice(currentMatrix, currentSignal);

    currentMatrix = boardUpdate(currentMatrix, boardChoice, currentSignal);

    Map<String, dynamic> gameWinCheck = boardCheck(currentMatrix);
    if (gameWinCheck["equality"]) {
      return {
        "matrix": currentMatrix,
        "player-name": playersInfo["player-name"],
        "rival-name": playersInfo["rival-name"],
        "winner": currentPlayer,
        "winner-signal": currentSignal,
        "equality-direction": gameWinCheck["equality-type"],
        "equal-line": gameWinCheck["equal-line"]
      };
    }
    turn++;

    if (turn == (currentMatrix.length * currentMatrix.length) + 1) {
      return {
        "matrix": currentMatrix,
        "player-name": playersInfo["player-name"],
        "rival-name": playersInfo["rival-name"],
        "winner": "-",
        "winner-signal": "-",
        "equality-direction": "-",
        "equal-line": "-"
      };
    }

    currentGameInfo = switchTurn(playersInfo, currentSignal);
  }
}


List<List<String>> boardUpdate(List<List<String>> matrix, String boardChoice, String currentSignal) {
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
  while (true) {
    stdout.write("> ");
    String? input = stdin.readLineSync();
    
    for (List<String> line in matrix) for (String value in line) if (input == value) return input!;
    print("\nOpção inválida!\nTente novamente\n");
  }
}


String generateBoardChoice(List<List<String>> matrix, String currentSignal) {
  List<String> possibleValues = [];

  for (List<String> line in matrix) for (String value in line) if (value != x && value != c) possibleValues.add(value);

  Random random = new Random();
  return possibleValues[int.parse(random.nextInt(possibleValues.length).toString())];
}


Map<String, dynamic> switchTurn(Map<String, dynamic> playersInfo, String currentSignal) {
  String newCurrentPlayer = "N/A", newCurrentSignal = "N/A";
  bool generateAnswer = false;

  if (currentSignal == x) {
    newCurrentSignal = c;
    newCurrentPlayer = playersInfo["player-choice"] == c ? playersInfo["player-name"] : playersInfo["rival-name"];
  } else {
    newCurrentSignal = x;
    newCurrentPlayer = playersInfo["player-choice"] == x ? playersInfo["player-name"] : playersInfo["rival-name"];
  }

  generateAnswer = newCurrentPlayer == playersInfo["rival-name"] && playersInfo["rival-type"] == "computer";

  return {
    "current-signal": newCurrentSignal,
    "current-player": newCurrentPlayer,
    "generate-answer": generateAnswer,
  };
}


Map<String, dynamic> boardCheck(matrix) {
  int lineStart = -1;
  String equalityType = "-";

  int lineIndex = 0;
  for (List<String> line in matrix) {
    bool isLineEqual = true;

    int cont = 1;
    for (String value in line) {
      if (value != line[0]) isLineEqual = false;

      if (line.length == cont && isLineEqual) {
        lineStart = lineIndex;
        equalityType = "horizontal";
      }
      cont++;
    }
    lineIndex++;
  }

  lineIndex = 0;
  for (int i = 0; i < matrix.length; i++) {
    List<String> vertivcalLine = [];
    bool isLineEqual = true;

    for (List line in matrix) vertivcalLine.add(line[i]);

    int cont = 1;
    for (String value in vertivcalLine) {
      if (vertivcalLine[0] != value) isLineEqual = false;

      if (cont == vertivcalLine.length && isLineEqual) {
        lineStart = lineIndex;
        equalityType = "vertical";
      }
      cont++;
    }
    lineIndex++;
  }


  List<List<String>> diagonalLines = [[], []];
  bool isLineEqual = true;

  int cont = 0;
  for (List line in matrix) {
    diagonalLines[0].add(line[cont]);
    cont++;
  }

  cont = matrix.length - 1;
  for (List line in matrix) {
    diagonalLines[1].add(line[cont]);
    cont--;
  }

  lineIndex = 1;
  for (List<String> diagonalLine in diagonalLines) {
    isLineEqual = true;
    cont = 1;
    for (String value in diagonalLine) {
      if (diagonalLine[0] != value) isLineEqual = false;

      if (diagonalLine.length == cont && isLineEqual) {

        if (lineIndex == 1) lineStart = 0;
        if (lineIndex == 2) lineStart = matrix[0].length - 1;
        equalityType = "diagonal";
      }
      cont++;
    }
  lineIndex++;
  }
  
  
  List<List<String>> clearMatrix = matrixGenerator(sideLength: matrix.length);
  switch (equalityType) {
    case "horizontal":
      return {"equality": true, "equal-line": clearMatrix[lineStart], "equality-type": equalityType};

    case "vertical":
      List<List<String>> verticalLines = [];

      for (int i = 0; i < clearMatrix.length; i++) {
        List<String> verticalLine = [];

        for (List<String> line in clearMatrix) verticalLine.add(line[i]);
        
        verticalLines.add(verticalLine);
      }
      return {"equality": true, "equal-line": verticalLines[lineStart], "equality-type": equalityType};

    case "diagonal":
      List<String> diagonalLine = [];

      if (lineStart == 0) {
        int cont = 0;

        for (List line in clearMatrix) {
          diagonalLine.add(line[cont]);
          cont++;
        }
      } 
      if (lineStart == clearMatrix.length-1) {
        int cont = clearMatrix.length - 1;

        for (List line in clearMatrix) {
          diagonalLine.add(line[cont]);
          cont--;
        }
      }
      return {"equality": true, "equal-line": diagonalLine, "equality-type": equalityType};

    default:
      return {"equality": false, "equal-line": [], "equality-tipe": "-"};
  }
}


List<List<String>> colorMatrix(List<List<String>> matrix, dynamic equalLine, String colorCode) {
  if (equalLine == "-") equalLine = [];
  if (colorCode == "-") colorCode = "0";
  
  List<List<String>> coloredMatrix = [];

  int cont = 1;
  for (List<String> line in matrix) {
    List<String> coloredLine = [];

    for (String value in line) {
      String cleanedValue = value.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '');
      
      equalLine.contains(cont.toString()) ? coloredLine.add("\x1B[${colorCode}m${cleanedValue}\x1B[0m") : coloredLine.add("\x1B[90m${cleanedValue}\x1B[m");
      cont++;
    }
    coloredMatrix.add(coloredLine);
  }

  return coloredMatrix;
}
