import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class BukuLogScreenArg {
  final Projek? projek;
  final SplebUser userClicked;
  final bool viewOnly;
  final BukuLogQuality? bukuLogQuality;
  final BukuLogOSHE? bukuLogOSHE;
  BukuLogScreenArg(this.projek, this.userClicked, this.bukuLogQuality, this.bukuLogOSHE, {this.viewOnly = false});
}

class BukuLogScreen extends StatefulWidget {
  const BukuLogScreen({super.key, required this.projek, required this.userClicked, this.viewOnly = false, this.bukuLogQuality});
  static const routeName = '/rekod-buku-log';
  final Projek? projek;
  final SplebUser userClicked;
  final bool viewOnly;
  final BukuLogQuality? bukuLogQuality;
  @override
  State<BukuLogScreen> createState() => _BukuLogScreenState();
}

class _BukuLogScreenState extends State<BukuLogScreen> {
  List<Checklist> checklists = [
    Checklist(null, 'Underground works (UG) - Manhole'),
    Checklist(null, 'Overhead Works (OH)'),
    Checklist(null, 'Distribution Point (DP)'),
    Checklist(null, 'Fiber Distribution Cabinet (FDC) / IPMSAN / MSAN / Power Cabinet'),
    Checklist(null, 'Inside Plant (Equipment / Electrical Works / Rectifier / Battery)'),
    Checklist(null, 'Civil Works')
  ];

  List<Approval> approvals = [
    Approval(name: null, signedAt: null, title: 'Penyelia', userId: null),
    Approval(name: null, signedAt: null, title: 'Pegawai', userId: null),
    Approval(name: null, signedAt: null, title: 'Pengurus', userId: null),
  ];

  Location location = Location();

  Future<LocationData?> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    var blq = widget.bukuLogQuality;
    if (blq == null) return;

    checklists = blq.checkList;

