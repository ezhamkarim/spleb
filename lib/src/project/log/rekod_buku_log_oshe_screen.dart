import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class BukuLogOSHEScreen extends StatefulWidget {
  const BukuLogOSHEScreen({super.key, required this.projek, required this.userClicked});
  static const routeName = '/rekod-oshe';
  final Projek projek;
  final SplebUser userClicked;
  @override
  State<BukuLogOSHEScreen> createState() => _BukuLogOSHEScreenState();
}

class _BukuLogOSHEScreenState extends State<BukuLogOSHEScreen> {
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
    Approval(name: null, signedAt: null, title: 'Pengurus', userId: null),
  ];

  List<TextEditingController> teControllers = [];

  @override
  void initState() {
    super.initState();

    for (var element in catatanLists) {
      teControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    var bukuLogOSHEController = context.watch<BukuLogOSHEController>();
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
                                  Text(widget.projek.nama),
                                ],
                              ),
                              SizedBoxHelper.sizedboxH8,
                              Row(
                                children: [
                                  const Text(
                                    'Aktiviti : ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.projek.statusAktiviti),
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
                                        controller: teController, hintText: 'Catatan', isObscure: false, isEnabled: true)
                                  ],
                                ),
                              ),
                            );
                          }),
                      StreamBuilder<List<SplebUser>>(
                          stream: userController.readOnebyName(widget.projek.namaPIC),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var users = snapshot.requireData;

                              var user = users.first;
                              return CustomButton(
                                  titleButton: 'Approve',
                                  onPressed: () async {
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

                                    var index = approvals.indexWhere((element) => element.title == widget.userClicked.role.name);

                                    if (index == -1) return;
                                    approvals[index].name = user.userName;
                                    approvals[index].userId = user.id;
                                    approvals[index].signedAt = DateTime.now().toString();

                                    var blqoshe = BukuLogOSHE(
                                        projekId: widget.projek.id,
                                        id: '',
                                        createdAt: DateTime.now().toString(),
                                        checklistPeralatan: checklistsPeralatan,
                                        checklist: checklists,
                                        approval: approvals,
                                        checklistCatatan: catatanLists);

                                    await bukuLogOSHEController
                                        .create(blqoshe)
                                        .then((value) => Navigator.of(context).pop())
                                        .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                  });
                            } else if (snapshot.hasError) {
                              return Text('Error ${snapshot.error}');
                            } else {
                              return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                            }
                          })
                    ]))))));
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
