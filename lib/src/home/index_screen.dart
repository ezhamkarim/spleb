import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/root/screens.dart';
import 'package:spleb/src/root/services.dart';
import 'package:spleb/src/widget/custom_widget.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});
  static const routeName = '/index';
  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    var authService = context.watch<AuthService>();
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          CustomButton(
              titleButton: 'Register',
              onPressed: () async {
                Navigator.of(context).pushNamed(RegisterScreen.routeName);
              }),
          SizedBoxHelper.sizedboxH16,
          CustomButton(
              viewState: authService.viewState,
              titleButton: 'Logout',
              onPressed: () async {
                await authService.logout();
              }),
        ]),
      ),
    );
  }
}
