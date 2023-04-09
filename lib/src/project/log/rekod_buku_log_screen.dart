import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';

class BukuLogScreen extends StatefulWidget {
  const BukuLogScreen({super.key, required this.projek});
  static const routeName = '/rekod-buku-log';
  final Projek projek;

  @override
  State<BukuLogScreen> createState() => _BukuLogScreenState();
}

class _BukuLogScreenState extends State<BukuLogScreen> {
  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Rekod Buku Log'),
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.projek.nama),
                            IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.chevronRight))
                          ],
                        ),
                      )
                    ]))))));
  }
}
