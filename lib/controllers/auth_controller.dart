import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {
  final String baseUrl = "http://20.60.20.242/api";
  Future<bool> checkServerConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health_check.php'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {"email": email, "password": password},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {"name": name, "email": email, "password": password},
    );
    return json.decode(response.body);
  }
}
