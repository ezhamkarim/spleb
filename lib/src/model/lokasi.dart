// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:spleb/src/model/models.dart';

class LokasiProjek implements BaseModel {
  double lat;
  double lang;
  LokasiProjek({
    required this.lat,
    required this.lang,
  });
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lang': lang,
    };
  }

  LokasiProjek copyWith({
    double? lat,
    double? lang,
  }) {
    return LokasiProjek(
      lat: lat ?? this.lat,
      lang: lang ?? this.lang,
    );
  }

  factory LokasiProjek.fromMap(Map<String, dynamic> map) {
    return LokasiProjek(
      lat: map['lat'] as double,
      lang: map['lang'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LokasiProjek.fromJson(String source) => LokasiProjek.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => '$lat,$lang';

  @override
  bool operator ==(covariant LokasiProjek other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.lang == lang;
  }

  @override
  int get hashCode => lat.hashCode ^ lang.hashCode;
}
