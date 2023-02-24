import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/model/models.dart';
import 'package:spleb/src/root/controllers.dart';
import 'package:spleb/src/style/style.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const routeName = '/register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController(text: 'Spleb1234');
  final roleController = RoleController();

  Role? role;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        title: const Text('Register User'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig(context).scaledHeight(),
          width: SizeConfig(context).scaledWidth(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    isObscure: false,
                    isEnabled: true,
                    keyboardType: TextInputType.emailAddress,
                    color: CustomColor.primary),
                SizedBoxHelper.sizedboxH16,
                CustomTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    isObscure: true,
                    isEnabled: true,
                    keyboardType: TextInputType.visiblePassword,
                    color: CustomColor.primary),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Role'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        StreamBuilder<List<Role>>(
                            stream: roleController.read(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var roles = snapshot.requireData;

                                // var roleAhliBiasa = roles.where((element) => element.nama == GeneralKey.ahli).toList();

                                // if (roleAhliBiasa.isNotEmpty) {
                                //   role = roleAhliBiasa.first;
                                // }
                                return Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<Role>(
                                        hint: const Text(
                                          'Role',
                                        ),
                                        decoration: InputDecoration(
                                            focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                                                borderRadius: const SmoothBorderRadius.all(
                                                    SmoothRadius(cornerRadius: 4, cornerSmoothing: 0.6))),
                                            disabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black, width: 2),
                                                borderRadius:
                                                    SmoothBorderRadius.all(SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6))),
                                            enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black, width: 2),
                                                borderRadius:
                                                    SmoothBorderRadius.all(SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6))),
                                            errorBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                                borderRadius:
                                                    SmoothBorderRadius.all(SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6))),
                                            focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: CustomColor.secondary, width: 2),
                                                borderRadius: SmoothBorderRadius.all(
                                                    SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6)))),
                                        value: role,
                                        items: roles.map((e) => DropdownMenuItem<Role>(value: e, child: Text(e.name))).toList(),
                                        onChanged: (hehe) {
                                          setState(() {
                                            role = hehe;
                                          });
                                        }),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Expanded(child: Text('Error ${snapshot.error}'));
                              } else {
                                return const Expanded(
                                    child: Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator())));
                              }
                            }),
                        IconButton(
                            onPressed: () {
                              // Navigator.of(context).pushNamed(DaftarRole.routeName);
                            },
                            icon: const FaIcon(FontAwesomeIcons.plus))
                      ],
                    ),
                  ],
                ),
                SizedBoxHelper.sizedboxH32,
                CustomButton(titleButton: 'Register', onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}
