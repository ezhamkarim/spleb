import 'package:spleb/src/model/base_model.dart';

class Role with BaseModel {
  String id;
  final String name;

  Role(this.id, this.name);
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(json['id'], json['name']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
