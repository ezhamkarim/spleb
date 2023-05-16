import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class DaftarIssue extends StatefulWidget {
  const DaftarIssue({super.key, required this.projekId});
  static const routeName = '/daftar-issue';

  final String projekId;
  @override
  State<DaftarIssue> createState() => _DaftarIssueState();
}

class _DaftarIssueState extends State<DaftarIssue> {
  final namaTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var issueController = context.watch<IssueController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primary,
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
                              hintText: 'Nama Issue',
                              isObscure: false,
                              isEnabled: true,
                              color: CustomColor.primary),
                          SizedBoxHelper.sizedboxH16,
                          CustomButton(
                              viewState: issueController.viewState,
                              titleButton: 'Register',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {}
                              })
                        ]))))));
  }
}
