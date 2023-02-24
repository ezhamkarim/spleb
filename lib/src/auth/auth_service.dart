import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';

class AuthService with ChangeNotifier {
  //TODO implement all service 9:00 AM
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
  Future<void> signIn(String email, String password) async {
    try {
      setState = ViewState.busy;
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      setState = ViewState.idle;
      return;
    } on FirebaseException catch (e) {
      setState = ViewState.idle;
      logError('Firebase Error $e');
      throw e.toString();
    } catch (e) {
      setState = ViewState.idle;
      logError('Other Error $e');

      throw e.toString();
    }
  }

  Future<void> signUp() async {}

  Future<void> deleteUser() async {}

  Future<void> sendPassword() async {}

  Future<void> updatePassword() async {}

  Future<void> updateProfile() async {}
}
