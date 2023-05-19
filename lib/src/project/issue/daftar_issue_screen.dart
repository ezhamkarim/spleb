import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class DaftarIssue extends StatefulWidget {
  const DaftarIssue({super.key, required this.projek});
  static const routeName = '/daftar-issue';

  final Projek projek;
  @override
  State<DaftarIssue> createState() => _DaftarIssueState();
}

class _DaftarIssueState extends State<DaftarIssue> {
  final namaTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var issueController = context.watch<IssueController>();
    var fbUser = context.watch<User?>();
    if (fbUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
          title: Text('Isu - ${widget.projek.nama}'),
          // title: widget.isEdit ? const Text('Kemaskini Issue') : const Text('Daftar Issue'),
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
                              hintText: 'Nama Isu',
                              isObscure: false,
                              isEnabled: true,
                              color: CustomColor.primary),
                          SizedBoxHelper.sizedboxH16,
                          CustomTextField(
                              controller: descriptionTextController,
                              hintText: 'Description',
                              isObscure: false,
                              isEnabled: true,
                              color: CustomColor.primary),
                          SizedBoxHelper.sizedboxH16,
                          CustomButton(
                              viewState: issueController.viewState,
                              titleButton: 'Create',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  var isu = Issue(
                                      id: '',
                                      projekId: widget.projek.id,
                                      name: namaTextController.text,
                                      createdById: fbUser.uid,
                                      isRead: false,
                                      description: descriptionTextController.text);

                                  await issueController
                                      .create(isu)
                                      .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()))
                                      .then((value) => Navigator.of(context).pop());
                                }
                              })
                        ]))))));
  }
}
