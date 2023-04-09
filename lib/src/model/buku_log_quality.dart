import 'package:spleb/src/model/models.dart';

class BukuLogQuality implements BaseModel {
  final String projekId;
  String id;
  String createdAt;
  final List<Checklist> checkList;
  List<Approval> approval;

  BukuLogQuality(
      {required this.createdAt, required this.approval, required this.projekId, required this.id, required this.checkList});

  factory BukuLogQuality.fromJson(Map<String, dynamic> json) {
    var list = json['checkList'] as List;
    var listApproval = json['approval'] as List;
    return BukuLogQuality(
        projekId: json['projekId'],
        id: json['id'],
        checkList: list.map((e) => Checklist.fromJson(e)).toList(),
        approval: listApproval.map((e) => Approval.fromJson(e)).toList(),
        createdAt: json['approval']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'projekId': projekId,
      'id': id,
      'checkList': checkList.map((e) => e.toMap()).toList(),
      'approval': approval.map((e) => e.toMap()).toList(),
      'createdAt': createdAt
    };
  }
}

class Checklist implements BaseModel {
  final String answer;
  final String title;

  Checklist(this.answer, this.title);

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(json['answer'], json['title']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {'answer': answer, 'title': title};
  }
}

class Approval implements BaseModel {
  final String name;
  final String signedAt;
  final bool isSigned;

  Approval({required this.name, required this.signedAt, required this.isSigned});

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(name: json['name'], signedAt: json['signedAt'], isSigned: json['isSigned']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'signedAt': signedAt, 'isSigned': isSigned};
  }
}
