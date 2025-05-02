import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookPenitipanController {
  static Future<bool> saveBooking({
    required String ownerName,
    required String phoneNumber,
    required int petCount,
    required String petType,
    required String notes,
    required DateTime bookingDate,
    required String bookingTime,
    required String package,
    required bool isDeliveryService,
    String? location,
    String? village,
    String? addressDetail,
  }) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.60.5.68',
        port: 3306,
        user: 'root',
        password: '',
        db: 'flutter_auth',
      ));

      // Convert DateTime to MySQL compatible format
      final formattedDate = bookingDate.toUtc().toString().split(' ')[0];
      
      final result = await conn.query(
        'INSERT INTO bookings (owner_name, phone_number, pet_count, pet_type, notes, booking_date, booking_time, package, is_delivery_service, location, village, address_detail) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          ownerName,
          phoneNumber,
          petCount,
          petType,
          notes,
          formattedDate,  // Using the new date format
          bookingTime,
          package,
          isDeliveryService ? 1 : 0,
          location ?? '',
          village ?? '',
          addressDetail ?? '',
        ],
      );

      return result.affectedRows! > 0;
    } catch (e) {
      print('Database Error: $e');
      return false;
    } finally {
      if (conn != null) {
        await conn.close();
      }
    }
  }
}