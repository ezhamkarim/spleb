import 'package:spleb/src/model/base_model.dart';

class Role with BaseModel {
  final String id;
  final String name;

  Role(this.id, this.name);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
