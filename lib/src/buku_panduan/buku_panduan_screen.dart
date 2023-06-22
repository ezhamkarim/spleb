import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spleb/src/buku_panduan/secure_storage.dart';

import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncPdf;

class BukuPanduanScreen extends StatefulWidget {
  const BukuPanduanScreen({super.key});
  static const routeName = '/buku-panduan';
  @override
  State<BukuPanduanScreen> createState() => _BukuPanduanScreenState();
}

class _BukuPanduanScreenState extends State<BukuPanduanScreen> {
  final pwController = TextEditingController();

  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                          titleButton: 'BUKU PANDUAN BEKERJA DI RUANG TERKURUNG',
                          onPressed: () async {
                            // OpenFile.open('assets/pdf/panduan.pdf');

                            syncPdf.PdfDocument document = syncPdf.PdfDocument(
                              inputBytes: await _readDocumentDataFromAsset('pdf/panduan.pdf'),
                            );

                            var pw = await SecureStorageService.read('pw');

                            if (pw != null) {
                              var bytes = await _readDocumentData('secured.pdf');

                              if (bytes == null) return;
                              _launchPdf(bytes, 'secured.pdf');
                              return;
                            }
                            _showDialog(document, 'secured.pdf');

                            // Navigator.of(context).pushNamed(PdfApp.routeName, arguments: 'assets/pdf/panduan.pdf');
                          }),
                    ),
                    IconButton(
                        onPressed: () {
                          DialogHelper.dialogWithAction(context, 'Amaran', 'Adakah anda pasti untuk decrypt fail ini?',
                              onPressed: () async {
                            var pw = await SecureStorageService.read('pw');

                            if (pw == null) return;

                            syncPdf.PdfDocument document =
                                syncPdf.PdfDocument(inputBytes: await _readDocumentData('secured.pdf'), password: pw);
                            syncPdf.PdfSecurity security = document.security;
                            security.userPassword = '';

                            SecureStorageService.delete('pw');
                          });
                        },
                        icon: const Icon(Icons.more_vert))
                  ],
                ),
                SizedBoxHelper.sizedboxH16,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                          titleButton: 'BUKU PANDUAN BEKERJA DI ATAS TALIAN',
                          onPressed: () async {
                            //TODO: Guna password dari login

                            // OpenFile.open('assets/pdf/panduan.pdf');

                            syncPdf.PdfDocument document = syncPdf.PdfDocument(
                              inputBytes: await _readDocumentDataFromAsset('pdf/panduan-2.pdf'),
                            );

                            var pw = await SecureStorageService.read('pw-2');

                            if (pw != null) {
                              var bytes = await _readDocumentData('secured-2.pdf');

                              if (bytes == null) return;
                              _launchPdf(bytes, 'secured-2.pdf');
                              return;
                            }
                            _showDialog(document, 'secured-2.pdf');
                            // Navigator.of(context).pushNamed(PdfApp.routeName, arguments: 'assets/pdf/panduan-2.pdf');
                          }),
                    ),
                    IconButton(
                        onPressed: () {
                          DialogHelper.dialogWithAction(context, 'Amaran', 'Adakah anda pasti untuk decrypt fail ini?',
                              onPressed: () async {
                            var pw = await SecureStorageService.read('pw-2');

                            if (pw == null) return;

                            syncPdf.PdfDocument document =
                                syncPdf.PdfDocument(inputBytes: await _readDocumentData('secured-2.pdf'), password: pw);
                            syncPdf.PdfSecurity security = document.security;
                            security.userPassword = '';

                            SecureStorageService.delete('pw-2');
                          });
                        },
                        icon: const Icon(Icons.more_vert))
                  ],
                )
              ]),
            ))));
  }

  void _showDialog(syncPdf.PdfDocument document, String docname) {
    showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Amaran'),
            content: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sila masukkan password'),
                  SizedBoxHelper.sizedboxH32,
                  CustomTextField(
                    controller: pwController,
                    hintText: 'Password',
                    isObscure: true,
                    isEnabled: true,
                    color: CustomColor.primary,
                  )
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: CustomColor.primary, side: const BorderSide(color: CustomColor.primary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    document.security.userPassword = pwController.text;

                    List<int> bytes = await document.save();
                    document.dispose();

                    if (docname == 'secure.pdf') {
                      SecureStorageService.write('pw', pwController.text);
                    } else {
                      SecureStorageService.write('pw-2', pwController.text);
                    }

                    _launchPdf(bytes, docname);
                    pwController.clear();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(elevation: 0, foregroundColor: CustomColor.primary),
                child: const Text('Okay'),
              )
            ],
          );
        });
  }

  Future<List<int>> _readDocumentDataFromAsset(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<List<int>?> _readDocumentData(String name) async {
    Directory? directory = await getExternalStorageDirectory();

    if (directory == null) return null;
    String path = directory.path;
    File file = File('$path/$name');

    return await file.readAsBytes();
  }

  Future<void> _launchPdf(List<int> bytes, String fileName) async {
    Directory? directory = await getExternalStorageDirectory();

    if (directory == null) return;
    String path = directory.path;
    File file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
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
