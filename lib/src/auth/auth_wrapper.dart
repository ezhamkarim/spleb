import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spleb/src/auth/login_screen.dart';
import 'package:spleb/src/root/screens.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    var fbUser = context.watch<User?>();

    if (fbUser == null) return const LoginScreen();

    return const IndexScreen();
  }
}
