import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart'; //it has similar properties as widgets.dart (pw)
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;
import 'package:path/path.dart' show join;
import 'package:startupnamer/camera_functions.dart';
import 'PdfHandler.dart';

void PopulateFeladatLista()
{
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos(
      "Ki volt Nikola Tesla? Ird le a fontosabb felfedezeseit es a hozzajuk kapcsolodo datumokat."
  ));

/*  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos(
      "Felség! \n" +
      "Danckán keresztül igen bizonytalan a levelek járása, ezért csak késedelmesen\n" +
      "tudtam teljesíteni kötelességemet, hogy Felségednek apróra elmondjam hazám\n" +
      "ügyeit. Most azonban, a konstantinápolyi cím birtokában semmit sem késve máris\n" +
      "alázatosan tudósítom Felségedet, mi jó és rossz történt, amióta előző leveleim\n" +
      "elmondták, mily sikerekre vezetett szabadságát féltő népem első tüze, amit nyilván\n" +
      "mutatott Schlick tábornok veresége. Ezen aktus után azonban a hadak, nem találván\n" +
      "több ellenséget, s azt vélvén, hogy egész Magyarország meghódításával biztonságba \n" +
      "jutottak, a maguk dolgával kezdtek törődni és az ellenségtől ejtett prédával\n" +
      "visszavonultak. Mindent megkísértettem, Felség, ami tőlem tellett, hogy a szerte\n" +
      "kóborló hadakat összegyűjtsem, mégis mivel a nagyon kemény szigorúságnak kárá\n" +
      "vallhattam volna oly hadi nép közt, amelyet mind a szabadság túlzottan tágas \n" +
      "felfogása, mind személyem igen nagy kedvelése lelkesít, a fenyegetéseket ígéretekkel\n" +
      "és kedvükben járással váltogattam, nehogy bármit is elmulasszak, amivel hazámnak \n" +
      "és Felségednek ügyét előbbre vihetem.” ( II. Rákóczi Ferenc XIV. Lajoshoz írott levele;\n" +
      "1704"
  ));*/


  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos(
      "A feladat a ket vilaghaboru kozotti Magyarorszaggal kapcsolatos. (k, rovid)\n" +
          "Mutassa be a forras es ismeretei felhasznalasaval a magyar kulpolitika mozgasterenek valtozasat az 1930as evekben!\n\n" +
          "Az 1927ben Olaszorszaggal mint gyoztes europai hatalommal kotott baratsagi szerzodes jelentette az elso lepest az elszigeteltsegunkbol valo kiszabadulas fele. A harmincas evek elejen jott azutan letre az ugynevezett romai jegyzokonyv, amelyet Ausztria, Olaszorszag es Magyarorszag irt ala, hogy megvedje Ausztriat a nemet bekebelezes veszelyetol. Ettol fogva Olaszorszag elsorangu tenyezoje volt a magyar kulpolitikanak. A romai jegyzokonyv jelentosege kesobb, 1934ben mutatkozott meg, amikor Mussolini megakadalyozta, hogy a nemetek elfoglaljak Ausztriat.\n" +
          "1935ben Anglia, anelkul hogy partnereivel konzultalt volna, flottaegyezmenyt kotott Nemetorszaggal, amivel az elso rest is utotte a versaillesi beke falan. S utana az olaszabesszin haboru, amely miatt a Nepszovetseg szankciokat hozott Olaszorszag ellen, egyenest a nemetek karjaba taszitotta Mussolinit. es 1936 oktobereben meg is szuletett a Berlin Roma tengely. Mindezek kovetkezteben az osztrak magyar olasz szovetseg ertelmet vesztette, kulonosen azutan, hogy 1938 marciusaban Hitler bevonult Becsbe."
  ));

  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos(
      "Mutassa be a Balassi Balint Az o szerelmenek orok es maradando voltarol cimu verseben megjeleno szerelem termeszetet! Terjen ki arra is, hogyan ervenyesul a versszovegben a reneszansz szemelyiseg ertekrendje!"
  ));

  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos(
      "Milyen felfedezeseket tett Albert Einstein? Ird le roviden a kutatasait. Mely tudomanyos teruleteken alkotott kiemelkedot?"
  ));

  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos(
      "Fejtse ki roviden, hogy Jozsef Attilaval milyen kapcsolatban alltak az alabb felsorolt szemelyisegek!\n\n" +
          "a) Horger Antal\n" +
          "b) Gyomroi Edit\n" +
          "c) Hatvany Lajos\n" +
          "d) Babits Mihaly\n" +
          "e) Juhasz Gyula\n" +
          "f) Vago Marta\n" +
          "g) Kosztolanyi Dezso\n" +
          "h) Illyes Gyula\n" +
          "i) Monus Illes"
  ));
}

