import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const String baseUrl = 'http://localhost/wellpage/create_hotel.php';

  static Future<bool> createHotelReservation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_hotel.php'),
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
}