import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/database/database.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';

import '../../model/models.dart';

class BukuLogController extends ChangeNotifier with DatabaseService {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
  Future<void> create(BukuLogQuality bukuLogQuality) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      // await _roleService.create();
      var docRef = logQualityCollection.doc();

      bukuLogQuality.id = docRef.id;

      await docRef.set(bukuLogQuality.toMap());
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> update(BukuLogQuality bukuLogQuality) async {
    try {
      await logQualityCollection.doc(bukuLogQuality.id).update(bukuLogQuality.toMap());
    } catch (e) {
      logError('Error log quality');
      rethrow;
    }
  }

  Stream<List<BukuLogQuality>> read() {
    return logQualityCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        logError('Project data $data');
        return BukuLogQuality.fromJson(data);
      }).toList();
    });
  }

  Stream<List<BukuLogQuality>> readByProjek(String id) {
    return logQualityCollection.where('id', isEqualTo: id).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        return BukuLogQuality.fromJson(data);
      }).toList();
    });
  }

  Future<void> delete(String id) async {
    try {
      await logQualityCollection.doc(id).delete();
    } catch (e) {
      logError('error delete log quality');
      rethrow;
    }
  }
}
