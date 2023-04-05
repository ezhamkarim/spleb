import 'models.dart';

class Aktiviti implements BaseModel {
  final String id;
  final String nama;
  final String projekId;

  Aktiviti(this.id, this.nama, this.projekId);

  factory Aktiviti.fromJson(Map<String, dynamic> json) {
    return Aktiviti(json['id'], json['nama'], json['projekId']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'projekId': projekId};
  }
}
