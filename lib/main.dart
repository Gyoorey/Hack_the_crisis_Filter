import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart'; //it has similar properties as widgets.dart (pw)
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;
import 'package:startupnamer/camera_functions.dart';

void PopulateFeladatLista()
{
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos("Milyen volt a hódok helyzete a két világháború között?"));
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos("Miért kék az ég, ha a nap nem is kék?"));
  globals.feladatmegoldasLista.add(globals.FeladatMegoldasParos("Ha ketten felszálnak a buszra és négyen leszállnak róla, akkor mennyien vannak a buszon?"));
}

final String s_AppTitle = "Számonkérési alkalmazás";
CameraFunctions cam;

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
  PdfHandler m_PdfHandler = PdfHandler("reportPdf.pdf");
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
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/characterCount.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('${DateTime.now()}:'+'$counter\n', mode: FileMode.append);
  }

  void startTimer() {
    _charLogTimer = Timer.periodic(new Duration(seconds: 10), (time) {
      print("charCount: " + _charCount.toString());
      writeCounter(_charCount);
    });
  }

  void stopTimer() {
    if (_charLogTimer != null) {
      writeCounter(_charCount);
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
                    if (globals.feladatSorszam <
                        globals.feladatmegoldasLista.length) {
                      globals.feladatmegoldasLista[globals.feladatSorszam]
                          .megoldas = megoldasTextController.text;
                      globals.feladatSorszam++;

                      // TODO: @dani extend globals with charCounter
                      stopTimer();

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
                  if (globals.feladatSorszam <
                      globals.feladatmegoldasLista.length) {
                    globals.feladatmegoldasLista[globals.feladatSorszam]
                        .megoldas = megoldasTextController.text;
                    globals.feladatSorszam++;

                    // TODO: @dani extend globals with charCounter
                    stopTimer();

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
                    globals.feladatSorszam--;
                    // TODO: @dani extend globals with charCounter
                    stopTimer();
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
                    await cam.stop();
                    globals.beadva = true;
                    m_PdfHandler.AddFeladatPage();
                    m_PdfHandler.SavePdf();
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
                )
              ]
          ),
        ),
      );
    }
  }
}

class PdfHandler {
  final String s_MainHeader = "Írásbeli számonkérés";
  final String s_Feladat = "Feladat";
  final String s_Leiras = "Leiras";
  final String s_Megoldas = "Megoldas";
  final String s_Kepek = "Kepek";
  final String s_Metrika = "Metrika";

  int feladatCount = 0;

  String m_FileName;
  pw.Document m_PdfDoc;

  PdfHandler(String _fileName) {
    m_FileName = _fileName;
    CreateDoc();
  }

  void CreateDoc() {
    m_PdfDoc = pw.Document();
  }

  void AddFeladatPage() {
    int i = 0;
    for(i = 0; i < globals.feladatmegoldasLista.length; i++) {
      m_PdfDoc.addPage(pw.MultiPage(
          pageFormat: GetPageFormat(),
          crossAxisAlignment: getCrossAxisAlignment(),
          header: (pw.Context context) {
            return GetHeader(context);
          },
          footer: (pw.Context context) {
            return getFooter(context);
          },
          build: (pw.Context context) =>
          <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(s_MainHeader, textScaleFactor: 2)
                    ])),
            pw.Header(level: 1, text: "${i+1}. ${s_Feladat}"),
            pw.Header(level: 2, text: s_Leiras),
            pw.Paragraph(
                text: globals.feladatmegoldasLista[i].feladat,
            ),
            pw.Header(level: 2, text: s_Megoldas),
            pw.Paragraph(
                text: globals.feladatmegoldasLista[i].megoldas,
            ),
          ]
      )
      );
    }
  }

  void AddImagesPage() {
    m_PdfDoc.addPage(pw.MultiPage(
        pageFormat: GetPageFormat(),
        crossAxisAlignment: getCrossAxisAlignment(),
        header: (pw.Context context) {
        return GetHeader(context);
        },
        footer: (pw.Context context) {
        return getFooter(context);
        },
        build: (pw.Context context) =>
        <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text(s_MainHeader, textScaleFactor: 2)
                  ])),
          pw.Header(level: 1, text: s_Kepek),


/*          pw.Table.fromTextArray(context: context, data: const <List<pw.Image>>[
            <pw.Image>[PdfImage.file(m_PdfDoc.document, bytes: File('test.webp').readAsBytesSync())],
          ]),*/
        ]));
  }

  void AddImagePage() async{
   // Image.asset('assets/images/lake.jpg')
   // final image = PdfImage.file(m_PdfDoc.document, bytes: File('assets/images/evosoft-logo.jpg').readAsBytesSync());

//    PdfImage logoImage = await pdfImageFromImageProvider(
//      pdf: m_PdfDoc.document,
//      image: AssetImage('assets/images/evosoft-logo.jpg'),
//    );
//
//    m_PdfDoc.addPage(pw.Page(
//        build: (pw.Context context) {
//          return pw.Center(
//            child: pw.Image(logoImage),
//          ); // Center
//        })); // Page

    var systemTempDir = (await getTemporaryDirectory()).path;
    var file = Directory("$systemTempDir").listSync();
    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    int i = 0;
    for(i = 0; i < file.length; i++)
    {
      if(file[i].statSync() == FileSystemEntityType.file)
      print(file[i].toString());
    }
//
//    final output = await getDownloadsDirectory();
//    print('${output.path}/${m_FileName}');
//    OpenFile.open('${output.path}/${m_FileName}', type: "image/jpeg", uti:  "public.jpeg");
//

  }

  void SavePdf() async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${m_FileName}");
    print("${output.path}/${m_FileName}");
    // final File file = File('example.pdf');
    file.writeAsBytesSync(m_PdfDoc.save());
  }

  void OpenPdf() async {
    final output = await getTemporaryDirectory();
    OpenFile.open('${output.path}/${m_FileName}', type: "application/pdf", uti:  "com.adobe.pdf");
    print('opened');
    print('${output.path}/${m_FileName}');
  }

  PdfPageFormat GetPageFormat() {
    return PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm);
  }

  pw.Container GetHeader(pw.Context context) {
      if (context.pageNumber == 1) {
        return null;
      }
      return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(
              border: pw.BoxBorder(
                  bottom: true, width: 0.5, color: PdfColors.grey)),
          child: pw.Text(s_MainHeader,
              style: pw.Theme
                  .of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey)));
  }

  pw.CrossAxisAlignment getCrossAxisAlignment() {
    return pw.CrossAxisAlignment.start;
  }

  pw.Container getFooter(pw.Context context) {
    return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.Theme
                .of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey)));
  }
}