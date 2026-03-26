import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Bilgisayarda çalışan lokal backend'e emülatör üzerinden erişmek için
  // Android Emulator -> 10.0.2.2 kullanır. Gerçek cihazsa IP yazılmalıdır.
  static const String baseUrl = 'http://10.0.2.2:3000/api'; 
  
  static Future<Map<String, dynamic>> trackProduct({
    required String url,
    required String size,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/track'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'url': url,
          'size': size,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['error'] ?? 'Bilinmeyen hata');
      }
    } catch (e) {
      throw Exception('API Hatası: $e');
    }
  }
}
