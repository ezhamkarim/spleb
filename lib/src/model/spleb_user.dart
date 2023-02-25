import 'base_model.dart';

import 'role.dart';

class SplebUser implements BaseModel {
  final String id;

  final String userName;

  final String kumpulan;

  final Role role;

  final String email;

  final String noPhone;

  final String? password;
  SplebUser(
      {required this.id,
      required this.userName,
      required this.kumpulan,
      required this.role,
      required this.email,
      required this.noPhone,
      this.password});
  factory SplebUser.fromJson(Map<String, dynamic> json) {
    return SplebUser(
        id: json['id'],
        userName: json['userName'],
        kumpulan: json['kumpulan'],
        role: Role.fromJson(json['role']),
        email: json['email'],
        noPhone: json['noPhone']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'userName': userName, 'kumpulan': kumpulan, 'role': role.toMap(), 'email': email, 'noPhone': noPhone};
  }

  Map<String, dynamic> toRegister() {
    return {
      'id': id,
      'userName': userName,
      'kumpulan': kumpulan,
      'role': role.toMap(),
      'email': email,
      'noPhone': noPhone,
      'password': password
    };
  }

  @override
  bool operator ==(Object other) => other is SplebUser && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
