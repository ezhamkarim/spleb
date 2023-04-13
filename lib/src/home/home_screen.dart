import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    var fbUser = context.watch<User?>();

    if (fbUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
        child: StreamBuilder<List<SplebUser>>(
            stream: userController.readOne(fbUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var splebUser = snapshot.requireData.first;
                return SizedBox(
                  height: SizeConfig(context).scaledHeight(),
                  width: SizeConfig(context).scaledWidth(),
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Text(
                          'Hi, ${TimeHelper.getGreetingTime()} ${splebUser.userName}!',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBoxHelper.sizedboxH32,
                        if (splebUser.role.name == 'Pengurus Projek')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Projeck untuk Disahkan',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBoxHelper.sizedboxH16,
                              StreamBuilder<List<Projek>>(
                                  stream: projectController.readBelumDisahkan(),
                                  builder: (context, snapshotProjek) {
                                    if (snapshotProjek.hasData) {
                                      var projeks = snapshotProjek.requireData;

                                      if (projeks.isEmpty) return const Center(child: Text('Tiada projek untuk disahkan'));
                                      var projek = projeks.first;
                                      return SizedBox(
                                        height: 200,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(ProjectScreenViewOnly.routeName,
                                                  arguments: ProjectScreenArg(projek.id, splebUser));
                                            },
                                            child: Card(
                                              margin: const EdgeInsets.all(8),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            projek.nama,
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
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
                                            )),
                                      );
                                    } else if (snapshotProjek.hasError) {
                                      return Text('Error ${snapshot.error}');
                                    } else {
                                      return const Center(
                                          child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                                    }
                                  })
                            ],
                          ),
                        SizedBoxHelper.sizedboxH32,
                        CustomButton(
                            titleButton: 'Register User',
                            onPressed: () async {
                              Navigator.of(context).pushNamed(RegisterScreen.routeName);
                            }),
                        SizedBoxHelper.sizedboxH16,
                        CustomButton(
                            titleButton: 'Register Project',
                            onPressed: () async {
                              Navigator.of(context)
                                  .pushNamed(DaftarProjek.routeName, arguments: DaftarProjekArg(false, null, null));
                            }),
                      ])),
                );
              } else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              } else {
                return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
              }
            }));
  }
}
