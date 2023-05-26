import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';

class SahkanProject extends StatefulWidget {
  const SahkanProject({super.key, required this.splebUser});
  static const routeName = '/sahkan-project';
  final SplebUser splebUser;
  @override
  State<SahkanProject> createState() => _SahkanProjectState();
}

class _SahkanProjectState extends State<SahkanProject> {
  @override
  Widget build(BuildContext context) {
    var projectController = context.watch<ProjectController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Urus Projek'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: StreamBuilder<List<Projek>>(
              stream: projectController.readBelumDisahkan(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var projeks = snapshot.requireData;

                  if (projeks.isEmpty) {
                    return const Expanded(child: Text('Tiada projek untuk disahkan'));
                  }
                  return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: projeks.length,
                      itemBuilder: (c, i) {
                        var projek = projeks[i];
                        return ListTile(
                          // tileColor: Colors.grey.shade400,
                          style: ListTileStyle.drawer,
                          title: Text(projek.nama),
                          trailing: TextButton(
                              onPressed: () {
                                DialogHelper.dialogWithAction(
                                    context, 'Pemberitahuan', 'Adakah anda pasti untuk sahkan projek ${projek.nama}',
                                    onPressed: () async {
                                  projek.statusProjek = 'Disahkan';
                                  await projectController.update(projek);
                                });
                              },
                              // style: TextButton.styleFrom(foregroundColor: Colors.white),
                              child: const Text('Sahkan')),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error ${snapshot.error}'));
                } else {
                  return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                }
              }),
        ));
  }
}
