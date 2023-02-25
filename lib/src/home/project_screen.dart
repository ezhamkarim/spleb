import 'package:flutter/material.dart';
import 'package:spleb/src/helper/helper.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
      height: SizeConfig(context).scaledHeight(),
      width: SizeConfig(context).scaledWidth(),
      child: Padding(
          padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [])),
    ));
  }
}
