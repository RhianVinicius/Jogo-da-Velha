import "dart:convert";
import "dart:io";
import "utils.dart";

const x = '\u00D7';
const c = '\u25CB';

String path = 'lib/statistics.json';
Future<void> storeGame(Map<String, dynamic> gameInfo) async {
  gameInfo["date"] = DateTime.now().toString();

  try {
    String jsonString = await File(path).readAsString();

    List<dynamic> gamesData = [];
    if (jsonString != '') gamesData = jsonDecode(jsonString);

    gamesData.add(gameInfo);

    String newJsonString = JsonEncoder.withIndent('  ').convert(gamesData);

    await File(path).writeAsString(newJsonString);

  } catch (e) {
    throw Exception("Erro ao realizar operação json: $e");
  }   
}


Future<void> printStatistics() async {
  String jsonString = await File(path).readAsString();

  List<dynamic> gamesData = [];
  if (jsonString != '') {
    gamesData = jsonDecode(jsonString);
  } else {
    print("\nNenhuma estatística armazenada até o momento\nExperiemnte jogar uma partida!\n");
    return;
  }
  
  Map<String, dynamic> gameStatistics = {
    "matches-quantity": 0,
    "x-victories": 0,
    "c-victories": 0,
    "draws": 0,
    "horizontal-equalities": 0,
    "vertical-equalities": 0,
    "diagonal-equalities": 0,
  };
  for (dynamic game in gamesData) {
    switch (game["winner-signal"]) {
      case x:
        gameStatistics["x-victories"]++;
        break;

      case c:
        gameStatistics["c-victories"]++;
        break;

      case "-":
        gameStatistics["draws"]++;
        break;
      
      default:
        throw Exception("Erro ao consultar estatísticas");
    }

    switch (game["equality-direction"]) {
      case "horizontal":
        gameStatistics["horizontal-equalities"]++;
        break;

      case "vertical":
        gameStatistics["vertical-equalities"]++;
        break;

      case "diagonal":
        gameStatistics["diagonal-equalities"]++;
        break; 

      case "-":
        break;

      default:
        throw Exception("Erro ao consultar estatísticas");
    }

    gameStatistics["matches-quantity"]++;
  }

  print("\n         Estatísticas");
  printLine(colorCode: "1;34");

  print("Quantidade de partidas:    ${gameStatistics["matches-quantity"]}\n");
  await wait(0, milliseconds: 500);
  print("Vitórias de $x:             ${gameStatistics["x-victories"]}");
  print("Vitórias de $c:             ${gameStatistics["c-victories"]}");
  print("Empates:                   ${gameStatistics["draws"]}\n");
  await wait(0, milliseconds: 500);
  print("Linhas horizontais feitas: ${gameStatistics["horizontal-equalities"]}");
  print("Linhas verticais feitas:   ${gameStatistics["vertical-equalities"]}");
  print("Linhas diagonais feitas:   ${gameStatistics["diagonal-equalities"]}");

  printLine(colorCode: "1;34");

  print("digite algo para voltar ao menu");
  stdout.write("> ");
  stdin.readLineSync();
}
