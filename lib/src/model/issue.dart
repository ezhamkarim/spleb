import 'package:spleb/src/model/models.dart';

class Issue implements BaseModel {
  String id;
  final String name;
  final String createdById;
  final String description;
  final bool isRead;
  final String projekId;

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        id: json['id'],
        name: json['name'],
        createdById: json['createdById'],
        isRead: json['isRead'],
        description: json['description'],
        projekId: json['projekId']);
  }
  Issue(
      {required this.id,
      required this.name,
      required this.createdById,
      required this.isRead,
      required this.description,
      required this.projekId});
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdById': createdById,
      'isRead': isRead,
      'description': description,
      'projekId': projekId
    };
  }
}