final String s_AppTitle = "Sz\u00E1monk\u00E9r\u00E9si alkalmaz\u00E1s";
CameraFunctions cam;
PdfHandler m_PdfHandler = PdfHandler(globals.s_RiportPdf);

void main() {
  PopulateFeladatLista();
  cam = CameraFunctions();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	cam.initState();
	cam.run();
    return Scaffold(
      appBar: AppBar(title: Text(s_AppTitle)),
      body: Center(
        child: RaisedButton(
          child: Text("Teszt ind\u00EDt\u00E1sa"),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SOF(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SOF extends StatefulWidget {
  @override
  _SOFState createState() => _SOFState();
}

class _SOFState extends State<SOF> {
  var cards = <Card>[];
  var megoldasTextController = TextEditingController();
  var feladatTextController = TextEditingController();

  int _charCount = 0;
  bool _isFirstChange = true;
  Timer _charLogTimer;

  Card createCard() {
    feladatTextController.text = globals.feladatmegoldasLista[globals.feladatSorszam].feladat;
    megoldasTextController.text = globals.feladatmegoldasLista[globals.feladatSorszam].megoldas;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
/*          Container(
            margin: EdgeInsets.all(12), //a képernyő széleitől 12 pixellel béjebb kezdődik a textfield minden irányban
            height: 1 * 24.0, //hány sor hosszú legyen * 24
            child: Text(
              "${globals.feladatSorszam+1}"+"."+ "Feladat",
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),*/
          Container(
            margin: EdgeInsets.all(12), //a képernyő széleitől 12 pixellel béjebb kezdődik a textfield minden irányban
            height: 10 * 24.0, //hány sor hosszú legyen * 24
            child: TextField(
              maxLines: 10,
              //enabled: false,
              textAlign: TextAlign.justify,
              readOnly: true,
              controller: feladatTextController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12), //a képernyő széleitől 12 pixellel béjebb kezdődik a textfield minden irányban
            height: 10 * 24.0, //hány sor hosszú legyen * 24
            child: TextField(
              maxLines: 10,
              controller: megoldasTextController,
			        onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: "\u00CDrd ide a megoldást",
                fillColor: Colors.grey[300],
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(globals.feladatSorszam < globals.feladatmegoldasLista.length) {
      cards.add(createCard());
    }
  }
  
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/characterCount.txt');
  }

  Future<File> writeCountersFile() async {
    final file = await _localFile;
    String appendedCounters = "";
    for (int i = 0; i < globals.feladatmegoldasLista.length; i++) {
      for (int j = 0; j < globals.feladatmegoldasLista[i].charCounter.length; j++) {
        appendedCounters += "feladat_$i," + globals.feladatmegoldasLista[i].charCounter[j].toString() + "\n";
      }
    }
    print("Writing character counter stats to file...");
    print(appendedCounters);
    return file.writeAsString(appendedCounters);
  }

  void startTimer() {
    _charLogTimer = Timer.periodic(new Duration(seconds: 10), (time) {
      int exerciseNum = (globals.feladatSorszam == globals.feladatmegoldasLista.length) ? globals.feladatSorszam - 1 : globals.feladatSorszam;
      globals.feladatmegoldasLista[exerciseNum].charCounter.add(globals.CharacterCounter(DateTime.now(), _charCount));
    });
  }

  void stopTimer() {
    if (_charLogTimer != null) {
      int exerciseNum = (globals.feladatSorszam == globals.feladatmegoldasLista.length) ? globals.feladatSorszam - 1 : globals.feladatSorszam;
      globals.feladatmegoldasLista[exerciseNum].charCounter.add(globals.CharacterCounter(DateTime.now(), _charCount));
      _charLogTimer.cancel();
    }
  }

  _onChanged(String value) {
    if (_isFirstChange) {
      startTimer();
      _isFirstChange = false;
    }
    setState(() {
      _charCount = value.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(globals.feladatSorszam == 0) {
      return Scaffold(
        appBar: AppBar(title: Text("${globals.feladatSorszam+1}"+"."+ "Feladat")),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cards[index];
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text('K\u00F6vetkez\u0151'),
                  onPressed: () async {
                    stopTimer();
                    if (globals.feladatSorszam <
                        globals.feladatmegoldasLista.length) {
                      globals.feladatmegoldasLista[globals.feladatSorszam]
                          .megoldas = megoldasTextController.text;
                      globals.feladatSorszam++;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SOF(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
      );
    } else if(globals.feladatSorszam < globals.feladatmegoldasLista.length) {
      return Scaffold(
        appBar: AppBar(title: Text("${globals.feladatSorszam+1}"+"."+ "Feladat")),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return cards[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                child: Text('K\u00F6vetkez\u0151'),
                onPressed: () async {
                  stopTimer();
                  if (globals.feladatSorszam < globals.feladatmegoldasLista.length) {
                    globals.feladatmegoldasLista[globals.feladatSorszam]
                        .megoldas = megoldasTextController.text;
                    globals.feladatSorszam++;
                  }

                   // if(globals.feladatSorszam < globals.feladatmegoldasLista.length-1) {
                   //   globals.feladatSorszam++;
                   // }

                    if (globals.feladatSorszam ==
                    globals.feladatmegoldasLista.length) {
                      await cam.stop();
                      m_PdfHandler.AddFeladatPage();
                      await m_PdfHandler.AddMetrikaPage();
                      await m_PdfHandler.AddImagesPage();
                    }

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SOF(),
                      ),
                    );
                  //}
                },
              ),
            ),
            RaisedButton(
                child: Text("El\u0151z\u0151"),
                onPressed: () {
                  if (globals.feladatSorszam > 0) {
                    stopTimer();
                    globals.feladatSorszam--;
                    Navigator.pop(context);
                  }
                }
            ),
          ],
        ),
      );
    } else if(!globals.beadva){
      return Scaffold(
        appBar: AppBar(title: Text(s_AppTitle)),
        body: Center (
           child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
               RaisedButton(
                  child: Text('Be\u00E1das'),
                  onPressed: () async {
                    globals.beadva = true;

                    await writeCountersFile();

/*                    await cam.stop();
                    m_PdfHandler.AddFeladatPage();
                    await m_PdfHandler.AddMetrikaPage();
                    await m_PdfHandler.AddImagesPage();
*/
                    await m_PdfHandler.SavePdf();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SOF(),
                      ),
                    );
                  }
                ),
                RaisedButton(
                  child: Text("Vissza"),
                  onPressed: () {
                    if (globals.feladatSorszam > 0) {
                      globals.feladatSorszam--;
                      Navigator.pop(context);
                    }
                  }
                ),
              ]
            ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(s_AppTitle)),
        body: Center (
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text('Megtekint\u00E9s'),
                    onPressed: () async {
                      m_PdfHandler.OpenPdf();
                    }
                ),
                RaisedButton(
                    child: Text('Kil\u00E9p\u00E9s'),
                    onPressed: () async {
                      exit(0);
                    }
                )
              ]
          ),
        ),
      );
    }
  }
}
