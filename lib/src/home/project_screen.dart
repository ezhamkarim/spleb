import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
//TODO: Add project screen list

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    var projectController = context.watch<ProjectController>();
    return SingleChildScrollView(
        child: SizedBox(
      height: SizeConfig(context).scaledHeight(),
      width: SizeConfig(context).scaledWidth(),
      child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            StreamBuilder<List<Projek>>(
                stream: projectController.read(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.requireData.length,
                        itemBuilder: (c, i) {
                          var projek = snapshot.requireData[i];
                          return Card(
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(
                                  children: [
                                    Expanded(child: Text('${projek.nama} (${projek.namaPIC})')),
                                    Chip(
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: ProjekHelper.getColorsStatusBg(projek.statusProjek),
                                        label: Text(
                                          projek.statusProjek,
                                        ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text(projek.lokasiProjek.isEmpty ? 'Tiada Lokasi' : projek.lokasiProjek)),
                                    IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_right))
                                  ],
                                )
                              ]),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else {
                    return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                  }
                })
          ])),
    ));
  }
}
