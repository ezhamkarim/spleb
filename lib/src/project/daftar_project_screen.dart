import 'package:flutter/material.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/project/project_controller.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class DaftarProjek extends StatefulWidget {
  const DaftarProjek({super.key});

  @override
  State<DaftarProjek> createState() => _DaftarProjekState();
}

class _DaftarProjekState extends State<DaftarProjek> {
  final formKey = GlobalKey<FormState>();
  final namaTextController = TextEditingController();
  final kumpulanTextController = TextEditingController();
  final tarikhMulaTextController = TextEditingController();
  final tarikhAkhirTextController = TextEditingController();

  String? statusProjek;
  String? statusAktiviti;
  SplebUser? namaPIC;
  String? lokasiProjek;

  final projectController = ProjectController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Daftar Role'),
        ),
        body: SingleChildScrollView(
            child: SizedBox(
                height: SizeConfig(context).scaledHeight(),
                width: SizeConfig(context).scaledWidth(),
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                        key: formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          CustomTextField(
                              controller: namaTextController,
                              hintText: 'Nama Projek',
                              isObscure: false,
                              isEnabled: true,
                              color: CustomColor.primary),
                          SizedBoxHelper.sizedboxH16,
                          CustomButton(
                              viewState: projectController.viewState,
                              titleButton: 'Register',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  var project = Projek(
                                      id: '',
                                      nama: namaTextController.text,
                                      statusProjek: statusProjek!,
                                      statusAktiviti: statusAktiviti!,
                                      lokasiProjek: '',
                                      kumpulan: kumpulanTextController.text,
                                      namaPIC: namaPIC!.userName,
                                      tarikhMula: tarikhMulaTextController.text,
                                      tarikhAkhir: tarikhAkhirTextController.text);
                                  await projectController
                                      .create(project)
                                      .then((value) => Navigator.of(context).pop())
                                      .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                }
                              })
                        ]))))));
  }
}
