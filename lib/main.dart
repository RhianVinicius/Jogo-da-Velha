import "dart:io";
import "game-functions.dart";
import "utils.dart";
import "statistics-functions.dart";

void main() {
  menu();
}


void menu() async {
  print("\n         Jogo da velha");
  printLine(colorCode: "1;36");
  printMenu(["Jogar conta o computador", "Jogar conta um amigo", "Visualizar estatísticas", "Sair do jogo"]);
  printLine(colorCode: "1;36");
  int menuChoice = validMenu(1, 4);

  switch (menuChoice) {
    case 1:
      jogo("computer");
    case 2:
      jogo("player");
    case 3:
      estatisticas();
    case 4:
    print("");
      for (int i = 0; i < 3; i++) {
        stdout.write(".");
        await wait(0, milliseconds: 700);
      }
      await wait(0, milliseconds: 500);

      exit(0);
  }
}


void jogo(rival) async {
  List<List<String>> matrix = matrixGenerator(sideLength: 3);
  Map<String, String> playersInfo = askPlayersInfo(opponent: rival);

  while (true) {
    Map<String, dynamic> gameInfo = runGame(matrix, playersInfo);
    
    // Usar gameInfo["equal-line"] para printar o tabuleiro final antes de deletar essa key/value
    print(matrix);
    print(gameInfo["equal-line"]);
    List<List<String>> coloredMatrix = colorMatrix(matrix, gameInfo["equal-line"]);
    printBoard(coloredMatrix);

    gameInfo.remove("equal-line");

    await storeGame(gameInfo);

    print("Deseja jogar novamente? [S/N]");
    String playAgainChoice = askCharactersInput(["S", "N"]);

    if (playAgainChoice == "N") return menu();  // está dando erro se tentar jogar novamente

    matrix = matrix = matrixGenerator(sideLength: 3);
  }
}



void estatisticas() async {
  await printStatistics();
  menu();
}