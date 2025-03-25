import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthBookingController {
  final String baseUrl = "http://192.168.194.32/api"; // Ganti dengan URL API Anda

  Future<Map<String, dynamic>> createBooking(
    String name,
    String phone,
    String month,
    String date,
    String time,
    String animalType,
    String package,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_booking.php'), // Endpoint untuk membuat booking
      body: {
        "name": name,
        "phone": phone,
        "month": month,
        "date": date,
        "time": time,
        "animal_type": animalType,
        "package": package,
      },
    );

    return json.decode(response.body);
  }
}