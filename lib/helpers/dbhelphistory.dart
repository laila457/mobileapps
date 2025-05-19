import 'dart:convert';
import 'package:http/http.dart' as http;

class DBHelpHistory {
  static const String baseUrl = 'http://localhost/mobileapps';

  static Future<List<Map<String, dynamic>>> getGroomingHistory(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_grooming_history.php'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        if (result['success'] && result['data'] != null) {
          return List<Map<String, dynamic>>.from(result['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching grooming history: $e');
      return [];
    }
  }

  static String formatPrice(dynamic price) {
    if (price == null) return 'Rp 0';
    return 'Rp ${double.parse(price.toString()).toStringAsFixed(0)}';
  }

  static String formatDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}'; // Convert to dd-mm-yyyy
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  static String formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}'; // HH:mm format
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500';
      case 'selesai':
        return '#4CAF50';
      case 'batal':
        return '#F44336';
      default:
        return '#757575';
    }
  }
}