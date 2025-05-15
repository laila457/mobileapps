import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {
  final String baseUrl = 'http://localhost/mobileapps-1/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'password': password,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connection failed: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String phone,
    String address,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': username,
          'email': email,
          'phone': phone,
          'address': address,
          'password': password,
          'role': 'user',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connection failed: $e',
      };
    }
  }
}
