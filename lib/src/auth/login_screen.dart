import 'package:flutter/material.dart';
import 'package:spleb/src/auth/register_screen.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/widget/custom_widget.dart';

//TODO implement login screen 10:30 AM
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                Column(
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
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(RegisterScreen.routeName);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBoxHelper.sizedboxH16,
                    Row(
                      children: [
                        Expanded(child: CustomButton(titleButton: 'Login', onPressed: () {})),
                      ],
                    )
                  ],
                ),
                SizedBoxHelper.sizedboxH16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
