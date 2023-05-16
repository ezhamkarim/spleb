import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spleb/src/database/database.dart';
import 'package:spleb/src/enum/viewstate_enum.dart';
import 'package:spleb/src/helper/log_helper.dart';
import 'package:spleb/src/model/models.dart';

class IssueController extends ChangeNotifier with DatabaseService {
  ViewState _viewState = ViewState.idle;

  set setState(ViewState vs) {
    _viewState = vs;
    notifyListeners();
  }

  ViewState get viewState => _viewState;
  Future<void> create(Issue issue) async {
    try {
      setState = ViewState.busy;
      /**
       * 
       */

      // await _roleService.create();
      var docRef = isuCollection.doc();

      issue.id = docRef.id;

      await docRef.set(issue.toMap());
      setState = ViewState.idle;
      return;
    } catch (e) {
      setState = ViewState.idle;
      rethrow;
    }
  }

  Future<void> update(Issue issue) async {
    try {
      await isuCollection.doc(issue.id).update(issue.toMap());
    } catch (e) {
      logError('Error log quality');
      rethrow;
    }
  }

  Stream<List<Issue>> read() {
    return isuCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;

        return Issue.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Issue>> readByProjek({String? id}) {
    return isuCollection.where('projekId', isEqualTo: id).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        // logError('Project data $data');
        return Issue.fromJson(data);
      }).toList();
    });
  }

  Future<void> delete(String id) async {
    try {
      await isuCollection.doc(id).delete();
    } catch (e) {
      logError('error delete issue');
      rethrow;
    }
  }
}
