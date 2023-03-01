import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class ProjectScreenArg {
  final String id;
  final String userRole;

  ProjectScreenArg(this.id, this.userRole);
}

class ProjectScreenViewOnly extends StatefulWidget {
  const ProjectScreenViewOnly({super.key, required this.projectId, required this.userRole});
  final String projectId;
  final String userRole;
  static const routeName = '/project';
  @override
  State<ProjectScreenViewOnly> createState() => _ProjectScreenViewOnlyState();
}

class _ProjectScreenViewOnlyState extends State<ProjectScreenViewOnly> {
  @override
  Widget build(BuildContext context) {
    var projectController = context.watch<ProjectController>();
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
                                if (widget.userRole == 'Pengurus Projek') SizedBoxHelper.sizedboxH16,
                                if (widget.userRole == 'Pengurus Projek')
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
                                if (widget.userRole == 'Penyelia') SizedBoxHelper.sizedboxH16,
                                if (widget.userRole == 'Penyelia') CustomButton(titleButton: 'Tambah Buku Log', onPressed: () {}),
                                if (widget.userRole == 'Pengurus Projek') SizedBoxHelper.sizedboxH16,
                                if (widget.userRole == 'Pengurus Projek')
                                  CustomButton(titleButton: 'Lihat Buku Log', onPressed: () {}),
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
