import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/auth/auth_wrapper.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/project/project_controller.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/user/user_controller.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class DaftarProjekArg {
  final bool isEdit;
  final Projek? projek;
  final SplebUser? personInCharge;
  DaftarProjekArg(this.isEdit, this.projek, this.personInCharge);
}

class DaftarProjek extends StatefulWidget {
  const DaftarProjek({super.key, required this.isEdit, this.projek, this.personInCharge});
  static const routeName = '/daftar-projek';
  final bool isEdit;
  final Projek? projek;
  final SplebUser? personInCharge;
  @override
  State<DaftarProjek> createState() => _DaftarProjekState();
}

class _DaftarProjekState extends State<DaftarProjek> {
  final formKey = GlobalKey<FormState>();
  final namaTextController = TextEditingController();
  final kumpulanTextController = TextEditingController();
  final tarikhMulaTextController = TextEditingController();
  final tarikhAkhirTextController = TextEditingController();
  final noProjekController = TextEditingController();

  String? aktivitiSekarang;
  // String? statusAktiviti;
  SplebUser? namaPIC;
  String? lokasiProjek;
  final newAktivitiTextController = TextEditingController();
  final currentAktivitiTextController = TextEditingController();
  List<String> statusProjeks = ['Belum Disahkan', 'Disahkan', 'Dibatalkan'];
  List<String> statusAktivitis = [
    'Project Creation',
    'Project Approval',
    'Handover',
    'Request LOR',
    'SURVEY with RR/Vendor',
    'PR/PO Material',
    'RR/VENDOR WORKS',
    'Testing',
    'Ready for RFSI',
    'RFSI & COMM',
    'Lnch',
    'Complete',
    'Close'
  ];

  @override
  void initState() {
    logInfo('IsEdit : ${widget.isEdit}, Projek obj : ${widget.projek}');
    if (!widget.isEdit) return;

    var projek = widget.projek;
    if (projek == null) return;

    namaTextController.text = projek.nama;
    kumpulanTextController.text = projek.kumpulan;

    tarikhAkhirTextController.text = projek.tarikhAkhir;

    tarikhMulaTextController.text = projek.tarikhMula;

    aktivitiSekarang = projek.statusAktiviti;

    statusAktivitis = projek.aktivitiTerkini;

    namaPIC = widget.personInCharge;

    super.initState();
  }

