import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const String baseUrl = 'http://localhost/mobileapps-1/create_penitipan.php';

  static Future<bool> createHotelReservation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_penitipan.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getHotelReservations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_hotel_reservations.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(result);
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<bool> updatePaymentStatus(String bookingId, String paymentMethod) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_payment_stat.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'booking_id': bookingId,
          'payment_method': paymentMethod,
          'payment_status': 'paid',
          'payment_date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> createPenitipanBooking(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/mobileapps-1/create_penitipan.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data,
      );

      final result = jsonDecode(response.body);
      return result['status'] == 'success';
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }
}