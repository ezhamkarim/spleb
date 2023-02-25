import 'package:flutter/material.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class DaftarRole extends StatefulWidget {
  const DaftarRole({super.key});
  static const routeName = '/daftar-role';
  @override
  State<DaftarRole> createState() => _DaftarRoleState();
}

class _DaftarRoleState extends State<DaftarRole> {
  final formKey = GlobalKey<FormState>();

  final namaTextController = TextEditingController();
  final roleController = RoleController();
  @override
  Widget build(BuildContext context) {
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
                              hintText: 'Nama',
                              isObscure: false,
                              isEnabled: true,
                              color: CustomColor.primary),
                          SizedBoxHelper.sizedboxH16,
                          CustomButton(
                              viewState: roleController.viewState,
                              titleButton: 'Register',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  var role = Role('', namaTextController.text);
                                  await roleController
                                      .create(role)
                                      .then((value) => Navigator.of(context).pop())
                                      .catchError((e) => DialogHelper.dialogWithOutActionWarning(context, e.toString()));
                                }
                              })
                        ]))))));
  }
}

class SenaraiRole extends StatefulWidget {
  const SenaraiRole({super.key});
  static const routeName = '/senarai-role';
  @override
  State<SenaraiRole> createState() => _SenaraiRoleState();
}

class _SenaraiRoleState extends State<SenaraiRole> {
  final roleController = RoleController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        title: const Text('Senarai Role'),
      ),
      body: StreamBuilder<List<Role>>(
          stream: roleController.read(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var roles = snapshot.requireData;
              return ListView.builder(
                  itemCount: roles.length,
                  itemBuilder: (c, i) {
                    return ListTile(
                      title: Text(roles[i].name),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            } else {
              return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
