import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/helper/helper.dart';
import 'package:spleb/src/root/services.dart';
import 'package:spleb/src/widget/custom_widget.dart';

//TODO: Add tetapan view
class TetapanScreen extends StatefulWidget {
  const TetapanScreen({super.key});

  @override
  State<TetapanScreen> createState() => _TetapanScreenState();
}

class _TetapanScreenState extends State<TetapanScreen> {
  @override
  Widget build(BuildContext context) {
    var authService = context.watch<AuthService>();
    return SingleChildScrollView(
        child: SizedBox(
      height: SizeConfig(context).scaledHeight(),
      width: SizeConfig(context).scaledWidth(),
      child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CustomButton(
                viewState: authService.viewState,
                titleButton: 'Logout',
                onPressed: () async {
                  await authService.logout();
                }),
          ])),
    ));
  }
}
