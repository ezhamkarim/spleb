import 'models.dart';

class Projek implements BaseModel {
  String id;
  final String nama;
  String statusProjek;
  String statusAktiviti;
  final List<String> aktivitiTerkini;
  final String lokasiProjek;
  final String kumpulan;
  final String namaPIC;
  final String tarikhMula;
  final String tarikhAkhir;

  @override
  bool operator ==(Object other) => other is Projek && other.id == id;

  @override
  int get hashCode => id.hashCode;

  Projek(
      {required this.id,
      required this.nama,
      required this.statusProjek,
      required this.statusAktiviti,
      required this.aktivitiTerkini,
      required this.lokasiProjek,
      required this.kumpulan,
      required this.namaPIC,
      required this.tarikhMula,
      required this.tarikhAkhir});

  factory Projek.fromJson(Map<String, dynamic> json) {
    var aktivitiTerkiniList = json['aktivitiTerkini'] as List;
    return Projek(
        id: json['id'],
        nama: json['nama'],
        statusProjek: json['statusProjek'],
        statusAktiviti: json['statusAktiviti'],
        lokasiProjek: json['lokasiProjek'],
        kumpulan: json['kumpulan'],
        namaPIC: json['namaPIC'],
        tarikhMula: json['tarikhMula'],
        tarikhAkhir: json['tarikhAkhir'],
        aktivitiTerkini: aktivitiTerkiniList.map((e) => e.toString()).toList());
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'statusProjek': statusProjek,
      'statusAktiviti': statusAktiviti,
      'aktivitiTerkini': aktivitiTerkini,
      'lokasiProjek': lokasiProjek,
      'kumpulan': kumpulan,
      'namaPIC': namaPIC,
      'tarikhMula': tarikhMula,
      'tarikhAkhir': tarikhAkhir
    };
  }
}
