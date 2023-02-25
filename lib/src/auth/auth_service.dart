import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/database/database.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';

class AuthService extends DatabaseService with ChangeNotifier {
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

  Future<void> signUp(SplebUser splebUser) async {
    try {
      setState = ViewState.busy;

      await userRegisteredCollection.doc().set(splebUser.toRegister(), SetOptions(merge: true));

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

  Future<void> logout() async {
    try {
      setState = ViewState.busy;
      await _firebaseAuth.signOut();

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

  Future<void> deleteUser() async {}

  Future<void> sendPassword() async {}

  Future<void> updatePassword() async {}

  Future<void> updateProfile() async {}
}
