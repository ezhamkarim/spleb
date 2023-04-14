import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/database/database.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';

class BukuLogOSHEController extends ChangeNotifier with DatabaseService {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
  Future<void> create(BukuLogOSHE bukuLogOSHE) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      // await _roleService.create();
      var docRef = logOSHECollection.doc();

      bukuLogOSHE.id = docRef.id;

      await docRef.set(bukuLogOSHE.toMap());
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> update(BukuLogOSHE bukuLogOSHE) async {
    try {
      await logOSHECollection.doc(bukuLogOSHE.id).update(bukuLogOSHE.toMap());
    } catch (e) {
      logError('Error log oshe quality');
      rethrow;
    }
  }

  Stream<List<BukuLogOSHE>> read() {
    return logOSHECollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        return BukuLogOSHE.fromJson(data);
      }).toList();
    });
  }

  Stream<List<BukuLogOSHE>> readByProjek(String id) {
    return logOSHECollection.where('projekId', isEqualTo: id).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        logError('BukuLogOSHE data $data');
        return BukuLogOSHE.fromJson(data);
      }).toList();
    });
  }

  Future<void> delete(String id) async {
    try {
      await logOSHECollection.doc(id).delete();
    } catch (e) {
      logError('error delete buku log oshe quality');
      rethrow;
    }
  }
}
