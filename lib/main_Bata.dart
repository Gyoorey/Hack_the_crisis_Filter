import 'dart:io';
import 'package:flutter/material.dart'; //it has similar properties as widgets.dart (pw)
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(title: "Számonkérési alkalmazás"),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text(title)),
      body: Center(
        child: RaisedButton(
          child: Text("Teszt indítása"),
          onPressed: () async {
            List<PersonEntry> persons = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SOF(),
              ),
            );
            if (persons != null) persons.forEach(print);
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
  var nameTECs = <TextEditingController>[];
  var ageTECs = <TextEditingController>[];
  var jobTECs = <TextEditingController>[];
  var cards = <Card>[];

  final TextEditingController megoldas1TextController = TextEditingController();

  PdfHandler m_PdfHandler = PdfHandler("reportPdf.pdf");

  String get feladat1 => "Ez egy feladat. Ez egy feladat. Ez egy nagyon hosszu feladat. Ez egy feladat. Ez egy feladat. Ez egy nagyon hosszu feladat. ";

  TextField get textMultiLine => TextField(
    textInputAction: TextInputAction.newline,
    keyboardType: TextInputType.multiline,
    maxLines: null,

  );

  Card createCard() {
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();
    nameTECs.add(nameController);
    ageTECs.add(ageController);
    jobTECs.add(jobController);
    return Card(
      child: Column(

        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Person ${cards.length + 1}'),
          TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Full Name')),
          TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age')),
          TextField(
              controller: jobController,
              decoration: InputDecoration(labelText: 'Study/ job')),
          Container(
            margin: EdgeInsets.all(12), //a képernyő széleitől 12 pixellel béjebb kezdődik a textfield minden irányban
            height: 3 * 24.0, //hány sor hosszú legyen * 24
            child: Text(
              feladat1,
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
              controller: megoldas1TextController,
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
    cards.add(createCard());
  }

  _onDone() {
    List<PersonEntry> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = nameTECs[i].text;
      var age = ageTECs[i].text;
      var job = jobTECs[i].text;
      entries.add(PersonEntry(name, age, job));
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              child: Text('Előre'),
              onPressed: () async {
                List<PersonEntry> persons = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SOF(),
                  ),
                );
                if (persons != null) persons.forEach(print);
              },
            ),
          ),
          RaisedButton(
              child: Text("Vissza"),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          RaisedButton(
            child: Text("AddPdfPage"),
            onPressed: () {
              m_PdfHandler.AddFeladatPage();
            },
          ),
          RaisedButton(
            child: Text("AddImagePage"),
            onPressed: () {
              m_PdfHandler.AddImagePage();
            },
          ),
          RaisedButton(
            child: Text("SavePdf"),
            onPressed: () {
              m_PdfHandler.SavePdf();
            },
          ),
          RaisedButton(
            child: Text("OpenPdf"),
            onPressed: () {
              m_PdfHandler.OpenPdf();
            },
          ),

        ],
      ),
      floatingActionButton:
      FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}

class PersonEntry {
  final String name;
  final String age;
  final String studyJob;

  PersonEntry(this.name, this.age, this.studyJob);
  @override
  String toString() {
    return 'Person: name= $name, age= $age, study job= $studyJob';
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
    feladatCount++;
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
          pw.Header(level: 1, text: "${feladatCount}. ${s_Feladat}"),
          pw.Header(level: 2, text: s_Leiras),
          pw.Paragraph(
              text: "feladat"
          ),
          pw.Header(level: 2, text: s_Megoldas),
          pw.Paragraph(
              text: "megoldas"
          ),
        ]));
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