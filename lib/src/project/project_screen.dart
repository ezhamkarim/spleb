import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class ProjectScreenArg {
  final String id;
  final SplebUser currentUser;

  ProjectScreenArg(this.id, this.currentUser);
}

class ProjectScreenViewOnly extends StatefulWidget {
  const ProjectScreenViewOnly({super.key, required this.projectId, required this.currentUser});
  final String projectId;
  final SplebUser currentUser;
  static const routeName = '/project';
  @override
  State<ProjectScreenViewOnly> createState() => _ProjectScreenViewOnlyState();
}

class _ProjectScreenViewOnlyState extends State<ProjectScreenViewOnly> {
  String? aktivitiSekarang;
  @override
  Widget build(BuildContext context) {
    var projectController = context.watch<ProjectController>();
    var userController = context.watch<UserController>();
    return StreamBuilder<List<Projek>>(
        stream: projectController.readOne(widget.projectId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var projects = snapshot.requireData;

            if (projects.isEmpty) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: CustomColor.primary,
                    title: const Text('Error'),
                  ),
                  body: SingleChildScrollView(
                      child: SizedBox(
                          height: SizeConfig(context).scaledHeight(),
                          width: SizeConfig(context).scaledWidth(),
                          child: const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: Text('Error, Project Not Found'),
                              )))));
            }

            var projek = projects.first;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: CustomColor.primary,
                  title: Text(projek.nama),
                  actions: [
                    StreamBuilder<List<SplebUser>>(
                        stream: userController.readOnebyName(projek.namaPIC),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var pics = snapshot.requireData;

                            if (pics.isEmpty || pics.length > 2) return const Text('Error');

                            var pic = pics.first;
                            return TextButton(
                                onPressed: () {
                                  logInfo('Projek : ${projek.toMap()}');
                                  Navigator.of(context)
                                      .pushNamed(DaftarProjek.routeName, arguments: DaftarProjekArg(true, projek, pic));
                                },
                                child: const Text('Edit'));
                          } else if (snapshot.hasError) {
                            return Text('Error ${snapshot.error}');
                          } else {
                            return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                          }
                        })
                  ],
                ),
                body: SingleChildScrollView(
                    child: SizedBox(
                        height: SizeConfig(context).scaledHeight(),
                        width: SizeConfig(context).scaledWidth(),
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Chip(
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                visualDensity: VisualDensity.compact,
                                                label: Text(
                                                  projek.statusProjek,
                                                ))
                                          ],
                                        ),
                                        SizedBoxHelper.sizedboxH16,
                                        const Text(
                                          'Lokasi',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBoxHelper.sizedboxH8,
                                        Text(projek.lokasiProjek.isEmpty ? 'Tiada Lokasi' : projek.lokasiProjek),
                                        SizedBoxHelper.sizedboxH16,
                                        const Text(
                                          'PIC (Person In Charge)',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBoxHelper.sizedboxH8,
                                        Text(projek.namaPIC.isEmpty ? 'Tiada PIC' : projek.namaPIC),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Aktiviti Sekarang',
                                        ),
                                      ),
                                      SizedBoxHelper.sizedboxH8,
                                      DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                            validator: (value) {
                                              if (value == null) return 'Sila Pilih Status Aktiviti Sekarang';
                                              return null;
                                            },
                                            hint: const Text(
                                              'Aktiviti Sekarang',
                                            ),
                                            decoration: InputDecoration(
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                                                    borderRadius: const SmoothBorderRadius.all(
                                                        SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                disabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 2),
                                                    borderRadius: SmoothBorderRadius.all(
                                                        SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black, width: 2),
                                                    borderRadius: SmoothBorderRadius.all(
                                                        SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                errorBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                                    borderRadius: SmoothBorderRadius.all(
                                                        SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(color: CustomColor.secondary, width: 2),
                                                    borderRadius: SmoothBorderRadius.all(
                                                        SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6)))),
                                            value: projek.statusAktiviti,
                                            items: projek.aktivitiTerkini
                                                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                                                .toList(),
                                            onChanged: (hehe) {
                                              if (hehe == null) return;
                                              setState(() {
                                                projek.statusAktiviti = hehe;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.currentUser.role.name == 'Pengurus Projek' && projek.statusProjek == 'Belum Disahkan')
                                  SizedBoxHelper.sizedboxH16,
                                if (widget.currentUser.role.name == 'Pengurus Projek' && projek.statusProjek == 'Belum Disahkan')
                                  CustomButton(
                                      titleButton: 'Sahkan',
                                      onPressed: () {
                                        DialogHelper.dialogWithAction(context, 'Amaran', 'Anda pasti untuk sahkan?',
                                            onPressed: () async {
                                          projek.statusProjek = 'Disahkan';
                                          await projectController.update(projek).catchError((e) {
                                            Navigator.of(context).pop();
                                            DialogHelper.dialogWithOutActionWarning(context, e.toString());
                                          });
                                        });
                                      }),
                                if (widget.currentUser.role.name == 'Penyelia') SizedBoxHelper.sizedboxH16,
                                if (widget.currentUser.role.name == 'Penyelia')
                                  CustomButton(
                                      titleButton: 'Rekod Buku Log',
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(BukuLogScreen.routeName,
                                            arguments: BukuLogScreenArg(projek, widget.currentUser, null, null));
                                      }),
                                if (widget.currentUser.role.name == 'Penyelia') SizedBoxHelper.sizedboxH16,
                                if (widget.currentUser.role.name == 'Penyelia')
                                  CustomButton(
                                      titleButton: 'Rekod Buku Log OSHE',
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(BukuLogOSHEScreen.routeName,
                                            arguments: BukuLogScreenArg(projek, widget.currentUser, null, null));
                                      }),
                                if (widget.currentUser.role.name == 'Pengurus Projek') SizedBoxHelper.sizedboxH16,
                                if (widget.currentUser.role.name == 'Pengurus Projek')
                                  CustomButton(
                                      titleButton: 'Lihat Buku Log',
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(BukuLogListScreen.routeName, arguments: BukuLogListArg(false, projek));
                                      }),
                                if (widget.currentUser.role.name == 'Pengurus Projek') SizedBoxHelper.sizedboxH16,
                                if (widget.currentUser.role.name == 'Pengurus Projek')
                                  CustomButton(
                                      titleButton: 'Lihat Buku Log OSHE',
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(BukuLogListScreen.routeName, arguments: BukuLogListArg(true, projek));
                                      }),
                              ],
                            )))));
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: CustomColor.primary,
                  title: const Text('Error'),
                ),
                body: SingleChildScrollView(
                    child: SizedBox(
                        height: SizeConfig(context).scaledHeight(),
                        width: SizeConfig(context).scaledWidth(),
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text('Error ${snapshot.error}'),
                            )))));
          } else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: CustomColor.primary,
                  title: const Text('Loading...'),
                ),
                body: SingleChildScrollView(
                    child: SizedBox(
                        height: SizeConfig(context).scaledHeight(),
                        width: SizeConfig(context).scaledWidth(),
                        child: const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            )))));
          }
        });
  }
}
