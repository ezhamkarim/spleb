import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spleb/src/database/database.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';

class UserController extends ChangeNotifier with DatabaseService {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;

  Future<void> update(SplebUser splebUser) async {
    try {
      await userCollection.doc(splebUser.id).update(splebUser.toMap());
    } catch (e) {
      logError('Error update role');
      rethrow;
    }
  }

  Stream<List<SplebUser>> read() {
    return userCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        logInfo('Role : $data');
        return SplebUser.fromJson(data);
      }).toList();
    });
  }

  Stream<List<SplebUser>> readOne(String userId) {
    return userCollection.where('id', isEqualTo: userId).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        logInfo('Role : $data');
        return SplebUser.fromJson(data);
      }).toList();
    });
  }
}
