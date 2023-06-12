import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/project/log/generate_pdf_controller.dart';

class GeneratePdfController {
  static Future<File> generateLogOSHE(String headerTitle, BukuLogOSHE bukuLogOSHE, Projek projek) async {
    final pdf = Document();
    var image = (await rootBundle.load('assets/images/ic_launcher_spleb.png')).buffer.asUint8List();
    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          _buildCustomHeader('OSHE DETAILS : $headerTitle', image),
          _buildLine(),
          _buildInfoProjekOSHE(projek, bukuLogOSHE),
          _buildLocation(projek.lokasiProjek),
          _buildSenaraiSemakOSHE(bukuLogOSHE),
          _buildPerakuan(),
          _buildKelulusanOSHE(bukuLogOSHE)
        ],
        footer: (context) {
          final text = '${context.pagesCount}';

          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: const TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );
    return PdfController.saveDocument(name: '${bukuLogOSHE.id} - ${projek.nama}', pdf: pdf);
  }

  static Future<File> generateLogQuality(String headerTitle, BukuLogQuality bukuLogQuality, Projek projek) async {
    final pdf = Document();
    var image = (await rootBundle.load('assets/images/ic_launcher_spleb.png')).buffer.asUint8List();
    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          _buildCustomHeader('QUALITY DETAILS : $headerTitle', image),
          _buildLine(),
          _buildInfoProjek(projek, bukuLogQuality),
          _buildLocation(projek.lokasiProjek),
          _buildSenaraiSemak(bukuLogQuality),
          _buildPerakuan(),
          _buildKelulusan(bukuLogQuality)
        ],
        footer: (context) {
          final text = '${context.pagesCount}';

          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: const TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );
    return PdfController.saveDocument(name: '${bukuLogQuality.id} - ${projek.nama}', pdf: pdf);
  }

  static Widget _buildInfoProjek(Projek projek, BukuLogQuality bukuLogQuality) => Padding(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Info Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        TableRow(children: [
          // We can use an Expanded widget, and use the flex parameter to specify
          // how wide this particular widget should be. With a flex parameter of
          // 2, the description widget will be 66% of the available width.
          Expanded(
            child: Padding(
              child: Text(
                'No Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          // Again, with a flex parameter of 1, the cost widget will be 33% of the
          // available width.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(projek.noProjek),
            ),
            flex: 2,
          )
        ]),
        TableRow(children: [
          // We can use an Expanded widget, and use the flex parameter to specify
          // how wide this particular widget should be. With a flex parameter of
          // 2, the description widget will be 66% of the available width.
          Expanded(
            child: Padding(
              child: Text(
                'Nama Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          // Again, with a flex parameter of 1, the cost widget will be 33% of the
          // available width.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(projek.nama),
            ),
            flex: 2,
          )
        ]),
        TableRow(children: [
          // We can use an Expanded widget, and use the flex parameter to specify
          // how wide this particular widget should be. With a flex parameter of
          // 2, the description widget will be 66% of the available width.
          Expanded(
            child: Padding(
              child: Text(
                'Jenis Kerja',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          // Again, with a flex parameter of 1, the cost widget will be 33% of the
          // available width.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(projek.statusAktiviti),
            ),
            flex: 2,
          )
        ]),
        TableRow(children: [
          Expanded(
            child: Padding(
              child: Text(
                'Tarikh Pemeriksaan',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(DateHelper.toDateOnly(bukuLogQuality.createdAt)),
            ),
            flex: 2,
          )
        ])
      ]));
  static Widget _buildInfoProjekOSHE(Projek projek, BukuLogOSHE bukuLogOSHE) => Padding(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Info Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        TableRow(children: [
          // We can use an Expanded widget, and use the flex parameter to specify
          // how wide this particular widget should be. With a flex parameter of
          // 2, the description widget will be 66% of the available width.
          Expanded(
            child: Padding(
              child: Text(
                'No Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          // Again, with a flex parameter of 1, the cost widget will be 33% of the
          // available width.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(projek.noProjek),
            ),
            flex: 2,
          )
        ]),
        TableRow(children: [
          // We can use an Expanded widget, and use the flex parameter to specify
          // how wide this particular widget should be. With a flex parameter of
          // 2, the description widget will be 66% of the available width.
          Expanded(
            child: Padding(
              child: Text(
                'Nama Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          // Again, with a flex parameter of 1, the cost widget will be 33% of the
          // available width.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(projek.nama),
            ),
            flex: 2,
          )
        ]),
        TableRow(children: [
          // We can use an Expanded widget, and use the flex parameter to specify
          // how wide this particular widget should be. With a flex parameter of
          // 2, the description widget will be 66% of the available width.
          Expanded(
            child: Padding(
              child: Text(
                'Jenis Kerja',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          // Again, with a flex parameter of 1, the cost widget will be 33% of the
          // available width.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(projek.statusAktiviti),
            ),
            flex: 2,
          )
        ]),
        TableRow(children: [
          Expanded(
            child: Padding(
              child: Text(
                'Tarikh Pemeriksaan',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(DateHelper.toDateOnly(bukuLogOSHE.createdAt)),
            ),
            flex: 2,
          )
        ])
      ]));

  static Widget _buildLocation(LokasiProjek? lokasiProjek) => Container(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Lokasi Projek',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        if (lokasiProjek != null)
          TableRow(children: [
            Expanded(
              child: Padding(
                child: Text(
                  'Latitude',
                  // style: const TextStyle(color: PdfColors.white),
                  textAlign: TextAlign.left,
                ),
                padding: const EdgeInsets.all(4),
              ),
              flex: 1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(lokasiProjek.lat.toString()),
              ),
              flex: 2,
            )
          ]),
        if (lokasiProjek != null)
          TableRow(children: [
            Expanded(
              child: Padding(
                child: Text(
                  'Longitude',
                  // style: const TextStyle(color: PdfColors.white),
                  textAlign: TextAlign.left,
                ),
                padding: const EdgeInsets.all(4),
              ),
              flex: 1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(lokasiProjek.lang.toString()),
              ),
              flex: 2,
            )
          ])
      ]));
  static Widget _buildSenaraiSemak(BukuLogQuality bukuLogQuality) => Container(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Senarai Semak',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        ...bukuLogQuality.checkList.map((e) => TableRow(children: [
              Expanded(
                child: Padding(
                  child: Text(
                    e.title,
                    // style: const TextStyle(color: PdfColors.white),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(4),
                ),
                flex: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(e.answer ?? ''),
                ),
                flex: 2,
              )
            ])),
        // ...bukuLogOSHE.checklistPeralatan.map((e) => TableRow(children: [
        //       Expanded(
        //         child: Padding(
        //           child: Text(
        //             e.title,
        //             // style: const TextStyle(color: PdfColors.white),
        //             textAlign: TextAlign.left,
        //           ),
        //           padding: const EdgeInsets.all(4),
        //         ),
        //         flex: 1,
        //       ),
        //       Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.all(4),
        //           child: Text(e.answer ?? ''),
        //         ),
        //         flex: 2,
        //       )
        //     ]))
      ]));
  static Widget _buildSenaraiSemakOSHE(BukuLogOSHE bukuLogOSHE) => Container(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Senarai Semak',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        ...bukuLogOSHE.checklist.map((e) => TableRow(children: [
              Expanded(
                child: Padding(
                  child: Text(
                    e.title,
                    // style: const TextStyle(color: PdfColors.white),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(4),
                ),
                flex: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(e.answer ?? ''),
                ),
                flex: 2,
              )
            ])),
        ...bukuLogOSHE.checklistPeralatan.map((e) => TableRow(children: [
              Expanded(
                child: Padding(
                  child: Text(
                    e.title,
                    // style: const TextStyle(color: PdfColors.white),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(4),
                ),
                flex: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(e.answer ?? ''),
                ),
                flex: 2,
              )
            ]))
      ]));
  static Widget _buildPerakuan() => Container(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Perakuan SPV',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        TableRow(
          // decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Expanded(
                child: Padding(
                  child: Text(
                    'Berdasarkan semakan dokumen dan pemerhatian fizikal di tapak, saya dengan ini mengesahkan',
                    // style: const TextStyle(color: PdfColors.white),
                    textAlign: TextAlign.left,
                  ),
                  padding: const EdgeInsets.all(30),
                ),
                flex: 2),
            Expanded(
                child: Padding(
                  child: Text(
                    'LULUS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.all(30),
                ),
                flex: 1),
          ],
        ),
      ]));

  static Widget _buildKelulusan(BukuLogQuality bukuLogQuality) => Container(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Kelulusan',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        TableRow(
          // decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  ...bukuLogQuality.approval.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Table(border: TableBorder.all(), children: [
                        TableRow(
                          decoration: const BoxDecoration(color: PdfColors.yellow200),
                          children: [
                            Padding(
                              child: Text(
                                e.title,
                                // style: const TextStyle(color: PdfColors.white),
                                textAlign: TextAlign.left,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                          ],
                        ),
                        TableRow(children: [
                          Expanded(
                            child: Padding(
                              child: Text(
                                'Nama',
                                // style: const TextStyle(color: PdfColors.white),
                                textAlign: TextAlign.left,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(e.name ?? ''),
                            ),
                            flex: 2,
                          )
                        ]),
                        TableRow(children: [
                          Expanded(
                            child: Padding(
                              child: Text(
                                'Tarikh',
                                // style: const TextStyle(color: PdfColors.white),
                                textAlign: TextAlign.left,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(DateHelper.toDateOnly(e.signedAt)),
                            ),
                            flex: 2,
                          )
                        ])
                      ])))
                ]))
          ],
        ),
      ]));
  static Widget _buildKelulusanOSHE(BukuLogOSHE bukuLogOSHE) => Container(
      padding: const EdgeInsets.all(3 * PdfPageFormat.mm),
      child: Table(border: TableBorder.all(), children: [
        TableRow(
          decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
              child: Text(
                'Kelulusan',
                // style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.left,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        TableRow(
          // decoration: const BoxDecoration(color: PdfColors.blue400),
          children: [
            Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  ...bukuLogOSHE.approval.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Table(border: TableBorder.all(), children: [
                        TableRow(
                          decoration: const BoxDecoration(color: PdfColors.yellow200),
                          children: [
                            Padding(
                              child: Text(
                                e.title,
                                // style: const TextStyle(color: PdfColors.white),
                                textAlign: TextAlign.left,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                          ],
                        ),
                        TableRow(children: [
                          Expanded(
                            child: Padding(
                              child: Text(
                                'Nama',
                                // style: const TextStyle(color: PdfColors.white),
                                textAlign: TextAlign.left,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(e.name ?? ''),
                            ),
                            flex: 2,
                          )
                        ]),
                        TableRow(children: [
                          Expanded(
                            child: Padding(
                              child: Text(
                                'Tarikh',
                                // style: const TextStyle(color: PdfColors.white),
                                textAlign: TextAlign.left,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(DateHelper.toDateOnly(e.signedAt)),
                            ),
                            flex: 2,
                          )
                        ])
                      ])))
                ]))
          ],
        ),
      ]));
  static Widget _buildCustomHeader(String headerTitle, Uint8List image) => Container(
        padding: const EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                headerTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PdfColors.black),
              ),
            ),
            SizedBox(width: 18),
            Image(MemoryImage(image), width: 80, height: 80)
          ],
        ),
      );

  static Widget _buildLine() => Container(
      padding: const EdgeInsets.only(bottom: 2 * PdfPageFormat.mm, top: 2 * PdfPageFormat.mm),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: PdfColors.black)),
      ));
}
