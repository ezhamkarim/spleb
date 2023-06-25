import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/project/log/generate_pdf.dart';
import 'package:spleb/src/project/log/generate_pdf_controller.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class BukuLogOSHEScreen extends StatefulWidget {
  const BukuLogOSHEScreen({super.key, required this.projek, required this.userClicked, this.viewOnly = false, this.bukuLogOSHE});
  static const routeName = '/rekod-oshe';
  final Projek? projek;
  final SplebUser userClicked;
  final bool viewOnly;
  final BukuLogOSHE? bukuLogOSHE;
  @override
  State<BukuLogOSHEScreen> createState() => _BukuLogOSHEScreenState();
}

class _BukuLogOSHEScreenState extends State<BukuLogOSHEScreen> {
  String? dateToday;
  CheckOSHE? checkOSHE;
  List<ChecklistOSHE> checklistsPeralatan = [
    ChecklistOSHE(answer: null, title: 'KELENGKAPAN PERLINDUNGAN DIRI (PPE)'),
    ChecklistOSHE(answer: null, title: 'PERALATAN KESELAMATAN'),
    ChecklistOSHE(answer: null, title: 'PERALATAN KERJA'),
    ChecklistOSHE(answer: null, title: 'PERALATAN HYGIENE'),
    ChecklistOSHE(answer: null, title: 'KAWALAN TRAFFIK & SUSUN ATUR TAPAK (DIBUAT MERUJUK AKS BEKERJA DI JALAN RAYA)'),
  ];

  List<ChecklistOSHE> checklists = [
    ChecklistOSHE(answer: null, title: 'Kerja Awam (SSKA)'),
  ];

  List<CatatanList> catatanLists = [
    CatatanList(title: 'KERJA DI TEMPAT TINGGI (WORKING AT HEIGHT - MENARA / ATAS BANGUNAN FLAT-TOP))', catatan: null),
    CatatanList(title: 'PENGGALIAN & PENGORAKAN PERPARIT (TRENCHING)', catatan: null),
    CatatanList(title: 'KERJA PANAS (HOT WORK)', catatan: null),
    CatatanList(title: 'PENGGUNAAN JENTERA MENGANGKAT', catatan: null),
    CatatanList(title: 'KERJA ELEKTRIK VOLTAN RENDAH/TINGGI', catatan: null),
    CatatanList(title: 'PERMIT TO WORK KERJA BERISIKO TINGGI', catatan: null),
  ];
  List<Approval> approvals = [
    Approval(name: null, signedAt: null, title: 'Penyelia', userId: null),
    Approval(name: null, signedAt: null, title: 'Pegawai', userId: null),
    Approval(name: null, signedAt: null, title: 'Pengurus Projek', userId: null),
  ];

  List<TextEditingController> teControllers = [];
  Location location = Location();

  BukuLogOSHE? bukuLogOSHE;

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

    for (var element in catatanLists) {
      teControllers.add(TextEditingController(text: element.catatan));
    }

    var blq = widget.bukuLogOSHE;
    logError('blq : $blq');

    if (blq == null) return;

    bukuLogOSHE = blq;

    logError('Project ID: ${bukuLogOSHE?.projekId}');
    logError('Id : ${widget.projek}');
    var format = DateFormat('dd/MM/yyyy');

    dateToday = format.format(DateTime.now());

    teControllers.clear();

    for (var element in blq.checklistCatatan) {
      teControllers.add(TextEditingController(text: element.catatan));
    }

    approvals = blq.approval;

    catatanLists = blq.checklistCatatan;
    checklists = blq.checklist;

