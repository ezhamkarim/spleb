import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class BukuPanduanScreen extends StatefulWidget {
  const BukuPanduanScreen({super.key});
  static const routeName = '/buku-panduan';
  @override
  State<BukuPanduanScreen> createState() => _BukuPanduanScreenState();
}

class _BukuPanduanScreenState extends State<BukuPanduanScreen> {
  @override
  Widget build(BuildContext context) {
    var projectController = context.watch<ProjectController>();
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
                    titleButton: 'Buku Panduan',
                    onPressed: () async {
                      OpenFile.open('assets/pdf/panduan.pdf');
                    })
              ]),
            ))));
  }
}
