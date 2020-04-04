library my_prj.globals;

class FeladatMegoldasParos {
  String feladat = "";
  String megoldas = "";
  List<String> charCounter = [];

  FeladatMegoldasParos(this.feladat);
}

final List<FeladatMegoldasParos> feladatmegoldasLista = [];

int feladatSorszam = 0;

bool beadva = false;

final String s_RiportPdf = "riportPdf.pdf";
final String s_ImagesFolder = "images";