    approvals = blq.approval;
  }

  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    var bukuLogController = context.watch<BukuLogController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Rekod Buku Log'),
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: StreamBuilder<List<Projek>>(
                stream: projectController.readOne(id: widget.projek?.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var projeks = snapshot.requireData;

                    if (projeks.isEmpty) {
                      return const Text('Projek tidak ditemui ');
                    }

                    var projek = projeks.first;
                    return SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Nama : ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(projek.nama),
                                        ],
                                      ),
                                      SizedBoxHelper.sizedboxH8,
                                      Row(
                                        children: [
                                          const Text(
                                            'Aktiviti : ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(projek.statusAktiviti),
                                        ],
                                      ),
                                      // IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.chevronRight))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBoxHelper.sizedboxH16,
                              ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: checklists.length,
                                  itemBuilder: (context, i) {
                                    var checklist = checklists[i];
                                    var no = i + 1;
                                    var checklistEnum = checklist.answer == null ? null : getChecklistEnum(checklist.answer!);
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(child: Text('$no. ${checklist.title}')),
                                                // IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.chevronRight))
                                              ],
                                            ),
                                            RadioRow(
                                              viewOnly: widget.viewOnly,
                                              onChanged: (e) {
                                                if (e == null) return;
                                                setState(() {
                                                  checklistEnum = e;
                                                  checklist.answer = getString(e);
                                                });
                                              },
                                              checklistEnum: checklistEnum,
                                              onChangedComply: (e) {
                                                if (e == null) return;
                                                setState(() {
                                                  checklistEnum = e;
                                                  checklist.answer = getString(e);
                                                });
                                              },
                                              onTap: () {
                                                if (checklistEnum == null) return;
                                                setState(() {
                                                  checklistEnum = ChecklistEnum.notComply;
                                                  checklist.answer = getString(checklistEnum!);
                                                });
                                              },
                                              onTapComply: () {
                                                if (checklistEnum == null) return;
                                                setState(() {
                                                  checklistEnum = ChecklistEnum.comply;
                                                  checklist.answer = getString(checklistEnum!);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBoxHelper.sizedboxH16,
                              StreamBuilder<List<SplebUser>>(
                                  stream: userController.readOnebyName(projek.namaPIC),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      // var users = snapshot.requireData;

                                      // var userPIC = users.first;
                                      return CustomButton(
                                          titleButton: 'Hantar',
                                          viewState: bukuLogController.viewState,
                                          onPressed: () async {
                                            bool answered = true;

                                            for (var element in checklists) {
                                              if (element.answer == null) {
                                                answered = false;
                                                break;
                                              }
                                            }

                                            logInfo('answered : $answered');
                                            if (!answered) return;
                                            var locationData = await getLocation();
                                            logError('LOCATION DATA : $locationData');
                                            if (locationData == null) return;
                                            var indexPIC =
                                                approvals.indexWhere((element) => element.title == widget.userClicked.role.name);
                                            logInfo('Index : ${widget.userClicked.role.name}');
                                            if (indexPIC == -1) return;
                                            approvals[indexPIC].name = widget.userClicked.userName;
                                            approvals[indexPIC].userId = widget.userClicked.id;
                                            approvals[indexPIC].signedAt = DateTime.now().toString();

                                            var blq = BukuLogQuality(
                                                createdAt: DateTime.now().toString(),
                                                approval: approvals,
                                                projekId: projek.id,
                                                id: '',
                                                checkList: checklists);
                                            // logInfo('${blq.toMap()}');

                                            if (widget.viewOnly) {
                                              if (widget.bukuLogQuality != null) {
                                                var oldblq = widget.bukuLogQuality;

                                                if (oldblq == null) return;
                                                blq.id = oldblq.id;
                                                logInfo('new blq ${blq.toMap()}');
                                                await bukuLogController
                                                    .update(blq)
                                                    .then((value) => Navigator.of(context).pop())
                                                    .catchError(
                                                        (e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                                return;
                                              }
                                              return;
                                            }
                                            await bukuLogController.create(blq).catchError(
                                                (e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                            projek.lokasiProjek =
                                                LokasiProjek(lat: locationData.latitude ?? 0, lang: locationData.longitude ?? 0);
                                            await projectController
                                                .update(projek)
                                                .then((value) => Navigator.of(context).pop())
                                                .catchError(
                                                    (e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text('Error ${snapshot.error}');
                                    } else {
                                      return const Center(
                                          child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                                    }
                                  })
                            ]))));
                  } else if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else {
                    return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                  }
                })));
  }

  String getString(ChecklistEnum clEnum) {
    if (clEnum == ChecklistEnum.comply) return 'comply';

    return 'notComply';
  }

  ChecklistEnum getChecklistEnum(String ans) {
    if (ans == 'comply') return ChecklistEnum.comply;

    return ChecklistEnum.notComply;
  }
}

class RadioRow extends StatefulWidget {
  const RadioRow(
      {super.key,
      required this.onChanged,
      required this.checklistEnum,
      required this.onChangedComply,
      required this.onTapComply,
      required this.onTap,
      required this.viewOnly});
  final Function(ChecklistEnum?)? onChanged;
  final Function(ChecklistEnum?)? onChangedComply;
  final Function()? onTapComply;
  final Function()? onTap;
  final ChecklistEnum? checklistEnum;
  final bool viewOnly;
  @override
  State<RadioRow> createState() => _RadioRowState();
}

class _RadioRowState extends State<RadioRow> {
  @override
  Widget build(BuildContext context) {
    // if (widget.viewOnly) return Container();
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Radio<ChecklistEnum>(
                  value: ChecklistEnum.notComply,
                  groupValue: widget.checklistEnum,
                  onChanged: widget.viewOnly ? null : widget.onChanged),
              Expanded(child: GestureDetector(onTap: widget.viewOnly ? null : widget.onTap, child: const Text('Not Comply')))
            ],
          ),
        ),
        Expanded(
            child: Row(
          children: [
            Radio<ChecklistEnum>(
                value: ChecklistEnum.comply,
                groupValue: widget.checklistEnum,
                onChanged: widget.viewOnly ? null : widget.onChangedComply),
            Expanded(child: GestureDetector(onTap: widget.viewOnly ? null : widget.onTapComply, child: const Text('Comply')))
          ],
        )),
      ],
    );
  }
}

enum ChecklistEnum { comply, notComply }