  void addStatusAktiviti() {
    setState(() {
      statusAktivitis.add(newAktivitiTextController.text);
    });

    newAktivitiTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: widget.isEdit ? const Text('Kemaskini Projek') : const Text('Daftar Projek'),
        ),
        body: SizedBox(
          height: SizeConfig(context).scaledHeight(),
          width: SizeConfig(context).scaledWidth(),
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                    key: formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      CustomTextField(
                          controller: namaTextController,
                          hintText: 'Nama Projek',
                          isObscure: false,
                          isEnabled: true,
                          color: CustomColor.primary),
                      SizedBoxHelper.sizedboxH16,
                      CustomTextField(
                          controller: noProjekController,
                          hintText: 'No Projek',
                          isObscure: false,
                          isEnabled: true,
                          color: CustomColor.primary),
                      CustomTextField(
                          controller: kumpulanTextController,
                          hintText: 'Kumpulan Projek(Syarikat Kontraktor)',
                          isObscure: false,
                          isEnabled: true,
                          color: CustomColor.primary),
                      SizedBoxHelper.sizedboxH16,
                      CustomTextField(
                          controller: tarikhMulaTextController,
                          hintText: 'Tarikh Jangka Mula Projek',
                          isObscure: false,
                          isEnabled: true,
                          onTap: () async {
                            var dateTimeNow = DateTime.now();

                            /// Amik dari tarikh mula jika controller ada text value;
                            if (tarikhMulaTextController.text.isNotEmpty) {
                              dateTimeNow = DateTime.tryParse(tarikhMulaTextController.text) ?? dateTimeNow;
                              logSuccess('DateTime Now : $dateTimeNow');
                            }
                            var datePicked = await showDatePicker(
                                context: context,
                                initialDate: dateTimeNow,
                                firstDate: dateTimeNow,
                                lastDate: DateTime(2030, DateTime.now().month, 1));
                            if (datePicked == null || !mounted) return;

                            var timePicked = await showTimePicker(
                                context: context, initialTime: TimeOfDay(hour: dateTimeNow.hour, minute: dateTimeNow.minute));

                            var selectedDateTime = DateTime(datePicked.year, datePicked.month, datePicked.day,
                                timePicked?.hour ?? 0, timePicked?.minute ?? 0);

                            var dateFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');

                            try {
                              DateTime? dtTarikhAkhir;
                              if (tarikhAkhirTextController.text.isNotEmpty) {
                                dtTarikhAkhir = dateFormat.parse(tarikhAkhirTextController.text);
                              }

                              tarikhMulaTextController.text = dateFormat.format(selectedDateTime);

                              if (dtTarikhAkhir == null) return;

                              /// If tarikh mula selepas dari tarikh akhir, reset balik tarikh akhir
                              if (selectedDateTime.isAfter(dtTarikhAkhir)) {
                                tarikhAkhirTextController.clear();
                              }
                            } catch (e) {
                              logError('Error format Tarikh Mula Controller : $e');
                            }
                          },
                          color: CustomColor.primary),
                      SizedBoxHelper.sizedboxH16,
                      CustomTextField(
                          controller: tarikhAkhirTextController,
                          hintText: 'Tarikh Jangka Tamat Projek',
                          isObscure: false,
                          isEnabled: true,
                          onTap: () async {
                            var dateTimeNow = DateTime.now();

                            if (tarikhAkhirTextController.text.isNotEmpty) {
                              dateTimeNow = DateTime.tryParse(tarikhAkhirTextController.text) ?? dateTimeNow;

                              logSuccess('DateTime Now from Controller : $dateTimeNow');
                            }
                            var dateFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');

                            try {
                              var tarikhMula = dateFormat.parse(tarikhMulaTextController.text);

                              dateTimeNow = tarikhMula;
                            } catch (e) {
                              logError('Tarikh Mula Parse failed $e');
                            }

                            logSuccess('DateTime Now take from tarikh mula : $dateTimeNow');

                            var datePicked = await showDatePicker(
                                context: context,
                                initialDate: dateTimeNow,
                                firstDate: dateTimeNow,
                                lastDate: DateTime(2030, DateTime.now().month, 1));
                            if (datePicked == null || !mounted) return;

                            var timePicked = await showTimePicker(
                                context: context, initialTime: TimeOfDay(hour: dateTimeNow.hour, minute: dateTimeNow.minute));

                            var selectedDateTime = DateTime(datePicked.year, datePicked.month, datePicked.day,
                                timePicked?.hour ?? 0, timePicked?.minute ?? 0);

                            try {
                              tarikhAkhirTextController.text = dateFormat.format(selectedDateTime);
                            } catch (e) {
                              logError('Error format Tarikh Akhir Controller : $e');
                            }
                          },
                          color: CustomColor.primary),
                      SizedBoxHelper.sizedboxH16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('Status Projek'),
                          ),
                          SizedBoxHelper.sizedboxH8,
                          Column(
                            children: statusAktivitis
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                                      child: Row(
                                        children: [
                                          const Text('- '),
                                          Text(
                                            e,
                                            style: const TextStyle(fontWeight: FontWeight.w400),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  statusAktivitis.removeWhere((element) => element == e);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                      SizedBoxHelper.sizedboxH8,
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                                color: CustomColor.primary,
                                controller: newAktivitiTextController,
                                hintText: 'Aktiviti',
                                validator: (p0) => null,
                                isObscure: false,
                                isEnabled: true),
                            SizedBoxHelper.sizedboxH8,
                            ElevatedButton(
                              onPressed: addStatusAktiviti,
                              style: ElevatedButton.styleFrom(backgroundColor: CustomColor.primary),
                              child: const Text('Add new aktiviti'),
                            )
                          ],
                        ),
                      ),
                      SizedBoxHelper.sizedboxH16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Aktiviti Sekarang/Status Projek',
                            ),
                          ),
                          SizedBoxHelper.sizedboxH8,
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null) return 'Sila Pilih Status Projek Sekarang';
                                  return null;
                                },
                                hint: const Text(
                                  'Aktiviti Sekarang',
                                ),
                                decoration: InputDecoration(
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                                        borderRadius:
                                            const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius:
                                            SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2),
                                        borderRadius:
                                            SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                    errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                        borderRadius:
                                            SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: CustomColor.secondary, width: 2),
                                        borderRadius:
                                            SmoothBorderRadius.all(SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6)))),
                                value: aktivitiSekarang,
                                items: statusAktivitis.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                                onChanged: (hehe) {
                                  setState(() {
                                    aktivitiSekarang = hehe;
                                  });
                                }),
                          ),
                        ],
                      ),
                      SizedBoxHelper.sizedboxH16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('PIC (Person In Charge)'),
                          ),
                          SizedBoxHelper.sizedboxH8,
                          Row(
                            children: [
                              StreamBuilder<List<SplebUser>>(
                                  stream: userController.read(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var roles = snapshot.requireData;

                                      // var roleAhliBiasa = roles.where((element) => element.nama == GeneralKey.ahli).toList();

                                      // if (roleAhliBiasa.isNotEmpty) {
                                      //   role = roleAhliBiasa.first;
                                      // }
                                      return Expanded(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<SplebUser>(
                                              validator: (value) {
                                                if (value == null) return 'Sila Pilih PIC';
                                                return null;
                                              },
                                              hint: const Text(
                                                'PIC (Person In Charge)',
                                              ),
                                              decoration: InputDecoration(
                                                  focusedErrorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                                                      borderRadius: const SmoothBorderRadius.all(
                                                          SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                  disabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black, width: 2),
                                                      borderRadius: SmoothBorderRadius.all(
                                                          SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                  enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black, width: 2),
                                                      borderRadius: SmoothBorderRadius.all(
                                                          SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                  errorBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                                      borderRadius: SmoothBorderRadius.all(
                                                          SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                                  focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(color: CustomColor.secondary, width: 2),
                                                      borderRadius: SmoothBorderRadius.all(
                                                          SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6)))),
                                              value: namaPIC,
                                              items: roles
                                                  .map((e) => DropdownMenuItem<SplebUser>(value: e, child: Text(e.userName)))
                                                  .toList(),
                                              onChanged: (hehe) {
                                                setState(() {
                                                  namaPIC = hehe;
                                                });
                                              }),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Expanded(child: Text('Error ${snapshot.error}'));
                                    } else {
                                      return const Expanded(
                                          child:
                                              Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator())));
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                      SizedBoxHelper.sizedboxH16,
                      CustomButton(
                          viewState: projectController.viewState,
                          titleButton: 'Register',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (widget.isEdit) {
                                var projekObjBeforeEdited = widget.projek;

                                if (projekObjBeforeEdited == null) return;
                                var project = Projek(
                                    id: projekObjBeforeEdited.id,
                                    nama: namaTextController.text,
                                    noProjek: noProjekController.text,
                                    statusProjek: projekObjBeforeEdited.statusProjek,
                                    statusAktiviti: aktivitiSekarang ?? '',
                                    lokasiProjek: projekObjBeforeEdited.lokasiProjek,
                                    aktivitiTerkini: statusAktivitis,
                                    kumpulan: kumpulanTextController.text,
                                    namaPIC: namaPIC!.userName,
                                    lampiran: projekObjBeforeEdited.lampiran,
                                    tarikhMula: tarikhMulaTextController.text,
                                    tarikhAkhir: tarikhAkhirTextController.text);

                                await projectController
                                    .update(project)
                                    .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                                        AuthWrapper.routeName, ModalRoute.withName(AuthWrapper.routeName)))
                                    .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                return;
                              }
                              var project = Projek(
                                  id: '',
                                  nama: namaTextController.text,
                                  noProjek: noProjekController.text,
                                  statusProjek: 'Belum Disahkan',
                                  statusAktiviti: aktivitiSekarang ?? '',
                                  lokasiProjek: null,
                                  aktivitiTerkini: statusAktivitis,
                                  kumpulan: kumpulanTextController.text,
                                  namaPIC: namaPIC!.userName,
                                  tarikhMula: tarikhMulaTextController.text,
                                  lampiran: [],
                                  tarikhAkhir: tarikhAkhirTextController.text);
                              await projectController
                                  .create(project)
                                  .then((value) => Navigator.of(context).pop())
                                  .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                            }
                          })
                    ]))),
          ),
        ));
  }
}
