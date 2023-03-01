import 'package:spleb/src/model/base_model.dart';

class Projek implements BaseModel {
  String id;
  final String nama;
  String statusProjek;
  final String statusAktiviti;
  final String lokasiProjek;
  final String kumpulan;
  final String namaPIC;
  final String tarikhMula;
  final String tarikhAkhir;

  Projek(
      {required this.id,
      required this.nama,
      required this.statusProjek,
      required this.statusAktiviti,
      required this.lokasiProjek,
      required this.kumpulan,
      required this.namaPIC,
      required this.tarikhMula,
      required this.tarikhAkhir});

  factory Projek.fromJson(Map<String, dynamic> json) {
    return Projek(
        id: json['id'],
        nama: json['nama'],
        statusProjek: json['statusProjek'],
        statusAktiviti: json['statusAktiviti'],
        lokasiProjek: json['lokasiProjek'],
        kumpulan: json['kumpulan'],
        namaPIC: json['namaPIC'],
        tarikhMula: json['tarikhMula'],
        tarikhAkhir: json['tarikhAkhir']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'statusProjek': statusProjek,
      'statusAktiviti': statusAktiviti,
      'lokasiProjek': lokasiProjek,
      'kumpulan': kumpulan,
      'namaPIC': namaPIC,
      'tarikhMula': tarikhMula,
      'tarikhAkhir': tarikhAkhir
    };
  }
}
