import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/database/database.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:path/path.dart' as pathFile;

class TambahLampiran extends StatefulWidget {
  const TambahLampiran({super.key, required this.projek});
  static const routeName = '/tambah-lampiran';

  final Projek projek;
  @override
  State<TambahLampiran> createState() => _TambahLampiranState();
}

class _TambahLampiranState extends State<TambahLampiran> {
  late Projek projek;

  @override
  void initState() {
    projek = widget.projek;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var projectController = context.watch<ProjectController>();
    var userController = context.watch<UserController>();
    var fbUser = context.watch<User?>();
    if (fbUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return StreamBuilder<List<SplebUser>>(
        stream: userController.readOne(fbUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.requireData.isEmpty) {
              return SizedBox(
                  height: SizeConfig(context).scaledHeight(),
                  width: SizeConfig(context).scaledWidth(),
                  child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('Sorry there are problems')])));
            }
            // var splebUser = snapshot.requireData.first;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: CustomColor.primary,
                title: const Text('Senarai Lampiran'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();

                        if (result == null) return;

                        File file = File(result.files.single.path!);

                        var task = await StorageService.uploadFile(
                            destination: '${projek.id}/${pathFile.basename(file.path)}', file: file);

                        if (task == null) return;

                        var link = await task.ref.getDownloadURL().catchError((e) {
                          logError('Error get download link : $e');
                          return 'null';
                        });

                        if (link == 'null') return;
                        projek.lampiran.add(Lampiran(
                            id: DateTime.timestamp().toString(), link: link, contentType: pathFile.extension(file.path)));

                        await projectController
                            .update(projek)
                            .then((value) => DialogHelper.dialogWithOutActionWarning(context, 'Berjaya menghantar'))
                            .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              body: SizedBox(
                height: SizeConfig(context).scaledHeight(),
                width: SizeConfig(context).scaledWidth(),
                child: StreamBuilder<List<Projek>>(
                    stream: projectController.readOne(id: widget.projek.id),
                    // stream: issueController.readByProjek(id: widget.projek.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var projeks = snapshot.requireData;

                        if (projeks.isEmpty) {
                          return Center(child: Text('Projek ${widget.projek.nama} tidak dijumpai'));
                        }
                        var lampirans = projeks.first.lampiran;

                        if (lampirans.isEmpty) {
                          return const Center(child: Text('Tiada lampiran'));
                        }
                        return SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: lampirans.length,
                                itemBuilder: (c, i) {
                                  var lampir = lampirans[i];
                                  var no = i + 1;
                                  return Container(
                                    margin: const EdgeInsets.all(8),
                                    color: Colors.grey.shade400,
                                    child: ListTile(
                                      onTap: () {},
                                      leading: Text('$no'),
                                      title: Text(lampir.id),
                                    ),
                                  );
                                })
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      } else {
                        return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                      }
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          } else {
            return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
          }
        });
  }
}
