import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class BukuLogOSHEScreen extends StatefulWidget {
  const BukuLogOSHEScreen({super.key, required this.projek});
  static const routeName = '/rekod-oshe';
  final Projek projek;
  @override
  State<BukuLogOSHEScreen> createState() => _BukuLogOSHEScreenState();
}

class _BukuLogOSHEScreenState extends State<BukuLogOSHEScreen> {
  List<Checklist> checklistsPeralatan = [
    Checklist(null, 'KELENGKAPAN PERLINDUNGAN DIRI (PPE)'),
    Checklist(null, 'PERALATAN KESELAMATAN'),
    Checklist(null, 'PERALATAN KERJA'),
    Checklist(null, 'PERALATAN HYGIENE'),
    Checklist(null, 'KAWALAN TRAFFIK & SUSUN ATUR TAPAK (DIBUAT MERUJUK AKS BEKERJA DI JALAN RAYA)'),
  ];

  List<Checklist> checklists = [
    Checklist(null, 'Kerja Awam (SSKA)'),
  ];

  List<Approval> approvals = [
    Approval(name: null, signedAt: null, title: 'Penyelia', userId: null),
    Approval(name: null, signedAt: null, title: 'Pegawai', userId: null),
    Approval(name: null, signedAt: null, title: 'Pengurus', userId: null),
  ];
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
                      CustomButton(titleButton: 'Approve', onPressed: () async {})
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
