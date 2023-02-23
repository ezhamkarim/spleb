import 'base_model.dart';

import 'role.dart';

class SplebUser implements BaseModel {
  final String id;

  final String userName;

  final String kumpulan;

  final Role role;

  final String email;

  final String noPhone;

  SplebUser(
      {required this.id,
      required this.userName,
      required this.kumpulan,
      required this.role,
      required this.email,
      required this.noPhone});

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'userName': userName, 'kumpulan': kumpulan, 'role': role, 'email': email, 'noPhone': noPhone};
  }
}
