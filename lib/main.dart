import "dart:io";
import "game-functions.dart";
import "utils.dart";

void main() {
  menu();
}


void menu() {
  printMenu(["Jogar conta o compotador", "Jogar conta um amigo", "Visualizar estatísticas", "Sair do jogo"]);
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


void jogo(rival) {
  List<List<String>> matriz = matrixGenerator(sideLength: 3);
  Map<String, String> playersInfo = askPlayersInfo(opponent: rival);
  
  print(playersInfo);
  printBoard(matriz);
}


void estatisticas() {
  print("Em desenvolvimento...");
  menu();
}