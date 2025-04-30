import 'package:http/http.dart' as http;
import 'dart:convert';

class BookPenitipanController {
  static final String baseUrl = "http://10.60.5.115/api";

  static Future<bool> saveBooking({
    required String ownerName,
    required String phoneNumber,
    required int petCount,
    required String petType,
    required String notes,
    required DateTime bookingDate,
    required String bookingTime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save_booking.php'),
        body: {
          'owner_name': ownerName,
          'phone_number': phoneNumber,
          'pet_count': petCount.toString(),
          'pet_type': petType,
          'notes': notes,
          'booking_date': bookingDate.toIso8601String(),
          'booking_time': bookingTime,
          'status': 'pending'
        },
      );

      final result = json.decode(response.body);
      return result['success'] == true;
    } catch (e) {
      print('Error saving booking: $e');
      return false;
    }
  }
}
