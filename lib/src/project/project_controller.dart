import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/database/database_service.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';

class ProjectController extends ChangeNotifier with DatabaseService {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
  Future<void> create(Projek projek) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      // await _roleService.create();
      var docRef = projectCollection.doc();

      projek.id = docRef.id;

      await docRef.set(projek.toMap());
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> update(Projek projek) async {
    try {
      await projectCollection.doc(projek.id).update(projek.toMap());
    } catch (e) {
      logError('Error update projek');
      rethrow;
    }
  }

  Stream<List<Projek>> read() {
    return projectCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;

        return Projek.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Projek>> readOne({String? id}) {
    return projectCollection.where('id', isEqualTo: id).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        return Projek.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Projek>> readBelumDisahkan() {
    return projectCollection.where('statusProjek', isEqualTo: 'Belum Disahkan').snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        return Projek.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Projek>> readDisahkan() {
    return projectCollection.where('statusProjek', isEqualTo: 'Disahkan').snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        return Projek.fromJson(data);
      }).toList();
    });
  }

  Future<void> delete(String id) async {
    try {
      await projectCollection.doc(id).delete();
    } catch (e) {
      logError('error delete projek');
      rethrow;
    }
  }
}
