import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';

class TambahLampiran extends StatefulWidget {
  const TambahLampiran({super.key, required this.projek});
  static const routeName = '/tambah-lampiran';

  final Projek projek;
  @override
  State<TambahLampiran> createState() => _TambahLampiranState();
}

class _TambahLampiranState extends State<TambahLampiran> {
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
            var splebUser = snapshot.requireData.first;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: CustomColor.primary,
                title: const Text('Senarai Isu'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed(DaftarIssue.routeName, arguments: widget.projek);
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              body: SizedBox(
                height: SizeConfig(context).scaledHeight(),
                width: SizeConfig(context).scaledWidth(),
                child: StreamBuilder<List<Projek>>(
                    stream: projectController.read(),
                    // stream: issueController.readByProjek(id: widget.projek.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var issues = snapshot.requireData;
                        return SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: issues.length,
                                itemBuilder: (c, i) {
                                  var isu = issues[i];
                                  var no = i + 1;
                                  return Container(
                                    margin: const EdgeInsets.all(8),
                                    color: Colors.grey.shade400,
                                    child: ListTile(
                                      onTap: () {},
                                      leading: Text('$no'),
                                      title: Text(isu.nama),
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
