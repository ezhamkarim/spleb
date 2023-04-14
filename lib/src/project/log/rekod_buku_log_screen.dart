import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class BukuLogScreenArg {
  final Projek projek;
  final SplebUser userClicked;
  final bool? viewOnly;
  BukuLogScreenArg(this.projek, this.userClicked, {this.viewOnly = false});
}

class BukuLogScreen extends StatefulWidget {
  const BukuLogScreen({super.key, required this.projek, required this.userClicked, this.viewOnly = false});
  static const routeName = '/rekod-buku-log';
  final Projek projek;
  final SplebUser userClicked;
  final bool viewOnly;
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
                      StreamBuilder<List<SplebUser>>(
                          stream: userController.readOnebyName(widget.projek.namaPIC),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var users = snapshot.requireData;

                              var user = users.first;
                              return CustomButton(
                                  titleButton: 'Approve',
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

                                    //TODO: Add approval user pegawai
                                    var index = approvals.indexWhere((element) => element.title == widget.userClicked.role.name);

                                    if (index == -1) return;
                                    approvals[index].name = user.userName;
                                    approvals[index].userId = user.id;
                                    approvals[index].signedAt = DateTime.now().toString();
                                    var blq = BukuLogQuality(
                                        createdAt: DateTime.now().toString(),
                                        approval: approvals,
                                        projekId: widget.projek.id,
                                        id: '',
                                        checkList: checklists);
                                    logInfo('${blq.toMap()}');

                                    await bukuLogController
                                        .create(blq)
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

class RadioRow extends StatefulWidget {
  const RadioRow(
      {super.key,
      required this.onChanged,
      required this.checklistEnum,
      required this.onChangedComply,
      required this.onTapComply,
      required this.onTap});
  final Function(ChecklistEnum?)? onChanged;
  final Function(ChecklistEnum?)? onChangedComply;
  final Function()? onTapComply;
  final Function()? onTap;
  final ChecklistEnum? checklistEnum;
  @override
  State<RadioRow> createState() => _RadioRowState();
}

class _RadioRowState extends State<RadioRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Radio<ChecklistEnum>(value: ChecklistEnum.notComply, groupValue: widget.checklistEnum, onChanged: widget.onChanged),
              Expanded(child: GestureDetector(onTap: widget.onTap, child: const Text('Not Comply')))
            ],
          ),
        ),
        Expanded(
            child: Row(
          children: [
            Radio<ChecklistEnum>(
                value: ChecklistEnum.comply, groupValue: widget.checklistEnum, onChanged: widget.onChangedComply),
            Expanded(child: GestureDetector(onTap: widget.onTapComply, child: const Text('Comply')))
          ],
        )),
      ],
    );
  }
}

enum ChecklistEnum { comply, notComply }
