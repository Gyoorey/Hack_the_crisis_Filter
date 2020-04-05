import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart'; //it has similar properties as widgets.dart (pw)
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;

class PdfHandler {
  final String s_MainHeader = "Írásbeli számonkérés";
  final String s_Feladat = "Feladat";
  final String s_Leiras = "Leiras";
  final String s_Megoldas = "Megoldas";
  final String s_Kepek = "Kepek";
  final String s_Metrika = "Metrikak";

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
              textAlign: pw.TextAlign.left
            ),
            pw.Header(level: 2, text: s_Megoldas),
            pw.Paragraph(
              text: globals.feladatmegoldasLista[i].megoldas,
                textAlign: pw.TextAlign.left
            ),
          ]
      )
      );
    }
  }

  Future<void> AddImagesPage() async {
    String _imgDocDirNewFolderPath;

    //create new folder if not existed
    final Directory _externalDocDir = await getExternalStorageDirectory();
    final Directory _imgDocDirFolder = Directory("${_externalDocDir.path}/${globals.s_ImagesFolder}/");
    _imgDocDirNewFolderPath = _imgDocDirFolder.path;
    /*if(await _imgDocDirFolder.exists()) {
      _imgDocDirNewFolderPath = _imgDocDirFolder.path;
    }
    else {
      final Directory _imgDocDirNewFolder = await _imgDocDirFolder
          .create(recursive: true);
      _imgDocDirNewFolderPath = _imgDocDirNewFolder.path;
    }*/

    var file = Directory(_imgDocDirNewFolderPath).listSync();
    int i = 0;
    for(i = 0; i < file.length; i++) {
      print(file[i].toString());
    }

    var pdfImages = <pw.Image>[];
    pw.Page page = pw.Page();
    pw.Document document = pw.Document();

    for(i = 0; i < file.length; i++) {
      print("full path:"+'${_imgDocDirNewFolderPath}${file[i].toString()}');
      print("file path:" + file[i].path);
      var bytes_image = await File('${file[i].path}').readAsBytes();
      var image = PdfImage.file(m_PdfDoc.document, bytes: bytes_image);

      pdfImages.add(pw.Image(image));
      m_PdfDoc.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            ); // Center
          }
        )
      ); // Page
    }

    //Directory(_tempDocDirNewFolderPath).deleteSync(recursive: true);
  }

  Future<void> AddMetrikaPage()
  {
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
                    pw.Text(s_Metrika, textScaleFactor: 2)
                  ])),
          pw.Table.fromTextArray(context: context, data: const <List<String>>[
            <String>['Kattintas szam metrika', 'Feladat befejezesenek idopontja', 'Kattintas szam'],
            <String>['1. feladat', '2020-04-05 10:01:00.249', '10'],
            <String>['2. feladat', '2020-04-05 10:05:01.357', '153'],
            <String>['3. feladat', '2020-04-05 10:06:09.436', '52'],
            <String>['4. feladat', '2020-04-05 10:10:34.676', '134'],
            <String>['5. feladat', '2020-04-05 10:14:20.235', '95'],
          ]),
          //pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ]));
  }

  Future<void> SavePdf() async {
    final output = await getExternalStorageDirectory();
    final file = File("${output.path}/${m_FileName}");
    print("${output.path}/${m_FileName}");
    file.writeAsBytesSync(m_PdfDoc.save());
  }

  Future<void> OpenPdf() async {
    final output = await getExternalStorageDirectory();
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