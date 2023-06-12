import 'models.dart';

class Projek implements BaseModel {
  String id;
  final String nama;
  String statusProjek;
  String noProjek;
  String statusAktiviti;
  final List<String> aktivitiTerkini;
  LokasiProjek? lokasiProjek;
  final String kumpulan;
  final String namaPIC;
  final String tarikhMula;
  final String tarikhAkhir;
  List<Lampiran> lampiran;
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
      required this.noProjek,
      required this.tarikhAkhir,
      required this.lampiran});

  factory Projek.fromJson(Map<String, dynamic> json) {
    var aktivitiTerkiniList = json['aktivitiTerkini'] as List;
    var lampirans = json['lampiran'] as List?;

    var lokasi = json['lokasiProjek'] == null ? null : LokasiProjek.fromMap(json['lokasiProjek']);
    return Projek(
        id: json['id'],
        nama: json['nama'],
        statusProjek: json['statusProjek'],
        statusAktiviti: json['statusAktiviti'],
        lokasiProjek: lokasi,
        kumpulan: json['kumpulan'],
        namaPIC: json['namaPIC'],
        tarikhMula: json['tarikhMula'],
        tarikhAkhir: json['tarikhAkhir'],
        aktivitiTerkini: aktivitiTerkiniList.map((e) => e.toString()).toList(),
        noProjek: json['noProjek'] ?? '-',
        lampiran: lampirans?.map((e) => Lampiran.fromMap(e)).toList() ?? []);
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noProjek': noProjek,
      'nama': nama,
      'statusProjek': statusProjek,
      'statusAktiviti': statusAktiviti,
      'aktivitiTerkini': aktivitiTerkini,
      'lokasiProjek': lokasiProjek?.toMap(),
      'kumpulan': kumpulan,
      'namaPIC': namaPIC,
      'tarikhMula': tarikhMula,
      'tarikhAkhir': tarikhAkhir,
      'lampiran': lampiran.map((e) => e.toMap()).toList()
    };
  }
}
