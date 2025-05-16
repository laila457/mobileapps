import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static const String baseUrl = 'http://localhost/mobileapps/create.php';

  static Future<dynamic> createGroomingReservation(Map<String, dynamic> data) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '',
        db: 'happypaws'
      ));

      var result = await conn.query(
        'INSERT INTO grooming ('
        'tanggal_grooming, waktu_booking, nama_pemilik, no_hp, '
        'jenis_hewan, paket_grooming, pengantaran, kecamatan, '
        'desa, detail_alamat, total_harga, metode_pembayaran, status_pembayaran) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          data['tanggal_grooming'],
          data['waktu_booking'],
          data['nama_pemilik'],
          data['no_hp'],
          data['jenis_hewan'],
          data['paket_grooming'],
          data['pengantaran'],
          data['kecamatan'],
          data['desa'],
          data['detail_alamat'],
          data['total_harga'],
          data['metode_pembayaran'],
          data['status_pembayaran'],
        ]
      );

      await conn.close();
      return result.insertId;
    } catch (e) {
      print('Database error: $e');
      return null;
    }
  }

  static Future<dynamic> createHotelReservation(Map<String, dynamic> data) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '',
        db: 'happypaws'
      ));

      var result = await conn.query(
        'INSERT INTO penitipan ('
        'check_in, check_out, nama_pemilik, no_hp, nama_hewan, '
        'jenis_hewan, paket_penitipan, pengantaran, kecamatan, '
        'desa, detail_alamat, catatan, total_harga, metode_pembayaran) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          data['check_in'],
          data['check_out'],
          data['nama_pemilik'],
          data['no_hp'],
          data['nama_hewan'],
          data['jenis_hewan'],
          data['paket_penitipan'],
          data['pengantaran'],
          data['kecamatan'],
          data['desa'],
          data['detail_alamat'],
          data['catatan'],
          data['total_harga'],
          data['metode_pembayaran'],
        ]
      );

      await conn.close();
      return result.insertId;
    } catch (e) {
      print('Database error: $e');
      return null;
    }
  }

  static Future<bool> createPayment(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_payment.php'),
        body: data,
      );
      
      final result = json.decode(response.body);
      return result['success'] == true;
    } catch (e) {
      print('Error creating payment: $e');
      return false;
    }
  }
}