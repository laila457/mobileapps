class Grooming {
  final int? id;
  final DateTime tanggalGrooming;
  final String waktuBooking;
  final String namaPemilik;
  final String noHp;
  final String jenisHewan;
  final String paketGrooming;
  final String pengantaran;
  final String? kecamatan;
  final String? desa;
  final String? detailAlamat;
  final double totalHarga;
  final String metodePembayaran;
  final String? buktiTransaksi;
  final String statusPembayaran;

  Grooming({
    this.id,
    required this.tanggalGrooming,
    required this.waktuBooking,
    required this.namaPemilik,
    required this.noHp,
    required this.jenisHewan,
    required this.paketGrooming,
    required this.pengantaran,
    this.kecamatan,
    this.desa,
    this.detailAlamat,
    required this.totalHarga,
    required this.metodePembayaran,
    this.buktiTransaksi,
    required this.statusPembayaran,
  });

  factory Grooming.fromJson(Map<String, dynamic> json) {
    return Grooming(
      id: int.parse(json['id'].toString()),
      tanggalGrooming: DateTime.parse(json['tanggal_grooming']),
      waktuBooking: json['waktu_booking'],
      namaPemilik: json['nama_pemilik'],
      noHp: json['no_hp'],
      jenisHewan: json['jenis_hewan'],
      paketGrooming: json['paket_grooming'],
      pengantaran: json['pengantaran'],
      kecamatan: json['kecamatan'],
      desa: json['desa'],
      detailAlamat: json['detail_alamat'],
      totalHarga: double.parse(json['total_harga'].toString()),
      metodePembayaran: json['metode_pembayaran'],
      buktiTransaksi: json['bukti_transaksi'],
      statusPembayaran: json['status_pembayaran'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_grooming': tanggalGrooming.toIso8601String().split('T')[0],
      'waktu_booking': waktuBooking,
      'nama_pemilik': namaPemilik,
      'no_hp': noHp,
      'jenis_hewan': jenisHewan,
      'paket_grooming': paketGrooming,
      'pengantaran': pengantaran,
      'kecamatan': kecamatan,
      'desa': desa,
      'detail_alamat': detailAlamat,
      'total_harga': totalHarga,
      'metode_pembayaran': metodePembayaran,
      'bukti_transaksi': buktiTransaksi,
      'status_pembayaran': statusPembayaran,
    };
  }
}