import "dart:io";
import "game-functions.dart";
import "utils.dart";
import "statistics-functions.dart";

const x = '\x1B[1;32m\u00D7\x1B[m';
const c = '\x1B[1;36m\u25CB\x1B[m';

void main() {
  menu();
}


void menu() async {
  print("\n         Jogo da velha");
  printLine(colorCode: "1;33");
  printMenu(["Jogar conta o computador", "Jogar conta um amigo", "Visualizar estatísticas", "Sair do jogo"]);
  printLine(colorCode: "1;33");
  int menuChoice = validMenu(1, 4);

  switch (menuChoice) {
    case 1:
      jogo("computer");
    case 2:
      jogo("player");
    case 3:
      estatisticas();
    case 4:
      exit(0);
  }
}


void jogo(rival) async {
  List<List<String>> matrix = matrixGenerator(sideLength: 3);
  Map<String, String> playersInfo = await askPlayersInfo(opponent: rival);

  while (true) {
    Map<String, dynamic> gameInfo = await runGame(matrix, playersInfo);
    String winnerColorCode = gameInfo["winner-signal"] == x ? "1;32" : "1;36";
    List<List<String>> coloredMatrix = colorMatrix(matrix, gameInfo["equal-line"], winnerColorCode);

    gameInfo.remove("equal-line");

    await storeGame(gameInfo);

    print("");
    printLine(colorCode: "1;31");
    print("           FIM DE JOGO");
    printLine(colorCode: "1;31");
    printBoard(coloredMatrix);
    print(gameInfo["winner"] == "-" ? "Empate..." : "Vencedor: ${gameInfo["winner"]}");

    printLine(colorCode: "1;31");

    print("Deseja jogar novamente? [S/N]");
    String playAgainChoice = askCharactersInput(["S", "N"]);

    if (playAgainChoice == "N") return menu();

    matrix = matrix = matrixGenerator(sideLength: 3);
  }
}



void estatisticas() async {
  await printStatistics();
  menu();
}