// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:spleb/src/model/models.dart';

class Lampiran implements BaseModel {
  String id;
  String link;
  String contentType;
  Lampiran({
    required this.id,
    required this.link,
    required this.contentType,
  });
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'link': link,
      'contentType': contentType,
    };
  }

  Lampiran copyWith({
    String? id,
    String? link,
    String? contentType,
  }) {
    return Lampiran(
      id: id ?? this.id,
      link: link ?? this.link,
      contentType: contentType ?? this.contentType,
    );
  }

  factory Lampiran.fromMap(Map<String, dynamic> map) {
    return Lampiran(
      id: map['id'] as String,
      link: map['link'] as String,
      contentType: map['contentType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lampiran.fromJson(String source) => Lampiran.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Lampiran(id: $id, link: $link, contentType: $contentType)';

  @override
  bool operator ==(covariant Lampiran other) {
    if (identical(this, other)) return true;

    return other.id == id && other.link == link && other.contentType == contentType;
  }

  @override
  int get hashCode => id.hashCode ^ link.hashCode ^ contentType.hashCode;
}
