import 'package:flutter/material.dart';

class DaftarIssue extends StatefulWidget {
  const DaftarIssue({super.key, required this.projekId});
  static const routeName = '/daftar-issue';

  final String projekId;
  @override
  State<DaftarIssue> createState() => _DaftarIssueState();
}

class _DaftarIssueState extends State<DaftarIssue> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
