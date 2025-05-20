class Petani{

  final String idPenjual;
  final String nama;
  final String nik;
  final String alamat;
  final String telp;
  final String foto;
  final String idKelompokTani;
  final String status;
  final String namaKelompok;
  final String createdAt;
  final String updatedAt;

  Petani({
    required this.idPenjual,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.telp,
    required this.foto,
    required this.idKelompokTani,
    required this.status,
    required this.namaKelompok,
    required this.createdAt,
    required this.updatedAt,
  });
    
  factory Petani.fromJson(Map<String, dynamic> json) => Petani(
    idPenjual: json["id_penjual"].toString(),
    nama: (json["nama"]==null || json["nama"]=='')?'':json["nama"].toString(),
    nik: (json["nik"]==null || json["nik"]=='')?'':json["nik"].toString(),
    alamat: json["alamat"].toString(),
    telp: json["telp"].toString(),
    foto: json["foto"].toString(),
    idKelompokTani: json["id_kelompok_tani"].toString(),
    status: json["status"].toString(),
    namaKelompok: json["nama_kelompok"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
  );

  Map<String, dynamic> toJson() => {  
    "id_penjual": idPenjual,
    "nama": nama,
    "nik": nik,
    "alamat": alamat,
    "telp": telp,
    "foto": foto,
    "id_kelompok_tani": idKelompokTani,
    "status": status,
    "nama_kelompok": namaKelompok,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
  bool matchesSearchQuery(String query) {
    final searchTerm = query.toLowerCase();
    return nama.toLowerCase().contains(searchTerm) ||
      nik.toLowerCase().contains(searchTerm) ||
      alamat.toLowerCase().contains(searchTerm) ||
      namaKelompok.toLowerCase().contains(searchTerm) ||
      telp.toLowerCase().contains(searchTerm);
  }
  bool matchesFilterCriteria(Map<String, dynamic> filters) {
    for (final entry in filters.entries) {
      final key = entry.key;
      final value = entry.value.toString().toLowerCase();
      
      switch (key) {
        case 'status':
          if (status.toLowerCase() != value) return false;
          break;
        case 'kelompok':
          if (namaKelompok.toLowerCase() != value) return false;
          break;
        case 'lokasi':
          if (!alamat.toLowerCase().contains(value)) return false;
          break;
        case 'telp':
          if (!telp.toLowerCase().contains(value)) return false;
          break;
      }
    }
    return true;
  }

  Petani copyWith({
    String? idPenjual,
    String? nama,
    String? nik,
    String? alamat,
    String? telp,
    String? foto,
    String? idKelompokTani,
    String? status,
    String? namaKelompok,
    String? createdAt,
    String? updatedAt,
  }){
    return Petani(
      idPenjual: idPenjual ?? this.idPenjual,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      alamat: alamat ?? this.alamat,
      telp: telp ?? this.telp,
      foto: foto ?? this.foto,
      idKelompokTani: idKelompokTani ?? this.idKelompokTani,
      status: status ?? this.status,
      namaKelompok: namaKelompok ?? this.namaKelompok,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  @override
  String toString() {
    return 'Petani(nama: $nama, nik: $nik, kelompok: $namaKelompok, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Petani && other.idPenjual == idPenjual;
  }

  @override
  int get hashCode => idPenjual.hashCode;
}