import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/database/database_service.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/role.dart';

class RoleController extends ChangeNotifier with DatabaseService {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
  Future<void> create(Role role) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      // await _roleService.create();
      var docRef = roleCollection.doc();

      role.id = docRef.id;

      await docRef.set(role.toMap());
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> update(Role role) async {
    try {
      await roleCollection.doc(role.id).update(role.toMap());
    } catch (e) {
      logError('Error update role');
      rethrow;
    }
  }

  Stream<List<Role>> read() {
    return roleCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        logInfo('Role : ${data.runtimeType}');
        return Role.fromJson(data);
      }).toList();
    });
  }

  Future<void> delete(String userId) async {
    try {
      await roleCollection.doc(userId).delete();
    } catch (e) {
      logError('error delete role');
      rethrow;
    }
  }
}
