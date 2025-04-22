import 'dart:convert';
import 'package:http/http.dart' as http;

class BookPenitipanController {
  static const String baseUrl = 'https://192.168.100.142/api/booking';

  static Future<bool> saveBooking({
    required String ownerName,
    required String phoneNumber,
    required int petCount,
    required String petType,
    String? notes,
    required DateTime bookingDate,
    required String bookingTime, // in "HH:mm" format
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "owner_name": ownerName,
          "phone_number": phoneNumber,
          "pet_count": petCount,
          "pet_type": petType,
          "notes": notes ?? "",
          "booking_date": bookingDate.toIso8601String().split("T").first,
          "booking_time": bookingTime,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Gagal menyimpan booking: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saat menyimpan booking: $e');
      return false;
    }
  }
}
