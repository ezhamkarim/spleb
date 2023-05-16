import 'package:flutter/material.dart';

class IssueListScreen extends StatefulWidget {
  const IssueListScreen({super.key, required this.projekId});
  static const routeName = '/issue-list';
  final String projekId;
  @override
  State<IssueListScreen> createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
