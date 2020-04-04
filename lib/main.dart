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
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos("Milyen volt a hódok helyzete a két világháború között?"));
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos("Miért kék az ég, ha a nap nem is kék?"));
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos("Ha ketten felszálnak a buszra és négyen leszállnak róla, akkor mennyien vannak a buszon?"));
}

final String s_AppTitle = "Számonkérési alkalmazás";
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
          child: Text("Teszt indítása"),
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
  int _charCount = 0;
  bool _isFirstChange = true;
  Timer _charLogTimer;

  Card createCard() {
    megoldasTextController.text = globals.feladatmegoldasLista[globals.feladatSorszam].megoldas;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12), //a képernyő széleitől 12 pixellel béjebb kezdődik a textfield minden irányban
            height: 3 * 24.0, //hány sor hosszú legyen * 24
            child: Text(
              globals.feladatmegoldasLista[globals.feladatSorszam].feladat,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
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
                hintText: "Írd ide a megoldást",
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

  Future<File> writeCounter() async {
    final file = await _localFile;
    String appendedCounters = "";
    for (int i = 0; i < globals.feladatmegoldasLista.length; i++) {
      for (int j = 0; j < globals.feladatmegoldasLista[i].charCounter.length; j++) {
        appendedCounters += globals.feladatmegoldasLista[i].charCounter[j];
      }
    }
    return file.writeAsString(appendedCounters);
  }

  void startTimer() {
    _charLogTimer = Timer.periodic(new Duration(seconds: 10), (time) {
      int exerciseNum = (globals.feladatSorszam == globals.feladatmegoldasLista.length) ? globals.feladatSorszam - 1 : globals.feladatSorszam;
      globals.feladatmegoldasLista[exerciseNum].charCounter.add('${DateTime.now()},feladat_$exerciseNum,$_charCount\n');
    });
  }

  void stopTimer() {
    if (_charLogTimer != null) {
      int exerciseNum = (globals.feladatSorszam == globals.feladatmegoldasLista.length) ? globals.feladatSorszam - 1 : globals.feladatSorszam;
      globals.feladatmegoldasLista[exerciseNum].charCounter.add('${DateTime.now()},feladat_$exerciseNum,$_charCount\n');
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
        appBar: AppBar(title: Text(s_AppTitle)),
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
                  child: Text('Következő'),
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
        appBar: AppBar(title: Text(s_AppTitle)),
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
                child: Text('Következő'),
                onPressed: () async {
                  stopTimer();
                  if (globals.feladatSorszam <
                      globals.feladatmegoldasLista.length) {
                    globals.feladatmegoldasLista[globals.feladatSorszam]
                        .megoldas = megoldasTextController.text;
                    globals.feladatSorszam++;


                    if (globals.feladatSorszam >=
                    globals.feladatmegoldasLista.length) {
                      await cam.stop();
                      m_PdfHandler.AddFeladatPage();
                      await m_PdfHandler.AddMetrikaPage();
                      await m_PdfHandler.AddImagesPage();
                      await writeCounter();
                    }

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
            RaisedButton(
                child: Text("Előző"),
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
                  child: Text('Beadas'),
                  onPressed: () async {
                    globals.beadva = true;
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
                    child: Text('Megtekintes'),
                    onPressed: () async {
                      m_PdfHandler.OpenPdf();
                    }
                ),
                RaisedButton(
                    child: Text('Kilepes'),
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
