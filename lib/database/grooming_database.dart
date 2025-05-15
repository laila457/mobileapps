import 'dart:convert';
import 'package:http/http.dart' as http;

class GroomingDatabase {
  static const String baseUrl = 'http://localhost/mobileapps-1/api';

  static Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_booking.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create booking');
  }

  static Future<Map<String, dynamic>> updatePayment(
    String bookingId,
    String paymentMethod,
    String filePath,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/update_payment.php'),
    );

    request.fields['booking_id'] = bookingId;
    request.fields['payment_method'] = paymentMethod;
    
    request.files.add(
      await http.MultipartFile.fromPath('bukti_transaksi', filePath),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to update payment');
  }
}