    checklistsPeralatan = blq.checklistPeralatan;
  }

  // Future<void> makePdf() async {
  //   final pdf = PdfDocument();

  // }

  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    var bukuLogOSHEController = context.watch<BukuLogOSHEController>();
    var id = widget.projek == null ? bukuLogOSHE?.projekId : widget.projek?.id;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Rekod Buku Log OSHE'),
          actions: [
            if (bukuLogOSHE != null)
              StreamBuilder<List<Projek>>(
                  stream: projectController.readOne(id: id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var projeks = snapshot.requireData;

                      if (projeks.isEmpty) {
                        return Container();
                      }

                      var projek = projeks.first;
                      return IconButton(
                          onPressed: () async {
                            if (bukuLogOSHE == null) return;
                            var file = await GeneratePdfController.generateLogOSHE(
                                '${projek.nama}-${DateHelper.toDateOnly(bukuLogOSHE?.createdAt)}', bukuLogOSHE!, projek);

                            await PdfController.openFile(file);
                          },
                          icon: const Icon(Icons.download));
                    } else if (snapshot.hasError) {
                      return Text('Error ${snapshot.error}');
                    } else {
                      return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                    }
                  })
          ],
        ),
        body: SizedBox(
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: StreamBuilder<List<Projek>>(
                stream: projectController.readOne(id: id),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Nama : ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: Text(projek.nama)),
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
                              const Text('Senarai semakan peralatan'),
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
                              const Text('Senarai peralatan berkaitan'),
                              SizedBoxHelper.sizedboxH16,
                              ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: checklistsPeralatan.length,
                                  itemBuilder: (context, i) {
                                    var checklist = checklistsPeralatan[i];
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
                              const Text('Senarai peralatan berkaitan'),
                              SizedBoxHelper.sizedboxH16,
                              ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: catatanLists.length,
                                  itemBuilder: (context, i) {
                                    var catatanList = catatanLists[i];
                                    var no = i + 1;
                                    var teController = teControllers[i];
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(child: Text('$no. ${catatanList.title}')),
                                                // IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.chevronRight))
                                              ],
                                            ),
                                            CustomTextField(
                                                color: CustomColor.primary,
                                                controller: teController,
                                                hintText: 'Catatan',
                                                isObscure: false,
                                                isEnabled: bukuLogOSHE == null ? true : false)
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBoxHelper.sizedboxH16,
                              if (widget.bukuLogOSHE == null)
                                Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'PERAKUAN SPV',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBoxHelper.sizedboxH16,
                                      const Text(
                                        'Berdasarkan semakan dokumen dan pemerhatian fizikal di tapak, saya dengan ini mengesahkan',
                                      ),
                                      SizedBoxHelper.sizedboxH16,
                                      Row(
                                        children: [
                                          const Expanded(child: Text('Kerja tersebut boleh dimulakan / diteruskan.')),
                                          Radio<CheckOSHE>(
                                              value: CheckOSHE.dimulakan,
                                              groupValue: checkOSHE,
                                              onChanged: (val) {
                                                if (val == null) return;

                                                setState(() {
                                                  checkOSHE = val;
                                                });
                                              })
                                        ],
                                      ),
                                      SizedBoxHelper.sizedboxH16,
                                      Row(
                                        children: [
                                          const Expanded(
                                              child: Text(
                                                  'Pemberhentian kerja tersebut serta merta. (Kerja hanya boleh dimulakan / disambung setelah tindakan pembaikan dibuat)')),
                                          Radio<CheckOSHE>(
                                              value: CheckOSHE.dihentikan,
                                              groupValue: checkOSHE,
                                              onChanged: (val) {
                                                if (val == null) return;

                                                setState(() {
                                                  checkOSHE = val;
                                                });
                                              })
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              if (widget.bukuLogOSHE == null)
                                StreamBuilder<List<SplebUser>>(
                                    stream: userController.readOnebyName(projek.namaPIC),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        // var users = snapshot.requireData;

                                        // var user = users.first;
                                        return CustomButton(
                                            viewState: bukuLogOSHEController.viewState,
                                            titleButton: 'Hantar',
                                            onPressed: checkOSHE == null
                                                ? null
                                                : () async {
                                                    bool answered = true;
                                                    bool answeredPeralatan = true;

                                                    for (var element in checklists) {
                                                      if (element.answer == null) {
                                                        answered = false;
                                                        break;
                                                      }
                                                    }

                                                    for (var element in checklistsPeralatan) {
                                                      if (element.answer == null) {
                                                        answeredPeralatan = false;
                                                        break;
                                                      }
                                                    }
                                                    logInfo('answered : $answered, answeredPeralatan : $answeredPeralatan');
                                                    if (!answered || !answeredPeralatan) return;

                                                    var index = approvals
                                                        .indexWhere((element) => element.title == widget.userClicked.role.name);

                                                    if (index == -1) return;
                                                    approvals[index].name = widget.userClicked.userName;
                                                    approvals[index].userId = widget.userClicked.id;
                                                    approvals[index].signedAt = DateTime.now().toString();

                                                    var locationData = await getLocation();
                                                    logError('LOCATION DATA : $locationData');
                                                    if (locationData == null) return;

                                                    var blqoshe = BukuLogOSHE(
                                                        projekId: projek.id,
                                                        id: '',
                                                        createdAt: DateTime.now().toString(),
                                                        checklistPeralatan: checklistsPeralatan,
                                                        checklist: checklists,
                                                        approval: approvals,
                                                        checklistCatatan: catatanLists,
                                                        lat: locationData.latitude ?? 0,
                                                        long: locationData.longitude ?? 0);
                                                    if (widget.viewOnly) {
                                                      if (widget.bukuLogOSHE != null) {
                                                        var oldblq = widget.bukuLogOSHE;

                                                        if (oldblq == null) return;
                                                        blqoshe.id = oldblq.id;
                                                        logInfo('new blq ${blqoshe.toMap()}');
                                                        await bukuLogOSHEController
                                                            .update(blqoshe)
                                                            .then((value) => Navigator.of(context).pop())
                                                            .catchError((e) =>
                                                                DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                                        return;
                                                      }
                                                      return;
                                                    }
                                                    await bukuLogOSHEController.create(blqoshe).catchError(
                                                        (e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                                    logError('Projek : ${projek.toMap()}');
                                                    projek.lokasiProjek = LokasiProjek(
                                                        lat: locationData.latitude ?? 0, lang: locationData.longitude ?? 0);
                                                    await projectController
                                                        .update(projek)
                                                        .then((value) => Navigator.of(context).pop())
                                                        .catchError((e) =>
                                                            DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                                  });
                                      } else if (snapshot.hasError) {
                                        return Text('Error ${snapshot.error}');
                                      } else {
                                        return const Center(
                                            child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                                      }
                                    }),
                              if (widget.userClicked.role.name == 'Pegawai' || widget.userClicked.role.name == 'Pengurus Projek')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Expanded(child: Text('Nama:')),
                                                Expanded(flex: 3, child: Text(widget.userClicked.userName))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                const Expanded(child: Text('Tarikh')),
                                                Expanded(flex: 3, child: Text(dateToday ?? ''))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CustomButton(
                                      viewState: bukuLogOSHEController.viewState,
                                      titleButton: 'Sahkan',
                                      onPressed: () async {
                                        if (bukuLogOSHE == null) return;

                                        for (var i = 0; i < bukuLogOSHE!.approval.length; i++) {
                                          var appr = bukuLogOSHE!.approval[i];

                                          if (appr.title == widget.userClicked.role.name) {
                                            bukuLogOSHE!.approval[i].name = widget.userClicked.userName;
                                            bukuLogOSHE!.approval[i].signedAt = DateTime.now().toString();

                                            bukuLogOSHE!.approval[i].userId = widget.userClicked.id;
                                          }
                                        }
                                        await bukuLogOSHEController
                                            .update(bukuLogOSHE!)
                                            .then((value) => Navigator.of(context).pop())
                                            .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                      },
                                    ),
                                  ],
                                ),
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

enum CheckOSHE { dimulakan, dihentikan }
