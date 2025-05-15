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

  Map<String, dynamic> toJson() => {
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