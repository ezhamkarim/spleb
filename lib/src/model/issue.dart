import 'package:spleb/src/model/models.dart';

class Issue implements BaseModel {
  final String id;
  final String name;
  final String createdById;
  final bool isRead;

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(id: json['id'], name: json['name'], createdById: json['createdById'], isRead: json['isRead']);
  }
  Issue({required this.id, required this.name, required this.createdById, required this.isRead});
  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdById': createdById, 'isRead': isRead};
  }
}
