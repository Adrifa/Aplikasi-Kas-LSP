class KasModel {
  int? id; // Menggunakan tipe int? untuk mengizinkan nilai null
  DateTime tanggal;
  double nominal;
  String? keterangan;
  String? status;

  KasModel(
      {this.id,
      required this.tanggal,
      required this.nominal,
      required this.keterangan, 
      required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'nominal': nominal,
      'keterangan': keterangan,
      'status': status,
    };
  }

  factory KasModel.fromMap(Map<String, dynamic> map) {
    return KasModel(
      id: map['id'],
      tanggal: DateTime.parse(map['tanggal']),
      nominal: map['nominal'],
      keterangan: map['keterangan'],
      status: map['status'],
    );
  }
}
