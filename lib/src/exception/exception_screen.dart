import 'package:flutter/material.dart';
import 'package:spleb/src/style/style.dart';

class ExceptionView extends StatelessWidget {
  const ExceptionView({Key? key, required this.routeName}) : super(key: key);
  final String routeName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Center(child: Text('Page $routeName not found'))]),
    );
  }
}
