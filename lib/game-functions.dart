import "dart:io";

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