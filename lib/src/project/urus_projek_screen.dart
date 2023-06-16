import 'package:flutter/material.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class UrusProjek extends StatefulWidget {
  const UrusProjek({super.key, required this.splebUser});
  static const routeName = '/urus-projek';

  final SplebUser splebUser;
  @override
  State<UrusProjek> createState() => _UrusProjekState();
}

class _UrusProjekState extends State<UrusProjek> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Urus Projek'),
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (widget.splebUser.role.name == 'Pegawai')
                  CustomButton(
                      titleButton: 'Daftar Pengguna',
                      onPressed: () async {
                        // OpenFile.open('assets/pdf/panduan.pdf');
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      }),
                if (widget.splebUser.role.name == 'Pegawai') SizedBoxHelper.sizedboxH16,
                if (widget.splebUser.role.name == 'Pegawai')
                  CustomButton(
                      titleButton: 'Daftar Projek',
                      onPressed: () async {
                        // OpenFile.open('assets/pdf/panduan.pdf');
                        Navigator.of(context).pushNamed(DaftarProjek.routeName);
                      }),
                if (widget.splebUser.role.name == 'Pegawai') SizedBoxHelper.sizedboxH16,
                if (widget.splebUser.role.name == 'Pengurus Projek')
                  CustomButton(
                      titleButton: 'Sahkan Projek',
                      onPressed: () async {
                        // OpenFile.open('assets/pdf/panduan.pdf');
                        Navigator.of(context).pushNamed(SahkanProject.routeName, arguments: widget.splebUser);
                      }),
              ]),
            ))));
  }
}
