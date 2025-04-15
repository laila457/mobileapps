import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingController {
  static Future<bool> saveBooking({
    required String ownerName,
    required String phoneNumber,
    required int petCount,
    required String petType,
    required String notes,
    required DateTime bookingDate,
    required TimeOfDay bookingTime,
  }) async {
    try {
      String url = 'http://192.168.251.32/flutter_api/save_booking.php'; // Ganti dengan 10.0.2.2 jika menggunakan emulator
      var formData = {
        'owner_name': ownerName,
        'phone_number': phoneNumber,
        'pet_count': petCount.toString(),
        'pet_type': petType,
        'notes': notes,
        'booking_date': "${bookingDate.year}-${bookingDate.month.toString().padLeft(2, '0')}-${bookingDate.day.toString().padLeft(2, '0')}",
        'booking_time': "${bookingTime.hour.toString().padLeft(2, '0')}:${bookingTime.minute.toString().padLeft(2, '0')}:00"
      };

      print('Sending request to: $url');
      print('Form data: $formData');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }
}