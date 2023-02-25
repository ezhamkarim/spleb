import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/project/project_controller.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/user/user_controller.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class DaftarProjek extends StatefulWidget {
  const DaftarProjek({super.key});
  static const routeName = '/daftar-projek';
  @override
  State<DaftarProjek> createState() => _DaftarProjekState();
}

class _DaftarProjekState extends State<DaftarProjek> {
  final formKey = GlobalKey<FormState>();
  final namaTextController = TextEditingController();
  final kumpulanTextController = TextEditingController();
  final tarikhMulaTextController = TextEditingController();
  final tarikhAkhirTextController = TextEditingController();

  // String? statusProjek;
  // String? statusAktiviti;
  SplebUser? namaPIC;
  String? lokasiProjek;

  List<String> statusProjeks = ['Belum Disahkan', 'Disahkan', 'Dibatalkan'];
  List<String> statusAktivitis = [
    'Belum Berlangsung',
    'Berlangsung',
  ];

  @override
  Widget build(BuildContext context) {
    var userController = context.watch<UserController>();
    var projectController = context.watch<ProjectController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: const Text('Daftar Role'),
        ),
        body: SingleChildScrollView(
            child: SizedBox(
                height: SizeConfig(context).scaledHeight(),
                width: SizeConfig(context).scaledWidth(),
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
                              controller: kumpulanTextController,
                              hintText: 'Kumpulan Projek',
                              isObscure: false,
                              isEnabled: true,
                              color: CustomColor.primary),
                          SizedBoxHelper.sizedboxH16,
                          CustomTextField(
                              controller: tarikhMulaTextController,
                              hintText: 'Tarikh Mula',
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
                              hintText: 'Tarikh Akhir',
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
                                              child: Center(
                                                  child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator())));
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
                                  var project = Projek(
                                      id: '',
                                      nama: namaTextController.text,
                                      statusProjek: 'Belum Disahkan',
                                      statusAktiviti: 'Belum Berlangsung',
                                      lokasiProjek: '',
                                      kumpulan: kumpulanTextController.text,
                                      namaPIC: namaPIC!.userName,
                                      tarikhMula: tarikhMulaTextController.text,
                                      tarikhAkhir: tarikhAkhirTextController.text);
                                  await projectController
                                      .create(project)
                                      .then((value) => Navigator.of(context).pop())
                                      .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                }
                              })
                        ]))))));
  }
}
