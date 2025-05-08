import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const String baseUrl = 'http://localhost/wellpage/create.php';

  static Future<bool> createGroomingReservation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
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