library my_prj.globals;

class CharacterCounter{
  DateTime timestamp = DateTime.now();
  int numberOfChars = 0;

  CharacterCounter(this.timestamp, this.numberOfChars);

  @override
  String toString() {
    return timestamp.toString() + "," + numberOfChars.toString();
  }
}

class FeladatMegoldasParos {
  String feladat = "";
  String megoldas = "";
  List<CharacterCounter> charCounter = [];

  FeladatMegoldasParos(this.feladat);
}

final List<FeladatMegoldasParos> feladatmegoldasLista = [];

int feladatSorszam = 0;

bool beadva = false;

final String s_RiportPdf = "riportPdf.pdf";
final String s_ImagesFolder = "images";

