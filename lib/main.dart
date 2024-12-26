import "dart:io";
import "game-functions.dart";
import "utils.dart";
import "statistics-functions.dart";

void main() {
  menu();
}


void menu() {
  printMenu(["Jogar conta o computador", "Jogar conta um amigo", "Visualizar estatísticas", "Sair do jogo"]);
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
  List<List<String>> matriz = matrixGenerator(sideLength: 3);
  Map<String, String> playersInfo = askPlayersInfo(opponent: rival);

  while (true) {
    Map<String, dynamic> gameInfo = runGame(matriz, playersInfo);
    
    // Usar gameInfo["equal-line"] para printar o tabuleiro final antes de deletar essa key/value

    gameInfo.remove("equal-line");

    await storeGame(gameInfo);

    print("Deseja jogar novamente? [S/N]");
    String playAgainChoice = askCharactersInput(["S", "N"]);

    if (playAgainChoice == "N") return menu();  // está dando erro se tentar jogar novamente

    matriz = matriz = matrixGenerator(sideLength: 3);
  }
}



void estatisticas() async {
  await printStatistics();
  menu();
}