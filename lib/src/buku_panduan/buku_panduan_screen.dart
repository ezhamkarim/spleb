import 'package:flutter/material.dart';

import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class BukuPanduanScreen extends StatefulWidget {
  const BukuPanduanScreen({super.key});
  static const routeName = '/buku-panduan';
  @override
  State<BukuPanduanScreen> createState() => _BukuPanduanScreenState();
}

class _BukuPanduanScreenState extends State<BukuPanduanScreen> {
  @override
  Widget build(BuildContext context) {
    // var projectController = context.watch<ProjectController>();
    //TODO: Tambah buku panduan
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Buku Panduan'),
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                CustomButton(
                    titleButton: 'BUKU PANDUAN BEKERJA DI RUANG TERKURUNG',
                    onPressed: () async {
                      // OpenFile.open('assets/pdf/panduan.pdf');
                      Navigator.of(context).pushNamed(PdfApp.routeName, arguments: 'assets/pdf/panduan.pdf');
                    }),
                SizedBoxHelper.sizedboxH16,
                CustomButton(
                    titleButton: 'BUKU PANDUAN BEKERJA DI ATAS TALIAN',
                    onPressed: () async {
                      // OpenFile.open('assets/pdf/panduan.pdf');
                      Navigator.of(context).pushNamed(PdfApp.routeName, arguments: 'assets/pdf/panduan-2.pdf');
                    })
              ]),
            ))));
  }
}

class PdfApp extends StatefulWidget {
  static const routeName = '/pdf-viewer';
  const PdfApp({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  State<PdfApp> createState() => _PdfAppState();
}

class _PdfAppState extends State<PdfApp> {
  late PdfController pdfController;

  Widget pdfView() => PdfView(
        controller: pdfController,
      );

  @override
  void initState() {
    super.initState();

    pdfController = PdfController(
      document: PdfDocument.openAsset(widget.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pdfView();
  }
}
