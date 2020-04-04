import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart'; //it has similar properties as widgets.dart (pw)
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfHandler {
  final String s_MainHeader = "Írásbeli számonkérés";
  final String s_Feladat = "Feladat";
  final String s_Leiras = "Leiras";
  final String s_Megoldas = "Megoldas";
  final String s_Kepek = "Kepek";
  final String s_Metrika = "Metrika";
  final String s_ImagesFolder = "images";

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

  void AddImagesPage() async {
    String _tempDocDirNewFolderPath;

    //create new folder if not existed
    final Directory _tempDocDir = await getTemporaryDirectory();
    final Directory _tempDocDirFolder = Directory("${_tempDocDir.path}/$s_ImagesFolder/");
    if(await _tempDocDirFolder.exists()) {
      _tempDocDirNewFolderPath = _tempDocDirFolder.path;
    }
    else {
    final Directory _tempDocDirNewFolder = await _tempDocDirFolder
        .create(recursive: true);
      _tempDocDirNewFolderPath = _tempDocDirNewFolder.path;
    }

    //Directory(_tempDocDirNewFolderPath).deleteSync(recursive: true);

    var file = Directory(_tempDocDirNewFolderPath).listSync();
    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    int i = 0;
    for(i = 0; i < file.length; i++) {
      print(file[i].toString());
    }

    var pdfImages = <pw.Image>[];
    pw.Page page = pw.Page();
    pw.Document document = pw.Document();

    for(i = 0; i < file.length; i++) {
      print("full path:"+'${_tempDocDirNewFolderPath}${file[i].toString()}');
      print("file path:" + file[i].path);
      final image = PdfImage(m_PdfDoc.document, image: File('${file[i].path}').readAsBytesSync(), width: 10, height: 10);
      final img = PdfImage.file(m_PdfDoc.document, bytes: File('${file[i].path}').readAsBytesSync());
      m_PdfDoc.addPage(
        pw.Page(
          build: (pw.Context context) {

            return pw.Center(
            child: pw.Image(image),
            ); // Center
      })); // Page
    }
  }

  void SavePdf() async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${m_FileName}");
    print("${output.path}/${m_FileName}");
    // final File file = File('example.pdf');
    file.writeAsBytesSync(m_PdfDoc.save());
  }

  void RemovePdf() async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${m_FileName}");
    print("${output.path}/${m_FileName}");
    // final File file = File('example.pdf');
    file.delete();
  }

  void OpenPdf() async {
    final output = await getTemporaryDirectory();
    OpenFile.open('${output.path}/${m_FileName}', type: "application/pdf", uti:  "com.adobe.pdf");
    print('opened');
    print('${output.path}/${m_FileName}');
  }

  PdfPageFormat GetPageFormat() {
    return PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm);
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

class ChoiceCard extends pw.Widget {
  ChoiceCard(this.image);

  final pw.Image image;
/*
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Icon(choice.icon, size:80.0, color: textStyle.color,)),
            new Expanded(
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child:
                  Text(choice.title, style: null, textAlign: TextAlign.left, maxLines: 5,),
                )
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        )
    );
  }*/

  @override
  void layout(pw.Context context, pw.BoxConstraints constraints, {bool parentUsesSize = false}) {
    // TODO: implement layout
  }
}