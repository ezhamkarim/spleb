import 'package:spleb/src/model/models.dart';

class BukuLogOSHE implements BaseModel {
  String projekId;
  String id;
  String createdAt;
  List<ChecklistOSHE> checklistPeralatan;
  List<ChecklistOSHE> checklist;
  List<Approval> approval;
  List<CatatanList> checklistCatatan;

  factory BukuLogOSHE.fromJson(Map<String, dynamic> json) {
    var listPeralatan = json['checklistPeralatan'] as List;
    var list = json['checkList'] as List;
    var approval = json['approval'] as List;
    var listCatatan = json['checklistCatatan'] as List;
    return BukuLogOSHE(
        projekId: json['projekId'],
        id: json['id'],
        createdAt: json['createdAt'],
        checklist: list.map((e) => ChecklistOSHE.fromJson(e)).toList(),
        checklistPeralatan: listPeralatan.map((e) => ChecklistOSHE.fromJson(e)).toList(),
        approval: approval.map((e) => Approval.fromJson(e)).toList(),
        checklistCatatan: listCatatan.map((e) => CatatanList.fromJson(e)).toList());
  }
  BukuLogOSHE(
      {required this.projekId,
      required this.id,
      required this.createdAt,
      required this.checklistPeralatan,
      required this.checklist,
      required this.approval,
      required this.checklistCatatan});

  @override
  Map<String, dynamic> toMap() {
    return {
      'projekId': projekId,
      'id': id,
      'createdAt': createdAt,
      'checklistPeralatan': checklistPeralatan.map((e) => e.toMap()).toList(),
      'checklist': checklist.map((e) => e.toMap()).toList(),
      'approval': approval.map((e) => e.toMap()).toList(),
    };
  }
}

class ChecklistOSHE implements BaseModel {
  String? answer;
  final String title;
  final String? catatan;
  ChecklistOSHE({
    required this.answer,
    required this.title,
    this.catatan,
  });

  factory ChecklistOSHE.fromJson(Map<String, dynamic> json) {
    return ChecklistOSHE(answer: json['answer'], title: json['title']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {'answer': answer, 'title': title, 'catatan': catatan};
  }
}

class CatatanList implements BaseModel {
  final String title;
  final String? catatan;

  factory CatatanList.fromJson(Map<String, dynamic> json) {
    return CatatanList(title: json['title'], catatan: json['catatan']);
  }
  CatatanList({required this.title, required this.catatan});
  @override
  Map<String, dynamic> toMap() {
    return {'title': title, 'catatan': catatan};
  }
}
