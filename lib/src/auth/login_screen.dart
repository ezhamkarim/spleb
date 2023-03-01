import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/root/services.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController(text: 'admin@spleb.com');
  final passwordTextController = TextEditingController(text: 'Spleb1234');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var authService = context.watch<AuthService>();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/vecteezy_technology-background-concept-circuit-board-electronic_6430145.jpg',
                    ))),
            height: SizeConfig(context).scaledHeight(),
            width: SizeConfig(context).scaledWidth(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SPLEB',
                          style: TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        SizedBox(
                          width: SizeConfig(context).scaledWidth(widthScale: 0.5),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Sistem Buku Log Elektronik Penyeliaan',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBoxHelper.sizedboxH32,
                    SizedBoxHelper.sizedboxH32,
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: emailTextController,
                            hintText: 'Email',
                            isObscure: false,
                            isEnabled: true,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBoxHelper.sizedboxH16,
                          CustomTextField(
                            controller: passwordTextController,
                            hintText: 'Password',
                            isObscure: true,
                            isEnabled: true,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          SizedBoxHelper.sizedboxH16,
                        ],
                      ),
                    ),
                    SizedBoxHelper.sizedboxH32,
                    SizedBoxHelper.sizedboxH32,
                    Row(
                      children: [
                        Expanded(
                            child: CustomButton(
                                viewState: authService.viewState,
                                titleButton: 'Login',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authService
                                        .signIn(emailTextController.text, passwordTextController.text)
                                        .catchError((e) {
                                      DialogHelper.dialogWithOutActionWarning(context, e.toString());
                                    });
                                  }
                                })),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //     bottom: 64,
          //     left: 36,
          //     right: 36,
          //     child: Row(
          //       children: [
          //         Expanded(
          //             child: CustomButton(
          //                 viewState: authService.viewState,
          //                 titleButton: 'Login',
          //                 onPressed: () async {
          //                   if (_formKey.currentState!.validate()) {
          //                     await authService.signIn(emailTextController.text, passwordTextController.text).catchError((e) {
          //                       DialogHelper.dialogWithOutActionWarning(context, e.toString());
          //                     });
          //                   }
          //                 })),
          //       ],
          //     ))
        ],
      ),
    );
  }
}
