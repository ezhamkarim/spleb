import 'package:flutter/material.dart';
import 'package:spleb/src/helper/helper.dart';
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
